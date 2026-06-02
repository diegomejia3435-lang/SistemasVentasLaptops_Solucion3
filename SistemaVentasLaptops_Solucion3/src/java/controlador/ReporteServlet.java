package controlador;

import dao.DAOFactory;
import interfaces.IReporteDAO;
import modelo.Usuario;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 5. Implementación de Apache POI (Exportación a Excel)
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "ReporteServlet", urlPatterns = {"/ReporteServlet"})
public class ReporteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // Validar que el usuario esté logueado
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioEnSesion");
        if(user == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        IReporteDAO dao = DAOFactory.getReporteDAO();
        
        // Ejecutar consultas de reportería
        Map<String, Double> resumenVentas = dao.obtenerResumenVentas();
        List<Map<String, Object>> topProductos = dao.obtenerProductosMasVendidos();
        
        // Verificar si el usuario solicitó la exportación a Excel
        String accion = request.getParameter("accion");
        if ("exportarExcel".equals(accion)) {
            exportarExcel(response, resumenVentas, topProductos);
            return; // Terminar la ejecución para no intentar cargar el JSP
        }
        
        // Datos adicionales para la vista web
        double[] ingresosMes = dao.obtenerIngresoMensual();
        double ingresosMesActual = dao.obtenerIngresosDelMes();
        Map<String, Integer> categorias = dao.obtenerVentasPorCategoria();
        
        // Anclar estos datos como atributos para el Request
        request.setAttribute("resumen", resumenVentas);
        request.setAttribute("topProductos", topProductos);
        request.setAttribute("ingresosMes", ingresosMes);
        request.setAttribute("ingresosMesActual", ingresosMesActual);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("reportes.jsp").forward(request, response);
    }
    
    // Lógica encapsulada para generar el Excel usando Apache POI
    private void exportarExcel(HttpServletResponse response, Map<String, Double> resumenVentas, List<Map<String, Object>> topProductos) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=ReporteVentas.xlsx");

        try (XSSFWorkbook workbook = new XSSFWorkbook();
             OutputStream out = response.getOutputStream()) {
             
            XSSFSheet sheet = workbook.createSheet("Resumen de Ventas");
            
            // Fila de Cabecera
            XSSFRow headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("Métrica");
            headerRow.createCell(1).setCellValue("Valor");
            
            // Datos del Resumen
            XSSFRow row1 = sheet.createRow(1);
            row1.createCell(0).setCellValue("Total Recaudado (S/)");
            row1.createCell(1).setCellValue(resumenVentas.getOrDefault("totalGlobal", 0.0));
            
            XSSFRow row2 = sheet.createRow(2);
            row2.createCell(0).setCellValue("Cantidad de Ventas");
            row2.createCell(1).setCellValue(resumenVentas.getOrDefault("cantidadVentas", 0.0));
            
            // Espacio
            sheet.createRow(4).createCell(0).setCellValue("Top Productos Más Vendidos");
            XSSFRow headerTop = sheet.createRow(5);
            headerTop.createCell(0).setCellValue("Producto");
            headerTop.createCell(1).setCellValue("Cantidad Vendida");
            headerTop.createCell(2).setCellValue("Ingreso Generado");
            
            // Datos Top Productos
            int rowNum = 6;
            for (Map<String, Object> p : topProductos) {
                XSSFRow row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(String.valueOf(p.get("nombre")));
                row.createCell(1).setCellValue(Integer.parseInt(String.valueOf(p.get("cantidad_total"))));
                row.createCell(2).setCellValue(Double.parseDouble(String.valueOf(p.get("ingreso_total"))));
            }
            
            // Escribir el archivo al cliente
            workbook.write(out);
        }
    }
}
