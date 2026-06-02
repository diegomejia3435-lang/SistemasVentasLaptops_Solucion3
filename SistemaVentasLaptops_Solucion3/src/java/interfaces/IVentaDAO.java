package interfaces;

import modelo.DetalleVenta;
import modelo.Venta;
import java.util.List;

public interface IVentaDAO {
    boolean registrarVenta(Venta v, List<DetalleVenta> detalles);
}
