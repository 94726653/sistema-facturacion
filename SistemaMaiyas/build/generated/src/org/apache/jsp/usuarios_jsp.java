package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import conexion.ConexionDB;

public final class usuarios_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList<String>(1);
    _jspx_dependants.add("/header.jsp");
  }

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write('\n');
      out.write(' ');
      out.write('\n');

    HttpSession miSession = request.getSession(false);
    String rolHeader = "empleado"; // valor por defecto
    if(miSession != null && miSession.getAttribute("rol") != null){
        rolHeader = (String) miSession.getAttribute("rol");
    }

      out.write("\n");
      out.write("\n");
      out.write("<!-- Header Navbar -->\n");
      out.write("<nav class=\"navbar navbar-expand-lg navbar-light\" style=\"background-color:#5bc0de;\"> <!-- color celeste -->\n");
      out.write("    <div class=\"container\">\n");
      out.write("        <!-- Logo + Nombre de la empresa -->\n");
      out.write("        <a class=\"navbar-brand text-white fw-bold d-flex align-items-center\" href=\"#\">\n");
      out.write("            <img src=\"images/logo_maiyas.png\" alt=\"Logo Maiyas\" style=\"height:40px; margin-right:10px;\">\n");
      out.write("            Soluciones Maiyas\n");
      out.write("        </a>\n");
      out.write("\n");
      out.write("        <button class=\"navbar-toggler\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarContent\"\n");
      out.write("                aria-controls=\"navbarContent\" aria-expanded=\"false\" aria-label=\"Toggle navigation\">\n");
      out.write("            <span class=\"navbar-toggler-icon\"></span>\n");
      out.write("        </button>\n");
      out.write("\n");
      out.write("        <div class=\"collapse navbar-collapse\" id=\"navbarContent\">\n");
      out.write("            <ul class=\"navbar-nav me-auto mb-2 mb-lg-0\">\n");
      out.write("                <li class=\"nav-item\"><a class=\"nav-link text-white\" href=\"menu.jsp\">Menú Principal</a></li>\n");
      out.write("                <li class=\"nav-item\"><a class=\"nav-link text-white\" href=\"inventario.jsp\">Inventario</a></li>\n");
      out.write("                <li class=\"nav-item\"><a class=\"nav-link text-white\" href=\"facturacion.jsp\">Facturación</a></li>\n");
      out.write("                <li class=\"nav-item\"><a class=\"nav-link text-white\" href=\"clientes.jsp\">Clientes</a></li>\n");
      out.write("                <li class=\"nav-item\"><a class=\"nav-link text-white\" href=\"reportes.jsp\">Reportes</a></li>\n");
      out.write("                ");
 if("admin".equalsIgnoreCase(rolHeader)) { 
      out.write("\n");
      out.write("                    <li class=\"nav-item\"><a class=\"nav-link text-white\" href=\"usuarios.jsp\">Usuarios</a></li>\n");
      out.write("                ");
 } 
      out.write("\n");
      out.write("            </ul>\n");
      out.write("            <span class=\"navbar-text text-white\">\n");
      out.write("                Bienvenido: <strong>");
      out.print( miSession != null ? miSession.getAttribute("usuario") : "Invitado" );
      out.write("</strong>\n");
      out.write("            </span>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("</nav>\n");
      out.write("\n");
      out.write("<!-- Bootstrap JS -->\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js\"></script>");
      out.write('\n');
      out.write('\n');

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
    out.println("<div class='alert alert-success'>Usuario agregado!</div>");
}

      out.write("\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>Usuarios</title>\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("<div class=\"container mt-5\">\n");
      out.write("<h2>Usuarios</h2>\n");
      out.write("\n");
      out.write("<!-- Formulario para agregar usuario -->\n");
      out.write("<form method=\"post\" class=\"row g-2 mb-3\">\n");
      out.write("    <div class=\"col-md-3\"><input type=\"text\" class=\"form-control\" name=\"usuarioNuevo\" placeholder=\"Usuario\" required></div>\n");
      out.write("    <div class=\"col-md-3\"><input type=\"password\" class=\"form-control\" name=\"passwordNuevo\" placeholder=\"Contraseña\" required></div>\n");
      out.write("    <div class=\"col-md-3\">\n");
      out.write("        <select name=\"rolNuevo\" class=\"form-control\">\n");
      out.write("            <option value=\"ADMIN\">ADMIN</option>\n");
      out.write("            <option value=\"EMPLEADO\">EMPLEADO</option>\n");
      out.write("        </select>\n");
      out.write("    </div>\n");
      out.write("    <div class=\"col-md-3\"><button class=\"btn btn-success w-100\">Agregar</button></div>\n");
      out.write("</form>\n");
      out.write("\n");
      out.write("<!-- Tabla de usuarios con Editar y Eliminar -->\n");
      out.write("<table class=\"table table-bordered\">\n");
      out.write("<tr><th>ID</th><th>Usuario</th><th>Rol</th><th>Acciones</th></tr>\n");

Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM usuarios");
while(rs.next()){

      out.write("\n");
      out.write("<tr>\n");
      out.write("    <td>");
      out.print(rs.getInt("id"));
      out.write("</td>\n");
      out.write("    <td>");
      out.print(rs.getString("usuario"));
      out.write("</td>\n");
      out.write("    <td>");
      out.print(rs.getString("rol"));
      out.write("</td>\n");
      out.write("    <td>\n");
      out.write("        <a href=\"editarUsuario.jsp?id=");
      out.print(rs.getInt("id"));
      out.write("\" class=\"btn btn-warning btn-sm\">Editar</a>\n");
      out.write("        <a href=\"eliminarUsuario.jsp?id=");
      out.print(rs.getInt("id"));
      out.write("\" class=\"btn btn-danger btn-sm\"\n");
      out.write("           onclick=\"return confirm('¿Desea eliminar este usuario?');\">Eliminar</a>\n");
      out.write("    </td>\n");
      out.write("</tr>\n");

}

      out.write("\n");
      out.write("</table>\n");
      out.write("</div>\n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
