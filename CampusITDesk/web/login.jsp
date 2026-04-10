<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Campus IT - Login</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 350px; text-align: center; }
        .login-box h2 { color: #333; margin-bottom: 20px; }
        .input-group { margin-bottom: 15px; text-align: left; }
        .input-group label { display: block; margin-bottom: 5px; color: #666; font-weight: bold; }
        .input-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        input[type="submit"] { width: 100%; padding: 12px; background-color: #0056b3; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 10px; transition: 0.3s;}
        input[type="submit"]:hover { background-color: #004494; }
        .error-msg { color: #dc3545; font-weight: bold; margin-bottom: 15px; }
        .success-msg { color: #28a745; font-weight: bold; margin-bottom: 15px; }
        .register-link { display: block; margin-top: 15px; color: #0056b3; text-decoration: none; font-size: 14px; }
        .register-link:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>IT Helpdesk Login</h2>
        
        <% 
            String error = request.getParameter("error"); 
            String msg = request.getParameter("msg"); 
            
            if ("invalid".equals(error)) {
                out.println("<div class='error-msg'>Invalid username or password.</div>");
            }
            
            if ("registered".equals(msg)) {
                out.println("<div class='success-msg'>Registration successful! Please login.</div>");
            }
        %>

        <form action="authenticate.jsp" method="POST">
            <div class="input-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <input type="submit" value="Login">
        </form>
        
        <a href="register.jsp" class="register-link">New Faculty? Register here.</a>
    </div>

</body>
</html>