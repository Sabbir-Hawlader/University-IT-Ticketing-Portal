<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security check: Make sure they are actually logged in!
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty IT Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { max-width: 900px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); margin: auto; margin-bottom: 30px; }
        h2 { text-align: center; color: #333; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        
        /* Form Styles */
        label { font-weight: bold; display: block; margin-top: 15px; color: #555; }
        select, textarea { width: 100%; padding: 10px; margin-top: 8px; border-radius: 4px; border: 1px solid #ccc; box-sizing: border-box; }
        .radio-group { margin-top: 10px; }
        .radio-group input { margin-right: 5px; }
        .radio-group label { display: inline; font-weight: normal; margin-right: 15px; }
        input[type="submit"] { background-color: #0056b3; color: white; border: none; padding: 12px; border-radius: 4px; width: 100%; margin-top: 25px; cursor: pointer; font-weight: bold; }
        input[type="submit"]:hover { background-color: #004494; }

        /* Table Styles */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #28a745; color: white; }
        .status { padding: 5px 10px; border-radius: 12px; font-size: 0.9em; font-weight: bold; }
        .status-Open { background-color: #e2e3e5; color: #383d41; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; }
        .logout-btn { background-color: #dc3545; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; font-weight: bold; }
    </style>
</head>
<body>

    <div class="container">
        <div class="header-bar">
            <h2>Welcome, <%= loggedInUser %></h2>
            <a href="login.jsp" class="logout-btn">Logout</a>
        </div>
        
        <h3>Submit a New IT Ticket</h3>
        <form action="submitTicket.jsp" method="POST">
            <label for="location">Your Location:</label>
            <select name="location_id" id="location" required>
                <option value="">-- Select Location --</option>
                <option value="1">CSE Department</option>
                <option value="2">EEE Department</option>
                <option value="3">Textile Department</option>
                <option value="4">English Department</option>
                <option value="5">BBA Department</option>
                <option value="6">8th Floor Lab</option>
                <option value="7">9th Floor Lab</option>
                <option value="8">15th Floor Lab</option>
                <option value="9">17th Floor Lab</option>
                <option value="10">Faculty Office (Floor 2)</option>
                <option value="11">Admission Office (Floor 3)</option>
                <option value="12">Faculty Floor (Floor 7)</option>
            </select>

            <label for="description">Issue Description:</label>
            <textarea name="issue_description" id="description" rows="3" required></textarea>

            <label>Priority Level:</label>
            <div class="radio-group">
                <input type="radio" id="low" name="priority_level" value="Low" required> <label for="low">Low</label>
                <input type="radio" id="medium" name="priority_level" value="Medium"> <label for="medium">Medium</label>
                <input type="radio" id="high" name="priority_level" value="High"> <label for="high">High</label>
            </div>

            <input type="submit" value="Submit Ticket">
        </form>
    </div>

    <div class="container">
        <h3>My Submitted Tickets</h3>
        <table>
            <thead>
                <tr>
                    <th>Ticket ID</th>
                    <th>Issue</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        // YOUR CONNECTION STRING
                        String dbURL = "jdbc:oracle:thin:@127.0.0.1:1521:xe"; 
                        String dbUser = "sabbir_hawlader"; 
                        String dbPass = "sabbir"; // <-- CHANGE THIS
                        
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                        
                        // Query ONLY the tickets submitted by this specific user
                        String sql = "SELECT ticket_id, issue_description, status, created_at FROM tickets WHERE submitted_by = ? ORDER BY created_at DESC";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, loggedInUser); // Bind the session username!
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>#" + rs.getInt("ticket_id") + "</td>");
                            out.println("<td>" + rs.getString("issue_description") + "</td>");
                            out.println("<td><span class='status status-" + rs.getString("status") + "'>" + rs.getString("status") + "</span></td>");
                            out.println("<td>" + rs.getTimestamp("created_at") + "</td>");
                            out.println("</tr>");
                        }
                    } catch (Exception e) { out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                    } finally { if (rs != null) try{rs.close();}catch(SQLException e){} if (pstmt != null) try{pstmt.close();}catch(SQLException e){} if (conn != null) try{conn.close();}catch(SQLException e){} }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>