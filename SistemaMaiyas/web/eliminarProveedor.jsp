<%-- 
    Document   : eliminarProveedor
    Created on : 03-13-2026, 11:59:39 PM
    Author     : Karol
--%>

<%@ page import="java.sql.*" %>
<%
    String usuarioLogueado = (String) session.getAttribute("usuario");
    if(usuarioLogueado == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");
    if(id != null && !id.isEmpty()){
        Connection con = null;
        PreparedStatement ps = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sistema_maiyas","root","");

            // Eliminar productos asignados (por si no hay cascade)
            ps = con.prepareStatement("DELETE FROM productos_proveedores WHERE proveedor_id=?");
            ps.setInt(1,Integer.parseInt(id));
            ps.executeUpdate();

            // Eliminar proveedor
            ps = con.prepareStatement("DELETE FROM proveedores WHERE id=?");
            ps.setInt(1,Integer.parseInt(id));
            ps.executeUpdate();

            response.sendRedirect("proveedores.jsp?msg=Proveedor+eliminado+correctamente");
        }catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("proveedores.jsp?msg=Error+al+eliminar+proveedor");
        } finally{
            try{ if(ps!=null) ps.close(); if(con!=null) con.close(); }catch(Exception e){}
        }
    } else {
        response.sendRedirect("proveedores.jsp?msg=ID+de+proveedor+no+valido");
    }
%>