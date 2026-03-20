<%-- 
    Document   : inventario.jsp
    Created on : 02-18-2026, 08:34:31 PM
    Author     : Karol
--%>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, java.util.*, conexion.ConexionDB" %>
<%
if(session.getAttribute("usuario") == null){
    response.sendRedirect("login.jsp");
}
String rol = (String) session.getAttribute("rol");
Connection con = ConexionDB.getConnection();

// Agregar producto (solo admin)
if("ADMIN".equals(rol) && request.getParameter("nuevoNombre") != null){
    String nombre = request.getParameter("nuevoNombre");
    String desc = request.getParameter("nuevoDesc");
    double precio = Double.parseDouble(request.getParameter("nuevoPrecio"));
    int cantidad = Integer.parseInt(request.getParameter("nuevoCantidad"));
    int stockMin = Integer.parseInt(request.getParameter("nuevoStockMin"));

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO productos(nombre,descripcion,precio,cantidad,stock_minimo) VALUES(?,?,?,?,?)");
    ps.setString(1,nombre);
    ps.setString(2,desc);
    ps.setDouble(3,precio);
    ps.setInt(4,cantidad);
    ps.setInt(5,stockMin);
    ps.executeUpdate();
    out.println("<div class='alert alert-success alert-dismissible fade show mt-3' role='alert'>Producto agregado!<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>");
}

// Registrar entrada o salida de producto
String accionStock = request.getParameter("accionStock");
if(accionStock != null){
    int productoId = Integer.parseInt(request.getParameter("productoId"));
    int cantidadCambio = Integer.parseInt(request.getParameter("cantidadCambio"));

    if("entrada".equals(accionStock)){
        PreparedStatement ps = con.prepareStatement(
            "UPDATE productos SET cantidad = cantidad + ? WHERE id = ?");
        ps.setInt(1, cantidadCambio);
        ps.setInt(2, productoId);
        ps.executeUpdate();
        out.println("<div class='alert alert-success alert-dismissible fade show mt-3' role='alert'>Entrada registrada!<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>");
    } else if("salida".equals(accionStock)){
        PreparedStatement ps = con.prepareStatement(
            "UPDATE productos SET cantidad = cantidad - ? WHERE id = ?");
        ps.setInt(1, cantidadCambio);
        ps.setInt(2, productoId);
        ps.executeUpdate();
        out.println("<div class='alert alert-warning alert-dismissible fade show mt-3' role='alert'>Salida registrada!<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>");
    }
}
%>

<html>
<head>
    <title>Inventario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #e6f7ff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        h2 {
            color: #007acc;
            margin-bottom: 30px;
            text-align: center;
        }
        .table thead {
            background-color: #007acc;
            color: white;
        }
        .table tbody tr:hover {
            background-color: #cceeff;
        }
        .table-danger {
            background-color: #ffcccc !important;
        }
        .btn-custom {
            background-color: #00aaff;
            color: white;
            border: none;
        }
        .btn-custom:hover {
            background-color: #007acc;
        }
        .btn-success:hover {
            background-color: #28a745cc;
        }
        .btn-warning:hover {
            background-color: #ffc107cc;
        }
        .btn-danger:hover {
            background-color: #dc3545cc;
        }
        input.form-control {
            border-radius: 0.5rem;
        }
        .alert {
            border-radius: 0.5rem;
        }
        .card-form {
            background-color: white;
            border-radius: 0.5rem;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .table-responsive {
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 0.5rem;
            overflow: hidden;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2>Inventario</h2>

    <% if("ADMIN".equals(rol)){ %>
    <!-- Formulario para agregar nuevo producto -->
    <div class="card-form">
        <form method="post" class="row g-2">
            <div class="col-md-2"><input type="text" class="form-control" name="nuevoNombre" placeholder="Nombre" required></div>
            <div class="col-md-2"><input type="text" class="form-control" name="nuevoDesc" placeholder="Descripción"></div>
            <div class="col-md-2"><input type="number" step="0.01" class="form-control" name="nuevoPrecio" placeholder="Precio" required></div>
            <div class="col-md-2"><input type="number" class="form-control" name="nuevoCantidad" placeholder="Cantidad" required></div>
            <div class="col-md-2"><input type="number" class="form-control" name="nuevoStockMin" placeholder="Stock mínimo" required></div>
            <div class="col-md-2"><button class="btn btn-custom w-100">Agregar</button></div>
        </form>
    </div>
    <% } %>

    <!-- Tabla de productos -->
    <div class="table-responsive rounded">
        <table class="table table-bordered align-middle text-center mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Precio</th>
                    <th>Cantidad</th>
                    <th>Stock Mínimo</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
            <%
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM productos");
            while(rs.next()){
                int cantidad = rs.getInt("cantidad");
                int stockMin = rs.getInt("stock_minimo");
            %>
                <tr <%= (cantidad <= stockMin ? "class='table-danger'" : "") %>>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("descripcion") %></td>
                    <td>Lps <%= (int)Math.round(rs.getDouble("precio")) %></td>
                    <td><%= cantidad %></td>
                    <td><%= stockMin %></td>
                    <td>
                    <% if("ADMIN".equals(rol)){ %>
                        <a href="editarProducto.jsp?id=<%=rs.getInt("id")%>" class="btn btn-warning btn-sm mb-1">Editar</a>
                        <a href="eliminarProducto.jsp?id=<%=rs.getInt("id")%>" class="btn btn-danger btn-sm mb-1" onclick="return confirm('¿Desea eliminar este producto?');">Eliminar</a>
                        <form method="post" class="d-inline mt-1">
                            <input type="hidden" name="productoId" value="<%=rs.getInt("id")%>">
                            <input type="number" name="cantidadCambio" placeholder="Cant." required style="width:70px;" class="form-control d-inline">
                            <button class="btn btn-success btn-sm" name="accionStock" value="entrada">Entrada</button>
                            <button class="btn btn-warning btn-sm" name="accionStock" value="salida">Salida</button>
                        </form>
                    <% } else { %>
                        <button class="btn btn-secondary btn-sm" disabled>Sin permisos</button>
                    <% } %>
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>
    </div>
    <p class="text-danger mt-3">Productos en rojo están por debajo del stock mínimo</p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>