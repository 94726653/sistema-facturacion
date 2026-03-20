package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;
import conexion.ConexionDB;

public final class facturacion_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write('\n');

    if(session.getAttribute("usuario") == null){
        response.sendRedirect("login.jsp");
    }
    String rol = (String) session.getAttribute("rol");

    Connection con = ConexionDB.getConnection();

    // Inicializar carrito en sesión
    List carrito = (List) session.getAttribute("carrito");
    if(carrito == null){
        carrito = new ArrayList();
        session.setAttribute("carrito", carrito);
    }

    // Agregar producto al carrito
    if(request.getParameter("productoId") != null && request.getParameter("cantidad") != null){
        int productoId = Integer.parseInt(request.getParameter("productoId"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        PreparedStatement psStock = con.prepareStatement("SELECT nombre, cantidad, precio FROM productos WHERE id=? AND activo=1");
        psStock.setInt(1, productoId);
        ResultSet rsStock = psStock.executeQuery();
        if(rsStock.next()){
            int stock = rsStock.getInt("cantidad");
            double precio = rsStock.getDouble("precio");
            String nombre = rsStock.getString("nombre");

            if(cantidad > stock){
                out.println("<div class='alert alert-danger'>No hay stock suficiente para " + nombre + "</div>");
            } else {
                // Crear mapa para el producto
                Map item = new HashMap();
                item.put("id", productoId);
                item.put("nombre", nombre);
                item.put("cantidad", cantidad);
                item.put("precio", precio);
                carrito.add(item);
            }
        }
    }

    // Calcular total
    double total = 0;
    for(int i=0; i<carrito.size(); i++){
        Map item = (Map) carrito.get(i);
        total += ((Integer)item.get("cantidad")) * ((Double)item.get("precio"));
    }

    // Finalizar venta
    if(request.getParameter("finalizar") != null && carrito.size() > 0){
        int clienteId = Integer.parseInt(request.getParameter("clienteId"));
        PreparedStatement psVenta = con.prepareStatement(
            "INSERT INTO ventas(fecha,total,usuario) VALUES(NOW(),?,?)", Statement.RETURN_GENERATED_KEYS
        );
        psVenta.setDouble(1, total);
        psVenta.setString(2, (String)session.getAttribute("usuario"));
        psVenta.executeUpdate();
        ResultSet rsVenta = psVenta.getGeneratedKeys();
        if(rsVenta.next()){
            int ventaId = rsVenta.getInt(1);
            for(int i=0; i<carrito.size(); i++){
                Map item = (Map) carrito.get(i);
                int pid = (Integer)item.get("id");
                int cant = (Integer)item.get("cantidad");
                double precio = (Double)item.get("precio");

                PreparedStatement psDetalle = con.prepareStatement(
                    "INSERT INTO detalle_venta(venta_id,producto_id,cantidad,precio) VALUES(?,?,?,?)"
                );
                psDetalle.setInt(1, ventaId);
                psDetalle.setInt(2, pid);
                psDetalle.setInt(3, cant);
                psDetalle.setDouble(4, precio);
                psDetalle.executeUpdate();

                // Actualizar stock
                PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE productos SET cantidad=cantidad-? WHERE id=?"
                );
                psUpdate.setInt(1, cant);
                psUpdate.setInt(2, pid);
                psUpdate.executeUpdate();
            }
            carrito.clear(); // Limpiar carrito después de venta
            out.println("<div class='alert alert-success'>Venta realizada correctamente</div>");
        }
    }

      out.write("\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>Facturación</title>\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("<div class=\"container mt-5\">\n");
      out.write("\n");
      out.write("<h2>Facturación - Soluciones Maiyas</h2>\n");
      out.write("\n");
      out.write("<form method=\"post\" class=\"row g-2 mb-3\">\n");
      out.write("    <div class=\"col-md-4\">\n");
      out.write("        Cliente:\n");
      out.write("        <select name=\"clienteId\" class=\"form-control\" required>\n");
      out.write("        ");

            Statement stC = con.createStatement();
            ResultSet rsC = stC.executeQuery("SELECT * FROM clientes");
            while(rsC.next()){
        
      out.write("\n");
      out.write("            <option value=\"");
      out.print(rsC.getInt("id"));
      out.write('"');
      out.write('>');
      out.print(rsC.getString("nombre"));
      out.write("</option>\n");
      out.write("        ");

            }
        
      out.write("\n");
      out.write("        </select>\n");
      out.write("    </div>\n");
      out.write("    <div class=\"col-md-4\">\n");
      out.write("        Producto:\n");
      out.write("        <select name=\"productoId\" class=\"form-control\" required>\n");
      out.write("        ");

            Statement stP = con.createStatement();
            ResultSet rsP = stP.executeQuery("SELECT * FROM productos WHERE activo=1");
            while(rsP.next()){
        
      out.write("\n");
      out.write("            <option value=\"");
      out.print(rsP.getInt("id"));
      out.write('"');
      out.write('>');
      out.print(rsP.getString("nombre"));
      out.write(" - Stock: ");
      out.print(rsP.getInt("cantidad"));
      out.write("</option>\n");
      out.write("        ");

            }
        
      out.write("\n");
      out.write("        </select>\n");
      out.write("    </div>\n");
      out.write("    <div class=\"col-md-2\">\n");
      out.write("        Cantidad:\n");
      out.write("        <input type=\"number\" class=\"form-control\" name=\"cantidad\" required min=\"1\">\n");
      out.write("    </div>\n");
      out.write("    <div class=\"col-md-2\">\n");
      out.write("        <br>\n");
      out.write("        <button class=\"btn btn-success w-100\">Agregar al carrito</button>\n");
      out.write("    </div>\n");
      out.write("</form>\n");
      out.write("\n");
      out.write("<h3>Carrito</h3>\n");
      out.write("<table class=\"table table-bordered\">\n");
      out.write("<tr><th>Producto</th><th>Cantidad</th><th>Precio</th><th>Subtotal</th></tr>\n");

for(int i=0; i<carrito.size(); i++){
    Map item = (Map) carrito.get(i);

      out.write("\n");
      out.write("<tr>\n");
      out.write("<td>");
      out.print( item.get("nombre") );
      out.write("</td>\n");
      out.write("<td>");
      out.print( item.get("cantidad") );
      out.write("</td>\n");
      out.write("<td>");
      out.print( item.get("precio") );
      out.write("</td>\n");
      out.write("<td>");
      out.print( ((Integer)item.get("cantidad"))*((Double)item.get("precio")) );
      out.write("</td>\n");
      out.write("</tr>\n");

}

      out.write("\n");
      out.write("<tr>\n");
      out.write("<td colspan=\"3\"><strong>Total</strong></td>\n");
      out.write("<td><strong>");
      out.print( total );
      out.write("</strong></td>\n");
      out.write("</tr>\n");
      out.write("</table>\n");
      out.write("\n");
      out.write("<form method=\"post\">\n");
      out.write("    <input type=\"hidden\" name=\"clienteId\" value=\"");
      out.print(request.getParameter("clienteId") != null ? request.getParameter("clienteId") : 1 );
      out.write("\">\n");
      out.write("    <button type=\"submit\" name=\"finalizar\" class=\"btn btn-primary\">Finalizar Venta</button>\n");
      out.write("</form>\n");
      out.write("\n");
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
