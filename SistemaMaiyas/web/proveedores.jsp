<%@ include file="header.jsp" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, javax.sql.*" %>
<%@ page import="conexion.ConexionDB" %>

<%
Connection con = ConexionDB.getConnection();
String mensaje = "";

// ---------------- USUARIO EN SESIÓN ----------------
String usuarioSesion = (String) session.getAttribute("usuario");
if(usuarioSesion == null) usuarioSesion = "Desconocido";

// ---------------- VARIABLES FORMULARIO ----------------
String nombreForm = "";
String telefonoForm = "";
String correoForm = "";
String direccionForm = "";
Set productosForm = new HashSet();
Integer editarId = null;

// ---------------- CARGAR DATOS PARA EDITAR ----------------
if(request.getParameter("editar") != null && request.getParameter("nombre") == null){
    editarId = Integer.parseInt(request.getParameter("editar"));
    PreparedStatement pst = con.prepareStatement("SELECT * FROM proveedores WHERE id=?");
    pst.setInt(1, editarId);
    ResultSet rsEditar = pst.executeQuery();
    if(rsEditar.next()){
        nombreForm = rsEditar.getString("nombre");
        telefonoForm = rsEditar.getString("telefono");
        correoForm = rsEditar.getString("correo");
        direccionForm = rsEditar.getString("direccion");
        usuarioSesion = rsEditar.getString("creado_por");
    }
    // Productos seleccionados
    PreparedStatement pstProd = con.prepareStatement("SELECT producto_id FROM productos_proveedores WHERE proveedor_id=?");
    pstProd.setInt(1, editarId);
    ResultSet rsProd = pstProd.executeQuery();
    while(rsProd.next()){
        productosForm.add(new Integer(rsProd.getInt("producto_id")));
    }
}

