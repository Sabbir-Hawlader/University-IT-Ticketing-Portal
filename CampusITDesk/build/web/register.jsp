<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Registration</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 350px; text-align: center; }
        .login-box h2 { color: #333; margin-bottom: 20px; }
        .input-group { margin-bottom: 15px; text-align: left; }
        .input-group label { display: block; margin-bottom: 5px; color: #666; font-weight: bold; }
        .input-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        input[type="submit"] { width: 100%; padding: 12px; background-color: #28a745; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 10px; transition: 0.3s; }
        input[type="submit"]:hover { background-color: #218838; }
        .login-link { margin-top: 15px; display: block; color: #0056b3; text-decoration: none; font-size: 14px; }
        .login-link:hover { text-decoration: underline; }
        .error-msg { color: #dc3545; font-weight: bold; margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>Faculty Registration</h2>
        
        <% 
            String error = request.getParameter("error"); 
            if ("exists".equals(error)) {
                out.println("<div class='error-msg'>Username already exists. Try another.</div>");
            } else if ("error".equals(error)) {
                out.println("<div class='error-msg'>Registration failed. Try again.</div>");
            }
        %>

        <form action="processRegistration.jsp" method="POST">
            <div class="input-group">
                <label for="new_username">Choose Username</label>
                <input type="text" id="new_username" name="new_username" required>
            </div>
            <div class="input-group">
                <label for="new_password">Choose Password</label>
                <input type="password" id="new_password" name="new_password" required>
            </div>
            <input type="submit" value="Register Account">
        </form>
        
        <a href="login.jsp" class="login-link">Already have an account? Login here.</a>
    </div>

</body>
</html>