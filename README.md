## Flor y Fuego — App de Restaurante

Aplicación móvil desarrollada con **Flutter** como Trabajo de Fin de Grado del Ciclo Formativo de Desarrollo de Aplicaciones Multiplataforma (DAM).

Flor y Fuego es una app para un restaurante ficticio que permite a los usuarios hacer reservas de mesa, consultar el menú, realizar pedidos y ver los eventos del local — todo sin necesidad de registro.

---

## Capturas de pantalla

> _Próximamente_

---

## Funcionalidades

- **Reservas** — Selección de fecha, hora y número de comensales, con mapa visual de mesas en tiempo real que muestra disponibilidad
- **Menú y pedidos** — Consulta del menú completo, marcado de favoritos y realización de pedidos
- **Eventos** — Visualización de eventos del restaurante desde la pantalla principal
- **Contacto** — Pantalla con los datos de contacto del restaurante
- **Sin login** — La app identifica al usuario por teléfono (pedidos) o email (reservas), sin necesidad de crear una cuenta

---

## Integración con FacturaScripts

La app está conectada a **FacturaScripts** como backend, lo que permite:

- Registrar y consultar reservas por email
- Registrar pedidos y consultarlos por número de teléfono
- Consultar la ocupación de mesas en tiempo real según fecha y hora
- Gestionar el menú (añadir y eliminar platos) desde el panel de FacturaScripts
- Actualizar el estado de los pedidos desde el panel de FacturaScripts

> Requiere una instancia de FacturaScripts propia. La URL de la API se configura en `lib/api/api_service.dart`.

---

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| Flutter / Dart | Framework principal, UI multiplataforma |
| FacturaScripts | Backend y gestión de datos |
| `http` | Comunicación con la API REST |
| `shared_preferences` | Persistencia local de datos del usuario |
| `google_fonts` | Tipografía personalizada |
| `url_launcher` | Apertura de enlaces y datos de contacto |
| `flutter_localizations` | Soporte de localización |

---

##  Estructura del proyecto

```
lib/
├── api/          # Servicios de comunicación con FacturaScripts
├── models/       # Modelos de datos (Reserva, Pedido, Platillo...)
├── screens/      # Pantallas de la aplicación
├── services/     # Servicios locales (SharedPreferences)
└── widgets/      # Componentes reutilizables
```

## Autor

Jessica Rodríguez Caballero  
Ciclo Formativo de Grado Superior — Desarrollo de Aplicaciones Multiplataforma (DAM)  

---

## Licencia

Este proyecto ha sido desarrollado con fines académicos.
