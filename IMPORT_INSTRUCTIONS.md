# Pet Rush! - Instrucciones de Importación y Prototipo

## Estado Actual
- **MCP Connectado**: Sí (Studio ID: d1792ff2-50e3-4ba3-a6ae-b943707cf59e)
- **Lugar**: "Lugar de katya_1902: 10222026_1"
- **Modo**: Edit
- **Archivos Locales**: 17 archivos Luau creados en /Users/katya/Roblox Juego/PetRush/
- **Objetivo**: Construir prototipo jugable Paso a paso

## Método Recomendado: Usar Rojo

### Paso 1: Instalar Rojo
```bash
cd /Users/katya/Roblox\ Juego/PetRush
cargo install rojo
# O: descarga desde https://github.com/ROBLOX/rojo
```

### Paso 2: Inicializar Rojo en Studio
1. Abre Roblox Studio con el lugar "Lugar de katya_1902: 10222026_1"
2. Asegúrate de estar en modo **Edit**
3. En la consola de comandos, ejecuta:
   ```
   rojo init
   ```
   Esto configurará Rojo en tu lugar de Studio y creará la estructura necesaria.

### Paso 3: Sincronizar el Proyecto
```bash
rojo sync
```
Esto copiará automáticamente todos los archivos `.luau` desde la carpeta `PetRush/` a las ubicaciones correctas en Studio:
- `ServerScriptService/PetRushSystem/Systems/*.luau`
- `StarterPlayer/StarterPlayerScripts/PetRushClient/*.luau`
- `StarterPlayer/StarterPlayerScripts/Controllers/*.luau`
- `ReplicatedStorage/PetRush/Shared/*.luau`

### Paso 4: Crear el Mapa Físico en Studio
Rojo creará los scripts, pero aún necesitas el mapa:
1. En Workspace, crea una Folder llamada `PetRushMap`
2. Agrega un `Part` llamado `Ground` (tamaño 200x5x200, posición y=2.5, anclado)
3. Agrega un `SpawnLocation` llamado `SpawnArea` (posición y=2, tamaño 10x5x10, color azul claro)
4. Crea 20 Parts de monedas y 20 Parts de caramelos con BillboardGuis

### Paso 5: Probar en Play Solo
1. Haz clic en el botón **Play** (Play Solo)
2. El jugador debería aparecer en el SpawnArea
3. Moverse para tocar monedas y caramelos
4. Ver números flotantes al recoger
5. Ver monedas incrementar en el HUD

## Método Alternativo: Inserción Manual

Si no usas Rojo, sigue estos pasos:

### 1. Insertar Scripts del Servidor
En Studio, en `ServerScriptService`:
1. Crea carpeta `PetRushSystem`
2. Crea subcarpeta `Systems/`
3. Copia estos archivos desde `/Users/katya/Roblox Juego/PetRush/ServerScriptService/Systems/`:
   - `Main.server.luau`
   - `PlayerData.server.luau`
   - `Collectibles.server.luau`
   - `Pets.server.luau`
   - `Shop.server.luau`
   - `Levels.server.luau`
   - `Zones.server.luau`

4. En `StarterPlayer/StarterPlayerScripts`:
   - Crea carpeta `PetRushClient/`
   - Copia: `ClientMain.client.luau`
   - Crea carpeta `Controllers/`
   - Copia: `HUDController.client.luau`, `CollectController.client.luau`, `PetFollowController.client.luau`, `ShopController.client.luau`, `FeedbackController.client.luau`

5. En `ReplicatedStorage`:
   - Crea carpeta `PetRush/`
   - Crea subcarpeta `Shared/`
   - Copia: `GameConfig.luau`, `Remotes.luau`, `Rewards.luau`, `PetData.luau`

### 2. Crear el Mapa Físico
En `Workspace`:
- Folder `PetRushMap`
  - Part `Ground` (tamaño 200x5x200, y=2.5, anclado, color gris oscuro)
  - Part `SpawnArea` (tamaño 10x5x10, posición y=2, color azul claro, anclado)
  - 20 Parts monedas (color oro neon, BillboardGui con "💰")
  - 20 Parts caramelos (color rojo neon, BillboardGui con "🍬")

### 3. Probar en Play Solo
Sigue los pasos del método Rojo.

## Estructura de Archivos Confirmada

### Servidor (7 archivos):
1. `Main.server.luau` - Punto de entrada, inicializa todos los sistemas
2. `Systems/PlayerData.server.luau` - Datos jugador, DataStore, validación
3. `Systems/Collectibles.server.luau` - Monedas, caramelos, reaparición
4. `Systems/Pets.server.luau` - Sistema de mascotas y seguimiento
5. `Systems/Shop.server.luau` - Tienda mejoras y cosméticos
6. `Systems/Levels.server.luau` - Sistema de niveles y XP
7. `Systems/Zones.server.luau` - Zonas con requisitos y multiplicadores

