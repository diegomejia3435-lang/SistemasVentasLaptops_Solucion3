package config;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// El WebFilter se engancha a todos los JSPs de la aplicación de manera centralizada.
// Para no caer en bucles, no aseguramos index.jsp aquí, validamos unicamente las vistas privadas predeterminadas.
@WebFilter(urlPatterns = {
        "/gestion_productos.jsp",
        "/inventario.jsp",
        "/registrar_venta.jsp",
        "/reportes.jsp"
})
public class ValidarSesionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Ejecutado por el servidor web una vez en inicialización.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false); // false para que revise si existe, pero no cree una nueva

        // Si no hay sesión general o si el atributo del objeto mapeado está vacío en
        // caché:
        if (session == null || session.getAttribute("usuarioEnSesion") == null) {

            // Forzar expulsión re-dirigiendo al login.
            // Esto anula la navegación maliciosa copiando la URL.
            res.sendRedirect(req.getContextPath() + "/index.jsp");

        } else {
            // De conceder autorización, pasamos la batuta en el FilterChain para que
            // renderize correctamente el JSP elegido..
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Ejecutado al destruir la aplicación o el ciclo de vida.
    }
}
