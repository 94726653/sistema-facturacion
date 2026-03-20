<%-- 
    Document   : imprimirFactura
    Created on : 03-06-2026, 02:10:14 AM
    Author     : Karol
--%>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, java.text.DecimalFormat, conexion.ConexionDB" %>

<%
if(session.getAttribute("usuario") == null){
    response.sendRedirect("login.jsp");
}

String paramVentaId = request.getParameter("ventaId");
int ventaId = 0;
Connection con = ConexionDB.getConnection();

if(paramVentaId != null && !paramVentaId.isEmpty()){
    ventaId = Integer.parseInt(paramVentaId);
}else{
    PreparedStatement psLast = con.prepareStatement(
        "SELECT id FROM ventas ORDER BY fecha DESC LIMIT 1");
    ResultSet rsLast = psLast.executeQuery();
    if(rsLast.next()){
        ventaId = rsLast.getInt("id");
    }else{
        out.println("<div class='alert alert-danger'>No hay ventas para imprimir</div>");
        return;
    }
}

PreparedStatement psVenta = con.prepareStatement(
    "SELECT v.id,v.fecha,v.total,v.usuario,c.nombre cliente " +
    "FROM ventas v LEFT JOIN clientes c ON v.cliente_id=c.id WHERE v.id=?");
psVenta.setInt(1,ventaId);
ResultSet rsVenta = psVenta.executeQuery();

String cliente="", usuario="", fecha="";
double total=0;
if(rsVenta.next()){
    cliente = rsVenta.getString("cliente");
    if(cliente==null) cliente="Consumidor Final";
    usuario = rsVenta.getString("usuario");
    fecha = rsVenta.getString("fecha");
    total = rsVenta.getDouble("total");
}

PreparedStatement psDet = con.prepareStatement(
    "SELECT p.nombre,p.descripcion,d.cantidad,d.precio " +
    "FROM detalle_venta d INNER JOIN productos p ON d.producto_id=p.id " +
    "WHERE d.venta_id=?");
psDet.setInt(1,ventaId);
ResultSet rsDet = psDet.executeQuery();

DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<html>
<head>
<title>Factura F-000<%=ventaId%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

<style>
/* --- Ajuste tamaño header (barra azul de navegación) --- */
.header, .navbar, .nav-link, .header-buttons {
    height: 50px !important;  /* Ajusta altura */
    padding: 5px 15px !important;
    font-size: 14px !important;  /* Tamaño del texto */
}
.header a, .navbar a, .nav-link {
    line-height: 40px !important;
}

/* --- Estilos de la factura --- */
body {
    background:#f0f4f8;
    font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin:0;
    padding:0;
}
.container{padding:50px;}
.factura{
    background:white;
    padding:50px 60px;
    border-radius:20px;
    box-shadow:0 20px 40px rgba(0,0,0,0.15);
}
.factura-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    border-bottom:5px solid #33c0f1;
    padding-bottom:20px;
    margin-bottom:25px;
}
.factura-header img{height:100px;}
.factura-header .empresa{
    font-size:32px;
    font-weight:bold;
    color:#33c0f1;
}
.factura-header .datos-empresa{
    font-size:13px;
    color:#555;
    margin-top:5px;
}

