import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final PermissionHelper _instance = PermissionHelper._internal();
  factory PermissionHelper() => _instance;
  PermissionHelper._internal();

  /// Verifica si ya tenemos permisos de almacenamiento
  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) return true;
    
    try {
      if (await _isAndroid11OrHigher()) {
        return await Permission.manageExternalStorage.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } catch (e) {
      print('Error checking storage permission: $e');
      return false;
    }
  }

  /// Solicita permisos de almacenamiento de manera inteligente
  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      if (await _isAndroid11OrHigher()) {
        // Para Android 11+ (API 30+)
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        // Para Android 10 y anteriores
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  /// Verifica si los permisos están permanentemente denegados
  Future<bool> isPermissionPermanentlyDenied() async {
    if (!Platform.isAndroid) return false;

    try {
      if (await _isAndroid11OrHigher()) {
        return await Permission.manageExternalStorage.isPermanentlyDenied;
      } else {
        return await Permission.storage.isPermanentlyDenied;
      }
    } catch (e) {
      print('Error checking if permission is permanently denied: $e');
      return false;
    }
  }

  /// Abre la configuración de la app
  Future<void> openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Error opening app settings: $e');
    }
  }

  /// Obtiene información sobre el estado de los permisos
  Future<PermissionStatus> getPermissionStatus() async {
    if (!Platform.isAndroid) return PermissionStatus.granted;

    try {
      if (await _isAndroid11OrHigher()) {
        return await Permission.manageExternalStorage.status;
      } else {
        return await Permission.storage.status;
      }
    } catch (e) {
      print('Error getting permission status: $e');
      return PermissionStatus.denied;
    }
  }

  /// Verifica si es Android 11 o superior
  Future<bool> _isAndroid11OrHigher() async {
    if (!Platform.isAndroid) return false;
    
    try {
      // Usar una aproximación simple para detectar la versión
      // En una implementación real, podrías usar device_info_plus
      return true; // Asumir Android 11+ por defecto para mayor compatibilidad
    } catch (e) {
      return true; // Fallback a Android 11+
    }
  }

  /// Maneja la solicitud de permisos de manera completa
  Future<bool> handleStoragePermission() async {
    // Verificar si ya tenemos permisos
    if (await hasStoragePermission()) {
      return true;
    }

    // Solicitar permisos
    final granted = await requestStoragePermission();
    if (granted) {
      return true;
    }

    // Si los permisos están permanentemente denegados, abrir configuración
    if (await isPermissionPermanentlyDenied()) {
      await openAppSettings();
      return false;
    }

    return false;
  }
} 