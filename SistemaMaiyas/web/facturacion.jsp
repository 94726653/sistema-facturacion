<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, java.util.*, conexion.ConexionDB" %>
<%
if(session.getAttribute("usuario") == null){
    response.sendRedirect("login.jsp");
}

Connection con = ConexionDB.getConnection();

// Inicializar carrito
List carrito = (List) session.getAttribute("carrito");
if(carrito == null){
    carrito = new ArrayList();
    session.setAttribute("carrito", carrito);
}

// Cliente seleccionado
String clienteIdSeleccionado = request.getParameter("clienteId");
if(clienteIdSeleccionado == null){
    clienteIdSeleccionado = "";
}

String accion = request.getParameter("accion");

// Agregar producto
if("agregar".equals(accion)){
    int productoId = Integer.parseInt(request.getParameter("productoId"));
    int cantidad = Integer.parseInt(request.getParameter("cantidad"));

    PreparedStatement psProd = con.prepareStatement("SELECT * FROM productos WHERE id=?");
    psProd.setInt(1, productoId);
    ResultSet rsProd = psProd.executeQuery();

    if(rsProd.next()){
        int stock = rsProd.getInt("cantidad");
        int stockMin = rsProd.getInt("stock_minimo");

        if(cantidad > stock){
            out.println("<div class='alert alert-danger'>No hay suficiente stock. Disponible: "+stock+"</div>");
        } else if(stock <= stockMin){
            out.println("<div class='alert alert-danger'>Stock mínimo alcanzado.</div>");
        } else {
            Map prod = new HashMap();
            prod.put("id", new Integer(rsProd.getInt("id")));
            prod.put("nombre", rsProd.getString("nombre"));
            prod.put("descripcion", rsProd.getString("descripcion"));
            prod.put("precio", new Double(rsProd.getDouble("precio")));
            prod.put("cantidad", new Integer(cantidad));
            carrito.add(prod);
            session.setAttribute("carrito", carrito);
        }
    }
}

// Eliminar producto
if("eliminar".equals(accion)){
    int index = Integer.parseInt(request.getParameter("index"));
    carrito.remove(index);
}

// Finalizar venta
if("finalizar".equals(accion) && carrito.size() > 0){
    if(clienteIdSeleccionado.isEmpty()){
        out.println("<div class='alert alert-danger'>Debe seleccionar un cliente.</div>");
    } else {
        double subtotal=0;
        for(int i=0;i<carrito.size();i++){
            Map p=(Map)carrito.get(i);
            subtotal+=((Double)p.get("precio")).doubleValue() * ((Integer)p.get("cantidad")).intValue();
        }

        double impuesto=subtotal*0.15;
        double totalVenta=subtotal+impuesto;
        int clienteId=Integer.parseInt(clienteIdSeleccionado);

        String numeroFactura="FAC-"+System.currentTimeMillis();

        PreparedStatement psVenta=con.prepareStatement(
            "INSERT INTO ventas(fecha,total,usuario,cliente_id,numero_factura,subtotal,impuesto) VALUES(NOW(),?,?,?,?,?,?)",
            Statement.RETURN_GENERATED_KEYS);
        psVenta.setDouble(1,totalVenta);
        psVenta.setString(2,(String)session.getAttribute("usuario"));
        psVenta.setInt(3,clienteId);
        psVenta.setString(4,numeroFactura);
        psVenta.setDouble(5,subtotal);
        psVenta.setDouble(6,impuesto);
        psVenta.executeUpdate();

        ResultSet rsVenta=psVenta.getGeneratedKeys();
        int ventaId=0;

        if(rsVenta.next()){
            ventaId=rsVenta.getInt(1);
            for(int i=0;i<carrito.size();i++){
                Map p=(Map)carrito.get(i);

                PreparedStatement psDet=con.prepareStatement(
                    "INSERT INTO detalle_venta(venta_id,producto_id,cantidad,precio) VALUES(?,?,?,?)");
                psDet.setInt(1,ventaId);
                psDet.setInt(2,((Integer)p.get("id")).intValue());
                psDet.setInt(3,((Integer)p.get("cantidad")).intValue());
                psDet.setDouble(4,((Double)p.get("precio")).doubleValue());
                psDet.executeUpdate();

                PreparedStatement psStock=con.prepareStatement(
                    "UPDATE productos SET cantidad=cantidad-? WHERE id=?");
                psStock.setInt(1,((Integer)p.get("cantidad")).intValue());
                psStock.setInt(2,((Integer)p.get("id")).intValue());
                psStock.executeUpdate();
            }
        }

        carrito.clear();
        session.setAttribute("carrito",carrito);

        out.println("<div class='alert alert-success'>Venta realizada. Factura: <b>"+numeroFactura+"</b> <a href='imprimirFactura.jsp?ventaId="+ventaId+"' target='_blank'>Imprimir</a></div>");
    }
}
%>

