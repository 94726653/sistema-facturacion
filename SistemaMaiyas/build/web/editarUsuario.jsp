<%-- 
    Document   : editarUsuario.jsp
    Created on : 03-06-2026, 05:06:45 AM
    Author     : Karol
--%>

<%@ page import="java.sql.*, conexion.ConexionDB" %>
<%
if(session.getAttribute("usuario") == null || !"ADMIN".equals(session.getAttribute("rol"))){
    response.sendRedirect("menu.jsp");
    return;
}

// Obtener el ID del usuario a editar
String idStr = request.getParameter("id");
if(idStr == null){
    response.sendRedirect("usuarios.jsp");
    return;
}

int id = Integer.parseInt(idStr);
Connection con = ConexionDB.getConnection();

// Procesar actualización si se envió el formulario
if(request.getParameter("usuario") != null){
    String usuarioNuevo = request.getParameter("usuario");
    String passwordNuevo = request.getParameter("password");
    String rolNuevo = request.getParameter("rol");

    PreparedStatement psUpdate = con.prepareStatement(
        "UPDATE usuarios SET usuario=?, password=?, rol=? WHERE id=?");
    psUpdate.setString(1, usuarioNuevo);
    psUpdate.setString(2, passwordNuevo);
    psUpdate.setString(3, rolNuevo);
    psUpdate.setInt(4, id);
    psUpdate.executeUpdate();
    psUpdate.close();

    // Redirigir a la lista de usuarios después de editar
    response.sendRedirect("usuarios.jsp");
    return;
}

// Obtener datos actuales del usuario
PreparedStatement ps = con.prepareStatement("SELECT * FROM usuarios WHERE id=?");
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();
if(!rs.next()){
    response.sendRedirect("usuarios.jsp");
    return;
}

String usuarioActual = rs.getString("usuario");
String passwordActual = rs.getString("password");
String rolActual = rs.getString("rol");

rs.close();
ps.close();
con.close();
%>

<html>
<head>
    <title>Editar Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Editar Usuario</h2>
    <form method="post" class="row g-2">
        <div class="col-md-4">
            <label>Usuario</label>
            <input type="text" name="usuario" class="form-control" value="<%=usuarioActual%>" required>
        </div>
        <div class="col-md-4">
            <label>Contraseña</label>
            <input type="text" name="password" class="form-control" value="<%=passwordActual%>" required>
        </div>
        <div class="col-md-4">
            <label>Rol</label>
            <select name="rol" class="form-control">
                <option value="ADMIN" <%= "ADMIN".equalsIgnoreCase(rolActual) ? "selected" : "" %>>ADMIN</option>
                <option value="EMPLEADO" <%= "EMPLEADO".equalsIgnoreCase(rolActual) ? "selected" : "" %>>EMPLEADO</option>
            </select>
        </div>
        <div class="col-md-12 mt-3">
            <button class="btn btn-primary">Actualizar Usuario</button>
            <a href="usuarios.jsp" class="btn btn-secondary">Cancelar</a>
        </div>
    </form>
</div>
</body>
</html>