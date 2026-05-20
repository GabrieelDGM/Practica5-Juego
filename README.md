# Agente Vs Malo

---
Es un juego 2D top-dow basado en acción estilo espía donde el Agente tiene que atrevesar la guarida y derrota el jefe malvado que tiene apresado a un pais completo
---

## Descripción
Juego 2D con vista cenital (top-down) y estética pixel-art retro arcade ambientado en el mundo de los espías. El jugador controla a **Agente**, un agente de traje negro que debe atravesar una sala de entrada para enfrentarse al jefe final **Jefe Malo** en un combate por fases.

El objetivo es vencer a Jefe malo esquivando sus ataques y consiguiendo la mayor puntuación posible en el menor tiempo.


---

## Controles del juego.

| Acción | Tecla |
|---|---|
| Mover | `W A S D` o `↑ ← ↓ →` |
| Disparar | `Espacio` o clic del ratón |
| Esquiva (dash) | `Shift` |
| Pausa | `Esc` |

---

# Características

-  Movimiento en 8 direcciones y disparo direccional
-  Dash con invulnerabilidad breve para esquivar proyectiles
-  Sistema de vida con barras HP para Agente y Jefe Final
-  Sistema de puntos con bonus por rapidez
- Jefe con dos fases de comportamiento (la fase 2 se activa al 40% de vida)
- Menú de pausa funcional
- Música y efectos de sonido en todos los eventos
- Estética espía retro con paleta oscura y rojos

## La estructura del proyecto 

├── project.godot           Configuración del proyecto y controles
├── assets/
│   ├── sprites/            Spritesheets, mapas y pantallas
│   ├── tiles/              Piezas del escenario
│   └── audio/              Música y efectos de sonido
├── scenes/                 11 escenas (.tscn) del juego
└── scripts/                14 scripts (.gd) con la lógica

##  Componentes principales

| Componente | Función |
|---|---|
| `MenuPrincipal` | Pantalla de inicio con botones Jugar y Salir |
| `Nivel1` | Pasillo de entrada hasta la sala del jefe |
| `CombateJefe` | Sala del enfrentamiento final |
| `Agente` (Agente) | Movimiento, disparo, dash, vida y animaciones |
| `Jefe` (Jefe Malo) | IA con dos fases de ataque |
| `Bala` | Proyectil con detección de colisiones por capas |
| `Puerta` | Detecta a Donald y carga el combate |
| `HUD` | Barras de vida y contador de puntos |
| `MenuPausa` | Pausa accesible con ESC |
| `GameOver` / `Victoria` | Pantallas de fin con reiniciar o volver al menú |
| `ScoreManager` | Singleton de puntos y bonus de tiempo |
| `AudioManager` | Singleton de música y efectos globales |

---

## Sistema de puntuación

| Acción | Puntos |
|---|---|
| Impactar a Jefe Final | +50 |
| Derrotar a Jefe Final | +1000 |
| Bonus de tiempo | Hasta +2000 (−10 por segundo) |

La **puntuación final** es la suma de puntos acumulados más el bonus de tiempo.

## Cómo ejecutar el juego

1. Descargar e instalar **Godot Engine 4.6.2**
2. Abrir Godot y pulsar **Importar**
3. Seleccionar la carpeta que contiene `project.godot`
4. Esperar a que Godot importe los recursos automáticamente
5. Pulsar `F5` o el botón ▶ Play para ejecutar

## Tecnologías utilizadas

- **Motor:** Godot Engine 4.6.2
- **Lenguaje:** GDScript
- **Resolución base:** 640x480 (escalado a 1280x960)
- **Tipo de juego:** 2D top-down

## Licencia

Proyecto académico de uso educativo.

## Autor
### Gabriel David Gelviz Monterrey
