# Rúbrica de Evaluación: I58N-APF3-2026M

**Puntaje Máximo:** 20 puntos

---

### 📋 Detalle de los Criterios de Evaluación

| Criterio | Puntaje Máximo | Estándar Esperado (Descripción del Logro) |
| --- | --- | --- |
| **Diseño de la solución** | **3 pts** | Se califica que el estudiante diseñe y desarrolle la solución mediante la construcción de la arquitectura inicial del proyecto. **Es obligatorio el uso de los 4 enfoques (MVC, TDD, DAO y SOLID)**. Dentro de cada enfoque, el proyecto **debe aplicar obligatoriamente al menos 3 principios, pasos o reglas específicas** de los detallados en la guía de diseño (ver desglose abajo), además de considerar aspectos de seguridad. |
| **Uso de recursos Java** | **2 pts** | El estudiante incorpora en su proyecto todas las librerías de apoyo a la codificación como **Google Guava, Apache POI, Apache Commons y Logback** para mejorar la eficiencia y funcionalidad del proyecto, teniendo en cuenta las consideraciones básicas de seguridad para el tratamiento de la información. |
| **Uso de control de versiones** | **3 pts** | El estudiante incorpora el uso de **Git** en su proyecto, dejando evidencia del 100% de sus avances y actualizaciones de los entregables del proyecto en la plataforma **GitHub**. |
| **Implementación de las interfaces gráficas** | **6 pts** | El estudiante implemente sus interfaces gráficas UI/UI cuyo funcionamiento de la solución cubre el **100% del alcance comprometido**. |
| **Construcción del producto final** | **4 pts** | El estudiante construye una solución informática considerando todos los siguientes criterios:<br>

<br>1) **Completa:** cubre el alcance comprometido.<br>

<br>2) **Coherente:** la documentación y el código están alineados.<br>

<br>3) **Buenas prácticas:** usa librerías adecuadas, patrones de diseño, software de control de versiones, entre otros.<br>

<br>4) **Autoría:** el código fue hecho por el estudiante o lo domina. |

---

### 🗣️ Evaluación Independiente (Sustentación Oral)

*Nota: Este componente se evalúa de forma aparte al desarrollo técnico del proyecto.*

| Criterio | Puntaje Máximo | Estándar Esperado (Descripción del Logro) |
| --- | --- | --- |
| **Sustentación oral** | **2 pts** | Las ideas siguen una secuencia lógica acorde a la estructura de presentación establecida. Además, las ideas se desarrollan de manera continua, sin pausas (fluidez) y son coherentes con el desarrollo del tema. Asimismo, demuestra dominio de la sección que sustenta, pues vincula sus ideas con los conceptos abordados en el curso. |

---

## 🛠️ Desglose Obligatorio para el "Diseño de la Solución" (3 pts)

Para obtener el puntaje completo en este criterio, el código y la arquitectura del proyecto deben demostrar fehacientemente la aplicación de **los 4 enfoques** y, como mínimo, **3 ítems/principios de cada uno**:



### 1. MVC (Modelo-Vista-Controlador) — *Aplicar al menos 3 principios:*

* **Separación de Responsabilidades (SoC):** La interfaz visual (Vista), la lógica de negocio (Modelo) y el enrutamiento (Controlador) no se mezclan bajo ningún motivo.
* **Aislamiento del Modelo:** El Modelo es completamente ignorante de la existencia de la Vista (independiente de si los datos se muestran en web, terminal, etc.).
* **Controlador como Mediador Ligero:** El controlador solo recibe peticiones, delega el trabajo pesado al Modelo y pasa el resultado a la Vista (sin cálculos matemáticos pesados ni miles de líneas de código).

### 2. TDD (Test-Driven Development) — *Aplicar el ciclo estricto de 3 pasos:*

* **Rojo (Red):** Evidencia de haber escrito primero una prueba automatizada que falle, demostrando que la prueba es válida y exige un cambio.
* **Verde (Green):** Escritura de la cantidad mínima indispensable de código para que la prueba pase (código funcional, no necesariamente perfecto).
* **Refactorizar (Refactor):** Limpieza, optimización y eliminación de duplicados en el código una vez que funciona, asegurando que las pruebas sigan pasando.

### 3. DAO (Data Access Object) — *Aplicar al menos 3 principios:*

* **Ocultamiento de la Persistencia:** El resto de la aplicación no sabe cómo ni dónde se guardan los datos; el DAO encapsula todas las consultas (SQL/NoSQL) en un solo lugar.
* **Interfaz vs. Implementación:** La app interactúa con una interfaz (ej. `guardarUsuario()`). Si se cambia el motor de base de datos, solo se modifica el DAO y el resto del sistema no se entera.
* **Operaciones CRUD Centralizadas:** Agrupación clara de las operaciones básicas de una entidad: Crear, Leer, Actualizar y Borrar.

### 4. SOLID — *Aplicar al menos 3 de los 5 principios:*

* **S - Responsabilidad Única:** Cada clase tiene una, y solo una, razón para cambiar (ej. separar el cálculo de impuestos de la generación de PDFs).
* **O - Abierto/Cerrado:** Código abierto para su extensión pero cerrado para su modificación (agregar funciones añadiendo código nuevo, no alterando el viejo).
* **L - Sustitución de Liskov:** Las clases hijas pueden sustituir a las clases padres en cualquier lugar del sistema sin que el programa se rompa o lance errores inesperados.
* **I - Segregación de Interfaces:** Interfaces pequeñas y específicas para que ningún cliente sea forzado a depender de métodos que no utiliza.
* **D - Inversión de Dependencias:** Los módulos de alto nivel (lógica de la app) no dependen de los de bajo nivel (herramientas/BD); ambos dependen de abstracciones (interfaces).

---

### 📊 Resumen de Puntuación Final

* **Desarrollo Técnico (Proyecto):** 18 pts
* **Sustentación Oral:** 2 pts
* **Puntaje Total:** **20 pts**