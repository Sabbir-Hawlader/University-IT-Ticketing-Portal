<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. SECURITY CHECK: Ensure only IT Admins can access this page
    String role = (String) session.getAttribute("userRole");
    if (!"IT".equals(role)) {
        // If they are not logged in, or if they are a Faculty member, kick them out!
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>IT Admin Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { max-width: 1100px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); margin: auto; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        h2 { color: #333; margin: 0; }
        .logout-btn { background-color: #dc3545; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; font-weight: bold; }
        .logout-btn:hover { background-color: #c82333; }
        
        /* Filter Bar Styles */
        .filter-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; background: #e9ecef; padding: 15px; border-radius: 6px; }
        .filter-bar select { padding: 8px; border-radius: 4px; border: 1px solid #ccc; }
        .filter-bar input[type="submit"] { padding: 8px 15px; background-color: #17a2b8; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;}
        .filter-bar input[type="submit"]:hover { background-color: #138496; }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #0056b3; color: white; }
        tr:hover { background-color: #f1f1f1; }
        
        .priority-High { color: #dc3545; font-weight: bold; }
        .priority-Medium { color: #ffc107; font-weight: bold; text-shadow: 0px 0px 1px #000; }
        .priority-Low { color: #28a745; font-weight: bold; }
        .status { padding: 5px 10px; border-radius: 12px; font-size: 0.9em; font-weight: bold; }
        .status-Open { background-color: #e2e3e5; color: #383d41; }
    </style>
</head>
<body>

    <div class="container">
        <div class="header-bar">
            <h2>IT Helpdesk Active Tickets</h2>
            <a href="login.jsp" class="logout-btn">Logout</a>
        </div>
        
        <% String filterLocationId = request.getParameter("location_filter"); %>

        <div class="filter-bar">
            <div><strong>Filter Tickets:</strong></div>
            <form action="dashboard.jsp" method="GET" style="margin: 0;">
                <select name="location_filter">
                    <option value="">-- All Locations --</option>
                    <option value="1" <%= "1".equals(filterLocationId) ? "selected" : "" %>>CSE Department</option>
                    <option value="2" <%= "2".equals(filterLocationId) ? "selected" : "" %>>EEE Department</option>
                    <option value="3" <%= "3".equals(filterLocationId) ? "selected" : "" %>>Textile Department</option>
                    <option value="4" <%= "4".equals(filterLocationId) ? "selected" : "" %>>English Department</option>
                    <option value="5" <%= "5".equals(filterLocationId) ? "selected" : "" %>>BBA Department</option>
                    <option value="6" <%= "6".equals(filterLocationId) ? "selected" : "" %>>8th Floor Lab</option>
                    <option value="7" <%= "7".equals(filterLocationId) ? "selected" : "" %>>9th Floor Lab</option>
                    <option value="8" <%= "8".equals(filterLocationId) ? "selected" : "" %>>15th Floor Lab</option>
                    <option value="9" <%= "9".equals(filterLocationId) ? "selected" : "" %>>17th Floor Lab</option>
                </select>
                <input type="submit" value="Apply Filter">
                <a href="dashboard.jsp" style="margin-left:10px; text-decoration:none; color:#dc3545; font-weight:bold;">Clear</a>
            </form>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Submitted By</th> <th>Location</th>
                    <th>Issue Description</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Action</th>
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
                        String dbPass = "sabbir"; // <-- CHANGE THIS TO YOUR PASSWORD
                        
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                        
                        // 2. UPDATED SQL: We added t.submitted_by to the SELECT statement
                        String sql = "SELECT t.ticket_id, t.submitted_by, l.location_name, t.issue_description, t.priority_level, t.status, t.created_at " +
                                     "FROM tickets t JOIN locations l ON t.location_id = l.location_id ";
                        
                        if (filterLocationId != null && !filterLocationId.isEmpty()) {
                            sql += "WHERE t.location_id = ? "; 
                        }
                        
                        sql += "ORDER BY t.created_at DESC";
                        
                        pstmt = conn.prepareStatement(sql);
                        
                        if (filterLocationId != null && !filterLocationId.isEmpty()) {
                            pstmt.setInt(1, Integer.parseInt(filterLocationId));
                        }

                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int id = rs.getInt("ticket_id");
                            
                            // 3. Grab the username. If it's an old ticket from before we had logins, show "Anonymous"
                            String submitter = rs.getString("submitted_by");
                            if (submitter == null) submitter = "Anonymous";

                            String location = rs.getString("location_name");
                            String description = rs.getString("issue_description");
                            String priority = rs.getString("priority_level");
                            String status = rs.getString("status");
                            Timestamp time = rs.getTimestamp("created_at");

                            out.println("<tr>");
                            out.println("<td>#" + id + "</td>");
                            out.println("<td><strong>" + submitter + "</strong></td>"); // NEW DATA CELL
                            out.println("<td>" + location + "</td>");
                            out.println("<td>" + description + "</td>");
                            out.println("<td class='priority-" + priority + "'>" + priority + "</td>");
                            out.println("<td><span class='status status-" + status + "'>" + status + "</span></td>");
                            out.println("<td>" + time + "</td>");
                            
                            out.println("<td style='display: flex; gap: 5px; align-items: center;'>");
                            out.println("<form action='updateTicket.jsp' method='POST' style='margin:0;'>");
                            out.println("<input type='hidden' name='ticket_id' value='" + id + "'>");
                            out.println("<select name='new_status' style='padding:5px; width:auto; display:inline-block;'>");
                            out.println("<option value='Open'>Open</option><option value='In Progress'>In Progress</option><option value='Resolved'>Resolved</option>");
                            out.println("</select>");
                            out.println("<input type='submit' value='Update' style='padding:5px 10px; margin-top:0; width:auto; cursor:pointer;'>");
                            out.println("</form>");
                            
                            out.println("<form action='deleteTicket.jsp' method='POST' style='margin:0;' onsubmit='return confirm(\"Are you sure you want to permanently delete this ticket?\");'>");
                            out.println("<input type='hidden' name='ticket_id' value='" + id + "'>");
                            out.println("<input type='submit' value='Delete' style='padding:5px 10px; margin-top:0; width:auto; background-color:#dc3545; color:white; border:none; border-radius:4px; cursor:pointer;'>");
                            out.println("</form>");
                            out.println("</td>");
                            
                            out.println("</tr>");
                        }
                    } catch (Exception e) { out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                    } finally { if (rs != null) try{rs.close();}catch(SQLException e){} if (pstmt != null) try{pstmt.close();}catch(SQLException e){} if (conn != null) try{conn.close();}catch(SQLException e){} }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>