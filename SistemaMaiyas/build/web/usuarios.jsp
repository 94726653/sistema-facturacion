<%-- 
    Document   : usuarios
    Created on : 03-05-2026, 08:10:31 PM
    Author     : Karol
--%>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, conexion.ConexionDB" %>

<%
if(session.getAttribute("usuario") == null || !"ADMIN".equals(session.getAttribute("rol"))){
    response.sendRedirect("menu.jsp");
}

Connection con = ConexionDB.getConnection();

// Agregar usuario
if(request.getParameter("usuarioNuevo") != null){
    String usuarioNuevo = request.getParameter("usuarioNuevo");
    String passwordNuevo = request.getParameter("passwordNuevo");
    String rolNuevo = request.getParameter("rolNuevo");

    PreparedStatement ps = con.prepareStatement("INSERT INTO usuarios(usuario,password,rol) VALUES(?,?,?)");
    ps.setString(1,usuarioNuevo);
    ps.setString(2,passwordNuevo);
    ps.setString(3,rolNuevo);
    ps.executeUpdate();
%>

<div class="container mt-3">
<div class="alert alert-success text-center">
 Usuario agregado correctamente
</div>
</div>

<%
}
%>

<html>
<head>
<title>Gestión de Usuarios</title>

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
.card-usuarios{
background:white;
border-radius:10px;
padding:25px;
box-shadow:0 6px 18px rgba(0,0,0,0.15);
}

/* INPUTS */
.form-control{
border-radius:8px;
}

/* BOTON AGREGAR */
.btn-agregar{
background:linear-gradient(90deg,#4fc3f7,#03a9f4);
border:none;
color:white;
font-weight:600;
border-radius:20px;
padding:8px 20px;
transition:0.3s;
}

.btn-agregar:hover{
transform:scale(1.05);
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

/* BOTONES ACCIONES */
.btn-warning{
font-weight:600;
}

.btn-danger{
font-weight:600;
}

</style>

</head>

<body>

<div class="container mt-4">

<h2 class="titulo">Gestión de Usuarios</h2>

<div class="card-usuarios">

<!-- FORMULARIO -->
<h5 class="mb-3">Agregar Nuevo Usuario</h5>

<form method="post" class="row g-3 mb-4">

<div class="col-md-3">
<input type="text" class="form-control" name="usuarioNuevo" placeholder="Usuario" required>
</div>

<div class="col-md-3">
<input type="password" class="form-control" name="passwordNuevo" placeholder="Contraseña" required>
</div>

<div class="col-md-3">
<select name="rolNuevo" class="form-control">
<option value="ADMIN">ADMIN</option>
<option value="EMPLEADO">EMPLEADO</option>
</select>
</div>

<div class="col-md-3">
<button class="btn btn-agregar w-100">Agregar Usuario</button>
</div>

</form>

<!-- TABLA -->
<table class="table table-bordered table-hover">

<tr>
<th>ID</th>
<th>Usuario</th>
<th>Rol</th>
<th>Acciones</th>
</tr>

<%
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM usuarios");

while(rs.next()){
%>

<tr>

<td><%=rs.getInt("id")%></td>
<td><strong><%=rs.getString("usuario")%></strong></td>
<td><%=rs.getString("rol")%></td>

<td>

<a href="editarUsuario.jsp?id=<%=rs.getInt("id")%>" class="btn btn-warning btn-sm">
Editar
</a>

<a href="eliminarUsuario.jsp?id=<%=rs.getInt("id")%>" 
class="btn btn-danger btn-sm"
onclick="return confirm('¿Desea eliminar este usuario?');">
Eliminar
</a>

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