# Assets Licenses - Pet Rush!

## Original Models - Created from Scratch with Python/bpy in Blender

This project creates all 3D models from scratch using Blender's Python API (bpy). No third-party CC0 assets were imported; all models are generated procedurally using primitive meshes, modifiers, and custom Python code.

### Creation Method
- **Tool:** Blender 3D with Python (bpy)
- **License:** Created by the developer - free for commercial and personal use, no attribution required
- **Created:** October 2026

### Poly Budget (target, actual counts after generation)
- **Mascotas:** <1,500 triangles each
- **Objetos:** <800 triangles each
- **Huevos:** <600 triangles each
- **Decoración:** <1,500 triangles each

### Models Included (all created from scratch)

#### MASCOTAS (4 base + 4 rareza variants = 8 .blend + 8 .fbx)
1. **Murciélago** - Cuerpo esférico morado oscuro, alas membranosas bajas poligonales, orejas puntiagudas, dos colmillos blancos, ojos amarillos
   - Common: base morada `#6B2FA0`
   - Rare: acentos morados `#2A1040`
   - Epic: acentos dorados `#FFD23F`
   - Legendary: aura emisiva bajo los pies (disco emitente)

2. **Fantasma** - Cuerpo en forma de gota blanco hueso con base ondulada, brazos cortos, boca ovalada, ojos negros grandes
   - Common: base blanco hueso `#F2EEDC`
   - Rare: acentos morados `#6B2FA0`
   - Epic: acentos dorados `#FFD23F`
   - Legendary: aura emisiva

3. **Gato negro** - Cuerpo redondeado negro, orejas triangulares, cola curvada, ojos verde ácido, un lazo naranja en el cuello
   - Common: base negro `#15121A`
   - Rare: acentos morados `#6B2FA0`
   - Epic: acentos dorados `#FFD23F`
   - Legendary: aura emisiva

4. **Calabaza** - Calabaza naranja con gajos marcados, tallo verde, cara tallada (ojos triangulares y sonrisa), brillo interior amarillo
   - Common: naranja `#FF7A18`
   - Rare: manchas moradas `#6B2FA0`
   - Epic: acentos dorados `#FFD23F`
   - Legendary: brillo interior intensivo + aura emisiva

#### RECOLECTABLES (4 tipos)
5. **Calabaza pequeña** - 2 studs de ancho, gajos, tallo, color naranja, plana por abajo
6. **Caramelo envuelto** - Cuerpo ovalado y dos lazos a los lados, rayas moradas y naranjas
7. **Caramelo de maíz (candy corn)** - Triángulo redondeado, tres bandas (blanco, naranja, amarillo)

#### HUEVOS (3 tipos, uno por botón de tienda)
8. **Huevo común** - naranja con manchas moradas
9. **Huevo raro** - morado con luna creciente blanca
10. **Huevo épico** - negro con estrellas doradas y base dorada

#### HABILIDADES (3 items con cooldown)
11. **Imán** - herradura roja con puntas blancas, brillo azul
12. **Botas veloces** - bota morada con ala pequeña y chispas
13. **Poción doble** - frasco redondo verde ácido con cuello, etiqueta "x2"

#### DECORACIÓN DEL MAPA (10 tipos)
14. **Lápidas** (3 variantes: redonda, cruz, con rotura), gris piedra `#8A8794`
15. **Árbol seco** - tronco retorcido negro con 4 ramas, sin hojas
16. **Valla de hierro** - módulo de 4 studs con puntas
17. **Farol con vela** - poste negro y llama amarilla emisiva
18. **Caldero con burbujas verdes**
19. **Telaraña de esquina** (plano blanco)
20. **Puerta de cementerio en arco** con dos pilares

### Technical Notes
- **Estilo:** Low poly, redondeado, simpático, tipo juguete (estilo chibi)
- **Un solo objeto por modelo**, un solo material, un solo mapa UV
- **Textura de paleta:** PNG de 128x128 con bloques de color plano; cada cara asignada al color correspondiente en el UV
- **Origen en el centro de la base**, frente hacia -Y en Blender
- **Escala y rotación aplicadas antes de exportar.** Sin cámaras ni luces.
- **Presupuesto:** mascotas <1.500 triángulos, objetos <800, huevos <600, decoración <1.500
- **Formatos:** .blend (editable) y .fbx (exportado con Path Mode Copy, Embed Textures activado, Apply Scalings = FBX Unit Scale, Add Leaf Bones desactivado, Bake Animation desactivado)
- **Mapa UV:** Un solo UV por modelo, todas las caras asignadas a colores de la paleta de 128x128

### Creator
- **Desarrollado por:** Comunidad Pet Rush!
- **Fecha:** Octubre 2026
- **Propósito:** Mascotas, recogibles, huevos, habilidades y decoración para Pet Rush! prototype

### Verificación
- ✅ Modelos creados desde cero con Python/bpy en Blender
- ✅ Sin importación de activos CC0 de terceros
- ✅ Política de licencia: creado por el desarrollador, uso comercial gratuito
- ✅ Cumple con los presupuestos de triángulos especificados
- ✅ Formato .blend (editable) y .fbx (para Roblox) generados
