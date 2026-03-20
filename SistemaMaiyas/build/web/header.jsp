<%@ page import="javax.servlet.http.HttpSession" %>   
<%
    HttpSession miSession = request.getSession(false);
    String rolHeader = "empleado";

    if(miSession != null && miSession.getAttribute("rol") != null){
        rolHeader = (String) miSession.getAttribute("rol");
    }

    String paginaActual = request.getRequestURI();
%>

<style>

/* NAVBAR CELESTE PROFESIONAL */
.navbar{
    background: linear-gradient(90deg,#4fc3f7,#29b6f6,#03a9f4);
    box-shadow:0 6px 18px rgba(0,0,0,0.25);
    font-family:'Segoe UI',sans-serif;
}

/* LOGO */
.navbar-brand{
    font-size:20px;
    font-weight:700;
    color:white !important;
    letter-spacing:1px;
}

.navbar-brand img{
    transition:0.3s;
}

.navbar-brand img:hover{
    transform:scale(1.1);
}

/* LINKS MENU */
.navbar-nav .nav-link{
    color:white !important;
    font-weight:500;
    padding:8px 15px;
    border-radius:6px;
    transition:all 0.3s;
    display:flex;
    align-items:center;
    gap:6px;
}

/* HOVER */
.navbar-nav .nav-link:hover{
    background:rgba(255,255,255,0.25);
    transform:translateY(-2px);
}

/* LINK ACTIVO */
.navbar-nav .nav-link.active{
    background:white;
    color:#0288d1 !important;
    font-weight:600;
    box-shadow:0 4px 10px rgba(0,0,0,0.3);
}

/* TEXTO USUARIO */
.navbar-text{
    color:white;
    font-weight:500;
}

/* BOTON CERRAR SESION */
.btn-logout{
    background:linear-gradient(135deg,#ff4d4d,#d50000);
    border:none;
    border-radius:25px;
    padding:8px 20px;
    color:white !important;
    font-weight:600;
    transition:0.3s;
    box-shadow:0 4px 10px rgba(0,0,0,0.3);
}

.btn-logout:hover{
    transform:scale(1.08);
    background:linear-gradient(135deg,#ff1a1a,#b00000);
}

/* RESPONSIVE */
@media(max-width:991px){

    .navbar-nav .nav-link{
        margin:4px 0;
    }

}

</style>

<!-- ICONOS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<nav class="navbar navbar-expand-lg navbar-dark">

<div class="container">

    <!-- LOGO -->
    <a class="navbar-brand d-flex align-items-center" href="#">
        <img src="images/logo_maiyas.png" style="height:40px;margin-right:10px;">
       
    </a>

    <!-- BOTON RESPONSIVE -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarContent">

        <ul class="navbar-nav me-auto">

            <!-- MENU PRINCIPAL SOLO SI NO ESTAS EN MENU -->
            <% if(!paginaActual.endsWith("menu.jsp")){ %>
            <li class="nav-item">
                <a class="nav-link" href="menu.jsp">
                    <i class="fa-solid fa-house"></i> Menú Principal
                </a>
            </li>
            <% } %>

            <!-- INVENTARIO -->
            <li class="nav-item">
                <a class="nav-link <%= paginaActual.endsWith("inventario.jsp") ? "active" : "" %>" href="inventario.jsp">
                    <i class="fa-solid fa-boxes-stacked"></i> Inventario
                </a>
            </li>

            <!-- FACTURACIÓN -->
            <li class="nav-item">
                <a class="nav-link <%= paginaActual.endsWith("facturacion.jsp") ? "active" : "" %>" href="facturacion.jsp">
                    <i class="fa-solid fa-file-invoice-dollar"></i> Facturación
                </a>
            </li>

            <!-- CLIENTES -->
            <li class="nav-item">
                <a class="nav-link <%= paginaActual.endsWith("clientes.jsp") ? "active" : "" %>" href="clientes.jsp">
                    <i class="fa-solid fa-users"></i> Clientes
                </a>
            </li>

            <!-- OPCIONES SOLO ADMIN -->
            <% if("admin".equalsIgnoreCase(rolHeader)){ %>

                <!-- USUARIOS -->
                <li class="nav-item">
                    <a class="nav-link <%= paginaActual.endsWith("usuarios.jsp") ? "active" : "" %>" href="usuarios.jsp">
                        <i class="fa-solid fa-user-gear"></i> Usuarios
                    </a>
                </li>

                <!-- REPORTES -->
                <li class="nav-item">
                    <a class="nav-link <%= paginaActual.endsWith("reportes.jsp") ? "active" : "" %>" href="reportes.jsp">
                        <i class="fa-solid fa-chart-line"></i> Reportes
                    </a>
                </li>

                <!-- PROVEEDORES -->
                <li class="nav-item">
                    <a class="nav-link <%= paginaActual.endsWith("proveedores.jsp") ? "active" : "" %>" href="proveedores.jsp">
                        <i class="fa-solid fa-truck"></i> Proveedores
                    </a>
                </li>

            <% } %>

        </ul>

        <!-- USUARIO Y LOGOUT -->
        <div class="d-flex align-items-center">

            <span class="navbar-text me-3">
                Bienvenido:
                <strong><%= miSession != null ? miSession.getAttribute("usuario") : "Invitado" %></strong>
            </span>

            <a href="logout.jsp" class="btn btn-logout">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
            </a>

        </div>

    </div>
</div>

</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>