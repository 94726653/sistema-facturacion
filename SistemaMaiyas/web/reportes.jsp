<%-- 
    Document   : reportes
    Created on : 03-05-2026, 08:09:58 PM
    Author     : Karol
--%>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*,conexion.ConexionDB" %>

<%
Connection con = ConexionDB.getConnection();
%>

<html>
<head>
<title>Reportes</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* FONDO GENERAL */
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

/* TARJETA PRINCIPAL */
.card-reporte{
background:white;
border-radius:10px;
padding:25px;
box-shadow:0 6px 18px rgba(0,0,0,0.15);
}

/* TABS */
.nav-tabs .nav-link{
color:#0288d1;
font-weight:500;
border-radius:6px 6px 0 0;
}

.nav-tabs .nav-link.active{
background:#03a9f4;
color:white;
font-weight:600;
}

/* BOTON BUSCAR */
.btn-buscar{
background:linear-gradient(90deg,#4fc3f7,#03a9f4);
border:none;
color:white;
font-weight:600;
border-radius:20px;
padding:8px 20px;
transition:0.3s;
}

.btn-buscar:hover{
transform:scale(1.05);
background:linear-gradient(90deg,#29b6f6,#0288d1);
}

/* TABLAS */
.table{
background:white;
}

.table th{
background:#03a9f4;
color:white;
text-align:center;
}

.table td{
text-align:center;
}

.table-hover tbody tr:hover{
background:#e1f5fe;
}

/* INPUTS */
.form-control{
border-radius:8px;
}

</style>

<script>
// Validar rango de fechas
function validarFechas() {
    let inicio = document.getElementById("fechaInicio").value;
    let fin = document.getElementById("fechaFin").value;
    if (inicio && fin && inicio > fin) {
        alert("La fecha de inicio no puede ser mayor que la fecha fin.");
        return false;
    }
    return true;
}
</script>

</head>

<body>

<div class="container mt-4">

<h2 class="titulo">Reportes </h2>

<div class="card-reporte">

<ul class="nav nav-tabs">

<li class="nav-item">
<a class="nav-link active" data-bs-toggle="tab" href="#ventas">Ventas por Fecha</a>
</li>

<li class="nav-item">
<a class="nav-link" data-bs-toggle="tab" href="#productos">Productos más vendidos</a>
</li>

<li class="nav-item">
<a class="nav-link" data-bs-toggle="tab" href="#inventario">Inventario Actual</a>
</li>

</ul>

<div class="tab-content">

<!-- ========================= -->
<!-- REPORTE VENTAS -->
<!-- ========================= -->

<div class="tab-pane fade show active" id="ventas">

<br>

<form method="get" class="row g-3" onsubmit="return validarFechas();">

<div class="col-md-4">
<input type="date" id="fechaInicio" name="fechaInicio" class="form-control" value="<%=request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "" %>">
</div>

<div class="col-md-4">
<input type="date" id="fechaFin" name="fechaFin" class="form-control" value="<%=request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "" %>">
</div>

<div class="col-md-4">
<button class="btn btn-buscar"> Buscar</button>
</div>

</form>

<br>

<table class="table table-bordered table-hover">

<tr>
<th>ID Venta</th>
<th>Fecha</th>
<th>Usuario</th>
<th>Cliente</th>
<th>Producto</th>
<th>Descripción</th>
<th>Cantidad</th>
<th>Precio</th>
<th>Subtotal</th>
<th>Nº Factura</th>
<th>Impuesto</th>
<th>Total</th>
</tr>

<%
String fechaInicio = request.getParameter("fechaInicio");
String fechaFin = request.getParameter("fechaFin");

double totalSubtotal = 0.0;
double totalImpuesto = 0.0;
double totalGeneral = 0.0;

String sqlVentas = "SELECT rv.*, v.numero_factura, v.impuesto, v.total " +
                   "FROM reporte_ventas rv " +
                   "LEFT JOIN ventas v ON rv.id = v.id";

if(fechaInicio != null && fechaFin != null && !fechaInicio.equals("") && !fechaFin.equals("")){
    sqlVentas += " WHERE DATE(rv.fecha) BETWEEN '"+fechaInicio+"' AND '"+fechaFin+"'";
}

Statement stVentas = con.createStatement();
ResultSet rsVentas = stVentas.executeQuery(sqlVentas);

while(rsVentas.next()){
    double subtotal = rsVentas.getDouble("subtotal");
    double impuesto = rsVentas.getDouble("impuesto");
    double total = rsVentas.getDouble("total");

    totalSubtotal += subtotal;
    totalImpuesto += impuesto;
    totalGeneral += total;
%>

<tr>
<td><%=rsVentas.getInt("id")%></td>
<td><%=rsVentas.getString("fecha")%></td>
<td><%=rsVentas.getString("usuario")%></td>
<td><%=rsVentas.getString("cliente")%></td>
<td><%=rsVentas.getString("producto")%></td>
<td><%=rsVentas.getString("descripcion")%></td>
<td><%=rsVentas.getInt("cantidad")%></td>
<td>L. <%=rsVentas.getDouble("precio")%></td>
<td>L. <%=subtotal%></td>
<td><%=rsVentas.getString("numero_factura")%></td>
<td>L. <%=impuesto%></td>
<td>L. <%=total%></td>
</tr>

<%
}
%>

<!-- FILA CON TOTALES -->
<tr style="background:#03a9f4;color:white;font-weight:600;">
<td colspan="8" class="text-end">Totales:</td>
<td>L. <%=totalSubtotal%></td>
<td></td>
<td>L. <%=totalImpuesto%></td>
<td>L. <%=totalGeneral%></td>
</tr>

</table>

</div>

<!-- ========================= -->
<!-- PRODUCTOS MAS VENDIDOS -->
<!-- ========================= -->

<div class="tab-pane fade" id="productos">

<br>

<table class="table table-bordered table-hover">

<tr>
<th>ID</th>
<th>Producto</th>
<th>Descripción</th>
<th>Total Vendido</th>
</tr>

<%
Statement stProductos = con.createStatement();
ResultSet rsProductos = stProductos.executeQuery("SELECT * FROM reporte_productos_mas_vendidos");

while(rsProductos.next()){
%>

<tr>

<td><%=rsProductos.getInt("id")%></td>
<td><%=rsProductos.getString("nombre")%></td>
<td><%=rsProductos.getString("descripcion")%></td>
<td><strong><%=rsProductos.getInt("total_vendido")%></strong></td>

</tr>

<%
}
%>

</table>

</div>

<!-- ========================= -->
<!-- INVENTARIO -->
<!-- ========================= -->

<div class="tab-pane fade" id="inventario">

<br>

<table class="table table-bordered table-hover">

<tr>
<th>ID</th>
<th>Producto</th>
<th>Descripción</th>
<th>Precio</th>
<th>Cantidad</th>
</tr>

<%
Statement stInventario = con.createStatement();
ResultSet rsInventario = stInventario.executeQuery("SELECT * FROM reporte_inventario");

while(rsInventario.next()){
%>

<tr>

<td><%=rsInventario.getInt("id")%></td>
<td><%=rsInventario.getString("nombre")%></td>
<td><%=rsInventario.getString("descripcion")%></td>
<td>L. <%=rsInventario.getDouble("precio")%></td>
<td><%=rsInventario.getInt("cantidad")%></td>

</tr>

<%
}
%>

</table>

</div>

</div>

</div>

</div>

</body>
</html>