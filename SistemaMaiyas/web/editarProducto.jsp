<%-- 
    Document   : editarProducto
    Created on : 02-18-2026, 08:58:23 PM
    Author     : Karol
--%>

<%@ page import="java.sql.*, conexion.ConexionDB" %>
<%
    if(session == null || session.getAttribute("usuario") == null){
        response.sendRedirect("login.jsp");
    }

    Connection con = ConexionDB.getConnection();
    int id = Integer.parseInt(request.getParameter("id"));

    if(request.getParameter("nombre") != null){
        String nombre = request.getParameter("nombre");
        double precio = Double.parseDouble(request.getParameter("precio"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        PreparedStatement ps = con.prepareStatement(
            "UPDATE productos SET nombre=?, precio=?, cantidad=? WHERE id=?");
        ps.setString(1,nombre);
        ps.setDouble(2,precio);
        ps.setInt(3,cantidad);
        ps.setInt(4,id);
        ps.executeUpdate();
        response.sendRedirect("inventario.jsp");
    }

    PreparedStatement psProd = con.prepareStatement("SELECT * FROM productos WHERE id=?");
    psProd.setInt(1,id);
    ResultSet rs = psProd.executeQuery();
    rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Editar Producto - Soluciones Maiyas S. de R.L.</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Editar Producto</h2>
    <form method="post" class="row g-2 mt-3">
        <div class="col-md-4">
            <input type="text" class="form-control" name="nombre" value="<%= rs.getString("nombre") %>" required>
        </div>
        <div class="col-md-3">
            <input type="number" step="0.01" class="form-control" name="precio" value="<%= rs.getDouble("precio") %>" required>
        </div>
        <div class="col-md-3">
            <input type="number" class="form-control" name="cantidad" value="<%= rs.getInt("cantidad") %>" required>
        </div>
        <div class="col-md-2">
            <button class="btn btn-primary w-100">Guardar</button>
        </div>
    </form>
    <a href="inventario.jsp" class="btn btn-secondary mt-3">Volver</a>
</div>
</body>
</html>