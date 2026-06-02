package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtiene la sesión activa actual pasando "false" para no crear una inadvertidamente
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Destruye completamente la variable "usuarioEnSesion" y el ID de sesión del servidor web
            session.invalidate();
        }
        
        // Retorna a la pantalla principal Login
        response.sendRedirect("index.jsp");
    }
}
