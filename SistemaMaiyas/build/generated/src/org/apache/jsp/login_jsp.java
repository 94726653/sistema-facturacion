package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

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
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write(" \n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <title>Login - Soluciones Maiyas</title>\n");
      out.write("    <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("    <link href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css\" rel=\"stylesheet\">\n");
      out.write("    <style>\n");
      out.write("        /* Fondo corporativo elegante */\n");
      out.write("        body {\n");
      out.write("            background: linear-gradient(135deg, #e0f7ff, #ccefff);\n");
      out.write("            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;\n");
      out.write("            min-height: 100vh;\n");
      out.write("            display: flex;\n");
      out.write("            justify-content: center;\n");
      out.write("            align-items: center;\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Tarjeta login */\n");
      out.write("        .card-login {\n");
      out.write("            width: 400px;\n");
      out.write("            background: #ffffffdd;\n");
      out.write("            padding: 45px 35px;\n");
      out.write("            border-radius: 20px;\n");
      out.write("            box-shadow: 0 20px 50px rgba(0,0,0,0.15);\n");
      out.write("            transition: transform 0.3s ease, box-shadow 0.3s ease;\n");
      out.write("        }\n");
      out.write("        .card-login:hover {\n");
      out.write("            transform: translateY(-5px);\n");
      out.write("            box-shadow: 0 30px 60px rgba(0,0,0,0.2);\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Logo */\n");
      out.write("        .logo-container {\n");
      out.write("            text-align: center;\n");
      out.write("        }\n");
      out.write("        .logo-container img {\n");
      out.write("            width: 180px;\n");
      out.write("            border-radius: 18px;\n");
      out.write("            transition: transform 0.3s ease;\n");
      out.write("        }\n");
      out.write("        .logo-container img:hover {\n");
      out.write("            transform: scale(1.05);\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Título */\n");
      out.write("        .text-title {\n");
      out.write("            text-align: center;\n");
      out.write("            font-size: 2rem;\n");
      out.write("            font-weight: 700;\n");
      out.write("            color: #0099cc;\n");
      out.write("            margin-bottom: 30px;\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Inputs con icono */\n");
      out.write("        .input-group-text {\n");
      out.write("            background-color: #0099cc;\n");
      out.write("            color: white;\n");
      out.write("            border-radius: 12px 0 0 12px;\n");
      out.write("            border: none;\n");
      out.write("        }\n");
      out.write("        .form-control {\n");
      out.write("            border-radius: 0 12px 12px 0;\n");
      out.write("            border: 1px solid #0099cc;\n");
      out.write("            transition: all 0.3s;\n");
      out.write("        }\n");
      out.write("        .form-control:focus {\n");
      out.write("            border-color: #0077aa;\n");
      out.write("            box-shadow: 0 0 10px rgba(0,153,204,0.3);\n");
      out.write("            outline: none;\n");
      out.write("        }\n");
      out.write("        .input-group {\n");
      out.write("            margin-bottom: 20px;\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Botón login premium */\n");
      out.write("        .btn-login {\n");
      out.write("            width: 100%;\n");
      out.write("            background: linear-gradient(90deg, #00bfff, #007acc);\n");
      out.write("            color: white;\n");
      out.write("            font-weight: 600;\n");
      out.write("            padding: 12px 0;\n");
      out.write("            border-radius: 12px;\n");
      out.write("            transition: all 0.3s ease;\n");
      out.write("            box-shadow: 0 5px 15px rgba(0,191,255,0.4);\n");
      out.write("        }\n");
      out.write("        .btn-login:hover {\n");
      out.write("            background: linear-gradient(90deg, #007acc, #00bfff);\n");
      out.write("            transform: translateY(-3px);\n");
      out.write("            box-shadow: 0 8px 25px rgba(0,191,255,0.6);\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Mensaje de error */\n");
      out.write("        .text-danger {\n");
      out.write("            font-size: 0.9rem;\n");
      out.write("            text-align: center;\n");
      out.write("            margin-top: 10px;\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        /* Responsive */\n");
      out.write("        @media (max-width: 480px) {\n");
      out.write("            .card-login {\n");
      out.write("                width: 90%;\n");
      out.write("                padding: 30px 20px;\n");
      out.write("            }\n");
      out.write("            .text-title {\n");
      out.write("                font-size: 1.6rem;\n");
      out.write("            }\n");
      out.write("        }\n");
      out.write("    </style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("<div class=\"card-login shadow\">\n");
      out.write("    <div class=\"logo-container\">\n");
      out.write("        <img src=\"images/logo_maiyas.png\" alt=\"Logo Maiyas\">\n");
      out.write("    </div>\n");
      out.write("    <h1 class=\"text-title\">Soluciones Maiyas</h1>\n");
      out.write("    <form action=\"LoginServlet\" method=\"post\">\n");
      out.write("        <div class=\"input-group\">\n");
      out.write("            <span class=\"input-group-text\"><i class=\"fa fa-user\"></i></span>\n");
      out.write("            <input type=\"text\" name=\"usuario\" class=\"form-control\" placeholder=\"Usuario\" required>\n");
      out.write("        </div>\n");
      out.write("        <div class=\"input-group\">\n");
      out.write("            <span class=\"input-group-text\"><i class=\"fa fa-lock\"></i></span>\n");
      out.write("            <input type=\"password\" id=\"password\" name=\"password\" class=\"form-control\" placeholder=\"Contraseña\" required>\n");
      out.write("            <span class=\"input-group-text\" style=\"cursor:pointer;\" onclick=\"togglePassword()\">\n");
      out.write("                <i id=\"toggleIcon\" class=\"fa fa-eye-slash\"></i>\n");
      out.write("            </span>\n");
      out.write("        </div>\n");
      out.write("        <button class=\"btn btn-login\">Ingresar</button>\n");
      out.write("    </form>\n");
      out.write("    <p class=\"text-danger\">\n");
      out.write("        ");
      out.print( request.getParameter("error") != null ? request.getParameter("error") : "" );
      out.write("\n");
      out.write("    </p>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js\"></script>\n");
      out.write("<script src=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/js/all.min.js\"></script>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("function togglePassword() {\n");
      out.write("    const passwordInput = document.getElementById('password');\n");
      out.write("    const toggleIcon = document.getElementById('toggleIcon');\n");
      out.write("\n");
      out.write("    if (passwordInput.type === 'password') {\n");
      out.write("        passwordInput.type = 'text';\n");
      out.write("        toggleIcon.classList.remove('fa-eye-slash');\n");
      out.write("        toggleIcon.classList.add('fa-eye'); // visible = ojo\n");
      out.write("    } else {\n");
      out.write("        passwordInput.type = 'password';\n");
      out.write("        toggleIcon.classList.remove('fa-eye');\n");
      out.write("        toggleIcon.classList.add('fa-eye-slash'); // oculta = ojo con pleca\n");
      out.write("    }\n");
      out.write("}\n");
      out.write("</script>\n");
      out.write("\n");
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