### Cliente (8 archivos):
1. `PetRushClient/ClientMain.client.luau` - Entrada principal cliente
2. `Controllers/HUDController.client.luau` - Interfaz completa
3. `Controllers/CollectController.client.luau` - Números flotantes, partículas
4. `Controllers/PetFollowController.client.luau` - Mascota seguidora
5. `Controllers/ShopController.client.luau` - Controlador tienda
6. `Controllers/FeedbackController.client.luau` - Efectos visuales/sonido

### Compartido (4 archivos):
1. `ReplicatedStorage/Shared/GameConfig.luau` - Configuración global (recompensas, precios, zonas)
2. `ReplicatedStorage/Shared/Remotes.luau` - Eventos remotos para sincronización
3. `ReplicatedStorage/Shared/Rewards.luau` - Cálculo de recompensas con combo y zonas
4. `ReplicatedStorage/Shared/PetData.luau` - Datos y probabilidades de 5 mascotas

### Documentos:
- `default.project.json` - Configuración Rojo
- `README.md` - Documentación en español
- `AGENTS.md` - Directrices de desarrollo
- `PLAN.md` - Plan de desarrollo con fases
- `SETUP_GUIDE.md` - Guía de configuración técnica

## Próximos Pasos para el Prototipo

### Fase 1: Mapa y Spawn (Esta Sesión)
- [ ] Crear Workspace/PetRushMap con suelo y SpawnLocation
- [ ] Insertar scripts servidor usando Rojo o manual
- [ ] Probar recolección de monedas con validación servidor
- [ ] Añadir HUD minimal que muestre monedas

### Fase 2: Sistema de Recogida
- [ ] 20 monedas con reaparición después de ser recogidas
- [ ] Números flotantes y partículas al recoger
- [ ] Sistema de combo temporal

### Fase 3: HUD y Progresión
- [ ] HUD que muestre: monedas, caramelos, nivel, XP, combo
- [ ] Subida de nivel con confeti y bonificación de monedas
- [ ] Desbloqueo de zonas según nivel

### Fase 4: Mascota y Tienda
- [ ] 5 mascotas con nombres, colores y rarezas distintas
- [ ] Mascota que sigue al jugador y recoge objetos
- [ ] Tienda con monedas: velocidad, alcance, multiplicador de caramelos
- [ ] 2 cosméticos para mascota

### Fase 5: Huevos y Probabilidades
- [ ] Huevos que muestran mascotas posibles y probabilidades
- [ ] Sistema de recolección para obtener huevos (no con Robux)

## Verificación de Importación

Después de importar con Rojo o manualmente, verifica:

1. **Scripts cargados**: Revisa Output en Studio por errores de sintaxis Luau
2. **Mapa físico**: Workspace/PetRushMap debe tener Ground y SpawnArea
3. **Juego en Play Solo**:
   - Aparecer en SpawnArea
   - Tocar monedas debería incrementar contador
   - Tocar caramelos debería incrementar contador de caramelos
   - HUD debe mostrar valores actualizados
   - Sistema de combinación debería funcionar al recoger consecutivamente

4. **Errores comunes**:
   - "attempt to index nil" - Verifica que los RemoteEvents existan y estén nombrados correctamente
   - "attempt to call nil" - Verifica que los scripts se hayan cargado en las ubicaciones correctas
   - Monedas que no se otorgan - Verifica la validación servidor

## Conservando Archivos Locales

Los archivos en `/Users/katya/Roblox Juego/PetRush/` están alineados y listos. Cuando importes usando Rojo:
- `rojo sync` mantendrá ambos en sincronización
- Los cambios en Studio se reflejarán en los archivos locales
- Los cambios en archivos locales se reflejarán en Studio al sincronizar

No borres los archivos locales - son tu fuente de verdad y permiten la colaboración futura.

## ¿Necesitas Ayuda Específica?

Si encuentras errores específicos al importar o probar, consulta:
1. Output de Studio para mensajes de error Luau
2. Que los RemoteEvents tengan nombres consistentes entre servidor y cliente
3. Que los scripts estén en las ubicaciones correctas (ServerScriptService vs StarterPlayer)
4. Que GameConfig.luau haya sido copiado a ReplicatedStorage/PetRush/Shared/

¿Deseas que te ayude con algún paso específico de la importación o tienes alguna pregunta sobre la estructura del proyecto?