# Fuentes Personalizadas

Este directorio contiene las fuentes personalizadas utilizadas en Arcadia Music.

## Fuentes Requeridas

### Orbitron
- **Orbitron-Regular.ttf**: Fuente principal para títulos y elementos destacados
- **Orbitron-Bold.ttf**: Variante en negrita para énfasis

### Montserrat
- **Montserrat-Regular.ttf**: Fuente para texto del cuerpo
- **Montserrat-Bold.ttf**: Variante en negrita
- **Montserrat-Light.ttf**: Variante ligera para subtítulos

## Instalación

1. Descarga las fuentes desde Google Fonts:
   - [Orbitron](https://fonts.google.com/specimen/Orbitron)
   - [Montserrat](https://fonts.google.com/specimen/Montserrat)

2. Coloca los archivos .ttf en este directorio

3. Las fuentes ya están configuradas en `pubspec.yaml`

## Uso en el Código

```dart
// Orbitron para títulos
Text(
  'ARCADIA MUSIC',
  style: AppTextStyles.heading1, // Usa Orbitron
)

// Montserrat para texto del cuerpo
Text(
  'Descripción de la canción',
  style: AppTextStyles.body1, // Usa Montserrat
)
```

## Nota

Si no tienes las fuentes instaladas, la aplicación usará las fuentes del sistema como fallback. 