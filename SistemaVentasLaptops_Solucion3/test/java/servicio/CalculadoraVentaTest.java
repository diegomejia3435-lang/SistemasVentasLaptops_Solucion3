package java.servicio;

import org.junit.Assert;
import org.junit.Test;
import servicio.CalculadoraVentaService;

/**
 * Pruebas automatizadas para demostrar el ciclo TDD (Rojo, Verde, Refactor).
 */
public class CalculadoraVentaTest {

    /*
     * -------------------------------------------------------------
     * FASE 1: ROJO (RED)
     * -------------------------------------------------------------
     * En TDD se escribe primero la prueba que define lo que debe
     * hacer el código antes de que exista. 
     * Si corriéramos este código antes de crear CalculadoraVentaService,
     * ni siquiera compilaría (falla de compilación = ROJO).
     * Si lo creamos pero devolvemos '0', la prueba falla porque
     * espera 500 (falla de aserción = ROJO).
     */

    @Test
    public void testCalcularDescuentoAlto() {
        // Preparación (Arrange)
        CalculadoraVentaService calc = new CalculadoraVentaService();
        double subtotal = 6000.0; // Mayor a 5000 -> 10% descuento
        
        // Ejecución (Act)
        // FASE 2: VERDE (GREEN)
        // Ahora el método calcularDescuento ya devuelve subtotal * 0.10.
        // Escribimos la cantidad mínima de código en el Service para que pase.
        double descuento = calc.calcularDescuento(subtotal);
        
        // Aserción (Assert)
        Assert.assertEquals(600.0, descuento, 0.001);
    }

    @Test
    public void testCalcularDescuentoMedio() {
        CalculadoraVentaService calc = new CalculadoraVentaService();
        double subtotal = 3000.0; // Mayor a 2000 -> 5% descuento
        
        double descuento = calc.calcularDescuento(subtotal);
        
        Assert.assertEquals(150.0, descuento, 0.001);
    }

    @Test
    public void testSinDescuento() {
        CalculadoraVentaService calc = new CalculadoraVentaService();
        double subtotal = 1000.0; // Menor a 2000 -> 0% descuento
        
        double descuento = calc.calcularDescuento(subtotal);
        
        Assert.assertEquals(0.0, descuento, 0.001);
    }

    /*
     * -------------------------------------------------------------
     * FASE 3: REFACTORIZAR (REFACTOR)
     * -------------------------------------------------------------
     * En el código fuente (CalculadoraVentaService.java) hemos factorizado 
     * el cálculo final limpiando posibles duplicidades. 
     * Además, aseguramos de que el código siga pasando todas las pruebas
     * a pesar de los cambios internos de estructura.
     */
    @Test
    public void testCalcularTotalFinal() {
        CalculadoraVentaService calc = new CalculadoraVentaService();
        double subtotal = 6000.0; // Debería restar 600
        
        double totalFinal = calc.calcularTotalFinal(subtotal);
        
        Assert.assertEquals(5400.0, totalFinal, 0.001);
    }
}
