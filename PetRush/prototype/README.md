# Pet Rush! Prototype v5

## Descripción
Pet Rush! es un prototipo minimalista de colección donde el jugador debe recoger monedas y caramelos para sumar en los contadores `leaderstats.Coins` y `leaderstats.Candies`. El juego presenta:
- Mapa con suelo y SpawnLocation
- 20 monedas neon distribuidas en círculo radio 10
- 10 caramelos rojos distribuidos en cuadrícula
- HUD que muestra y actualiza Coins y Candies en tiempo real
- Reaparición de monedas y caramelos después de 5 segundos
- Configuración idempotente de leaderstats al unirse
- Sistema de compra de mejora con coste validado en el servidor

## Objetivo
Recoger 20 monedas y 10 caramelos para ganar recompensas. Las monedas y caramelos reaparecen automáticamente después de 5 segundos.

## Controles
- **Mover**: W/A/S/D o controles de movimiento estándar de Roblox
- **Recoger**: Al tocar una moneda/caramelo cuando el personaje esté a ≤5 studs

## Cómo Arrastrar el Prototipo

### Requisitos
- Roblox Studio instalado
- Rojo 7.7.1 o superior

### Instrucciones de Build
1. Abrir `PetRush/prototype/PetRush-prototype-v5.rbxlx` en Roblox Studio
2. Ejecutar `Play` para iniciar el juego
3. Las 20 monedas y 10 caramelos deberían aparecer
4. Mover el personaje para tocar las monedas/caramelos y sumar al contador
5. Las monedas/caramelos reaparecen después de 5 segundos

### Sincronización con Rojo
Si desea modificar el proyecto:
- Editar `PetRush/prototype/ServerScript.server.luau` (servidor)
- Editar `PetRush/prototype/HUDController.client.luau` (cliente)
- Recompilar con: `rojo build PetRush/prototype/proof.project.json -o PetRush/prototype/PetRush-prototype-v5.rbxlx`

## Estado Actual
✅ Mapa con Floor y SpawnLocation
✅ 20 monedas distribuidas en círculo radio 10
✅ 10 caramelos distribuidos en cuadrícula
✅ Recogida validada por servidor (leaderstats.Coins++ y leaderstats.Candies++)
✅ Reaparición de monedas y caramelos después de 5 segundos
✅ HUD que muestra y actualiza Coins y Candies en tiempo real
✅ Configuración idempotente de leaderstats (no se duplican al unirse)
✅ Sistema de compra con coste validado en servidor (pending implementation)

## Próximos Pasos
- Implementar sistema de mascotas inicial
- Añadir sistema de compra/upgrade con validación en servidor
- Mejorar visuales con modelos Blender
- Implementar sistema de guardado

## Compras y Mejoras del Servidor
- **Compra de Multiplicador de Combo**: Cuesta 50 Candies
- **Desbloquea**: Multiplicador de puntos al recolectar monedas y caramelos
- **Validado en servidor**: El costo se descuenta solo si el jugador tiene suficientes Candies

