package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Conexion {
    private static final Logger logger = LoggerFactory.getLogger(Conexion.class);
    
    private Connection con;
    private final String bd = "sistema_laptops";
    private final String url = "jdbc:postgresql://localhost:5432/" + bd;
    private final String user = "postgres";
    private final String pass = "root";

    public Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            logger.error("Error de conexión a la base de datos", e);
        }
        return con;
    }
}
