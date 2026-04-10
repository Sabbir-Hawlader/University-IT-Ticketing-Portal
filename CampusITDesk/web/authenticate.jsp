<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Get the credentials submitted from the login form
    String user = request.getParameter("username");
    String pass = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        
        // YOUR CONNECTION CREDENTIALS
        String dbURL = "jdbc:oracle:thin:@127.0.0.1:1521:xe"; 
        String dbUser = "sabbir_hawlader"; 
        String dbPass = "sabbir"; // <-- CHANGE THIS TO YOUR PASSWORD
        
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // 2. Query the database to see if this user exists with this exact password
        String sql = "SELECT role FROM users WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user);
        pstmt.setString(2, pass);

        rs = pstmt.executeQuery();

        // 3. Check the result and route the user
        if (rs.next()) {
            // SUCCESS! The user exists. Let's find out their role.
            String role = rs.getString("role");
            
            // Create a secure Session Variable so the server remembers who is logged in
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userRole", role);

            // Traffic Cop: Send them to the right page based on their role
            if ("IT".equals(role)) {
                response.sendRedirect("dashboard.jsp"); // IT goes to the main dashboard
            } else if ("FACULTY".equals(role)) {
                response.sendRedirect("facultyDashboard.jsp"); // Faculty goes to their own dashboard
            }
            
        } else {
            // FAILED! Wrong username or password. Kick them back to login.
            response.sendRedirect("login.jsp?error=invalid");
        }

    } catch (Exception e) {
        out.println("Database Error: " + e.getMessage());
    } finally {
        // Always close connections
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>