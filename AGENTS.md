# AGENTS.md - Regles y directrices para el desarrollo de Pet Rush!

## CONTEXTO
- Sistema: macOS Apple Silicon M4
- Carpeta del proyecto: /Users/katya/Roblox Juego
- Conexión: Roblox Studio via MCP (conectado)
- Archivos locales existentes: 17 archivos Luau creados en PetRush/
- Objetivo: Construir prototipo jugable de "Pet Rush!"

## FORMA DE TRABAJO
1. Inspecciona el estado real antes de modificarlo
2. Mantén un plan en docs/PLAN.md con tareas pendientes, en curso y completadas
3. Completa una tarea, verifica su funcionamiento y pasa a la siguiente
4. Si aparece un error, investiga y corrígelo antes de continuar
5. Después de tres intentos fallidos con el mismo problema, documenta el bloqueo y continúa
6. No afirmes que algo funciona sin evidencia de prueba
7. Distingue entre archivos locales, cambios en DataModel y cambios temporales durante Play
8. Conserva trabajo existente y evita duplicados
9. No desactives permisos ni salvaguardas
10. Pide intervención solo para permisos, decisiones importantes o acciones manuales

## ALCANCE AUTORIZADO
- Crear/editar archivos en /Users/katya/Roblox Juego/PetRush/
- Crear/editar objetos Pet Rush! via MCP en Studio Place1 (ID: ed6d826b-4cf0-49eb-b115-de975606325d)
- Ejecutar y detener pruebas, revisar Output
- Mantener alineados código local y scripts de Studio

## REQUIERE MI CONFIRMACIÓN
- Publicar el juego
- Crear/borrar repositorios remotos o subir a GitHub
- Gastar dinero o Robux
- Instalar plugins o dependencias nuevas
- Borrar trabajo existente o modificar objetos ajenos a Pet Rush!
- Cambiar ajustes de seguridad o acceder credenciales

## OBJETIVO DE ESTA SESIÓN (Prototipo Mínimo)
1. Mapa y spawn
2. Recogida monedas y caramelos (validadas por servidor)
3. HUD: monedas, caramelos, nivel, XP
4. Mascota seguidora
5. Tienda: 2 mejoras con moneda del juego
6. Guardado con manejo seguro de fallos
7. Prueba del conjunto y corrección de errores

No añadas nuevas funciones hasta estabilizar el prototipo.

## AL TERMINAR - Informe breve
- Qué completado
- Pruebas realizadas y resultados
- Qué pendiente
- Bloqueos
- Si cambios guardados y dónde