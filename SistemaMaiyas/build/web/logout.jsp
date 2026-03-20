<%-- 
    Document   : logout.jsp
    Created on : 03-06-2026, 10:13:17 PM
    Author     : Karol
--%>

<%
session.invalidate();
response.sendRedirect("login.jsp");
%>