# Pet Rush! Prototype v6

## Descripción
Pet Rush! es un prototipo minimalista de colección donde el jugador debe recoger monedas y caramelos, y puede obtener y equipar una mascota inicial. El juego presenta:
- Mapa con suelo y SpawnLocation
- 20 monedas neon distribuidas en círculo radio 10
- 10 caramelos rojos distribuidos en cuadrícula
- 1 mascota inicial (perro) que sigue al jugador
- HUD que muestra Coins, Candies y el estado de la mascota
- Reaparición de monedas y caramelos después de 5 segundos
- Configuración idempotente de leaderstats al unirse
- Sistema de compra con coste validado en el servidor

## Objetivo
Recoger 20 monedas y 10 caramelos, y equipar la mascota inicial. Las monedas y caramelos reaparecen automáticamente después de 5 segundos.

## Controles
- **Mover**: W/A/S/D o controles de movimiento estándar de Roblox
- **Recoger**: Al tocar una moneda/caramelo cuando el personaje esté a ≤5 studs
- **Equipar/Mascota**: Automática al unirse, puede desequiparse manualmente

## Cómo Arrastrar el Prototipo

### Requisitos
- Roblox Studio instalado
- Rojo 7.7.1 o superior

### Instrucciones de Build
1. Abrir PetRush/prototype/PetRush-prototype-v6.rbxlx en Roblox Studio
2. Ejecutar Play para iniciar el juego