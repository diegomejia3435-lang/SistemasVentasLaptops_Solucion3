<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="modelo.Producto"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.List"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioEnSesion");
    if(user == null){
        response.sendRedirect("index.jsp");
        return;
    }

    ProductoDAO dao = new ProductoDAO();
    List<Producto> listaProductos = dao.listarTodo();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario Crítico - Sistema Laptops</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

<%@include file="navbar.jsp" %>

<div class="container">
    <!-- Nueva sección de Alertas -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card card-body border-0 shadow-sm main-card">
                <h5 class="fw-bold text-danger mb-3"><i class="fa-solid fa-bell text-warning"></i> Alertas de Reabastecimiento</h5>
                <%
                    List<Producto> listaAlertas = dao.listarStockBajo();
                    if(listaAlertas != null && !listaAlertas.isEmpty()){
                %>
                <ul class="list-group">
                    <% for(Producto pa : listaAlertas) { %>
                    <li class="list-group-item d-flex justify-content-between align-items-center list-group-item-danger border-danger border-opacity-25 shadow-sm mb-1 rounded">
                        <span><strong>Cod. <%= pa.getIdProducto() %> - <%= pa.getNombre() %></strong> (<%= pa.getMarca() %>)</span>
                        <span class="badge bg-danger rounded-pill fs-6 px-3"><i class="fa-solid fa-arrow-down"></i> Quedan <%= pa.getStock() %> uds</span>
                    </li>
                    <% } %>
                </ul>
                <% } else { %>
                <div class="alert alert-success m-0 fw-bold border-0" style="background-color: #d1e7dd; color: #0f5132;">
                    <i class="fa-solid fa-circle-check fs-5 me-2"></i> Estado de Stock Saludable. No hay alertas críticas por atender.
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card main-card card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold m-0"><i class="fa-solid fa-clipboard-list text-primary"></i> Estado General de Inventario</h4>
                    <div>
                        <span class="badge bg-danger p-2"><i class="fa-solid fa-circle-exclamation"></i> Stock Crítico (< 5)</span>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th class="text-center">Cod</th>
                                <th>Descripción</th>
                                <th>Marca</th>
                                <th class="text-center">Stock Físico</th>
                                <th class="text-center">Déficit Inminente</th>
                                <th class="text-center">Acción Sugerida</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (listaProductos != null && !listaProductos.isEmpty()) {
                                    for (Producto p : listaProductos) {
                                        // Aquí implementamos la regla principal solicitada por el usuario
                                        boolean critico = p.getStock() < 5;
                                        String filaClase = critico ? "table-danger" : "";
                            %>
                            <tr class="<%= filaClase %>">
                                <td class="text-center fw-bold"><%= p.getIdProducto() %></td>
                                <td><%= p.getNombre() %></td>
                                <td><span class="badge bg-secondary"><%= p.getMarca() %></span></td>
                                <td class="text-center fw-bold fs-5 <%= critico ? "text-danger" : "text-success" %>">
                                    <%= p.getStock() %>
                                </td>
                                <td class="text-center">
                                    <% if(critico && p.getStock() > 0) { %>
                                        <i class="fa-solid fa-arrow-trend-down text-danger"></i> ¡Próximo a agotarse!
                                    <% } else if(critico && p.getStock() == 0) { %>
                                        <span class="badge bg-danger w-100 py-2">TOTALMENTE AGOTADO</span>
                                    <% } else { %>
                                        <i class="fa-solid fa-check text-success"></i> Abastecido
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-dark fw-bold"
                                        onclick="solicitarReabasto('<%= p.getIdProducto() %>', '<%= p.getNombre().replace("'", "\\'") %>', <%= p.getStock() %>)">
                                        <i class="fa-solid fa-truck-fast"></i> Solicitar
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    No se encontraron productos registrados en el inventario.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Modal Reabasto a Proveedor -->
<div class="modal fade" id="reabastoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header" style="background: #1e3a5f; color: white;">
        <h5 class="modal-title"><i class="fa-solid fa-truck-fast"></i> Solicitud de Reabastecimiento</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p class="mb-1">Producto: <strong id="rNombre"></strong></p>
        <p class="mb-3 text-danger">Stock actual: <strong id="rStock"></strong> unidades</p>
        <label class="form-label fw-bold">Cantidad a solicitar al proveedor</label>
        <input type="number" id="rCantidad" class="form-control" value="10" min="1">
        <div class="alert alert-info mt-3 mb-0 small">
            <i class="fa-solid fa-circle-info me-1"></i>
            En un sistema de producción, este formulario enviaría una orden de compra
            al proveedor conectado a la BD. En esta versión académica, registra la solicitud.
        </div>
      </div>
      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-dark fw-bold" onclick="confirmarSolicitud()">
            <i class="fa-solid fa-paper-plane"></i> Confirmar Solicitud
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Toast de confirmación -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
  <div id="toastReabasto" class="toast align-items-center text-bg-success border-0" role="alert">
    <div class="d-flex">
      <div class="toast-body fw-bold">
        <i class="fa-solid fa-circle-check me-2"></i> <span id="toastMsg"></span>
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
  </div>
</div>

<script>
    let productoActual = {};

    function solicitarReabasto(id, nombre, stock) {
        productoActual = { id, nombre, stock };
        document.getElementById('rNombre').textContent = nombre;
        document.getElementById('rStock').textContent  = stock;
        document.getElementById('rCantidad').value     = 10;
        new bootstrap.Modal(document.getElementById('reabastoModal')).show();
    }

    function confirmarSolicitud() {
        const cantidad = document.getElementById('rCantidad').value;
        bootstrap.Modal.getInstance(document.getElementById('reabastoModal')).hide();
        document.getElementById('toastMsg').textContent =
            'Solicitud de ' + cantidad + ' uds. de "' + productoActual.nombre + '" enviada correctamente.';
        new bootstrap.Toast(document.getElementById('toastReabasto'), { delay: 4000 }).show();
    }
</script>
</body>
</html>
