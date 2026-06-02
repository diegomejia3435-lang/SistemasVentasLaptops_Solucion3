package dao;

import interfaces.IProductoDAO;
import interfaces.IReporteDAO;
import interfaces.IUsuarioDAO;
import interfaces.IVentaDAO;

/**
 * Fabrica de DAOs para aplicar el principio de Inversión de Dependencias (SOLID - DIP).
 * Permite a los Servlets depender de interfaces sin conocer la implementación exacta.
 */
public class DAOFactory {

    public static IProductoDAO getProductoDAO() {
        return new ProductoDAO();
    }

    public static IUsuarioDAO getUsuarioDAO() {
        return new UsuarioDAO();
    }

    public static IVentaDAO getVentaDAO() {
        return new VentaDAO();
    }

    public static IReporteDAO getReporteDAO() {
        return new ReporteDAO();
    }
}