// ---------------- ACCIONES ----------------
if(request.getParameter("guardar") != null){
    String nombre = request.getParameter("nombre");
    String telefono = request.getParameter("telefono");
    String correo = request.getParameter("correo");
    String direccion = request.getParameter("direccion");

    PreparedStatement pst = con.prepareStatement(
        "INSERT INTO proveedores (nombre, telefono, correo, direccion, creado_por) VALUES (?,?,?,?,?)",
        Statement.RETURN_GENERATED_KEYS
    );
    pst.setString(1, nombre);
    pst.setString(2, telefono);
    pst.setString(3, correo);
    pst.setString(4, direccion);
    pst.setString(5, usuarioSesion);
    pst.executeUpdate();

    ResultSet rsKey = pst.getGeneratedKeys();
    int proveedorId = 0;
    if(rsKey.next()){ proveedorId = rsKey.getInt(1); }

    String[] productosSeleccionados = request.getParameterValues("productos");
    String productosConcatenados = "";
    if(productosSeleccionados != null){
        PreparedStatement pstProd = con.prepareStatement(
            "INSERT INTO productos_proveedores (proveedor_id, producto_id) VALUES (?,?)"
        );
        for(int i=0;i<productosSeleccionados.length;i++){
            int pid = Integer.parseInt(productosSeleccionados[i]);
            pstProd.setInt(1, proveedorId);
            pstProd.setInt(2, pid);
            pstProd.executeUpdate();

            Statement stTemp = con.createStatement();
            ResultSet rsTemp = stTemp.executeQuery("SELECT nombre, descripcion FROM productos WHERE id=" + pid);
            if(rsTemp.next()){
                productosConcatenados += rsTemp.getString("nombre") + " (" + rsTemp.getString("descripcion") + ")";
                if(i < productosSeleccionados.length-1) productosConcatenados += ", ";
            }
        }
    }

    PreparedStatement pstUpd = con.prepareStatement(
        "UPDATE proveedores SET productos_suministrados=? WHERE id=?"
    );
    pstUpd.setString(1, productosConcatenados);
    pstUpd.setInt(2, proveedorId);
    pstUpd.executeUpdate();

    mensaje = "Proveedor registrado con éxito.";

} else if(request.getParameter("editar") != null && request.getParameter("nombre") != null){
    int idEditar = Integer.parseInt(request.getParameter("editar"));
    String nombre = request.getParameter("nombre");
    String telefono = request.getParameter("telefono");
    String correo = request.getParameter("correo");
    String direccion = request.getParameter("direccion");

    PreparedStatement pst = con.prepareStatement(
        "UPDATE proveedores SET nombre=?, telefono=?, correo=?, direccion=? WHERE id=?"
    );
    pst.setString(1, nombre);
    pst.setString(2, telefono);
    pst.setString(3, correo);
    pst.setString(4, direccion);
    pst.setInt(5, idEditar);
    pst.executeUpdate();

    PreparedStatement pstDel = con.prepareStatement("DELETE FROM productos_proveedores WHERE proveedor_id=?");
    pstDel.setInt(1, idEditar);
    pstDel.executeUpdate();

    String[] productosSeleccionados = request.getParameterValues("productos");
    String productosConcatenados = "";
    if(productosSeleccionados != null){
        PreparedStatement pstProd = con.prepareStatement(
            "INSERT INTO productos_proveedores (proveedor_id, producto_id) VALUES (?,?)"
        );
        for(int i=0;i<productosSeleccionados.length;i++){
            int pid = Integer.parseInt(productosSeleccionados[i]);
            pstProd.setInt(1, idEditar);
            pstProd.setInt(2, pid);
            pstProd.executeUpdate();

            Statement stTemp = con.createStatement();
            ResultSet rsTemp = stTemp.executeQuery("SELECT nombre, descripcion FROM productos WHERE id=" + pid);
            if(rsTemp.next()){
                productosConcatenados += rsTemp.getString("nombre") + " (" + rsTemp.getString("descripcion") + ")";
                if(i < productosSeleccionados.length-1) productosConcatenados += ", ";
            }
        }
    }

    PreparedStatement pstUpd = con.prepareStatement(
        "UPDATE proveedores SET productos_suministrados=? WHERE id=?"
    );
    pstUpd.setString(1, productosConcatenados);
    pstUpd.setInt(2, idEditar);
    pstUpd.executeUpdate();

    mensaje = "Proveedor actualizado con éxito.";

} else if(request.getParameter("eliminar") != null){
    int idEliminar = Integer.parseInt(request.getParameter("eliminar"));
    PreparedStatement pst = con.prepareStatement("DELETE FROM proveedores WHERE id=?");
    pst.setInt(1, idEliminar);
    pst.executeUpdate();
    mensaje = "Proveedor eliminado con éxito.";
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Proveedores - Sistema Maiyas Profesional</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.bootstrap5.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(to right, #cce6ff, #e6f7ff); font-family: Arial,sans-serif; }
        .contenedor-normal { width: auto; max-width: none; margin: 20px auto; }
        .card { border-radius: 20px; box-shadow: 0 8px 25px rgba(0,0,0,0.25); }
        h2 { color: #004080; font-weight: 600; margin-bottom: 20px; }
        h4 { color: #0066cc; font-weight: 500; margin-bottom: 15px; }
        .btn-primary { background-color: #3399ff; border: none; }
        .btn-primary:hover { background-color: #007acc; }
        .btn-warning { background-color: #ffcc00; border: none; }
        .btn-warning:hover { background-color: #e6b800; }
        .btn-danger { background-color: #cc0000; border: none; }
        .btn-danger:hover { background-color: #990000; }
        .btn-success { background-color: #28a745; border: none; }
        .btn-success:hover { background-color: #218838; }
        table th { background-color: #004080; color: white; text-align: center; }
        table td { vertical-align: middle; text-align: center; }
        .form-check-inline { margin-right: 15px; }
        .alert-success { background-color: #cce6ff; color: #004080; }
        .dt-buttons { margin-bottom: 10px; }
    </style>
</head>
<body>
<div class="contenedor-normal">
    <h2> Proveedores</h2>

    <!-- Formulario Agregar / Editar -->
    <div class="card p-4 mb-4">
       
        <form method="post">
            <div class="mb-3">
                <label>Nombre:</label>
                <input type="text" name="nombre" class="form-control" required value="<%=nombreForm%>">
            </div>
            <div class="mb-3">
                <label>Teléfono:</label>
                <input type="text" name="telefono" class="form-control" value="<%=telefonoForm%>">
            </div>
            <div class="mb-3">
                <label>Correo:</label>
                <input type="email" name="correo" class="form-control" value="<%=correoForm%>">
            </div>
            <div class="mb-3">
                <label>Dirección:</label>
                <input type="text" name="direccion" class="form-control" value="<%=direccionForm%>">
            </div>
            <div class="mb-3">
                <label>Productos suministrados:</label><br>
                <%
                    Statement stProd = con.createStatement();
                    ResultSet rsProd = stProd.executeQuery("SELECT * FROM productos");
                    while(rsProd.next()){
                        int pid = rsProd.getInt("id");
                        String checked = productosForm.contains(new Integer(pid)) ? "checked" : "";
                %>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" name="productos" value="<%=pid%>" <%=checked%>>
                        <label class="form-check-label"><%=rsProd.getString("nombre")%> (<%=rsProd.getString("descripcion")%>)</label>
                    </div>
                <%
                    }
                %>
            </div>
            <button type="submit" name="<%=editarId != null ? "editar" : "guardar"%>" class="btn btn-primary">
                <%=editarId != null ? "Actualizar" : "Guardar"%>
            </button>
        </form>
        <% if(!mensaje.isEmpty()){ %>
            <div class="alert alert-success mt-3" id="alertaMensaje"><%=mensaje%></div>
        <% } %>
    </div>

    <!-- Tabla de Proveedores -->
    <div class="card p-4">
        <h4>Listado de proveedores</h4>
        <input type="text" id="busqueda" placeholder="Buscar por nombre o producto..." class="form-control mb-3">
        <table id="tablaProveedores" class="table table-bordered table-striped table-hover nowrap" style="width:100%">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Teléfono</th>
                    <th>Correo</th>
                    <th>Dirección</th>
                    <th>Productos</th>
                    <th>Creado por</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
            <%
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM proveedores");
                while(rs.next()){
            %>
                <tr>
                    <td><%=rs.getInt("id")%></td>
                    <td><%=rs.getString("nombre")%></td>
                    <td><%=rs.getString("telefono")%></td>
                    <td><%=rs.getString("correo")%></td>
                    <td><%=rs.getString("direccion")%></td>
                    <td><%=rs.getString("productos_suministrados") != null ? rs.getString("productos_suministrados") : "-" %></td>
                    <td><%=rs.getString("creado_por")%></td>
                    <td>
                        <a href="proveedores.jsp?editar=<%=rs.getInt("id")%>" class="btn btn-warning btn-sm">Editar</a>
                        <a href="proveedores.jsp?eliminar=<%=rs.getInt("id")%>" class="btn btn-danger btn-sm" onclick="return confirm('¿Desea eliminar este proveedor?')">Eliminar</a>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

<script>
$(document).ready(function() {
    var table = $('#tablaProveedores').DataTable({
        dom: 'Bfrtip',
        paging: false,  // Quitamos paginación
        info: false,    // Quitamos el número de registros
        buttons: [
            { extend: 'excelHtml5', text: 'Exportar a Excel', className: 'btn btn-success btn-sm' },
            { extend: 'pdfHtml5', text: 'Exportar a PDF', className: 'btn btn-danger btn-sm', orientation: 'landscape', pageSize: 'A4', exportOptions: { columns: ':visible' } },
            { extend: 'print', text: 'Imprimir', className: 'btn btn-primary btn-sm' }
        ],
        language: { search: "Buscar:" },
        scrollX: true
    });

    $('#busqueda').on('keyup', function(){
        table.search(this.value).draw();
    });

    if($('#alertaMensaje').length){
        setTimeout(function(){
            $('#alertaMensaje').fadeOut('slow');
        }, 5000);
    }
});
</script>
</body>
</html>