<html>
<head>
<title>Facturación</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body{background:#e0f7ff;font-family:Arial;}
h2{color:#007acc;border-bottom:2px solid #00aaff;padding:10px;}
.table th,.table td{vertical-align:middle;}
.btn-primary{background:#00aaff;border-color:#00aaff;}
.btn-success{background:#00cc88;border-color:#00cc88;}
.btn-danger{background:#ff5555;border-color:#ff5555;}
.btn-info{background:#00aaff;border-color:#00aaff;}
.btn:hover,.btn:focus{opacity:.85;box-shadow:none;}
#buscar{margin-bottom:10px;}
</style>
</head>
<body>
<div class="container mt-4">
<h2>Facturación - Soluciones Maiyas</h2>

<!-- Selección de cliente -->
<form method="post" class="row g-2 mb-3">
<div class="col-md-4">
Cliente:
<select name="clienteId" class="form-control" onchange="this.form.submit()">
<option value="">-- Seleccionar Cliente --</option>
<%
Statement stC=con.createStatement();
ResultSet rsC=stC.executeQuery("SELECT * FROM clientes ORDER BY nombre");
while(rsC.next()){
    String clienteIdStr=String.valueOf(rsC.getInt("id"));
%>
<option value="<%=clienteIdStr%>" <%=clienteIdSeleccionado.equals(clienteIdStr)?"selected":""%>>
<%=rsC.getString("nombre")%> - <%=rsC.getString("telefono")%>
</option>
<%
}
%>
</select>
</div>
</form>

<!-- Buscador de productos -->
<input type="text" id="buscar" class="form-control mb-2" placeholder="Buscar producto">

<!-- Lista desplegable de productos -->
<form method="post" class="mb-3">
<input type="hidden" name="accion" value="agregar">
<input type="hidden" name="clienteId" value="<%=clienteIdSeleccionado%>">
<select id="productosSelect" name="productoId" class="form-control mb-2" required></select>
<input type="number" name="cantidad" value="1" min="1" class="form-control mb-2" style="width:100px;">
<button class="btn btn-success">Agregar al carrito</button>
</form>

<!-- Carrito -->
<h3>Carrito</h3>
<table class="table table-bordered">
<tr><th>Producto</th><th>Descripción</th><th>Precio</th><th>Cantidad</th><th>Total</th><th>Acción</th></tr>
<%
double totalGeneral=0;
for(int i=0;i<carrito.size();i++){
    Map p=(Map)carrito.get(i);
    double total=((Double)p.get("precio")).doubleValue() * ((Integer)p.get("cantidad")).intValue();
    totalGeneral+=total;
%>
<tr>
<td><%=p.get("nombre")%></td>
<td><%=p.get("descripcion")%></td>
<td>Lps <%=p.get("precio")%></td>
<td><%=p.get("cantidad")%></td>
<td>Lps <%=total%></td>
<td>
<form method="post">
<input type="hidden" name="accion" value="eliminar">
<input type="hidden" name="index" value="<%=i%>">
<input type="hidden" name="clienteId" value="<%=clienteIdSeleccionado%>">
<button class="btn btn-danger btn-sm">Cancelar</button>
</form>
</td>
</tr>
<%
}
double impuesto=totalGeneral*0.15;
double totalConImpuesto=totalGeneral+impuesto;
%>
<tr>
<td colspan="4" align="right"><b>Subtotal</b></td>
<td colspan="2">Lps <%=totalGeneral%></td>
</tr>
<tr>
<td colspan="4" align="right"><b>Impuesto (15%)</b></td>
<td colspan="2">Lps <%=impuesto%></td>
</tr>
<tr>
<td colspan="4" align="right"><b>Total</b></td>
<td colspan="2"><b>Lps <%=totalConImpuesto%></b></td>
</tr>
</table>

<!-- Finalizar venta -->
<form method="post">
<input type="hidden" name="accion" value="finalizar">
<input type="hidden" name="clienteId" value="<%=clienteIdSeleccionado%>">
<button class="btn btn-primary">Finalizar Venta</button>
</form>

<!-- Últimas ventas -->
<h3 class="mt-4">Últimas ventas</h3>
<table class="table table-bordered">
<tr><th>ID</th><th>Fecha</th><th>Total</th><th>Usuario</th><th>Cliente</th><th>Imprimir</th></tr>
<%
Statement stV=con.createStatement();
ResultSet rsV=stV.executeQuery(
"SELECT v.id,v.fecha,v.total,v.usuario,c.nombre cliente "+
"FROM ventas v LEFT JOIN clientes c ON v.cliente_id=c.id "+
"ORDER BY v.fecha DESC LIMIT 10");
while(rsV.next()){
    int ventaId=rsV.getInt("id");
%>
<tr>
<td><%=ventaId%></td>
<td><%=rsV.getString("fecha")%></td>
<td>Lps <%=rsV.getDouble("total")%></td>
<td><%=rsV.getString("usuario")%></td>
<td><%=rsV.getString("cliente")%></td>
<td>
<a href="imprimirFactura.jsp?ventaId=<%=ventaId%>" target="_blank" class="btn btn-info btn-sm">Imprimir</a>
</td>
</tr>
<%
}
%>
</table>
</div>

<script>
// Array de productos desde JSP
var productos = [];
<%
Statement stProd=con.createStatement();
ResultSet rsProd=stProd.executeQuery("SELECT * FROM productos ORDER BY cantidad DESC, nombre ASC");
while(rsProd.next()){
    int stock=rsProd.getInt("cantidad");
    int stockMin=rsProd.getInt("stock_minimo");
    boolean disponible = stock > stockMin;
%>
productos.push({
    id: '<%=rsProd.getInt("id")%>',
    nombre: '<%=rsProd.getString("nombre")%>',
    descripcion: '<%=rsProd.getString("descripcion")%>',
    disponible: <%=disponible%>
});
<%
}
%>

var select = document.getElementById("productosSelect");
var input = document.getElementById("buscar");

// Normaliza texto: minusculas, guiones y guion bajo como espacio, trim
function normalizar(texto){
    return texto.toLowerCase().replace(/[-_]/g," ").replace(/\s+/g," ").trim();
}

// Inicializar opciones del select
function cargarSelect(){
    select.innerHTML = "";
    for(var i=0;i<productos.length;i++){
        var p = productos[i];
        var opcion = document.createElement("option");
        opcion.value = p.id;
        opcion.text = p.nombre + " - " + p.descripcion + (p.disponible ? "" : " (No disponible)");
        if(!p.disponible) opcion.disabled = true;
        select.appendChild(opcion);
    }
}

// Filtrar select según input y seleccionar automáticamente primera coincidencia
function filtrarSelect(){
    var filtro = normalizar(input.value);
    var primera = null;

    for(var i=0;i<select.options.length;i++){
        var opcion = select.options[i];
        var p = productos[i];
        var texto = normalizar(p.nombre + " " + p.descripcion);

        if(texto.indexOf(filtro) !== -1){
            opcion.style.display = "";
            if(primera === null && p.disponible){
                primera = opcion;
            }
        } else {
            opcion.style.display = "none";
        }
    }

    if(primera !== null){
        select.value = primera.value;
    } else {
        select.value = "";
    }
}

// Inicializamos select completo
cargarSelect();

// Evento input
input.addEventListener("keyup", filtrarSelect);

// Enter agrega directamente el producto seleccionado
input.addEventListener("keydown", function(e){
    if(e.key === "Enter"){
        e.preventDefault();
        if(select.value !== ""){
            select.closest("form").submit();
        }
    }
});
</script>
</body>
</html>