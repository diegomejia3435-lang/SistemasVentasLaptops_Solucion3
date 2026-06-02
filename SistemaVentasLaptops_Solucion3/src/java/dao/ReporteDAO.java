package dao;

import config.Conexion;
import interfaces.IReporteDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReporteDAO implements IReporteDAO {
    private Conexion cn = new Conexion();

    // 1. Obtener la suma total recabada y la cantidad de ventas hechas globalmente
    public Map<String, Double> obtenerResumenVentas() {
        Map<String, Double> resumen = new HashMap<>();
        String sql = "SELECT COUNT(id_venta) as cantidad, COALESCE(SUM(total), 0) as total_ingreso FROM ventas";
        
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            if (rs.next()) {
                resumen.put("cantidadVentas", (double) rs.getInt("cantidad"));
                resumen.put("ingresosTotales", rs.getDouble("total_ingreso"));
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerResumenVentas: " + e.getMessage());
        }
        return resumen;
    }

    // 2. Obtener el Top 5 de productos más vendidos (Suma total de cantidades del detalle)
    public List<Map<String, Object>> obtenerProductosMasVendidos() {
        List<Map<String, Object>> top = new ArrayList<>();
        String sql = "SELECT p.nombre, SUM(d.cantidad) as cant_total, SUM(d.cantidad * d.precio_unitario) as ing_total " +
                     "FROM detalle_ventas d " +
                     "JOIN productos p ON d.id_producto = p.id_producto " +
                     "GROUP BY p.nombre " +
                     "ORDER BY cant_total DESC LIMIT 5";
                     
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("nombre", rs.getString("nombre"));
                map.put("cantidad_total", rs.getInt("cant_total"));
                map.put("ingreso_total", rs.getDouble("ing_total"));
                top.add(map);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerProductosMasVendidos: " + e.getMessage());
        }
        return top;
    }

    // 3. Obtener el reporte de ingresos agrupado por mes (Para el gráfico Chart.js)
    public double[] obtenerIngresoMensual() {
        // Un arreglo para 12 meses, inicializado en 0 por defecto.
        double[] ingresosMes = new double[12];
        
        // Sumar ventas por mes, exclusivamente del año en curso
        String sql = "SELECT EXTRACT(MONTH FROM fecha) as mes, SUM(total) as suma " +
                     "FROM ventas WHERE EXTRACT(YEAR FROM fecha) = EXTRACT(YEAR FROM CURRENT_DATE) " +
                     "GROUP BY EXTRACT(MONTH FROM fecha)";
                     
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                int mesIndex = rs.getInt("mes") - 1; // Base 0 (Enero es 0)
                double suma = rs.getDouble("suma");
                ingresosMes[mesIndex] = suma;
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerIngresoMensual: " + e.getMessage());
        }
        return ingresosMes;
    }

    // 4. Total de ingresos puramente del mes actual
    public double obtenerIngresosDelMes() {
        double totalMes = 0;
        String sql = "SELECT COALESCE(SUM(total), 0) as total FROM ventas " +
                     "WHERE EXTRACT(MONTH FROM fecha) = EXTRACT(MONTH FROM CURRENT_DATE) " +
                     "AND EXTRACT(YEAR FROM fecha) = EXTRACT(YEAR FROM CURRENT_DATE)";
        try(Connection con = cn.getConnection(); 
            PreparedStatement ps = con.prepareStatement(sql); 
            ResultSet rs = ps.executeQuery()){
            if(rs.next()) totalMes = rs.getDouble("total");
        } catch(SQLException e) {
            System.err.println("Error en obtenerIngresosDelMes: " + e.getMessage());
        }
        return totalMes;
    }

    // 5. Productos vendidos organizados por Categoría (Para gráfica Chart JS Torta)
    public Map<String, Integer> obtenerVentasPorCategoria() {
        Map<String, Integer> categorias = new HashMap<>();
        String sql = "SELECT p.categoria, SUM(d.cantidad) as cant FROM detalle_ventas d " +
                     "JOIN productos p ON d.id_producto = p.id_producto GROUP BY p.categoria";
        try(Connection con = cn.getConnection(); 
            PreparedStatement ps = con.prepareStatement(sql); 
            ResultSet rs = ps.executeQuery()){
            while(rs.next()){
                String catName = rs.getString("categoria");
                // Si la categoría viene nula, la marcamos como "Otros"
                categorias.put(catName == null ? "Otros" : catName, rs.getInt("cant"));
            }
        } catch(SQLException e) {
            System.err.println("Error en obtenerVentasPorCategoria: " + e.getMessage());
        }
        return categorias;
    }
}
