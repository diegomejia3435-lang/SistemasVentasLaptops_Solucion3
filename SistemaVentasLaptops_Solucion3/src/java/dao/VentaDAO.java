package dao;

import config.Conexion;
import interfaces.IVentaDAO;
import modelo.DetalleVenta;
import modelo.Venta;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class VentaDAO implements IVentaDAO {
    private Conexion cn = new Conexion();

    // Método transaccional: Inserta la venta, sus detalles y reduce el stock. Si algo falla, se revierte todo (Rollback)
    public boolean registrarVenta(Venta v, List<DetalleVenta> detalles) {
        boolean exito = false;
        
        // Uso de RETURNING para capturar inmediatamente el id autogenerado por PostgreSQL
        String sqlVenta = "INSERT INTO ventas(total, id_usuario) VALUES(?, ?) RETURNING id_venta";
        String sqlDet = "INSERT INTO detalle_ventas(id_venta, id_producto, cantidad, precio_unitario) VALUES(?, ?, ?, ?)";
        String sqlStock = "UPDATE productos SET stock = stock - ? WHERE id_producto = ?";

        Connection con = null;
        try {
            con = cn.getConnection();
            con.setAutoCommit(false); // 1. Deshabilitar auto-commit para iniciar transacción manual
            
            int idVentaGenerado = 0;
            
            // 2. Registrar el encabezado de Venta
            try (PreparedStatement psVenta = con.prepareStatement(sqlVenta)) {
                psVenta.setDouble(1, v.getTotal());
                psVenta.setInt(2, v.getIdUsuario());
                
                try (ResultSet rs = psVenta.executeQuery()) {
                    if (rs.next()) {
                        idVentaGenerado = rs.getInt(1);
                    }
                }
            }
            
            if (idVentaGenerado == 0) {
                con.rollback();
                return false;
            }

            // 3. Registrar el detalle utilizando Batch Update y mermar el stock de forma atómica
            try (PreparedStatement psDet = con.prepareStatement(sqlDet);
                 PreparedStatement psStock = con.prepareStatement(sqlStock)) {
                 
                for (DetalleVenta d : detalles) {
                    // Preparamos Detalle
                    psDet.setInt(1, idVentaGenerado);
                    psDet.setInt(2, d.getIdProducto());
                    psDet.setInt(3, d.getCantidad());
                    psDet.setDouble(4, d.getPrecioUnitario());
                    psDet.addBatch();
                    
                    // Preparamos actualización de Stock
                    psStock.setInt(1, d.getCantidad());
                    psStock.setInt(2, d.getIdProducto());
                    psStock.addBatch();
                }
                
                psDet.executeBatch();
                psStock.executeBatch();
            }

            // 4. Confirmar todo el bloque en la BD
            con.commit();
            exito = true;
            
        } catch (SQLException e) {
            System.err.println("Error en transacción registrarVenta: " + e.getMessage());
            try {
                if (con != null) {
                    con.rollback(); // Deshacer cambios si ocurre cualquier fallo en la inserción
                }
            } catch (SQLException ex) {
                System.err.println("Error haciendo rollback de VentaDAO: " + ex.getMessage());
            }
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) { }
        }
        
        return exito;
    }
}
