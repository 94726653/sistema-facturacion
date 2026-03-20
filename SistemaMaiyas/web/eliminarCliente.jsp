<%-- 
    Document   : eliminarCliente.jsp
    Created on : 03-06-2026, 10:26:10 PM
    Author     : Karol
--%>
<%@ page import="java.sql.*, conexion.ConexionDB" %>

<%
String usuario = (String) session.getAttribute("usuario");
String rol = (String) session.getAttribute("rol");

if(usuario == null){
    response.sendRedirect("login.jsp");
}

String idStr = request.getParameter("id");

if(idStr != null){
    int id = Integer.parseInt(idStr);

    Connection con = ConexionDB.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "DELETE FROM clientes WHERE id=?"
    );
    ps.setInt(1, id);
    ps.executeUpdate();
}

response.sendRedirect("clientes.jsp");
%>