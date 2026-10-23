# Pet Rush! - Guía de Configuración y Proyecto Completo

## Estructura del Proyecto Creado

El proyecto Pet Rush! ha sido creado exitosamente en la carpeta local con la siguiente estructura:

```
PetRush/
├── default.project.json      - Configuración Rojo
├── README.md                 - Documentación en español
├── default.project.json
├── ReplicatedStorage/
│   └── Shared/
│       ├── GameConfig.luau   - Configuración global
│       ├── Remotes.luau      - Eventos remotos
│       ├── Rewards.luau      - Sistema de recompensas
│       └── PetData.luau      - Datos de mascotas
├── ServerScriptService/
│   ├── Main.server.luau      - Punto de entrada del servidor
│   ├── Systems/
│   │   ├── PlayerData.server.luau  - Datos y persistencia
│   │   ├── Collectibles.server.luau - Objetos recolectables
│   │   ├── Pets.server.luau        - Sistema de mascotas
│   │   ├── Shop.server.luau        - Tienda mejoras
│   │   ├── Levels.server.luau      - Sistema de niveles
│   │   └── Zones.server.luau       - Zonas y áreas
│   └── PetRushServer/          (por crear en Studio)
├── StarterPlayer/
│   └── StarterPlayerScripts/
│       ├── PetRushClient/      - Scripts cliente
│       │   ├── ClientMain.client.luau  - Punto de entrada cliente
│       │ ├── HUDController.client.luau - Interfaz de usuario
│       │ ├── CollectController.client.luau - Efectos de recogida
│       │ ├── PetFollowController.client.luau - Controlador de mascota
│       │ ├── ShopController.client.luau - Controlador de tienda
│       │ └── FeedbackController.client.luau - Efectos visuales y de sonido
│       └── Controllers/        (subfolder actual)
└── Prototipo listo para importar a Studio
```

## Cómo Importar a Roblox Studio

### Opción 1: Usando Rojo (Recomendado para desarrollo continuo)

1. **Instalar Rojo** (si no lo tienes):
   ```bash
   cargo install rojo
   ```
   O descarga desde: https://github.com/ROBLOX/rojo

2. **Sincronizar con Studio**:
   - Abre Roblox Studio y crea un lugar en blanco
   - En la consola de comandos, navega a la carpeta del proyecto
   - Ejecuta: `rojo init` (dentro del lugar de Studio)
   - Ejecuta: `rojo sync` - esto copiará todos los archivos `.luau` a las ubicaciones correctas

3. **Verificar importación**:
   - Revisa que los scripts aparezcan en las carpetas correctas en Studio
   - Los scripts del servidor irán en `ServerScriptService/PetRushSystem/`
   - Los scripts del cliente irán en `StarterPlayer/StarterPlayerScripts/PetRushClient/`

### Opción 2: Copia Manual

Si no usas Rojo, sigue estos pasos:

