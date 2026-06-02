package servicio;

/**
 * Servicio lógico para calcular descuentos y totales finales en ventas.
 * Creado siguiendo la metodología TDD (Rojo, Verde, Refactor).
 */
public class CalculadoraVentaService {

    /**
     * Calcula el descuento basado en el subtotal.
     * Reglas de negocio:
     * - Si subtotal > 5000: 10% de descuento.
     * - Si subtotal > 2000: 5% de descuento.
     * - En otro caso: 0% de descuento.
     * 
     * @param subtotal El monto total acumulado de la venta antes de descuentos.
     * @return El monto del descuento a aplicar.
     */
    public double calcularDescuento(double subtotal) {
        if (subtotal > 5000) {
            return subtotal * 0.10;
        } else if (subtotal > 2000) {
            return subtotal * 0.05;
        }
        return 0.0;
    }

    /**
     * Calcula el monto final a pagar (subtotal - descuento).
     */
    public double calcularTotalFinal(double subtotal) {
        double descuento = calcularDescuento(subtotal);
        return subtotal - descuento;
    }
}
