<%-- 
    Document   : clientes
    Created on : 03-05-2026, 08:08:26 PM
    Author     : Karol
--%>

<%@ page import="java.sql.*, conexion.ConexionDB" %>
<%@ include file="header.jsp" %>

<%
String usuarioActual = (String) session.getAttribute("usuario");
if(usuarioActual == null){
    response.sendRedirect("login.jsp");
}

String rol = (String) session.getAttribute("rol");
if(rol == null){
    rol = "empleado";
}

Connection con = ConexionDB.getConnection();

// Agregar cliente
if(request.getParameter("nuevoNombre") != null){

    String nombre = request.getParameter("nuevoNombre");
    String telefono = request.getParameter("nuevoTelefono");
    String correo = request.getParameter("nuevoCorreo");

    PreparedStatement ps = con.prepareStatement(
    "INSERT INTO clientes(nombre, telefono, correo, fecha_registro, creado_por) VALUES(?,?,?,?,?)"
    );

    ps.setString(1,nombre);
    ps.setString(2,telefono);
    ps.setString(3,correo);
    ps.setDate(4,new java.sql.Date(System.currentTimeMillis()));
    ps.setString(5,usuarioActual);

    ps.executeUpdate();
%>

<div class="container mt-3">
<div class="alert alert-success text-center">
Cliente agregado correctamente
</div>
</div>

<%
}
%>

<html>

<head>

<title>Clientes</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background:#f4f9fc;
font-family:'Segoe UI',sans-serif;
}

/* TITULO */

.titulo{
color:#0288d1;
font-weight:700;
margin-bottom:20px;
}

/* TARJETA */

.card-clientes{
background:white;
padding:25px;
border-radius:10px;
box-shadow:0 6px 18px rgba(0,0,0,0.15);
}

/* BOTON AGREGAR */

.btn-agregar{
background:linear-gradient(90deg,#4fc3f7,#03a9f4);
border:none;
color:white;
font-weight:600;
border-radius:20px;
}

.btn-agregar:hover{
background:linear-gradient(90deg,#29b6f6,#0288d1);
}

/* TABLA */

.table th{
background:#03a9f4;
color:white;
text-align:center;
}

.table td{
text-align:center;
vertical-align:middle;
}

.table-hover tbody tr:hover{
background:#e1f5fe;
}

</style>

</head>

<body>

<div class="container mt-4">

<h2 class="titulo">Clientes</h2>

<div class="card-clientes">

<form method="post" class="row g-3 mb-4" onsubmit="return confirm('¿Estás seguro que deseas guardar este cliente?');">

<div class="col-md-3">
<input type="text" class="form-control" name="nuevoNombre" placeholder="Nombre" required>
</div>

<div class="col-md-3">
<input type="text" class="form-control" name="nuevoTelefono" placeholder="Teléfono">
</div>

<div class="col-md-3">
<input type="email" class="form-control" name="nuevoCorreo" placeholder="Correo">
</div>

<div class="col-md-3">
<button class="btn btn-agregar w-100">Agregar</button>
</div>

</form>


<table class="table table-bordered table-hover">

<tr>
<th>ID</th>
<th>Nombre</th>
<th>Teléfono</th>
<th>Correo</th>
<th>Fecha Registro</th>
<th>Creado Por</th>
<th>Acciones</th>
</tr>

<%

Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM clientes ORDER BY fecha_registro DESC");

java.sql.Date fechaHoy = new java.sql.Date(System.currentTimeMillis());

while(rs.next()){

int clienteId = rs.getInt("id");
String creadoPor = rs.getString("creado_por");
java.sql.Date fechaRegistro = rs.getDate("fecha_registro");

%>

<tr>

<td><%=clienteId%></td>
<td><%=rs.getString("nombre")%></td>
<td><%=rs.getString("telefono")%></td>
<td><%=rs.getString("correo")%></td>
<td><%=fechaRegistro%></td>
<td><%=creadoPor%></td>

<td>

<%
if("ADMIN".equalsIgnoreCase(rol)){
%>

<a href="editarCliente.jsp?id=<%=clienteId%>" class="btn btn-warning btn-sm">Editar</a>

<a href="eliminarCliente.jsp?id=<%=clienteId%>"
class="btn btn-danger btn-sm"
onclick="return confirm('¿Desea eliminar este cliente?');">
Eliminar
</a>

<%
}
else if("empleado".equalsIgnoreCase(rol) && fechaRegistro.equals(fechaHoy) && usuarioActual.equals(creadoPor)){
%>

<a href="editarCliente.jsp?id=<%=clienteId%>" class="btn btn-warning btn-sm">Editar</a>

<a href="eliminarCliente.jsp?id=<%=clienteId%>"
class="btn btn-danger btn-sm"
onclick="return confirm('¿Desea eliminar este cliente?');">
Eliminar
</a>

<%
}
else{
%>

<button class="btn btn-secondary btn-sm" disabled>Sin permisos</button>

<%
}
%>

</td>

</tr>

<%
}
%>

</table>

</div>

</div>

</body>

</html>