.row-info{margin-bottom:35px;}
.row-info .col-md-6{font-size:14px;}
.row-info .col-md-6 strong{color:#33c0f1;}

.table thead th{
    background:#33c0f1 !important;
    color:white !important;
    text-align:center;
    font-size:14px;
    padding:12px;
}
.table tbody td{
    text-align:center;
    padding:12px;
    font-size:13px;
}
.table tbody tr:nth-child(even){
    background:#f3f9fc;
}

.total-box{
    background:#d9f0fc;
    padding:25px;
    border-radius:12px;
    margin-top:20px;
}
.total-line{display:flex;justify-content:space-between;margin-bottom:10px;font-size:14px;}
.total-final{font-size:24px;font-weight:bold;color:#33c0f1;}

.text-muted{color:#6c757d;font-size:12px;}
.no-print{display:inline-block;}

/* Impresión solo factura */
@page { margin:0; }
@media print{
    body *{visibility:hidden !important;}
    .factura, .factura *{visibility:visible !important;}
    .factura{position:absolute;left:0;top:0;width:100%;}
    .no-print{display:none !important;}
}
</style>

<script>
function imprimirFactura() { window.print(); }

function descargarPDF() {
    const factura = document.querySelector(".factura");
    const botones = factura.querySelectorAll(".no-print");
    botones.forEach(b=>b.style.display='none');

    html2canvas(factura,{scale:2}).then(canvas=>{
        const imgData = canvas.toDataURL('image/png');
        const { jsPDF } = window.jspdf;
        const pdf = new jsPDF('p','pt','a4');
        const pdfWidth = pdf.internal.pageSize.getWidth()-40;
        const pdfHeight = (canvas.height*pdfWidth)/canvas.width;
        pdf.addImage(imgData,'PNG',20,20,pdfWidth,pdfHeight);
        pdf.save('Factura_F-000<%=ventaId%>.pdf');
        botones.forEach(b=>b.style.display='inline-block');
    });
}
</script>
</head>

<body>
<div class="container">
<div class="factura">

<!-- Encabezado profesional -->
<div class="factura-header">
    <div>
        <div class="empresa">Soluciones Maiyas</div>
        <div class="datos-empresa">
            Dirección: Av. Principal #123, Tegucigalpa, Honduras<br>
            Tel: +504 2222-3333 | Email: contacto@solucionesmaiyas.com<br>
            NIT: 0801-1990-01234
        </div>
    </div>
    <div><img src="images/logo_maiyas.png" alt="Logo Empresa"></div>
</div>

<!-- Información cliente y factura -->
<div class="row row-info">
<div class="col-md-6" style="text-align:left;">
<strong>Cliente:</strong> <%=cliente%><br>
<strong>Vendedor:</strong> <%=usuario%>
</div>
<div class="col-md-6" style="text-align:right;">
<strong>Factura No:</strong> F-000<%=ventaId%><br>
<strong>Fecha:</strong> <%=fecha%>
</div>
</div>

<!-- Tabla productos -->
<table class="table table-bordered">
<thead>
<tr>
<th>Producto</th>
<th>Descripción</th>
<th>Cantidad</th>
<th>Precio</th>
<th>Total</th>
</tr>
</thead>
<tbody>
<%
double subtotal=0;
while(rsDet.next()){
    String nombre = rsDet.getString("nombre");
    String descripcion = rsDet.getString("descripcion");
    int cantidad = rsDet.getInt("cantidad");
    double precio = rsDet.getDouble("precio");
    double totalLinea = cantidad*precio;
    subtotal += totalLinea;
%>
<tr>
<td><%=nombre%></td>
<td><%=descripcion%></td>
<td><%=cantidad%></td>
<td>L. <%=df.format(precio)%></td>
<td>L. <%=df.format(totalLinea)%></td>
</tr>
<% } %>
</tbody>
</table>

<%
double impuesto=subtotal*0.15;
double totalFinal=subtotal+impuesto;
%>

<!-- Totales destacados -->
<div class="row">
<div class="col-md-7"></div>
<div class="col-md-5">
<div class="total-box">
<div class="total-line"><span>Subtotal</span><span>L. <%=df.format(subtotal)%></span></div>
<div class="total-line"><span>ISV 15%</span><span>L. <%=df.format(impuesto)%></span></div>
<hr>
<div class="total-line total-final"><span>Total</span><span>L. <%=df.format(totalFinal)%></span></div>
</div>
</div>
</div>

<!-- Pie de página elegante -->
<hr>
<div class="text-center text-muted">
<p><strong>Gracias por su compra</strong></p>
<p>Documento con validez fiscal | Contacto: +504 2222-3333 | contacto@solucionesmaiyas.com</p>
</div>

<!-- Botones pantalla -->
<div class="text-center no-print">
<button class="btn btn-primary" onclick="imprimirFactura()">Imprimir Factura</button>
<button class="btn btn-success" onclick="descargarPDF()">Descargar PDF</button>
<a href="facturacion.jsp" class="btn btn-secondary">Volver</a>
</div>

</div>
</div>
</body>
</html>