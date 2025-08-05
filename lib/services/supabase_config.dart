// Configuración de Supabase para Arcadia Music
// 
// INSTRUCCIONES:
// 1. Reemplaza 'YOUR_SUPABASE_URL' con la URL de tu proyecto Supabase
// 2. Reemplaza 'YOUR_SUPABASE_ANON_KEY' con la Anon Key de tu proyecto
// 3. Copia este archivo a supabase_service.dart y actualiza las constantes

class SupabaseConfig {
  // URL de tu proyecto Supabase
  // Ejemplo: https://abcdefghijklmnop.supabase.co
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  
  // Anon Key de tu proyecto Supabase
  // Encuéntrala en Settings > API en tu dashboard de Supabase
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // URL de redirección para OAuth
  static const String redirectUrl = 'com.arcadia_music://login-callback';
}

// CÓMO OBTENER LAS CREDENCIALES:
//
// 1. Ve a https://supabase.com y crea una cuenta
// 2. Crea un nuevo proyecto
// 3. Ve a Settings > API en el dashboard
// 4. Copia la "Project URL" y "anon public" key
// 5. Reemplaza las constantes arriba con tus valores
//
// CONFIGURACIÓN DE GOOGLE OAUTH:
//
// 1. Ve a Authentication > Providers en Supabase
// 2. Habilita Google provider
// 3. Configura las credenciales de Google OAuth
// 4. Agrega la URL de redirección: com.arcadia_music://login-callback
//
// CONFIGURACIÓN DE LA BASE DE DATOS:
//
// Ejecuta los siguientes comandos SQL en el editor SQL de Supabase:
//
// -- Tabla de canciones
// CREATE TABLE songs (
//   id TEXT PRIMARY KEY,
//   title TEXT NOT NULL,
//   description TEXT NOT NULL,
//   genre TEXT NOT NULL,
//   image_url TEXT NOT NULL,
//   audio_url TEXT NOT NULL,
//   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
// );
//
// -- Tabla de perfiles de usuario
// CREATE TABLE profiles (
//   id UUID REFERENCES auth.users(id) PRIMARY KEY,
//   email TEXT,
//   name TEXT,
//   avatar_url TEXT,
//   is_admin BOOLEAN DEFAULT FALSE,
//   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
// );
//
// -- Tabla de favoritos
// CREATE TABLE favorites (
//   id SERIAL PRIMARY KEY,
//   user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
//   song_id TEXT REFERENCES songs(id) ON DELETE CASCADE,
//   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
//   UNIQUE(user_id, song_id)
// );
//
// -- Tabla de descargas
// CREATE TABLE downloads (
//   id SERIAL PRIMARY KEY,
//   user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
//   song_id TEXT REFERENCES songs(id) ON DELETE CASCADE,
//   downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
//   UNIQUE(user_id, song_id)
// );
//
// -- Habilitar RLS
// ALTER TABLE songs ENABLE ROW LEVEL SECURITY;
// ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
// ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
// ALTER TABLE downloads ENABLE ROW LEVEL SECURITY;
//
// -- Políticas de seguridad
// CREATE POLICY "Songs are viewable by everyone" ON songs FOR SELECT USING (true);
// CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
// CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
// CREATE POLICY "Users can view own favorites" ON favorites FOR SELECT USING (auth.uid() = user_id);
// CREATE POLICY "Users can insert own favorites" ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
// CREATE POLICY "Users can delete own favorites" ON favorites FOR DELETE USING (auth.uid() = user_id);
// CREATE POLICY "Users can view own downloads" ON downloads FOR SELECT USING (auth.uid() = user_id);
// CREATE POLICY "Users can insert own downloads" ON downloads FOR INSERT WITH CHECK (auth.uid() = user_id);
// CREATE POLICY "Users can delete own downloads" ON downloads FOR DELETE USING (auth.uid() = user_id); 