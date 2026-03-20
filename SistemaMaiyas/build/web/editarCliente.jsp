<%-- 
    Document   : editarCliente.jsp
    Created on : 03-06-2026, 10:32:35 PM
    Author     : Karol
--%>

<%@ page import="java.sql.*, conexion.ConexionDB" %>
<%@ include file="header.jsp" %>

<%
String usuario = (String) session.getAttribute("usuario");
if(usuario == null){
    response.sendRedirect("login.jsp");
}

Connection con = ConexionDB.getConnection();

String idStr = request.getParameter("id");
int id = Integer.parseInt(idStr);

// Guardar cambios
if(request.getParameter("guardar") != null){

    String nombre = request.getParameter("nombre");
    String telefono = request.getParameter("telefono");
    String correo = request.getParameter("correo");

    PreparedStatement ps = con.prepareStatement(
        "UPDATE clientes SET nombre=?, telefono=?, correo=? WHERE id=?"
    );
    ps.setString(1, nombre);
    ps.setString(2, telefono);
    ps.setString(3, correo);
    ps.setInt(4, id);
    ps.executeUpdate();

    response.sendRedirect("clientes.jsp");
}

// Obtener datos del cliente
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM clientes WHERE id=?"
);
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();

String nombre = "";
String telefono = "";
String correo = "";

if(rs.next()){
    nombre = rs.getString("nombre");
    telefono = rs.getString("telefono");
    correo = rs.getString("correo");
}
%>

<html>
<head>
<title>Editar Cliente</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<div class="container mt-5">

<h2>Editar Cliente</h2>

<form method="post">

<input type="hidden" name="guardar" value="1">

<div class="mb-3">
<label>Nombre</label>
<input type="text" name="nombre" class="form-control" value="<%=nombre%>" required>
</div>

<div class="mb-3">
<label>Teléfono</label>
<input type="text" name="telefono" class="form-control" value="<%=telefono%>">
</div>

<div class="mb-3">
<label>Correo</label>
<input type="email" name="correo" class="form-control" value="<%=correo%>">
</div>

<button class="btn btn-success">Guardar Cambios</button>
<a href="clientes.jsp" class="btn btn-secondary">Cancelar</a>

</form>

</div>

</body>
</html>