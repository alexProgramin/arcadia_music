# Configuración de Supabase para Arcadia Music

## ✅ Credenciales Configuradas

Las credenciales de Supabase ya han sido configuradas en el código:
- **URL**: `https://mwnedjxdabfwtghapgke.supabase.co`
- **Anon Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im13bmVkanhkYWJmd3RnaGFwZ2tlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQwODMzOTMsImV4cCI6MjA2OTY1OTM5M30.7uSUgodKqDE1aA2B3rfrbYl1bUQzj0BtP_KIUJIZvKw`

## 📋 Pasos Restantes para Completar la Configuración

### 1. Crear las Tablas en Supabase

Ejecuta estos scripts SQL en el **SQL Editor** de tu dashboard de Supabase:

#### Tabla `songs`
```sql
CREATE TABLE songs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  genre TEXT NOT NULL,
  image_url TEXT,
  audio_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE songs ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura a todos los usuarios autenticados
CREATE POLICY "Songs are viewable by everyone" ON songs
  FOR SELECT USING (true);

-- Política para permitir inserción solo a administradores
CREATE POLICY "Songs can be inserted by admins" ON songs
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Política para permitir actualización solo a administradores
CREATE POLICY "Songs can be updated by admins" ON songs
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Política para permitir eliminación solo a administradores
CREATE POLICY "Songs can be deleted by admins" ON songs
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );
```

#### Tabla `profiles`
```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT,
  name TEXT,
  avatar_url TEXT,
  is_admin BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Política para permitir a los usuarios ver su propio perfil
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Política para permitir a los usuarios actualizar su propio perfil
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Política para permitir inserción de perfiles
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
```

#### Tabla `favorites`
```sql
CREATE TABLE favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  song_id UUID REFERENCES songs(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, song_id)
);

-- Habilitar RLS
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Política para permitir a los usuarios ver sus propios favoritos
CREATE POLICY "Users can view own favorites" ON favorites
  FOR SELECT USING (auth.uid() = user_id);

-- Política para permitir a los usuarios agregar favoritos
CREATE POLICY "Users can insert own favorites" ON favorites
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Política para permitir a los usuarios eliminar sus favoritos
CREATE POLICY "Users can delete own favorites" ON favorites
  FOR DELETE USING (auth.uid() = user_id);
```

#### Tabla `downloads`
```sql
CREATE TABLE downloads (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  song_id UUID REFERENCES songs(id) ON DELETE CASCADE,
  downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, song_id)
);

-- Habilitar RLS
ALTER TABLE downloads ENABLE ROW LEVEL SECURITY;

-- Política para permitir a los usuarios ver sus descargas
CREATE POLICY "Users can view own downloads" ON downloads
  FOR SELECT USING (auth.uid() = user_id);

-- Política para permitir a los usuarios agregar descargas
CREATE POLICY "Users can insert own downloads" ON downloads
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Política para permitir a los usuarios eliminar sus descargas
CREATE POLICY "Users can delete own downloads" ON downloads
  FOR DELETE USING (auth.uid() = user_id);
```

### 2. Configurar Google OAuth

1. Ve a **Settings** → **Auth** → **Providers**
2. Habilita **Google**
3. Configura:
   - **Client ID**: Tu Google OAuth Client ID
   - **Client Secret**: Tu Google OAuth Client Secret
4. En **Redirect URLs** agrega: `com.arcadia_music://login-callback`

### 3. Crear un Usuario Administrador

1. Registra un usuario normal en la app
2. Ve a **Authentication** → **Users** en Supabase
3. Encuentra tu usuario y copia su ID
4. Ejecuta este SQL para hacerlo administrador:

```sql
UPDATE profiles 
SET is_admin = true 
WHERE id = 'TU_USER_ID_AQUI';
```

### 4. Insertar Datos de Ejemplo

Ejecuta este SQL para agregar algunas canciones de ejemplo:

```sql
INSERT INTO songs (title, description, genre, image_url, audio_url) VALUES
('Neon Dreams', 'Sintetizadores electrónicos con ritmos futuristas', 'Electronic', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400', 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav'),
('Cyber Pulse', 'Música electrónica con beats sintéticos', 'Electronic', 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400', 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav'),
('Digital Horizon', 'Ambiente electrónico con melodías espaciales', 'Ambient', 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=400', 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav'),
('Synthwave Nights', 'Retro synthwave con toques neón', 'Synthwave', 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400', 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav'),
('Quantum Beats', 'Ritmos cuánticos con efectos digitales', 'Electronic', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400', 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav');
```

## 🚀 Probar la Aplicación

1. Ejecuta `flutter run` en tu dispositivo/emulador
2. La app debería abrirse en la pantalla de login
3. Puedes registrarte con email/password o usar Google OAuth
4. Una vez autenticado, verás la pantalla principal con las canciones

## 📱 Funcionalidades Disponibles

- ✅ **Autenticación**: Login/registro con email y Google OAuth
- ✅ **Búsqueda**: Filtrado en tiempo real de canciones
- ✅ **Filtros**: Por género musical
- ✅ **Reproducción**: Streaming de audio
- ✅ **Favoritos**: Marcar/desmarcar canciones
- ✅ **Descargas**: Descargar canciones localmente
- ✅ **Perfil**: Ver información del usuario
- ✅ **Admin**: Panel para agregar nuevas canciones (solo para admins)

## 🔧 Solución de Problemas

### Error de OAuth
- Verifica que las URLs de redirección estén configuradas correctamente
- Asegúrate de que el Client ID y Secret de Google sean correctos

### Error de Permisos
- Verifica que las políticas RLS estén aplicadas correctamente
- Asegúrate de que el usuario esté autenticado

### Error de Audio
- Verifica que las URLs de audio sean accesibles
- Asegúrate de que el dispositivo tenga permisos de audio

## 📞 Soporte

Si encuentras algún problema, verifica:
1. Que todas las tablas estén creadas correctamente
2. Que las políticas RLS estén aplicadas
3. Que las credenciales de Google OAuth sean correctas
4. Que las URLs de audio sean válidas y accesibles 