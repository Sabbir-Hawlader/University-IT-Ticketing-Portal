<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Grab the ID of the ticket we want to destroy from the dashboard form
    String ticketId = request.getParameter("ticket_id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        
        // YOUR CONNECTION CREDENTIALS
        String dbURL = "jdbc:oracle:thin:@127.0.0.1:1521:xe"; 
        String dbUser = "sabbir_hawlader"; 
        String dbPass = "sabbir"; // <-- CHANGE THIS TO YOUR PASSWORD
        
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // 2. The SQL DELETE statement
        String sql = "DELETE FROM tickets WHERE ticket_id = ?";
        pstmt = conn.prepareStatement(sql);
        
        // Bind the ticket ID to the question mark in the SQL string
        pstmt.setInt(1, Integer.parseInt(ticketId));

        // 3. Execute the deletion
        pstmt.executeUpdate();

    } catch (Exception e) {
        out.println("Error deleting ticket: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    // 4. Immediately redirect the user back to the dashboard so they can see the change!
    response.sendRedirect("dashboard.jsp");
%>