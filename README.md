# OficiosYa 🛠️

App móvil desarrollada en Flutter que conecta personas que necesitan un arreglo (plomería, electricidad, mecánica, pintura, etc.) con prestadores de oficios verificados de la provincia de Mendoza.

> Proyecto final de la materia **Programación de Aplicaciones para Celulares**.

**Integrantes:** Cruceño · Elías · Mancifesta · Luna

---

## 1. Idea del proyecto

Hoy contratar un oficio depende de recomendaciones informales o de búsquedas poco confiables. OficiosYa centraliza la oferta de prestadores locales y permite:

- **Proximidad:** encontrar profesionales cercanos al domicilio.
- **Confianza:** ver reputación, reseñas y verificación (matrícula y DNI) antes de contratar.
- **Visibilidad:** que los oficios tradicionales tengan presencia digital para conseguir clientes más allá del boca a boca.

## 2. Público objetivo

| Usuario | Perfil | Necesidad principal |
|---|---|---|
| **Cliente** | Martín González, 28, empleado administrativo | Encontrar rápido un prestador cercano, confiable y bien valorado |
| **Prestador** | Carlos Rodríguez, 42, mecánico independiente | Conseguir clientes nuevos y construir reputación con valoraciones |

## 3. Diseño UX/UI

- Metodología: Design Thinking en 7 pasos (contexto, empatizar, definir, idear, prototipar, evaluar).
- Prototipo de alta fidelidad: [Ver en Figma](https://www.figma.com/proto/V1CpKzNQsStl02izWPUUeK/OficiosYa?node-id=0-1&t=eueAPB3OV8UZe9wv-1)
- Sistema visual: azul primario, chips verdes de "verificado", estrellas amarillas, tarjetas blancas con bordes suaves.
- Mejoras surgidas del test de usabilidad: tarjetas claras para elegir rol, barra de contacto fija (sticky CTA) en el perfil y modal de confirmación al calificar.

## 4. Estructura del proyecto

```
lib/
├── main.dart                 # punto de entrada
├── routes/                   # rutas de navegación
├── models/                   # entidades y conversiones de datos
├── data/
│   ├── mocks/                # datos ficticios para desarrollo
│   └── repositories/         # contratos e implementaciones de acceso a datos
└── ui/
    ├── screens/              # pantallas; coordinan UI y repositorios
    └── widgets/              # componentes visuales reutilizables
assets/
├── images/
└── fonts/
```

### Responsabilidades y dependencias

- Los modelos (`models/`) representan datos sin depender de Flutter ni de la UI.
- Los contratos de `data/repositories/` describen las operaciones que necesita la aplicación; las implementaciones mock obtienen datos de `data/mocks/`.
- Las pantallas reciben los contratos de repositorio y no conocen dónde ni cómo se almacenan los datos.
- `routes/` conecta las pantallas con las implementaciones concretas. Para cambiar el origen de datos, se agrega una implementación del contrato y se selecciona allí.
- `data/mocks/` contiene fixtures de desarrollo, no lógica de presentación ni acceso SQL. No se agrega una carpeta de utilidades hasta que haya funciones puras compartidas que la necesiten.
- La aplicación todavía no usa SQLite ni una base de datos remota; la persistencia actual en memoria se pierde al reiniciar.

## 5. Lógica de las funcionalidades

> Completar a medida que se avance. Ejemplos:

- **Navegación:** se usa `Navigator` con rutas con nombre; el flujo va de Bienvenida → Home → Resultados → Perfil.
- **Selección de rol:** la pantalla de bienvenida define si el usuario sigue el flujo de cliente o de prestador.
- **Componentes reutilizables:** `PrestadorCard`, `CategoriaChip`, `BotonPrimario`, etc., para no repetir código.

## 6. Evidencia de ejecución

> Una captura o GIF por cada avance. Ejecutado en emulador Android / dispositivo real.

### Avance 1 — Setup y primera pantalla
<!-- ![Bienvenida](docs/screenshots/01_bienvenida.png) -->
<img width="720" height="1600" alt="Screenshot_20260928-220242" src="https://github.com/user-attachments/assets/49ae48df-696d-4d5e-920e-4c61216d4a14" />

### Avance 2 — Home y resultados
<!-- ![Home](docs/screenshots/02_home.png) -->
<img width="720" height="1600" alt="Screenshot_20260928-220347" src="https://github.com/user-attachments/assets/91beb973-a1be-4a8c-b187-adcdf417189b" />

### Avance 3 — Perfil del prestador
<!-- ![Perfil](docs/screenshots/03_perfil.png) -->
<img width="720" height="1600" alt="Screenshot_20260928-220356" src="https://github.com/user-attachments/assets/259fb3ed-b643-450a-a5e3-3807d41a0cb8" />

### Avance 4 — Buscador

<img width="720" height="1600" alt="Screenshot_20260928-220500" src="https://github.com/user-attachments/assets/7b55f8b9-dfc6-4c33-8b8d-99596f5d62f2" />

<img width="720" height="1600" alt="Screenshot_20260928-220431" src="https://github.com/user-attachments/assets/245fba0e-48f2-463a-9cfc-c20a99b3afaf" />

## 7. Cómo ejecutar

```bash
git clone <URL-DEL-REPO>
cd oficiosya
flutter pub get
flutter run
```

Requisitos: Flutter SDK instalado y un emulador o dispositivo conectado (`flutter doctor` sin errores).
