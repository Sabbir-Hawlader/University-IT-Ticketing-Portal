<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String newUsername = request.getParameter("new_username");
    String newPassword = request.getParameter("new_password");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbURL = "jdbc:oracle:thin:@127.0.0.1:1521:xe"; 
        String dbUser = "sabbir_hawlader"; 
        String dbPass = "sabbir"; // <-- CHANGE THIS
        
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // We HARDCODE 'FACULTY' into the role column. 
        // This guarantees nobody can register as an 'IT' admin.
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'FACULTY')";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, newUsername);
        pstmt.setString(2, newPassword);

        int rows = pstmt.executeUpdate();
        
        if (rows > 0) {
            // Success! Send them to the login page with a success message
            response.sendRedirect("login.jsp?msg=registered");
        }

    } catch (SQLIntegrityConstraintViolationException e) {
        // This specifically catches if someone tries to register a username that is already taken
        response.sendRedirect("register.jsp?error=exists");
    } catch (Exception e) {
        response.sendRedirect("register.jsp?error=error");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>