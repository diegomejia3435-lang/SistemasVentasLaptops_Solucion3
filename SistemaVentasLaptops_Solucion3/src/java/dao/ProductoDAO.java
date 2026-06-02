package dao;

import config.Conexion;
import interfaces.IProductoDAO;
import modelo.Producto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import java.util.concurrent.TimeUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProductoDAO implements IProductoDAO {
    private Conexion cn = new Conexion();
    private static final Logger logger = LoggerFactory.getLogger(ProductoDAO.class);

    // 4. Implementación de Google Guava (Optimización/Caché)
    private static final Cache<String, List<Producto>> cacheProductos = CacheBuilder.newBuilder()
            .expireAfterWrite(5, TimeUnit.MINUTES)
            .build();

    public List<Producto> listarTodo() {
        long inicio = System.nanoTime(); // ⏱️ RNF02: Cronómetro de rendimiento

        // Intentar leer de la caché de RAM primero (Guava)
        List<Producto> lista = cacheProductos.getIfPresent("lista_todos");
        if (lista != null) {
            long tiempoMs = (System.nanoTime() - inicio) / 1_000_000;
            logger.info("✅ [CACHÉ HIT] Inventario servido desde RAM en {} ms (RNF02: < 3000 ms)", tiempoMs);
            return lista;
        }

        lista = new ArrayList<>();
        String sql = "SELECT * FROM productos";

        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setNombre(rs.getString("nombre"));
                p.setMarca(rs.getString("marca"));
                p.setCategoria(rs.getString("categoria"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                
                lista.add(p);
            }
            
            // Guardamos el resultado en caché para próximas peticiones
            if (!lista.isEmpty()) {
                cacheProductos.put("lista_todos", lista);
                long tiempoMs = (System.nanoTime() - inicio) / 1_000_000;
                logger.info("🗄️  [BD QUERY] Inventario consultado desde PostgreSQL en {} ms — almacenado en Caché por 5 min", tiempoMs);
            }
            
        } catch (SQLException e) {
            logger.error("Error al listar los productos", e);
        }

        return lista;
    }

    public Producto buscarPorId(int id) {
        Producto p = null;
        String sql = "SELECT * FROM productos WHERE id_producto = ?";

        // Preparamos PreparedStatement en el try, ResultSet se declara por separado porque depende de setInt
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Producto();
                    p.setIdProducto(rs.getInt("id_producto"));
                    p.setNombre(rs.getString("nombre"));
                    p.setMarca(rs.getString("marca"));
                    p.setCategoria(rs.getString("categoria"));
                    p.setPrecio(rs.getDouble("precio"));
                    p.setStock(rs.getInt("stock"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar el producto por ID: " + e.getMessage());
        }

        return p;
    }

    public List<Producto> listarStockBajo() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE stock < 5";

        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setNombre(rs.getString("nombre"));
                p.setMarca(rs.getString("marca"));
                p.setCategoria(rs.getString("categoria"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar stock bajo: " + e.getMessage());
        }

        return lista;
    }

    // ── INSERTAR ──────────────────────────────────────────────────────────────
    public boolean insertar(Producto p) {
        String sql = "INSERT INTO productos(nombre, marca, categoria, precio, stock) VALUES(?, ?, ?, ?, ?)";
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getMarca());
            ps.setString(3, p.getCategoria());
            ps.setDouble(4, p.getPrecio());
            ps.setInt(5, p.getStock());

            boolean success = ps.executeUpdate() > 0;
            if (success) {
                cacheProductos.invalidateAll();
                logger.info("Caché de productos invalidada tras inserción.");
            }
            return success;
        } catch (SQLException e) {
            logger.error("Error al insertar producto", e);
            return false;
        }
    }

    // ── ACTUALIZAR ────────────────────────────────────────────────────────────
    public boolean actualizar(Producto p) {
        String sql = "UPDATE productos SET nombre=?, marca=?, categoria=?, precio=?, stock=? WHERE id_producto=?";
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getMarca());
            ps.setString(3, p.getCategoria());
            ps.setDouble(4, p.getPrecio());
            ps.setInt(5, p.getStock());
            ps.setInt(6, p.getIdProducto());

            boolean success = ps.executeUpdate() > 0;
            if (success) {
                cacheProductos.invalidateAll();
                logger.info("Caché de productos invalidada tras actualización.");
            }
            return success;
        } catch (SQLException e) {
            logger.error("Error al actualizar producto", e);
            return false;
        }
    }

    // ── ELIMINAR ──────────────────────────────────────────────────────────────
    // Lanza SQLException para que el controlador pueda inspeccionar el código
    // de error de PostgreSQL (ej: 23503 = violación de clave foránea).
    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM productos WHERE id_producto = ?";
        try (Connection con = cn.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            boolean success = ps.executeUpdate() > 0;
            if (success) {
                cacheProductos.invalidateAll();
                logger.info("Caché de productos invalidada tras eliminación.");
            }
            return success;
        }
        // No se captura SQLException aquí: se propaga al servlet.
    }
}
