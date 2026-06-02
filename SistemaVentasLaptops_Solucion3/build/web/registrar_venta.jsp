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

    ProductoDAO pdao = new ProductoDAO();
    List<Producto> catalogo = pdao.listarTodo();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Venta - Sistema Laptops</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

<!-- Navbar (Sencillo para Prototype) -->
<%@include file="navbar.jsp" %>

<div class="container mb-5">
    
    <!-- Mensajes de Alerta -->
    <% if("ok".equals(request.getParameter("exito"))){ %>
            <div class="alert alert-success shadow-sm mt-3 fw-bold rounded-3">
                <i class="fa-solid fa-circle-check fs-5 me-2"></i> ¡Transacción completada! La venta fue registrada satisfactoriamente.
            </div>
        <% } %>
        <% if("db".equals(request.getParameter("error"))){ %>
            <div class="alert alert-danger shadow-sm mt-3 fw-bold rounded-3">
                <i class="fa-solid fa-triangle-exclamation fs-5 me-2"></i> Ocurrió un fallo en el servidor o BD. Venta anulada por seguridad.
            </div>
        <% } %>
        <% if("stock".equals(request.getParameter("error"))){ 
            String prodFallo = request.getParameter("producto");
        %>
            <div class="alert alert-warning shadow-sm mt-3 fw-bold rounded-3" style="color: #664d03; background-color: #fff3cd; border-color: #ffecb5;">
                <i class="fa-solid fa-boxes-stacked fs-5 me-2"></i> Operación rechazada: No hay stock físico suficiente para el producto "<%= prodFallo %>".
            </div>
        <% } %>
    
    <% String err = request.getParameter("error"); 
       if(err != null && !"stock".equals(err) && !"db".equals(err)) { %>
       <div class="alert alert-danger shadow-sm"><i class="fa-solid fa-triangle-exclamation"></i> Ocurrió un error en el registro.</div>
    <% } %>

    <div class="row">
        <!-- Formulario Selector Superior -->
        <div class="col-12 mb-4">
            <div class="card main-card card-body">
                <h5 class="fw-bold mb-3 text-primary"><i class="fa-solid fa-barcode"></i> Añadir Productos</h5>
                <div class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label text-muted fw-bold">Seleccione un Producto</label>
                        <select class="form-select border-primary" id="cboProducto">
                            <option value="">[ Seleccione ]</option>
                            <% 
                              if(catalogo != null){
                                  for(Producto p : catalogo){ 
                                      if(p.getStock() > 0) { // Solo mostrar si hay stock
                            %>
                                    <option value="<%= p.getIdProducto() %>|<%= p.getPrecio() %>|<%= p.getNombre() %>">
                                        <%= p.getNombre() %> (Stock: <%= p.getStock() %>) - S/ <%= String.format("%.2f", p.getPrecio()) %>
                                    </option>
                            <%        }
                                  }
                              }
                            %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted fw-bold">Cantidad</label>
                        <input type="number" class="form-control text-center border-primary" id="txtCantidad" value="1" min="1">
                    </div>
                    <div class="col-md-3">
                        <button type="button" class="btn btn-primary w-100 fw-bold" onclick="agregarAlCarrito()">
                            <i class="fa-solid fa-plus"></i> Añadir a la lista
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Carrito de Compras Dinámico -->
        <div class="col-12">
            <div class="card main-card card-body p-4">
                <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-cart-shopping text-success"></i> Detalle de la Venta</h5>
                
                <form action="VentaServlet" method="POST" id="formVenta">
                    <div class="table-responsive">
                        <table class="table table-hover table-cart align-middle">
                            <thead>
                                <tr>
                                    <th>Descripción de Producto</th>
                                    <th class="text-center">Cantidad</th>
                                    <th class="text-end">P. Unitario</th>
                                    <th class="text-end">Subtotal</th>
                                    <th class="text-center">Quitar</th>
                                </tr>
                            </thead>
                            <tbody id="tablaCuerpo">
                                <!-- Filas JS -->
                                <tr id="filaVacia"><td colspan="5" class="text-center text-muted py-4"><i class="fa-solid fa-inbox fa-2x mb-2 d-block"></i> Aún no hay productos en la lista</td></tr>
                            </tbody>
                            <tfoot class="bg-light">
                                <tr>
                                    <td colspan="3" class="text-end fw-bold text-uppercase">Total General:</td>
                                    <td class="text-end fw-bold text-success fs-5" id="lblTotal">S/ 0.00</td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    
                    <!-- Contenedor Invisible para Inputs -->
                    <div id="contenedorInputs"></div>

                    <div class="d-flex justify-content-end mt-3">
                        <a href="gestion_productos.jsp" class="btn btn-outline-secondary me-2"><i class="fa-solid fa-xmark"></i> Cancelar</a>
                        <button type="submit" class="btn btn-success fw-bold px-4 shadow-sm" id="btnProcesar" disabled>
                            <i class="fa-solid fa-cash-register"></i> Procesar Venta
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Arreglo JS donde guardaremos la lista local de elementos de compra.
    let carrito = [];

    function agregarAlCarrito() {
        let select = document.getElementById("cboProducto");
        let cantStr = document.getElementById("txtCantidad").value;
        let cantidad = parseInt(cantStr);
        
        if (select.value === "" || isNaN(cantidad) || cantidad <= 0) {
            alert("Por favor, seleccione un producto válido y defina una cantidad mayor a 0.");
            return;
        }

        // El value está compuesto por: "ID|Precio|Nombre"
        let datos = select.value.split("|");
        let idProd = datos[0];
        let pre = parseFloat(datos[1]);
        let nom = datos[2];
        
        // Verificamos si en la lista JS ya se añadió este objeto previamente.
        let itemExistente = carrito.find(item => item.id == idProd);
        if (itemExistente) {
            itemExistente.cantidad += cantidad;
        } else {
            carrito.push({
                id: idProd,
                nombre: nom,
                precio: pre,
                cantidad: cantidad
            });
        }
        
        // Al final, repinta la tabla visual y rearmar los input hidden
        actualizarPantalla();
        
        // Reseteamos valores al default visual para mayor fluidez.
        select.value = "";
        document.getElementById("txtCantidad").value = "1";
    }

    function eliminarDelCarrito(index) {
        carrito.splice(index, 1);
        actualizarPantalla();
    }

    function actualizarPantalla() {
        let tabla = document.getElementById("tablaCuerpo");
        let lblTotal = document.getElementById("lblTotal");
        let btnProcesar = document.getElementById("btnProcesar");
        let contInputsDiv = document.getElementById("contenedorInputs");
        
        tabla.innerHTML = "";
        contInputsDiv.innerHTML = "";
        let sumaTotal = 0;

        if(carrito.length === 0){
            tabla.innerHTML = `<tr id="filaVacia"><td colspan="5" class="text-center text-muted py-4"><i class="fa-solid fa-inbox fa-2x mb-2 d-block"></i> Aún no hay productos en la lista</td></tr>`;
            lblTotal.innerText = "S/ 0.00";
            btnProcesar.disabled = true;
            return;
        }

        carrito.forEach((p, i) => {
            let subtotal = p.cantidad * p.precio;
            sumaTotal += subtotal;
            
            // Fila HTML FrontEnd
            let tr = document.createElement("tr");
            tr.innerHTML = `
                <td class="fw-bold">\${p.nombre}</td>
                <td class="text-center">\${p.cantidad}</td>
                <td class="text-end">S/ \${p.precio.toFixed(2)}</td>
                <td class="text-end fw-bold text-dark">S/ \${subtotal.toFixed(2)}</td>
                <td class="text-center">
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarDelCarrito(\${i})"><i class="fa-solid fa-trash"></i></button>
                </td>
            `;
            tabla.appendChild(tr);
            
            // Injección de Input Hidden Para que Java Servlet lo lea vía form POST
            contInputsDiv.innerHTML += `
               <input type="hidden" name="idProducto[]" value="\${p.id}">
               <input type="hidden" name="cantidad[]" value="\${p.cantidad}">
               <input type="hidden" name="precio[]" value="\${p.precio}">
            `;
        });

        lblTotal.innerText = `S/ \${sumaTotal.toFixed(2)}`;
        btnProcesar.disabled = false;
    }
</script>
</body>
</html>
