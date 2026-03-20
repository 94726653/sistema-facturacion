package conexion;
import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionDB {
    public static Connection getConnection(){
        Connection con = null;
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/sistema_maiyas","root","");
        } catch(Exception e){ e.printStackTrace(); }
        return con;
    }
}