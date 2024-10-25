// auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

import '../route/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user.bindStream(_auth.authStateChanges());
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;

      // Clear browser session storage
      html.window.sessionStorage.clear();
      html.window.localStorage.clear();

      // Clear cookies jika menggunakan
      _clearCookies();

      // Sign out dari Firebase
      await _auth.signOut();

      // Sign out dari Google jika menggunakan Google Sign In
      // await GoogleAuthProvider().signOut();

      // Redirect ke login page dengan replace state
      // Ini mencegah user kembali ke halaman sebelumnya dengan tombol back
      router.replaceNamed('login');

      Get.snackbar(
        'Success',
        'You have been signed out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error signing out: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _clearCookies() {
    final List<String> cookies = html.document.cookie?.split(';') ?? <String>[];
    for (final String cookie in cookies) {
      final String cookieName = cookie.split('=')[0].trim();
      html.document.cookie = '$cookieName=; Max-Age=0; path=/;';
    }
  }
}

// web_storage_service.dart
class WebStorageService extends GetxService {
  Future<void> clearStorage() async {
    html.window.localStorage.clear();
    html.window.sessionStorage.clear();
  }

  Future<void> clearSpecificData(String key) async {
    html.window.localStorage.remove(key);
    html.window.sessionStorage.remove(key);
  }
}
