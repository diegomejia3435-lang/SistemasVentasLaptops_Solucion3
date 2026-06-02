package controlador;

import dao.DAOFactory;
import interfaces.IUsuarioDAO;
import modelo.Usuario;

import java.io.IOException;
// NOTA: Se está usando jakarta.servlet para servidores nuevos (Tomcat 10+), 
// si tu proyecto requiere javax.servlet (Tomcat 9 o anterior), cambia "jakarta" por "javax" aquí:
// import javax.servlet.ServletException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Recibir los parámetros del formulario HTML (index.jsp)
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        
        // 1.5. Validar con Apache Commons (Seguridad/Robustez)
        if (org.apache.commons.lang3.StringUtils.isBlank(correo) || org.apache.commons.lang3.StringUtils.isBlank(password)) {
            request.setAttribute("error", "Los campos no pueden estar vacíos o contener solo espacios.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        
        // 2. Instanciar el DAO a través de la interfaz usando el Factory (DIP)
        IUsuarioDAO dao = DAOFactory.getUsuarioDAO();
        Usuario usuarioValidado = dao.validar(correo, password);
        
        // 3. Evaluar el resultado y responder o redirigir
        if (usuarioValidado != null) {
            // Caso Éxito: Crear sesión para el usuario y llevar a productos
            HttpSession session = request.getSession();
            session.setAttribute("usuarioEnSesion", usuarioValidado);
            
            // Hacemos el redireccionamiento.
            // Hacemos el redireccionamiento ahora a la página de productos.
            response.sendRedirect("gestion_productos.jsp");
        } else {
            // Caso Fracaso: Redirigir de regreso al login colocando un posible error
            request.setAttribute("error", "Credenciales incorrectas. Verifique y vuelva a intentarlo.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // En caso de que se intente entrar por URL, forzar ir al JSP local
        response.sendRedirect("index.jsp");
    }
}
