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
- **Equipar/Mascar mascota**: Automática al unirse, puede desequiparse manualmente

## Cómo Arrastrar el Prototipo

### Requisitos
- Roblox Studio instalado
- Rojo 7.7.1 o superior

### Instrucciones de Build
1. Abrir `PetRush/prototype/PetRush-prototype-v6.rbxlx` en Roblox Studio
2. Ejecutar `Play` para iniciar el juego
3. Las 20 monedas y 10 caramelos deberían aparecer
4. Mover el personaje para tocar las monedas/caramelos y sumar al contador
5. La mascota inicial debería seguír al jugador
6. Las monedas y caramelos reaparecen después de 5 segundos

### Sincronización con Rojo
Si desea modificar el proyecto:
- Editar `PetRush/prototype/ServerScript.server.luau` (servidor)
- Editar `PetRush/prototype/HUDController.client.luau` (cliente)
- Recompilar con: `rojo build PetRush/prototype/proof.project.json -o PetRush/prototype/PetRush-prototype-v6.rbxlx`

## Estado Actual
✅ Mapa con Floor y SpawnLocation
✅ 20 monedas distribuidas en círculo radio 10
✅ 10 caramelos distribuidos en cuadrícula
✅ 1 mascota inicial (perro) que sigue al jugador
✅ HUD que muestra y actualiza Coins y Candies en tiempo real
✅ Configuración idempotente de leaderstats (no se duplican al unirse)
✅ Sistema de compra con coste validado en el servidor (pending implementation)

## Próximos Pasos
- Mejorar visuales con modelos Blender
- Implementar sistema de guardado persistente
- Añadir más tipos de mascotas desbloqueables

## Sistema de Compra/Miglioramiento del Servidor
- **Compra de Multiplicador de Combo**: Cuesta 100 Candies
- **Desbloquea**: Multiplicador de puntos al recolectar monedas y caramelos (x1.5)
- **Validado en servidor**: El costo se descuenta solo si el jugador tiene suficientes Candies, y el multiplicador se aplica a las recompensas futuras

