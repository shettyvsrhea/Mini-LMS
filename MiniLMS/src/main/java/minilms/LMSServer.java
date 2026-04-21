package minilms;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.*;
import java.net.InetSocketAddress;
import java.nio.file.*;
import java.sql.*;

public class LMSServer {

    private static Connection conn = null;

    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(3000), 0);
        server.createContext("/api/connect", LMSServer::handleConnect);
        server.createContext("/api/disconnect", LMSServer::handleDisconnect);
        server.createContext("/api/query", LMSServer::handleQuery);
        server.createContext("/api/execute", LMSServer::handleExecute);
        server.createContext("/", LMSServer::handleStatic);
        server.setExecutor(null);
        server.start();
        System.out.println("Mini LMS running on http://localhost:3000");
    }

    private static String readBody(HttpExchange ex) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(ex.getRequestBody()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        return sb.toString();
    }

    private static void sendJson(HttpExchange ex, String json) throws IOException {
        ex.getResponseHeaders().set("Content-Type", "application/json");
        byte[] bytes = json.getBytes("UTF-8");
        ex.sendResponseHeaders(200, bytes.length);
        ex.getResponseBody().write(bytes);
        ex.getResponseBody().close();
    }

    private static String esc(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "") + "\"";
    }

    private static String getVal(String json, String key) {
        String search = "\"" + key + "\"";
        int idx = json.indexOf(search);
        if (idx == -1) return "";
        int colon = json.indexOf(":", idx);
        int start = json.indexOf("\"", colon + 1);
        int end = json.indexOf("\"", start + 1);
        return json.substring(start + 1, end);
    }

    private static String getSql(String json) {
        String search = "\"sql\"";
        int idx = json.indexOf(search);
        if (idx == -1) return "";
        int colon = json.indexOf(":", idx);
        int start = json.indexOf("\"", colon + 1);
        int i = start + 1;
        while (i < json.length()) {
            if (json.charAt(i) == '\\') { i += 2; continue; }
            if (json.charAt(i) == '"') break;
            i++;
        }
        return json.substring(start + 1, i).replace("\\\"", "\"").replace("\\n", "\n");
    }

    private static void handleConnect(HttpExchange ex) throws IOException {
        if (!"POST".equals(ex.getRequestMethod())) { ex.sendResponseHeaders(405, -1); return; }
        String body = readBody(ex);
        String user = getVal(body, "username");
        String password = getVal(body, "password");
        String dsn = getVal(body, "connectString");
         System.out.println("USER: " + user);
         System.out.println("PASSWORD: " + password);
        System.out.println("DSN: " + dsn);
        try {
            if (conn != null && !conn.isClosed()) conn.close();
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@" + dsn, user, password);
            conn.setAutoCommit(true);
            sendJson(ex, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();  // VERY IMPORTANT
            sendJson(ex, "{\"success\":false,\"error\":" + esc(e.getMessage()) + "}");
        }
    }

    private static void handleDisconnect(HttpExchange ex) throws IOException {
        if (!"POST".equals(ex.getRequestMethod())) { ex.sendResponseHeaders(405, -1); return; }
        readBody(ex);
        try {
            if (conn != null) { conn.close(); conn = null; }
            sendJson(ex, "{\"success\":true}");
        } catch (Exception e) {
            sendJson(ex, "{\"success\":false,\"error\":" + esc(e.getMessage()) + "}");
        }
    }

    private static void handleQuery(HttpExchange ex) throws IOException {
        if (!"POST".equals(ex.getRequestMethod())) { ex.sendResponseHeaders(405, -1); return; }
        String body = readBody(ex);
        String sql = getSql(body);
        if (conn == null) { sendJson(ex, "{\"success\":false,\"error\":\"Not connected\"}"); return; }
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            ResultSetMetaData meta = rs.getMetaData();
            int cols = meta.getColumnCount();

            StringBuilder metaJson = new StringBuilder("[");
            for (int i = 1; i <= cols; i++) {
                if (i > 1) metaJson.append(",");
                metaJson.append("{\"name\":").append(esc(meta.getColumnName(i))).append("}");
            }
            metaJson.append("]");

            StringBuilder rowsJson = new StringBuilder("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) rowsJson.append(",");
                first = false;
                rowsJson.append("{");
                for (int i = 1; i <= cols; i++) {
                    if (i > 1) rowsJson.append(",");
                    String val = rs.getString(i);
                    rowsJson.append(esc(meta.getColumnName(i))).append(":").append(esc(val));
                }
                rowsJson.append("}");
            }
            rowsJson.append("]");

            rs.close();
            stmt.close();
            sendJson(ex, "{\"success\":true,\"meta\":" + metaJson + ",\"rows\":" + rowsJson + "}");
        } catch (Exception e) {
            sendJson(ex, "{\"success\":false,\"error\":" + esc(e.getMessage()) + "}");
        }
    }

    private static void handleExecute(HttpExchange ex) throws IOException {
        if (!"POST".equals(ex.getRequestMethod())) { ex.sendResponseHeaders(405, -1); return; }
        String body = readBody(ex);
        String sql = getSql(body);
        if (conn == null) { sendJson(ex, "{\"success\":false,\"error\":\"Not connected\"}"); return; }
        try {
            Statement stmt = conn.createStatement();
            stmt.execute(sql);
            stmt.close();
            sendJson(ex, "{\"success\":true}");
        } catch (Exception e) {
            sendJson(ex, "{\"success\":false,\"error\":" + esc(e.getMessage()) + "}");
        }
    }

    private static void handleStatic(HttpExchange ex) throws IOException {
        String path = ex.getRequestURI().getPath();
        if (path.equals("/")) path = "/index.html";

        File file = new File("public" + path);
        if (!file.exists() || file.isDirectory()) {
            ex.sendResponseHeaders(404, -1);
            return;
        }

        String mime = "text/plain";
        if (path.endsWith(".html")) mime = "text/html";
        else if (path.endsWith(".css")) mime = "text/css";
        else if (path.endsWith(".js")) mime = "application/javascript";

        byte[] bytes = Files.readAllBytes(file.toPath());
        ex.getResponseHeaders().set("Content-Type", mime + "; charset=UTF-8");
        ex.sendResponseHeaders(200, bytes.length);
        ex.getResponseBody().write(bytes);
        ex.getResponseBody().close();
    }
}