package interfaces;

import modelo.Producto;
import java.sql.SQLException;
import java.util.List;

public interface IProductoDAO {
    List<Producto> listarTodo();
    Producto buscarPorId(int id);
    List<Producto> listarStockBajo();
    boolean insertar(Producto p);
    boolean actualizar(Producto p);
    boolean eliminar(int id) throws SQLException;
}
