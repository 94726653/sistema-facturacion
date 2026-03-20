package servlets;

import conexion.ConexionDB;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Obtener datos y quitar espacios
        String usuario = request.getParameter("usuario").trim();
        String password = request.getParameter("password").trim();

        try {
            Connection con = ConexionDB.getConnection();
            
            // Consulta usando LOWER para insensibilidad a mayúsculas en usuario
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM usuarios WHERE LOWER(usuario)=LOWER(?) AND password=?"
            );
            ps.setString(1, usuario);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                // Guardar usuario y rol en sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuario", rs.getString("usuario"));
                session.setAttribute("rol", rs.getString("rol"));
                
                // Redirigir al menú
                response.sendRedirect("menu.jsp");
            } else {
                // Usuario o contraseña incorrecta
                response.sendRedirect("login.jsp?error=Usuario o contraseña incorrecta");
            }
        } catch(Exception e){ 
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Error interno, contacte al administrador");
        }
    }
}