# Pet Rush! - Juego de Recogida y Mascotas

## Descripción general
Pet Rush! es un juego infantil, colorido y recompensador donde los jugadores recogen caramelos y monedas, ganan XP, suben de nivel, desbloquean mascotas y mejoran su velocidad. El bucle de juego es corto: recoger durante 30-60 segundos, recibir recompensas, mejorar y repetir.

## Estructura del proyecto
El proyecto sigue una estructura modular compatible con Rojo para gestión de versiones y sincronización con Roblox Studio.

```
PetRush/
├── default.project.json
├── README.md
├── ReplicatedStorage/
│   └── Shared/
│       ├── GameConfig.luau
│       ├── Remotes.luau
│       ├── Rewards.luau
│       └── PetData.luau
├── ServerScriptService/
│   ├── Main.server.luau
│   ├── Systems/
│   │       ├── PlayerData.server.luau
│   │       ├── Collectibles.server.luau
│   │       ├── Pets.server.luau
│   │       ├── Shop.server.luau
│   │       ├── Levels.server.luau
│   │       └── Zones.server.luau
└── StarterPlayer/
    └── StarterPlayerScripts/
        ├── ClientMain.client.luau
        ├── Controllers/
        │       ├── HUDController.client.luau
        │       ├── CollectController.client.luau
        │       ├── PetFollowController.client.luau
        │       ├── ShopController.client.luau
        │       └── FeedbackController.client.luau
```

## Cómo abrir el proyecto

### Opción A: Usando Rojo (Recomendado)
Rojo es una herramienta de código abierto que sincroniza tus archivos Luau con Roblox Studio.

1. **Instalar Rojo**:
   ```bash
   cargo install rojo
   ```
   O descarga el ejecutable desde: https://github.com/ROBLOX/rojo

2. **Inicializar Rojo en Roblox Studio**:
   - Abre Roblox Studio
   - Crea un nuevo lugar en blanco
   - Ejecuta: `rojo init`
   - Esto creará un archivo `.gitignore` y configuración de Rojo en el lugar

3. **Sincronizar el proyecto**:
   - Mueve la carpeta `PetRush/` al lugar de Roblox Studio o configura Rojo para apunte a ella
   - Ejecuta: `rojo sync`
   - Rojo copiará automáticamente todos los archivos `.luau` a la ubicación correcta en Roblox Studio

4. **Desarrollar**:
   - Modifica los archivos `.luau` en la carpeta `PetRush/`
   - Ejecuta: `rojo sync` para actualizar Roblox Studio

### Opción B: Copia manual (Sin Rojo)
Si no usas Rojo, copia manualmente cada archivo a la ubicación correcta en Roblox Studio:

1. **ReplicatedStorage** -> `Shared/`:
   - `GameConfig.luau` -> `ReplicatedStorage/Shared/`
   - `Remotes.luau` -> `ReplicatedStorage/Shared/`
   - `Rewards.luau` -> `ReplicatedStorage/Shared/`
   - `PetData.luau` -> `ReplicatedStorage/Shared/`

2. **ServerScriptService/`:
   - `Main.server.luau` -> `ServerScriptService/`
   - `PlayerData.server.luau` -> `ServerScriptService/Systems/`
   - `Collectibles.server.luau` -> `ServerScriptService/Systems/`
   - `Pets.server.luau` -> `ServerScriptService/Systems/`
   - `Shop.server.luau` -> `ServerScriptService/Systems/`
   - `Levels.server.luau` -> `ServerScriptService/Systems/`
   - `Zones.server.luau` -> `ServerScriptService/Systems/`

3. **StarterPlayer/StarterPlayerScripts/`:
   - `ClientMain.client.luau` -> `StarterPlayer/StarterPlayerScripts/`
   - `HUDController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/`
   - `CollectController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/`
   - `PetFollowController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/`
   - `ShopController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/`
   - `FeedbackController.client.luau` -> `StarterPlayer/StarterPlayerScripts/Controllers/`

## Colocar scripts en Roblox Studio
- **ServerScriptService**: Contiene scripts del servidor (ejecútan automáticamente al iniciar).
- **ReplicatedStorage/Shared**: Contiene módulos y configuraciones compartidas entre cliente y servidor.
- **StarterPlayer/StarterPlayerScripts**: Contienen scripts locales que se ejecutan para cada jugador al unirse.

## Cómo probar en Play Solo
1. Abre Roblox Studio con el proyecto sincronizado
2. Haz clic en el botón "Play" (Play Solo)
3. El jugador debería aparecer en el mapa pequeño
4. Moverse para recoger monedas y caramelos
5. Verificar que el HUD muestre las recompensas
6. Probar la tienda con monedas del juego
7. Verificar que la mascota siga al jugador

## Próximos pasos
1. Configurar el mapa y partes de spawn
2. Probar sistema de recolección completo
3. Implementar sistema de mascotas y huevos
4. Agregar más zonas y mejoras
5. Optimizar rendimiento y efectos visuales