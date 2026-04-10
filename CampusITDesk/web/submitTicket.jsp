<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Security Check: Grab the username from the active session
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    
    // If they aren't logged in, kick them back to the login page
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ticket Submission Status</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 40px; text-align: center; }
        .message-box { max-width: 500px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); margin: auto; }
        .success { color: #28a745; }
        .error { color: #dc3545; }
        a { display: inline-block; margin-top: 20px; text-decoration: none; color: white; background-color: #0056b3; padding: 10px 20px; border-radius: 4px; }
        a:hover { background-color: #004494; }
    </style>
</head>
<body>
    <div class="message-box">
        <%
            // Grab the form data
            String locationId = request.getParameter("location_id");
            String description = request.getParameter("issue_description");
            String priority = request.getParameter("priority_level");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                
                // YOUR CONNECTION CREDENTIALS
                String dbURL = "jdbc:oracle:thin:@127.0.0.1:1521:xe"; 
                String dbUser = "sabbir_hawlader"; 
                String dbPass = "sabbir"; // <-- CHANGE THIS TO YOUR PASSWORD
                
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                // 2. UPDATED SQL: We added the 'submitted_by' column and a 4th question mark
                String sql = "INSERT INTO tickets (location_id, issue_description, priority_level, submitted_by) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                
                pstmt.setInt(1, Integer.parseInt(locationId));
                pstmt.setString(2, description);
                pstmt.setString(3, priority);
                
                // 3. Bind the session username to the 4th parameter!
                pstmt.setString(4, loggedInUser); 

                int rowsInserted = pstmt.executeUpdate();

                if (rowsInserted > 0) {
                    out.println("<h2 class='success'>Ticket Submitted Successfully!</h2>");
                    out.println("<p>Your issue has been logged securely in the system.</p>");
                }
            } catch (Exception e) {
                out.println("<h2 class='error'>Error Submitting Ticket</h2>");
                out.println("<p>" + e.getMessage() + "</p>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
        
        <a href="facultyDashboard.jsp">Return to My Dashboard</a>
    </div>
</body>
</html>