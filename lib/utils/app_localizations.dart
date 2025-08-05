import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      // Auth
      'login': 'LOGIN',
      'register': 'REGISTER',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'fullName': 'Full Name',
      'pleaseEnterEmail': 'Please enter your email',
      'pleaseEnterValidEmail': 'Please enter a valid email',
      'pleaseEnterPassword': 'Please enter your password',
      'passwordMinLength': 'Password must be at least 6 characters',
      'pleaseEnterFullName': 'Please enter your full name',
      'nameMinLength': 'Name must be at least 2 characters',
      'pleaseConfirmPassword': 'Please confirm your password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'dontHaveAccount': "Don't have an account? ",
      'alreadyHaveAccount': 'Already have an account? ',
      'userRegisteredSuccessfully': 'User registered successfully',
      
      // Home
      'discoverNextFavorite': 'Discover your next favorite track',
      'noSongsFound': 'No songs found',
      'tryAdjustingSearch': 'Try adjusting your search or filters',
      
      // Profile
      'settings': 'Settings',
      'appPreferences': 'App preferences and configuration',
      'helpSupport': 'Help & Support',
      'getHelpContact': 'Get help and contact support',
      'about': 'About',
      'appVersionInfo': 'App version and information',
      'signOut': 'Sign Out',
      'signOutAccount': 'Sign out of your account',
      'favorites': 'Favorites',
      'downloads': 'Downloads',
      'areYouSureSignOut': 'Are you sure you want to sign out?',
      'cancel': 'Cancel',
      
      // Downloads
      'songDownloadedSuccessfully': 'Song downloaded successfully',
      'downloadError': 'Download error',
      'retry': 'Retry',
      'connectionError': 'Connection error. Check your internet connection.',
      'timeoutError': 'Request timeout. Please try again.',
      'downloadErrorGeneric': 'Error downloading song',
      'storagePermissionDenied': 'Storage permission denied. Please enable permissions in app settings.',
      'invalidAudioUrl': 'Invalid audio URL',
      'permissionRequired': 'Permission Required',
      'permissionExplanation': 'This app needs storage permission to download songs. Please grant the permission in your device settings.',
      'openSettings': 'Open Settings',
      'storagePermission': 'Storage Permission',
      'permissionRequestExplanation': 'To download songs, we need access to your device storage. This allows you to save music for offline listening.',
      'whyWeNeedPermission': 'Why do we need this?',
      'permissionBenefits': '• Download songs for offline listening\n• Access your music library\n• Save storage space with efficient downloads',
      'grantPermission': 'Grant Permission',
      'notNow': 'Not Now',
      
      // Settings
      'language': 'Language',
      'languageSettings': 'Language Settings',
      'selectLanguage': 'Select Language',
      'spanish': 'Spanish',
      'english': 'English',
      'languageChanged': 'Language changed successfully',
      
      // General
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',
    },
    'es': {
      // Auth
      'login': 'INICIAR SESIÓN',
      'register': 'REGISTRARSE',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'confirmPassword': 'Confirmar contraseña',
      'fullName': 'Nombre completo',
      'pleaseEnterEmail': 'Por favor ingresa tu correo electrónico',
      'pleaseEnterValidEmail': 'Por favor ingresa un correo válido',
      'pleaseEnterPassword': 'Por favor ingresa tu contraseña',
      'passwordMinLength': 'La contraseña debe tener al menos 6 caracteres',
      'pleaseEnterFullName': 'Por favor ingresa tu nombre completo',
      'nameMinLength': 'El nombre debe tener al menos 2 caracteres',
      'pleaseConfirmPassword': 'Por favor confirma tu contraseña',
      'passwordsDoNotMatch': 'Las contraseñas no coinciden',
      'dontHaveAccount': '¿No tienes una cuenta? ',
      'alreadyHaveAccount': '¿Ya tienes una cuenta? ',
      'userRegisteredSuccessfully': 'Usuario registrado exitosamente',
      
      // Home
      'discoverNextFavorite': 'Descubre tu próxima canción favorita',
      'noSongsFound': 'No se encontraron canciones',
      'tryAdjustingSearch': 'Intenta ajustar tu búsqueda o filtros',
      
      // Profile
      'settings': 'Configuración',
      'appPreferences': 'Preferencias y configuración de la app',
      'helpSupport': 'Ayuda y Soporte',
      'getHelpContact': 'Obtén ayuda y contacta soporte',
      'about': 'Acerca de',
      'appVersionInfo': 'Versión e información de la app',
      'signOut': 'Cerrar Sesión',
      'signOutAccount': 'Cerrar sesión de tu cuenta',
      'favorites': 'Favoritos',
      'downloads': 'Descargas',
      'areYouSureSignOut': '¿Estás seguro de que quieres cerrar sesión?',
      'cancel': 'Cancelar',
      
      // Downloads
      'songDownloadedSuccessfully': 'Canción descargada exitosamente',
      'downloadError': 'Error de descarga',
      'retry': 'Reintentar',
      'connectionError': 'Error de conexión. Verifica tu conexión a internet.',
      'timeoutError': 'Tiempo de espera agotado. Intenta de nuevo.',
      'downloadErrorGeneric': 'Error al descargar la canción',
      'storagePermissionDenied': 'Permisos de almacenamiento denegados. Por favor, habilita los permisos en la configuración de la app.',
      'invalidAudioUrl': 'URL de audio no válida',
      'permissionRequired': 'Permiso Requerido',
      'permissionExplanation': 'Esta aplicación necesita permiso de almacenamiento para descargar canciones. Por favor, otorga el permiso en la configuración de tu dispositivo.',
      'openSettings': 'Abrir Configuración',
      'storagePermission': 'Permiso de Almacenamiento',
      'permissionRequestExplanation': 'Para descargar canciones, necesitamos acceso al almacenamiento de tu dispositivo. Esto te permite guardar música para escuchar sin conexión.',
      'whyWeNeedPermission': '¿Por qué necesitamos esto?',
      'permissionBenefits': '• Descargar canciones para escuchar sin conexión\n• Acceder a tu biblioteca de música\n• Ahorrar espacio de almacenamiento con descargas eficientes',
      'grantPermission': 'Otorgar Permiso',
      'notNow': 'Ahora No',
      
      // Settings
      'language': 'Idioma',
      'languageSettings': 'Configuración de Idioma',
      'selectLanguage': 'Seleccionar Idioma',
      'spanish': 'Español',
      'english': 'Inglés',
      'languageChanged': 'Idioma cambiado exitosamente',
      
      // General
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'warning': 'Advertencia',
      'info': 'Información',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 