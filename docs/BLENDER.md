# BLENDER.md - Guía de Modelado y Conexión

## Configuración de Conexión (MCPBridge)
- **Servidor MCP**: `@iamjrmh/mcpbridge@1.0.0` vía `npx`.
- **Puerto**: `7843` (Localhost).
- **Add-on de Blender**: `MCPBridge.py` instalado en Preferencias $\rightarrow$ Add-ons.
- **Activación**: Pestaña "MCPBridge" en el panel lateral (N) $\rightarrow$ "Start Bridge".

## Assets de Pet Rush!
### Pendientes
- [ ] Cachorro Low-Poly (Cabeza grande, cuerpo pequeño, expresivo).
- [ ] Moneda (Volumen, borde, detalle central).
- [ ] Árbol (Estilo alegre, redondeado).
- [ ] Roca (Estilo alegre, redondeado).

### Flujo de Trabajo
1. **Modelado**: Crear en colección `PetRush_Assets`.
2. **Guardado**: Archivo independiente en `PetRush/assets/blender/`.
3. **Exportación**: Formato compatible con Roblox en `PetRush/assets/exports/`.
4. **Importación**: Via Roblox Studio $\rightarrow$ Asset Manager.

## Reversión
- Eliminar entrada `mcpbridge` de la configuración de Claude Code.
- Desactivar y eliminar add-on en Blender.
