<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Barra de Navegación Global Bootstrap 5 -->
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm mb-4">
  <div class="container-fluid px-4">
    <a class="navbar-brand fw-bold" href="gestion_productos.jsp">
      <i class="fa-solid fa-microchip text-info"></i> Sys<span class="text-info">Laptops</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarPrincipal" aria-controls="navbarPrincipal" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="navbarPrincipal">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">

        <li class="nav-item">
          <a class="nav-link px-3" href="gestion_productos.jsp"><i class="fa-solid fa-laptop me-1"></i> Productos</a>
        </li>
        <li class="nav-item">
          <a class="nav-link px-3" href="registrar_venta.jsp"><i class="fa-solid fa-cart-arrow-down me-1"></i> Ventas</a>
        </li>
        <li class="nav-item">
          <a class="nav-link px-3" href="inventario.jsp"><i class="fa-solid fa-boxes-stacked me-1"></i> Inventario</a>
        </li>
        <li class="nav-item">
          <a class="nav-link px-3" href="ReporteServlet"><i class="fa-solid fa-file-invoice me-1"></i> Reportes</a>
        </li>
      </ul>
      <div class="d-flex align-items-center">
         <%-- Recuperamos de la sesión los datos del usuario logueado para personalizar el navbar --%>
         <% 
            if (session.getAttribute("usuarioEnSesion") != null) { 
                modelo.Usuario navUser = (modelo.Usuario) session.getAttribute("usuarioEnSesion");
         %>
             <span class="text-white-50 me-4 fw-bold">
                 <i class="fa-solid fa-user-circle text-info me-2"></i> <%= navUser.getNombre() %> 
                 <span class="badge bg-secondary ms-1"><%= navUser.getRol() %></span>
             </span>
         <% } %>
         <a href="LogoutServlet" class="btn btn-outline-light btn-sm fw-bold px-3 py-2 rounded-3">
            <i class="fa-solid fa-power-off"></i> Cerrar Sesión
         </a>
      </div>
    </div>
  </div>
</nav>
