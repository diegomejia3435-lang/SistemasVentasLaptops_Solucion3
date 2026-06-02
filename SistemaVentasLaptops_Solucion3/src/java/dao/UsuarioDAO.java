package dao;

import config.Conexion;
import interfaces.IUsuarioDAO;
import modelo.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO implements IUsuarioDAO {
    private Conexion cn = new Conexion();

    // Método para validar credenciales en el Login
    public Usuario validar(String correo, String password) {
        Usuario user = null;
        String sql = "SELECT * FROM usuarios WHERE correo = ? AND password = ?";
        
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, correo);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new Usuario();
                    user.setIdUsuario(rs.getInt("id_usuario"));
                    user.setNombre(rs.getString("nombre"));
                    user.setCorreo(rs.getString("correo"));
                    user.setPassword(rs.getString("password"));
                    user.setRol(rs.getString("rol"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al validar el usuario (DAO): " + e.getMessage());
        }
        
        return user;
    }
}