1. **ReplicatedStorage/PetRush/Shared/**
   - Copia todos los archivos `.luau` de `PetRush/ReplicatedStorage/Shared/` a `TuLugarDeRoblox/ReplicatedStorage/PetRush/Shared/`

2. **ServerScriptService/PetRushSystem/**
   - `Main.server.luau` -> `ServerScriptService/PetRushSystem/Main.lua`
   - `PlayerData.server.luau` -> `ServerScriptService/PetRushSystem/Systems/PlayerData.lua`
   - `Collectibles.server.luau` -> `ServerScriptService/PetRushSystem/Systems/Collectibles.lua`
   - `Pets.server.luau` -> `ServerScriptService/PetRushSystem/Systems/Pets.lua`
   - `Shop.server.luau` -> `ServerScriptService/PetRushSystem/Systems/Shop.lua`
   - `Levels.server.luau` -> `ServerScriptService/PetRushSystem/Systems/Levels.lua`
   - `Zones.server.luau` -> `ServerScriptService/PetRushSystem/Systems/Zones.lua`

3. **StarterPlayer/StarterPlayerScripts/PetRushClient/**
   - `ClientMain.client.luau` -> `StarterPlayer/StarterPlayerScripts/PetRushClient/`
   - `HUDController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/HUDController.lua`
   - `CollectController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/CollectController.lua`
   - `PetFollowController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/PetFollowController.lua`
   - `ShopController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/ShopController.lua`
   - `FeedbackController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/FeedbackController.lua`

## Primera Prueba en Play Solo

1. **Abre Roblox Studio** con tu proyecto sincronizado (o copia manual los archivos)
2. **Haz clic en Play** (Play Solo)
3. **Deberías ver:**
   - Tu personaje apareciendo en el área de spawn
   - Monedas (💰) y caramelos (🍬) distribuidos por el mapa
   - El HUD en la esquina superior mostrando monedas, caramelos, nivel y XP
   - Una mascota siguiendo al jugador (la primera equipada por defecto)
   - Botones de "Tienda" y "Mascotas" en el HUD

4. **Probar mecánicas básicas:**
   - **Recoger monedas**: Tocarlas debería sumar monedas y mostrar números flotantes
   - **Recoger caramelos**: Sumar caramelos y actualizar el contador
   - **Ver combo**: Recoger objetos seguidamente debería mostrar el combo x2 o x3
   - **Subir de nivel**: Ganar suficiente XP debería mostrar confeti y sube de nivel
   - **Tienda**: Presionar el botón de Tienda debería mostrar artículos disponibles
   - **Comprar mejora**: Con monedas suficientes, comprar debería aplicar la mejora

## Lista de Archivos Creados (18 archivos totales)

### Scripts del Servidor (7 archivos):
1. `default.project.json` - Configuración Rojo
2. `README.md` - Documentación
3. `ReplicatedStorage/Shared/GameConfig.luau` - Configuración global
4. `ReplicatedStorage/Shared/Remotes.luau` - Eventos remotos
5. `ReplicatedStorage/Shared/Rewards.luau` - Sistema de recompensas
6. `ReplicatedStorage/Shared/PetData.luau` - Datos de mascotas
7. `ServerScriptService/Main.server.luau` - Punto de entrada
8. `ServerScriptService/Systems/PlayerData.server.luau` - Datos jugador
9. `ServerScriptService/Systems/Collectibles.server.luau` - Recogida
10. `ServerScriptService/Systems/Pets.server.luau` - Mascotas
11. `ServerScriptService/Systems/Shop.server.luau` - Tienda
12. `ServerScriptService/Systems/Levels.server.luau` - Niveles
13. `ServerScriptService/Systems/Zones.server.luau` - Zonas

### Scripts del Cliente (8 archivos):
1. `StarterPlayer/StarterPlayerScripts/PetRushClient/ClientMain.client.luau` - Entrada cliente
2. `StarterPlayer/StarterPlayerScripts/Controllers/HUDController.client.luau` - Interfaz
3. `StarterPlayer/StarterPlayerScripts/Controllers/CollectController.client.luau` - Efectos recogida
4. `StarterPlayer/StarterPlayerScripts/Controllers/PetFollowController.client.luau` - Mascota seguidora
5. `StarterPlayer/StarterPlayerScripts/Controllers/ShopController.client.luau` - Tienda cliente
6. `StarterPlayer/StarterPlayerScripts/Controllers/FeedbackController.client.luau` - Efectos visuales/sonido

### Archivos de Soporte (3 archivos):
- `default.project.json` - Config Rojo
- `README.md` - Documentación en español
- Estructura de carpetas lista para Studio

## Próximos Pasos y Mejoras

### Inmediatas (para el prototipo mínimo):
1. **Crear el mapa físico en Studio**:
   - Agregar un `SpawnLocation` centrado en Workspace
   - Crear el suelo y decoración en `Workspace/PetRushMap/`
   - Crear al menos 20 monedas y 20 caramelos en `Workspace/PetRushMap/Collectibles/`
   - Crear 3 zonas: Pradera, Bosque Dulce, Cueva Arcoíris

2. **Probar sistema de recolección**:
   - Verificar que monedas y caramelos se destruyan y reappearen
   - Confirmar que los números flotantes aparezcan correctamente
   - Validar que el servidor otorga recompensas (no el cliente)

3. **Probar sistema de mascotas**:
   - Equipar diferentes mascotas desde la tienda
   - Verificar que la mascota siga al jugador
   - Confirmar recolección automática de objetos cercanos

### Después del prototipo mínimo:
1. **Sistema de combo**: Verificar que el contador aumente y se reinicie
2. **Sistema de niveles y XP**: Probar subida de nivel y recompensas
3. **Zonas**: Desbloquear Bosque Dulce y Cueva Arcoíris al alcanzar niveles requeridos
4. **Huevos y mascotas raras**: Implementar sistema de huevos con probabilidades
5. **Optimización**: Asegurar que funcione bien en móvil y PC

## Seguridad y Cumplimiento Roblox

✅ **Etiqueta objetivo**: Minimal/Mild (para público infantil)
✅ **Sin violencia**: Juego de recogida tranquilo
✅ **Sin Robux**: Todo basado en monedas del juego
✅ **Sin apuestas**: No hay loot boxes con Robux
✅ **Validación en servidor**: Todas las acciones monetarias validadas en servidor
✅ **RemoteEvents seguros**: Solo para sincronizar estado y efectos

## Solución de Problemas Comunes

### Si el HUD no aparece:
- Verifica que `ClientMain.client.luau` se ejecute en `StarterPlayer/StarterPlayerScripts/`
- Revisa Output en Studio por errores de sintaxis Luau

### Si las recompensas no se otorgan:
- Verifica que el servidor tenga acceso a `DataStoreService`
- Confirma que los RemoteEvents estén correctamente nombrados y conectados
- Revisa que `PlayerData.Set()` se esté llamando correctamente

### Si la mascota no sigue al jugador:
- Verifica que la mascota esté desbloqueada en los datos del jugador
- Confirma que el `HumanoidRootPart` existe en el personaje
- Revisa que el script del cliente esté corriendo

### Si la tienda no responde:
- Verifica que el jugador tenga suficientes monedas
- Confirma que el nivel requerido se cumpla
- Revisa Output por errores en `Shop.PurchaseItem()`

## ¿Cómo contactar para soporte?

Si encuentras errores al probar en Play Solo, por favor:
1. Revisa la sección "Output" en Roblox Studio
2. Verifica que todos los scripts estén en las ubicaciones correctas
3. Confirma que no haya errores de sintaxis en los archivos Luau
4. Consulta la guía de cada sistema para debugging específico

---

**Proyecto Pet Rush! creado con éxito.**
**Estructura completada para importación a Roblox Studio.**
**Próximo paso: Crear el mapa físico en Studio y probar la mecánica básica de recolección.**