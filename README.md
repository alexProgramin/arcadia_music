# Arcadia Music - Futuristic Music Streaming App

Una aplicación móvil de streaming de música con diseño futurista, construida con Flutter y Supabase.

## 🚀 Características

### Autenticación
- ✅ Login y registro con email/password
- ✅ Autenticación con Google OAuth
- ✅ Validación automática de sesión
- ✅ Redirección automática según estado de autenticación

### Pantalla Principal
- ✅ Barra de búsqueda en tiempo real
- ✅ Filtros por género musical
- ✅ Listado de canciones con diseño futurista
- ✅ Reproducción de audio streaming
- ✅ Descarga de canciones para uso offline
- ✅ Sistema de favoritos por usuario

### Navegación
- ✅ Barra de navegación inferior futurista
- ✅ 4 secciones principales: Home, Favorites, Downloads, Profile
- ✅ Reproductor de audio flotante
- ✅ Transiciones suaves entre pantallas

### Diseño Visual
- ✅ Estilo futurista con colores oscuros
- ✅ Acentos en cyan, morado y neón
- ✅ Tipografías modernas (Orbitron, Montserrat)
- ✅ Animaciones suaves y efectos visuales
- ✅ Interfaz limpia y minimalista

### Funcionalidades Avanzadas
- ✅ Gestión de estado con Provider
- ✅ Arquitectura limpia y escalable
- ✅ Código bien comentado y profesional
- ✅ Panel de administrador para subir canciones
- ✅ Manejo de favoritos y descargas
- ✅ Reproducción de audio con controles

## 🛠️ Configuración

### 1. Configurar Supabase

1. Crea una cuenta en [Supabase](https://supabase.com)
2. Crea un nuevo proyecto
3. Obtén las credenciales de tu proyecto:
   - URL del proyecto
   - Anon Key

### 2. Configurar la Base de Datos

Ejecuta los siguientes comandos SQL en el editor SQL de Supabase:

```sql
-- Tabla de canciones
CREATE TABLE songs (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  genre TEXT NOT NULL,
  image_url TEXT NOT NULL,
  audio_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de perfiles de usuario
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  name TEXT,
  avatar_url TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de favoritos
CREATE TABLE favorites (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  song_id TEXT REFERENCES songs(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, song_id)
);

-- Tabla de descargas
CREATE TABLE downloads (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  song_id TEXT REFERENCES songs(id) ON DELETE CASCADE,
  downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, song_id)
);

-- Políticas de seguridad RLS
ALTER TABLE songs ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE downloads ENABLE ROW LEVEL SECURITY;

-- Políticas para songs (lectura pública)
CREATE POLICY "Songs are viewable by everyone" ON songs
  FOR SELECT USING (true);

-- Políticas para profiles
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Políticas para favorites
CREATE POLICY "Users can view own favorites" ON favorites
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own favorites" ON favorites
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own favorites" ON favorites
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas para downloads
CREATE POLICY "Users can view own downloads" ON downloads
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own downloads" ON downloads
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own downloads" ON downloads
  FOR DELETE USING (auth.uid() = user_id);
```

### 3. Configurar Autenticación con Google

1. Ve a Authentication > Providers en Supabase
2. Habilita Google provider
3. Configura las credenciales de Google OAuth:
   - Client ID
   - Client Secret
4. Configura las URLs de redirección:
   - `io.supabase.flutter://login-callback/`

### 4. Configurar el Proyecto Flutter

1. Actualiza las credenciales en `lib/services/supabase_service.dart`:
```dart
static const String _supabaseUrl = 'TU_SUPABASE_URL';
static const String _supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## 📱 Uso de la Aplicación

### Para Usuarios Regulares
1. **Registro/Login**: Usa email/password o Google OAuth
2. **Explorar Música**: Navega por la biblioteca de canciones
3. **Buscar**: Usa la barra de búsqueda para encontrar canciones
4. **Filtrar**: Usa los chips de género para filtrar
5. **Reproducir**: Toca el botón de play para escuchar
6. **Favoritos**: Marca canciones como favoritas
7. **Descargar**: Descarga canciones para uso offline

### Para Administradores
1. **Acceso**: Los usuarios con `is_admin=true` pueden acceder al panel
2. **Subir Canciones**: Usa el formulario para agregar nuevas canciones
3. **Gestionar**: Administra la biblioteca de música

## 🎨 Estructura del Proyecto

```
lib/
├── models/           # Modelos de datos
├── providers/        # Gestión de estado
├── screens/          # Pantallas de la aplicación
│   ├── auth/        # Autenticación
│   ├── home/        # Pantalla principal
│   ├── favorites/   # Favoritos
│   ├── downloads/   # Descargas
│   ├── profile/     # Perfil de usuario
│   └── admin/       # Panel de administrador
├── services/         # Servicios (Supabase, Audio, Downloads)
├── utils/           # Utilidades y constantes
└── widgets/         # Widgets reutilizables
```

## 🔧 Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo móvil
- **Supabase**: Backend como servicio (BaaS)
- **Provider**: Gestión de estado
- **Just Audio**: Reproducción de audio
- **Cached Network Image**: Carga de imágenes
- **Google Fonts**: Tipografías personalizadas

## 🚀 Despliegue

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📝 Notas Importantes

1. **Configuración de Supabase**: Asegúrate de configurar correctamente las políticas RLS
2. **Permisos**: La aplicación requiere permisos de almacenamiento para descargas
3. **URLs de Audio**: Asegúrate de que las URLs de audio sean accesibles públicamente
4. **Google OAuth**: Configura correctamente las credenciales de Google

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🆘 Soporte

Si tienes problemas o preguntas:
1. Revisa la documentación de Supabase
2. Verifica la configuración de las políticas RLS
3. Asegúrate de que las URLs de audio sean válidas
4. Revisa los logs de la aplicación

---

**Arcadia Music** - Futuristic Music Experience 🎵✨
