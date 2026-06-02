<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema Laptops</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para Iconos Tecnológicos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

<div class="login-card text-center p-5 mx-auto shadow-lg" style="width: 100%; max-width: 400px;">
    <div class="login-logo">
        <i class="fa-solid fa-microchip"></i>
    </div>
    <h3 class="mb-4 brand-text">Sys<span class="brand-highlight">Laptops</span></h3>

    <!-- Scriptlet para mostrar errores de sesión al tratar de loguear -->
    <% 
        String errorMsg = (String) request.getAttribute("error");
        if (errorMsg != null) {
    %>
        <div class="alert alert-danger d-flex align-items-center py-2" role="alert" style="background: rgba(220, 53, 69, 0.1); border: 1px solid rgba(220, 53, 69, 0.2); color: #ff8a8a;">
            <i class="fa-solid fa-triangle-exclamation flex-shrink-0 me-2"></i>
            <div class="text-start small fw-bold">
                <%= errorMsg %>
            </div>
        </div>
    <% 
        } 
    %>

    <!-- Formulario que llama al Servlet "LoginServlet" por medio del action y usar método POST seguro -->
    <form action="LoginServlet" method="POST">
        <div class="input-group mb-3 text-start">
            <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
            <input type="email" name="correo" class="form-control" placeholder="Correo Administrativo" required autofocus>
        </div>

        <div class="input-group mb-4 text-start">
            <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
            <input type="password" name="password" class="form-control" placeholder="Contraseña" required>
        </div>

        <button type="submit" class="btn btn-primary w-100 btn-login text-white">
            <i class="fa-solid fa-right-to-bracket me-2"></i> Ingresar al Sistema
        </button>
    </form>
    
    <div class="mt-4 text-secondary small" style="opacity: 0.6;">
        <p class="mb-0">Proyecto Integrador I &copy; 2026</p>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
