# PLAN.md - Pet Rush! Desarrollo Actualizado

## Estado actual
- MCP conectado: ✓
- Studio: Place1 (ed6d826b-4cf0-49eb-b115-de975606325d)
- Modo: Por inspeccionar/establecer
- Archivos locales: 17 archivos Luau completos en /PetRush/

## Prototipo mínimo - Fases

### FASE 1: Mapa y Spawn [PENDIENTE EN STUDIO]
[ ] Workspace/PetRushMap:
  - [ ] Suelo y decoración
  - [ ] SpawnLocation centrado
  - [ ] Zonas: Pradera, Bosque Dulce, Cueva Arcoíris
  - [ ] 20 monedas + 20 caramelos con reaparición

### FASE 2: Sistema de Recogida [PENDIENTE]
[ ] Scripts servidor: Collectibles.server.luau
[ ] RemoteEvents para notificar cliente
[ ] Números flotantes y partículas
[ ] Reaparición objetos

### FASE 3: HUD [PENDIENTE]
[ ] HUDController.client.luau en StarterPlayer/StarterPlayerScripts/
[ ] Mostrar: monedas, caramelos, nivel, XP, combo
[ ] Botones: Tienda, Mascotas

### FASE 4: Mascota [PENDIENTE]
[ ] Pets.server.luau en ServerScriptService/Systems/
[ ] PetFollowController.client.luau
[ ] Mascota que sigue al jugador

### FASE 5: Tienda [PENDIENTE]
[ ] Shop.server.luau en ServerScriptService/Systems/
[ ] ShopController.client.luau
[ ] 2 mejoras con moneda del juego

### FASE 6: Niveles y Progresión [PENDIENTE]
[ ] Levels.server.luau
[ ] XP, subida de nivel, confeti

### FASE 7: Guardado [PENDIENTE]
[ ] PlayerData.server.luau con DataStore
[ ] Manejo de fallos (datos temporales)

## Trabajo completado LOCAL
✓ 17 archivos Luau creados en /PetRush/
✓ Estructura de carpetas correcta
✓ Código Luau comentado y organizado
✓ AGENTS.md y PLAN.md creados

## Próximo paso
Inspeccionar lugar en Studio e insertar estructura física básica (Mapa, Spawn, Partes)