# Pet Rush! Prototype v8

## Descripción
Pet Rush! es un prototipo de colección y crecimiento donde el jugador recoge monedas y caramelos para desbloquear y criar mascotas con rarezas únicas. El juego presenta un bucle de retención progresivo con feedback inmediato, economía validada en servidor y colección de mascotas.

## Bucle de Retención (Gameplay Loop)

### Fase 1: Recoger y Crecer (Core Loop)
- **Qué hacer**: Mover al personaje para tocar monedas y caramelos dispersos en el mapa
- **Feedback inmediato**: 
  - Número flotante (IntValue) que aparece al tocar con animación de escala
  - Efecto de partícula pequeña (sparkles) en el punto de colección
  - Sonido "ding" corto al recoger
  - HUD actualiza Coins y Candies en tiempo real
- **Progresión**: Las monedas dan Coins, los caramelos dan Candies. Ambos se usan para comprar Huevos y mejorar multiplicadores.

### Fase 2: Huevos y Rarezas
- **Qué hacer**: Comprar Huevos con Coins o Candies. Cada huevo tiene una tabla de probabilidades de rarezas.
- **Rarezas definidas en módulo**: Common (40%), Rare (30%), Epic (20%), Legendary (10%)
- **Qué hay dentro**: Cada huevo revela una mascota con atributos únicos (velocidad, multiplicador, habilidad especial)
- **Visual**: El huevo se abre con animación y la mascota aparece junto al jugador
- **Identidad propia**: Nombres originales como "CaramelEgg", "PetalEgg", "StarEgg" - sin copiar nombres de juegos existentes

### Fase 3: colección y Rasgos de Mascotas
- **Qué hacer**: Las mascotas se equipan automáticamente y dan rasgos pasivos:
  - Common: +1% de recolección de velocidad
  - Rare: +5% de generación de Candies por segundo
  - Epic: Multiplicador de Coins 1.2x cuando recogen
  - Legendary: Habilidad especial "Encontrar objetos ocultos"
- **Slots de equipamiento**: Límite de 3 mascotas equipadas a la vez. Mascotas extras van al inventario.
- **Visual**: Las mascotas aparecen como partes pequeñas (VisualPet) que flotan junto al jugador, con colores según rareza

### Fase 4: Zonas Desbloqueables
- **Qué hacer**: Pagar un costo creciente para desbloquear nuevas áreas del mapa con diferentes tipos de monedas y caramelos.
- **Progresión**: Cada zona tiene multiplicadores más altos pero requiere más recursos.

### Fase 5: Rebirth
- **Qué hacer**: Reiniciar el progreso a cambio de un Multiplicador Permanente ( Permanent Cookie Multiplier).
- **Qué se guarda**: Total de mascotas coleccionadas, rarezas obtenidas.
- **Beneficio**: El multiplicador permanente se suma al actual para acelerar futuras corridas.

### Fase 6: Recompensa Diaria y Misiones
- **Qué hacer**: Iniciar sesión diario para obtener bonos gratis.
- **Misiones cortas**: "Recoge 10 monedas", "Compra tu primer huevo", "Equipa 3 mascotas".
- **Reward**: Coins adicionales, boosts temporales o artículos de edición limitada.

### Fase 7: Elemento Social (Ligero)
- **Ranking**: Tabla global anónima de "Más mascotas Legendary obtenidas".
- **Intercambio**: No implementado en prototipo inicial por restricciones de edad.

## Patrones Tomados de Simuladores Populares
1. **Feedback inmediato** (Bee Swarm Simulator): números flotantes, sonidos, partículas al recolectar
2. **Huevos con rarezas** (Pet Simulator 99): probabilidades definidas, apertura visual
3. **Mascotas con rasgos** (Adopt Me): rasgos pasivos, slots de equipamiento
4. **Rebirth/progreso permanente** (Bloons TD Battles): reinicio por beneficio permanente
5. **Recompensas diarias** (Grow a Garden): sesión diaria obligatoria

## Identidad Propia de Pet Rush!
- **Tema**: Mascotas y caramelos (no animales genéricos ni gameplay de combate)
- **Economía**: Monedas y Caramelos (no gemas o moneda premium agresiva)
- **Probabilidades**: Claramente marcadas (40/30/20/10), sin mecánicas de azar de pago
- **Público**: Jugadores jóvenes - todo es visual y no agresivo
- **Acceso**: Todo desbloqueable con moneda del juego, sin purchases necesarios

## Configuración Técnica
- Economía y probabilidades en módulo `ShopConfig.lua` o tabla Lua en ServerScript
- Todo validado en servidor (Ningún cliente decide si obtiene Legendary)
- DataStore para persistencia al finalizar bucle básico
- HUD: Coins (dorado), Candies (rosado), Multiplicador, Slot de mascota

## Siguientes Pasos
1. Feedback al recoger (sonido, partículas, número flotante) - **PRIMERO**
2. Sistema de Huevos con rarezas y probabilidades
3. Mascotas con rasgos y slots de equipamiento
4. Zonas desbloqueables
5. Rebirth y multiplicador permanente
6. Recompensa diaria y misiones
7. Elemento social (ranking)