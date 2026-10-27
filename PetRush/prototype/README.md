# Pet Rush! Prototype v4

## Descripción
Pet Rush! es un prototipo minimalista de colección de monedas donde el jugador debe recoger 20 monedas distribuidas en un círculo para sumar en el contador `leaderstats.Coins`. El juego presenta:
- Mapa con suelo y SpawnLocation
- 20 monedas neon distribuidas en círculo radio 10
- HUD que muestra y actualiza las monedas en tiempo real
- Reaparición de monedas después de 5 segundos tras ser recogida
- Configuración idempotente de leaderstats al unirse

## Objetivo
Recoger 20 monedas evitando la colección múltiple. Las monedas reaparecen automáticamente después de 5 segundos.

## Controles
- **Mover**: W/A/S/D o controles de movimiento estándar de Roblox
- **Recoger**: Al tocar una moneda cuando el personaje esté a ≤5 studs

## Cómo Arrastrar el Prototipo

### Requisitos
- Roblox Studio instalado
- Rojo 7.7.1 o superior

### Instrucciones de Build
1. Abrir `PetRush/prototype/PetRush-prototype-v4.rbxlx` en Roblox Studio
2. Ejecutar `Play` para iniciar el juego
3. Las 20 monedas deberían aparecer distribuidas en un círculo
4. Mover el personaje para tocar las monedas y sumar al contador

### Sincronización con Rojo
Si desea modificar el proyecto:
- Editar `PetRush/prototype/ServerScript.server.luau` (servidor)
- Editar `PetRush/prototype/HUDController.client.luau` (cliente)
- Recompilar con: `rojo build PetRush/prototype/proof.project.json -o PetRush/prototype/PetRush-prototype-v4.rbxlx`

## Estado Actual
✅ Mapa con Floor y SpawnLocation
✅ 20 monedas distribuidas en círculo
✅ Recogida validada por servidor (leaderstats.Coins++)
✅ Reaparición de monedas después de 5 segundos
✅ HUD que muestra y actualiza Coins en tiempo real
✅ Configuración idempotente de leaderstats (no se duplican al unirse)
✅ Configuración de jugadores existentes al cargar el lugar

❌ Gráficos finales (usar modelos provisionales)
❌ Efectos de partículas adicionales
❌ Sistema de guardado persistente

## Próximos Pasos
- Implementar sistema de caramelos
- Añadir sistema de mascotas
- Mejorar visuales con modelos Blender
- Implementar sistema de guardado
