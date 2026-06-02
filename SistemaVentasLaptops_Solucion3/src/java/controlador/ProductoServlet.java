package controlador;

import dao.DAOFactory;
import interfaces.IProductoDAO;
import modelo.Producto;
import modelo.Usuario;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * ProductoServlet: Controlador MVC que centraliza todas las acciones CRUD
 * sobre la tabla 'productos' de PostgreSQL.
 * Acciones disponibles via parámetro "accion":
 *   - "insertar"  -> POST: registra un nuevo producto
 *   - "actualizar"-> POST: modifica un producto existente
 *   - "eliminar"  -> GET:  borra un producto por su ID
 */
@WebServlet(name = "ProductoServlet", urlPatterns = {"/ProductoServlet"})
public class ProductoServlet extends HttpServlet {

    // 1. Inyectamos la dependencia a través de la fábrica y la interfaz
    private final IProductoDAO dao = DAOFactory.getProductoDAO();

    // ── GET: sólo se usa para eliminar ────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión activa
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioEnSesion");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("eliminar".equals(accion)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.eliminar(id);
                if (ok) {
                    response.sendRedirect("gestion_productos.jsp?msg=eliminado");
                } else {
                    response.sendRedirect("gestion_productos.jsp?error=eliminar");
                }
            } catch (java.sql.SQLException e) {
                System.err.println("SQL Error al eliminar: [" + e.getSQLState() + "] " + e.getMessage());
                // Código 23503 = foreign_key_violation en PostgreSQL
                if ("23503".equals(e.getSQLState())) {
                    response.sendRedirect("gestion_productos.jsp?error=fk");
                } else {
                    response.sendRedirect("gestion_productos.jsp?error=eliminar");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("gestion_productos.jsp?error=id");
            }
        } else {
            response.sendRedirect("gestion_productos.jsp");
        }
    }

    // ── POST: insertar y actualizar ────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Verificar sesión activa
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioEnSesion");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        // Construir objeto Producto con los datos del formulario
        Producto p = new Producto();
        p.setNombre(request.getParameter("nombre"));
        p.setMarca(request.getParameter("marca"));
        p.setCategoria(request.getParameter("categoria"));

        try {
            p.setPrecio(Double.parseDouble(request.getParameter("precio")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
        } catch (NumberFormatException e) {
            response.sendRedirect("gestion_productos.jsp?error=datos");
            return;
        }

        if ("insertar".equals(accion)) {
            boolean ok = dao.insertar(p);
            if (ok) {
                response.sendRedirect("gestion_productos.jsp?msg=creado");
            } else {
                response.sendRedirect("gestion_productos.jsp?error=insertar");
            }

        } else if ("actualizar".equals(accion)) {
            try {
                p.setIdProducto(Integer.parseInt(request.getParameter("id")));
            } catch (NumberFormatException e) {
                response.sendRedirect("gestion_productos.jsp?error=id");
                return;
            }
            boolean ok = dao.actualizar(p);
            if (ok) {
                response.sendRedirect("gestion_productos.jsp?msg=actualizado");
            } else {
                response.sendRedirect("gestion_productos.jsp?error=actualizar");
            }

        } else {
            response.sendRedirect("gestion_productos.jsp");
        }
    }
}
