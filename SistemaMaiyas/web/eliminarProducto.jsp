<%-- 
    Document   : eliminarProducto
    Created on : 02-18-2026, 08:58:51 PM
    Author     : Karol
--%>

<%@ page import="java.sql.*, conexion.ConexionDB" %>
<%
    if(session == null || session.getAttribute("usuario") == null){
        response.sendRedirect("login.jsp");
    }

    Connection con = ConexionDB.getConnection();
    int id = Integer.parseInt(request.getParameter("id"));

    PreparedStatement ps = con.prepareStatement("DELETE FROM productos WHERE id=?");
    ps.setInt(1,id);
    ps.executeUpdate();
    response.sendRedirect("inventario.jsp");
%>