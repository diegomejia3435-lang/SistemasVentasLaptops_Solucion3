package interfaces;

import java.util.List;
import java.util.Map;

public interface IReporteDAO {
    Map<String, Double> obtenerResumenVentas();
    List<Map<String, Object>> obtenerProductosMasVendidos();
    double[] obtenerIngresoMensual();
    double obtenerIngresosDelMes();
    Map<String, Integer> obtenerVentasPorCategoria();
}
