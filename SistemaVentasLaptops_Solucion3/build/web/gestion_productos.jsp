<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="modelo.Producto"%>
<%@page import="java.util.List"%>
<%
    // Instanciar DAO y obtener la lista de productos
    ProductoDAO dao = new ProductoDAO();
    List<Producto> listaProductos = dao.listarTodo();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Productos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

<%@include file="navbar.jsp" %>

<div class="container">

    <%-- ── Alertas de resultado ─────────────────────────────────────────────── --%>
    <% String msg = request.getParameter("msg"); String err = request.getParameter("error"); %>
    <% if ("creado".equals(msg)) { %>
        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> Producto registrado correctamente en la base de datos.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("actualizado".equals(msg)) { %>
        <div class="alert alert-info alert-dismissible fade show mt-3" role="alert">
            <i class="fa-solid fa-pen-to-square me-2"></i> Producto actualizado correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("eliminado".equals(msg)) { %>
        <div class="alert alert-warning alert-dismissible fade show mt-3" role="alert">
            <i class="fa-solid fa-trash me-2"></i> Producto eliminado del inventario.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("fk".equals(err)) { %>
        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
            <i class="fa-solid fa-link me-2"></i>
            <strong>No se puede eliminar este producto</strong> porque tiene ventas registradas asociadas en la base de datos.
            Si desea retirarlo, ponga su stock en <strong>0</strong> usando el botón Editar.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if (err != null) { %>
        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> Ocurrió un error al procesar la operación. Intente nuevamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
        <h2 class="text-primary"><i class="fa-solid fa-laptop text-dark"></i> Inventario de Productos</h2>
        <%-- Botón que activa el modal de NUEVO producto --%>
        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#nuevoProductoModal">
            <i class="fa-solid fa-plus"></i> Nuevo Producto
        </button>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th scope="col" class="text-center">ID</th>
                    <th scope="col">Nombre</th>
                    <th scope="col">Marca</th>
                    <th scope="col">Categoría</th>
                    <th scope="col" class="text-center">Precio</th>
                    <th scope="col" class="text-center">Stock</th>
                    <th scope="col" class="text-center">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (listaProductos != null && !listaProductos.isEmpty()) {
                        for (Producto p : listaProductos) {
                %>
                <tr>
                    <td class="text-center fw-bold"><%= p.getIdProducto() %></td>
                    <td><%= p.getNombre() %></td>
                    <td><span class="badge bg-secondary"><%= p.getMarca() %></span></td>
                    <td><%= p.getCategoria() %></td>
                    <td class="text-success text-center fw-bold">S/ <%= String.format("%.2f", p.getPrecio()) %></td>
                    <td class="text-center">
                        <% if(p.getStock() > 10) { %>
                            <span class="badge bg-info text-dark"><%= p.getStock() %> ud.</span>
                        <% } else if(p.getStock() > 0) { %>
                            <span class="badge bg-warning text-dark"><%= p.getStock() %> ud.</span>
                        <% } else { %>
                            <span class="badge bg-danger">Agotado</span>
                        <% } %>
                    </td>
                    <td class="text-center">
                        <%-- ── Botón EDITAR: carga los datos en el modal de edición ────────── --%>
                        <button class="btn btn-sm btn-primary" title="Editar"
                            onclick="abrirEditar(
                                '<%= p.getIdProducto() %>',
                                '<%= p.getNombre().replace("'", "\\'") %>',
                                '<%= p.getMarca() %>',
                                '<%= p.getCategoria().replace("'", "\\'") %>',
                                '<%= p.getPrecio() %>',
                                '<%= p.getStock() %>'
                            )">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                        <%-- ── Botón ELIMINAR: confirma y redirige al servlet ─────────────── --%>
                        <button class="btn btn-sm btn-danger" title="Eliminar"
                            onclick="confirmarEliminar('<%= p.getIdProducto() %>', '<%= p.getNombre().replace("'", "\\'") %>')">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="text-center text-muted py-4">
                        <i class="fa-solid fa-box-open fs-2 mb-2 d-block"></i> No hay productos registrados en este momento.
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<%-- Modal NUEVO Producto — action apunta a ProductoServlet con accion=insertar --%>
<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="nuevoProductoModal" tabindex="-1" aria-labelledby="nuevoProductoModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="nuevoProductoModalLabel"><i class="fa-solid fa-plus-circle"></i> Registrar Nuevo Producto</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="formNuevo" action="ProductoServlet" method="POST">
            <input type="hidden" name="accion" value="insertar">
            <div class="row mb-3">
                <div class="col-md-12">
                    <label class="form-label">Nombre del Producto</label>
                    <input type="text" name="nombre" class="form-control" placeholder="Ej: Laptop HP Omen 15" required>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Marca</label>
                    <select name="marca" class="form-select" required>
                        <option value="">Seleccione...</option>
                        <option value="HP">HP</option>
                        <option value="Lenovo">Lenovo</option>
                        <option value="Asus">Asus</option>
                        <option value="Dell">Dell</option>
                        <option value="Acer">Acer</option>
                        <option value="Apple">Apple</option>
                        <option value="MSI">MSI</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Categoría</label>
                    <input type="text" name="categoria" class="form-control" placeholder="Ej: Gaming" required>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Precio (S/)</label>
                    <input type="number" name="precio" step="0.01" min="0.01" class="form-control" placeholder="0.00" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Stock</label>
                    <input type="number" name="stock" min="0" class="form-control" placeholder="Cantidad" required>
                </div>
            </div>
        </form>
      </div>
      <div class="modal-footer d-flex justify-content-between">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        <button type="submit" form="formNuevo" class="btn btn-success">
            <i class="fa-solid fa-save"></i> Guardar Producto
        </button>
      </div>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<%-- Modal EDITAR Producto — action apunta a ProductoServlet con accion=actualizar --%>
<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="editarProductoModal" tabindex="-1" aria-labelledby="editarProductoModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title" id="editarProductoModalLabel"><i class="fa-solid fa-pen-to-square"></i> Editar Producto</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="formEditar" action="ProductoServlet" method="POST">
            <input type="hidden" name="accion" value="actualizar">
            <input type="hidden" name="id" id="editId">
            <div class="row mb-3">
                <div class="col-md-12">
                    <label class="form-label">Nombre del Producto</label>
                    <input type="text" name="nombre" id="editNombre" class="form-control" required>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Marca</label>
                    <select name="marca" id="editMarca" class="form-select" required>
                        <option value="">Seleccione...</option>
                        <option value="HP">HP</option>
                        <option value="Lenovo">Lenovo</option>
                        <option value="Asus">Asus</option>
                        <option value="Dell">Dell</option>
                        <option value="Acer">Acer</option>
                        <option value="Apple">Apple</option>
                        <option value="MSI">MSI</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Categoría</label>
                    <input type="text" name="categoria" id="editCategoria" class="form-control" required>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Precio (S/)</label>
                    <input type="number" name="precio" id="editPrecio" step="0.01" min="0.01" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Stock</label>
                    <input type="number" name="stock" id="editStock" min="0" class="form-control" required>
                </div>
            </div>
        </form>
      </div>
      <div class="modal-footer d-flex justify-content-between">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" form="formEditar" class="btn btn-warning fw-bold">
            <i class="fa-solid fa-save"></i> Actualizar Producto
        </button>
      </div>
    </div>
  </div>
</div>

<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<%-- Modal de Confirmación para ELIMINAR --%>
<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="eliminarModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title"><i class="fa-solid fa-triangle-exclamation"></i> Confirmar</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <p>¿Deseas eliminar el producto <strong id="nombreEliminar"></strong>?</p>
        <p class="text-danger small">Esta acción no se puede deshacer.</p>
      </div>
      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
        <a id="btnConfirmarEliminar" href="#" class="btn btn-danger btn-sm fw-bold">
            <i class="fa-solid fa-trash"></i> Eliminar
        </a>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Abre el modal de edición e inyecta los datos del producto seleccionado
    function abrirEditar(id, nombre, marca, categoria, precio, stock) {
        document.getElementById('editId').value       = id;
        document.getElementById('editNombre').value   = nombre;
        document.getElementById('editMarca').value    = marca;
        document.getElementById('editCategoria').value = categoria;
        document.getElementById('editPrecio').value   = precio;
        document.getElementById('editStock').value    = stock;
        new bootstrap.Modal(document.getElementById('editarProductoModal')).show();
    }

    // Abre el modal de confirmación de eliminar con el nombre del producto
    function confirmarEliminar(id, nombre) {
        document.getElementById('nombreEliminar').textContent = nombre;
        document.getElementById('btnConfirmarEliminar').href = 'ProductoServlet?accion=eliminar&id=' + id;
        new bootstrap.Modal(document.getElementById('eliminarModal')).show();
    }
</script>
</body>
</html>
