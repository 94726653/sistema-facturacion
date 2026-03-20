<%-- 
    Document   : menu.jsp
    Created on : 02-18-2026, 08:32:55 PM
    Author     : Karol
--%>
<%@ include file="header.jsp" %>
<%@ page import="javax.servlet.*" %>
<%
    if(session.getAttribute("usuario") == null){
        response.sendRedirect("login.jsp");
    }
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menú - Soluciones Maiyas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f5f5f5;
        }
        .header {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header img {
            height: 50px;
        }
        .header .usuario-info {
            font-weight: bold;
        }
        .main-logo {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .main-logo img {
            max-width: 500px;
            width: 80%;
            height: auto;
        }
        .footer {
            background-color: #f8f9fa;
            padding: 10px 20px;
            text-align: center;
        }
        .footer img {
            height: 40px;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>



<!-- Pantalla principal: logo centrado -->
<div class="main-logo">
    <img src="images/logo_maiyas.png" alt="Logo Maiyas">
</div>



</body>
</html>