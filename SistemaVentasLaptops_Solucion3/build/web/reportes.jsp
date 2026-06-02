<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioEnSesion");
    if(user == null){
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Evitar errores de Null si se accede directo sin pasar por el Servlet
    Map<String, Double> resumen = (Map<String, Double>) request.getAttribute("resumen");
    List<Map<String, Object>> top = (List<Map<String, Object>>) request.getAttribute("topProductos");
    double[] ingresosMensuales = (double[]) request.getAttribute("ingresosMes");
    
    Double ingresosMesActual = (Double) request.getAttribute("ingresosMesActual");
    if (ingresosMesActual == null) ingresosMesActual = 0.0;
    
    Map<String, Integer> categorias = (Map<String, Integer>) request.getAttribute("categorias");
    
    double ingresosTotal = (resumen != null && resumen.get("ingresosTotales") != null) ? resumen.get("ingresosTotales") : 0.0;
    double conteoVentas = (resumen != null && resumen.get("cantidadVentas") != null) ? resumen.get("cantidadVentas") : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes Analíticos - Sistema Laptops</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

<%@include file="navbar.jsp" %>

<div class="container mb-5">

    <!-- Botón de Exportación POI -->
    <div class="d-flex justify-content-end mb-3">
        <a href="ReporteServlet?accion=exportarExcel" class="btn btn-success fw-bold shadow-sm">
            <i class="fa-solid fa-file-excel me-2"></i> Exportar a Excel (Apache POI)
        </a>
    </div>
    
    <!-- Resumen Ingresos Totales Extraídos de la Base de Datos -->
    <div class="row mb-4">
        <!-- Ingresos Históricos -->
        <div class="col-md-6 mb-3 mb-md-0">
            <div class="card card-ingresos p-4 shadow-sm border-0 text-center h-100">
                <i class="fa-solid fa-sack-dollar fa-3x mb-2 opacity-50"></i>
                <h6 class="text-uppercase fw-bold letter-spacing-1">Ingresos Globales Totales</h6>
                <h2 class="display-5 fw-bold">S/ <%= String.format("%.2f", ingresosTotal) %></h2>
                <p class="mb-0 text-white-50"><%= (int)conteoVentas %> transacciones facturadas globalmente.</p>
            </div>
        </div>
        
        <!-- Ingresos Mes Actual (NUEVO PUNTUAL DEL MES) -->
        <div class="col-md-6">
            <div class="card p-4 shadow-sm border-0 text-center h-100" style="background: linear-gradient(135deg, #10b981, #059669); color: white; border-radius: 12px;">
                <i class="fa-solid fa-calendar-check fa-3x mb-2 opacity-50"></i>
                <h6 class="text-uppercase fw-bold letter-spacing-1">Ingresos del Mes (Actual)</h6>
                <h2 class="display-5 fw-bold">S/ <%= String.format("%.2f", ingresosMesActual) %></h2>
                <p class="mb-0 text-white-50">Sincronizado vía PostgreSQL en Tiempo Real.</p>
            </div>
        </div>
    </div>

    <!-- Sección Inferior -->
    <div class="row g-4">
        
        <!-- Tabla: Productos Más Vendidos -->
        <div class="col-lg-5">
            <div class="card main-card card-body p-4 h-100">
                <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-trophy text-warning"></i> Productos Estrella</h5>
                <ul class="list-group list-group-flush">
                    <% 
                       if(top != null && !top.isEmpty()){
                           int rank = 1;
                           for(Map<String, Object> t : top){
                               String rColor = (rank == 1) ? "rank-gold" : (rank == 2) ? "rank-silver" : (rank == 3) ? "rank-bronze" : "rank-standard";
                    %>
                    <li class="list-group-item d-flex justify-content-between align-items-center py-3 px-0 border-bottom">
                        <div class="d-flex align-items-center">
                            <span class="product-rank <%= rColor %> fw-bold me-3 shadow-sm"><%= rank %></span>
                            <span class="fw-bold text-secondary"><%= t.get("nombre") %></span>
                        </div>
                        <span class="badge bg-primary rounded-pill px-3 py-2"><%= t.get("cantidad_total") %> uds. vendidas</span>
                    </li>
                    <% 
                              rank++;
                           }
                       } else { 
                    %>
                       <li class="list-group-item text-muted text-center py-4 border-0"><br>Sin datos de productos vendidos aún.</li>
                    <% } %>
                </ul>
            </div>
        </div>
        
        <!-- Gráfico de Chart.js dinámico -->
        <div class="col-lg-7">
            <div class="card main-card card-body p-4 h-100">
                <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-chart-column text-primary"></i> Ingresos Mensuales (Año en Curso)</h5>
                <div class="chart-container">
                    <canvas id="graficoBarras"></canvas>
                </div>
            </div>
        </div>

    </div>

    <!-- Nueva Fila: Gráfico Segmentado de Categorías (Laptops, Accesorios, etc) -->
    <div class="row mt-4">
        <div class="col-lg-6 mx-auto">
            <div class="card main-card card-body p-4 h-100 shadow-sm border-0">
                <h5 class="fw-bold mb-4 text-dark text-center"><i class="fa-solid fa-chart-pie text-success"></i> Ventas por Categoría (Laptops vs PCs)</h5>
                <div class="chart-container">
                    <canvas id="graficoDona"></canvas>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Funcionalidad de Chart.js Inyectando Java Array JSON-like -->
<script>
    // Recuperamos el array de Java que construimos en el Controlador, convirtiéndolo a un formato legible por JavaScript.
    <% 
        StringBuilder jsData = new StringBuilder();
        if(ingresosMensuales != null) {
            for(int i = 0; i < ingresosMensuales.length; i++) {
                jsData.append(ingresosMensuales[i]);
                if(i < ingresosMensuales.length - 1) jsData.append(",");
            }
        }
    %>
    const dataFromServer = [<%= jsData.toString() %>];

    const ctxBarras = document.getElementById('graficoBarras').getContext('2d');
    new Chart(ctxBarras, {
        type: 'bar',
        data: {
            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
            datasets: [{
                label: 'Ingresos Mensuales (S/)',
                data: dataFromServer,  // <-- Inyección desde Servidor
                backgroundColor: '#3b82f6',
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true }
            }
        }
    });

    // ==========================================
    // SEGUNDO GRÀFICO DOUGHNUT (CATEGORÌAS)
    // ==========================================
    <% 
        StringBuilder labelsCat = new StringBuilder();
        StringBuilder dataCat = new StringBuilder();
        if(categorias != null && !categorias.isEmpty()){
            int count = 0;
            for(Map.Entry<String, Integer> entry : categorias.entrySet()){
                labelsCat.append("'").append(entry.getKey()).append("'");
                dataCat.append(entry.getValue());
                if(count < categorias.size() - 1){
                    labelsCat.append(",");
                    dataCat.append(",");
                }
                count++;
            }
        }
    %>
    const ctxDona = document.getElementById('graficoDona').getContext('2d');
    new Chart(ctxDona, {
        type: 'doughnut',
        data: {
            labels: [<%= labelsCat.toString() %>],
            datasets: [{
                data: [<%= dataCat.toString() %>],
                backgroundColor: [
                    '#1a237e', /* Tech Blue */
                    '#0ea5e9', /* Light Blue */
                    '#f59e0b', /* Yellow */
                    '#10b981', /* Green */
                    '#ec4899'  /* Pink */
                ],
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
