<%-- 
    Document   : eliminarUsuario.jsp
    Created on : 03-06-2026, 05:03:11 AM
    Author     : Karol
--%>

<%@ page import="java.sql.*, conexion.ConexionDB" %>
<%
if(session.getAttribute("usuario") == null || !"ADMIN".equals(session.getAttribute("rol"))){
    response.sendRedirect("menu.jsp");
    return;
}

String idStr = request.getParameter("id");
if(idStr != null){
    int id = Integer.parseInt(idStr);
    Connection con = ConexionDB.getConnection();
    PreparedStatement ps = con.prepareStatement("DELETE FROM usuarios WHERE id=?");
    ps.setInt(1, id);
    ps.executeUpdate();
    ps.close();
    con.close();
}

// Redirigir de nuevo a la lista de usuarios
response.sendRedirect("usuarios.jsp");
%>