package controlador;

import dao.VentaDAO;
import modelo.DetalleVenta;
import modelo.Usuario;
import modelo.Venta;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "VentaServlet", urlPatterns = { "/VentaServlet" })
public class VentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario user = (Usuario) request.getSession().getAttribute("usuarioEnSesion");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Obtener los arrays desde el formulario dinámico
        String[] idsProductos = request.getParameterValues("idProducto[]");
        String[] cantidades = request.getParameterValues("cantidad[]");
        String[] precios = request.getParameterValues("precio[]");

        if (idsProductos == null || idsProductos.length == 0) {
            // No enviaron datos
            response.sendRedirect("registrar_venta.jsp?error=vacio");
            return;
        }

        double totalGlobal = 0;
        List<DetalleVenta> listaDetalle = new ArrayList<>();

        for (int i = 0; i < idsProductos.length; i++) {
            int id = Integer.parseInt(idsProductos[i]);
            int cant = Integer.parseInt(cantidades[i]);
            double pre = Double.parseDouble(precios[i]);

            totalGlobal += (cant * pre);

            DetalleVenta det = new DetalleVenta();
            det.setIdProducto(id);
            det.setCantidad(cant);
            det.setPrecioUnitario(pre);
            listaDetalle.add(det);
        }

        Venta venta = new Venta();
        venta.setTotal(totalGlobal);
        venta.setIdUsuario(user.getIdUsuario());

        // 1. Inyectamos la dependencia a través de la fábrica
        interfaces.IVentaDAO ventaDao = dao.DAOFactory.getVentaDAO();

        // 2. Delegamos la lógica transaccional pesada al DAO (MVC - Controlador ligero)
        boolean exito = ventaDao.registrarVenta(venta, listaDetalle);

        if (exito) {
            response.sendRedirect("registrar_venta.jsp?exito=ok");
        } else {
            // El DAO ya maneja el rollback si hay error (ej. falta de stock o error DB)
            response.sendRedirect("registrar_venta.jsp?error=db");
        }
    }
}
