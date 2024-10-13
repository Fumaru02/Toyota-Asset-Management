import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helpers/regex.dart';
import '../helpers/snackbar.dart';
import '../route/app_routes.dart';
import '../utils/enums.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final RxBool isObscurePassword = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TapGestureRecognizer privacyPolicyRecognizer = TapGestureRecognizer();
  final FocusNode fullnameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final RxBool isValidated = false.obs;
  final RxBool isValidatedFullname = false.obs;

  final RxBool isLoading = false.obs;
  final RxBool isTappedSignUp = false.obs;

  final RxDouble angle = RxDouble(0);

  void get context {}

  dynamic changeForm() {
    isTappedSignUp.value = !isTappedSignUp.value;
    update();
  }

  dynamic validateFullName(String fullname) {
    if (RegexHelper.fullname.hasMatch(fullname)) {
      isValidatedFullname.value = true;
    } else {
      isValidatedFullname.value = false;
    }
    update();
  }

  dynamic validateEmail(String email) {
    if (RegexHelper.emailType.hasMatch(email)) {
      isValidated.value = true;
    } else {
      isValidated.value = false;
    }
    update();
  }

  //Sign Up FORM

  dynamic clearTextController() {
    emailController.clear();
    fullNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> signInWithGoogle() async {
    Future<dynamic>.delayed(const Duration(milliseconds: 200));
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      // sharedPref.writeAccessToken(googleAuth!.accessToken!);
      final UserCredential userCreds =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCreds.user;
      if (userCreds.user != null) {
        final CollectionReference<dynamic> users =
            _firestore.collection('users');
        if (userCreds.additionalUserInfo!.isNewUser) {
          await users.doc(user!.uid).set(<String, dynamic>{
            'user_uid': user.uid,
            'creation_time': user.metadata.creationTime!.toIso8601String(),
            'last_sign_in_time':
                user.metadata.lastSignInTime!.toIso8601String(),
            'email': user.email,
            'role': 'guest',
            'key_name': user.displayName!.substring(0, 1).toUpperCase(),
            'username': fullNameController.text.trim(),
            'user_image': user.photoURL,
          });
        } else {
          await users
              .doc(fullNameController.text.trim())
              .update(<Object, Object?>{
            'last_sign_in_time':
                user!.metadata.lastSignInTime!.toIso8601String(),
          });
        }

        router.goNamed('dashboard');
      } else {
        Snack.show(SnackbarType.error, 'invalid email',
            'Email tidak dapat ditemukan coba lagi');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> signUpWithEmailAndPassword() async {
    if (confirmPasswordController.text != passwordController.text) {
      Snack.show(SnackbarType.error, 'Information',
          'Your password is not matched try again');
      return false;
    } else if (passwordController.text.length < 6) {
      Snack.show(SnackbarType.error, 'Information',
          'Your password too weak try again');
      return false;
    }
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      await credential.user?.sendEmailVerification();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(
        <String, dynamic>{
          'user_uid': credential.user!.uid,
          'username': fullNameController.text,
          'email': emailController.text,
          'role': 'guest',
          'user_image': '',
          'key_name': fullNameController.text.substring(0, 1).toUpperCase(),
          'creation_time':
              credential.user!.metadata.creationTime!.toIso8601String(),
        },
      );
      isTappedSignUp.value = false;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Snack.show(SnackbarType.error, 'Error', 'weak password try again');
      } else if (e.code == 'email-already-in-use') {
        Snack.show(SnackbarType.info, 'Information',
            '${emailController.text} is already exists');
      } else if (e.code == 'invalid-email') {
        Snack.show(
            SnackbarType.error, 'Information', 'Your email id is invalid');
      }
    }
    return false;
  }

  // Rx<UsersModel> userModel = UsersModel().obs;

//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     tabController = TabController(length: 2, vsync: this);

//     await Future<dynamic>.delayed(
//         const Duration(seconds: 2)); // Menunggu selama 2 detik
//     isFloating.value = true; // Mengubah nilai menjadi true setelah 2 detik
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     privacyPolicyRecognizer.dispose();
//   }

//   void flipped() {
//     angle.value = (angle + math.pi) % (2 * math.pi);
//     update();
//   }

//   Future<void> getUserToken() async {
//     final String? token = await _auth.currentUser?.getIdToken();
//     sharedPref.writeAccessToken(token!);
//   }

//   Future<void> signInWithGoogle() async {
//     Future<dynamic>.delayed(const Duration(milliseconds: 200));
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       final OAuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
//       sharedPref.writeAccessToken(googleAuth!.accessToken!);
//       final UserCredential userCreds =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       final User? user = userCreds.user;
//       if (userCreds.user != null) {
//         isTapped.value = true;
//         final CollectionReference<dynamic> users =
//             _firestore.collection('users');
//         if (userCreds.additionalUserInfo!.isNewUser) {
//           await users.doc(user!.uid).set(<String, dynamic>{
//             'user_uid': user.uid,
//             'update_time': DateTime.now().toIso8601String(),
//             'creation_time': user.metadata.creationTime!.toIso8601String(),
//             'last_sign_in_time':
//                 user.metadata.lastSignInTime!.toIso8601String(),
//             'email': user.email,
//             'status': 'User',
//             'key_name': user.displayName!.substring(0, 1).toUpperCase(),
//             'username': user.displayName,
//             'user_image': user.photoURL,
//             'description': '',
//             'gender': '',
//             'profiency': '',
//             'city': '',
//             'subdistrict': '',
//           });

//           users.doc(user.uid).collection('chats');
//         } else {
//           await users.doc(user!.uid).update(<Object, Object?>{
//             'last_sign_in_time':
//                 user.metadata.lastSignInTime!.toIso8601String(),
//           });
//         }

//         final DocumentSnapshot<Object?> currUser =
//             await users.doc(user.uid).get();
//         final Map<String, dynamic> currUserData =
//             currUser.data()! as Map<String, dynamic>;

//         userModel(UsersModel.fromJson(currUserData));

//         userModel.refresh();

//         final QuerySnapshot<Map<String, dynamic>> listChats =
//             await users.doc(user.uid).collection('chats').get();

//         // ignore: prefer_is_empty
//         if (listChats.docs.length != 0) {
//           final List<ChatUser> dataListChat = <ChatUser>[];
//           // ignore: avoid_function_literals_in_foreach_calls
//           listChats.docs.forEach(
//             (QueryDocumentSnapshot<Map<String, dynamic>> element) {
//               final Map<String, dynamic> dataDocChat = element.data();
//               final String dataDocChatId = element.id;
//               dataListChat.add(ChatUser(
//                   chatId: dataDocChatId,
//                   connection: dataDocChat['connection'] as String?,
//                   lastTime: dataDocChat['last_time'] as String?,
//                   totalUnread: dataDocChat['total_unread'] as int?));
//             },
//           );
//           userModel.update((UsersModel? user) {
//             user!.chats = dataListChat;
//           });
//         } else {
//           userModel.update((UsersModel? user) {
//             user!.chats = <ChatUser>[];
//           });
//         }
//         userModel.refresh();

//         isTapped.value = false;
//         Get.offAllNamed('/frame');
//       } else {
//         Snack.show(SnackbarType.error, 'invalid email',
//             'Email tidak dapat ditemukan coba lagi');
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   Future<bool> resetPassword() async {
//     try {
//       await _auth.sendPasswordResetEmail(email: emailController.text.trim());
//       return true;
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'invalid-email':
//           Snack.show(SnackbarType.error, 'invalid email',
//               'Email tidak dapat ditemukan coba lagi');
//           break;
//         case 'user-not-found':
//           Snack.show(SnackbarType.error, 'Unknown email',
//               'Akun tidak dapat ditemukan coba lagi/password salah');
//           break;
//         default:
//           Snack.show(SnackbarType.error, 'Error',
//               'Something error please try again later');
//       }
//       return false;
//     }
//   }

  dynamic signInWithEmailAndPassword() async {
    try {
      isLoading.value = true;
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (!credential.user!.emailVerified) {
        Snack.show(SnackbarType.error, 'Email Verification',
            'Email kamu belum terverifikasi mohon check inbox/spam');
        isLoading.value = false;
        return;
      }
      if (credential.user == null) {
        Snack.show(SnackbarType.error, 'Email Verification',
            'Email kamu belum terverifikasi mohon check inbox/spam');
        isLoading.value = false;
        return;
      }

      isLoading.value = false;
      router.goNamed('dashboard');

      return credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          Snack.show(SnackbarType.error, 'invalid email',
              'Email tidak dapat ditemukan coba lagi');
          isLoading.value = false;
          break;
        case 'invalid-credential':
          Snack.show(SnackbarType.error, 'wrong email/password',
              'Email/Password salah coba lagi');
          isLoading.value = false;
          break;
        case 'user-not-found':
          Snack.show(SnackbarType.error, 'Unknown email',
              'Akun tidak dapat ditemukan coba lagi/password salah');
          isLoading.value = false;
          break;
        case 'ERROR_USER_DISABLED':
          Snack.show(SnackbarType.error, 'Error User',
              'Akunmu dihentikan untuk sementara waktu');
          isLoading.value = false;
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          Snack.show(
              SnackbarType.error, 'Error', 'Too many request try again later');
          isLoading.value = false;
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          Snack.show(SnackbarType.error, 'Unknown user', 'Operasi dihentikan');
          isLoading.value = false;
          break;
        default:
          Snack.show(SnackbarType.error, 'Error',
              'Something error please try again later');
          isLoading.value = false;
          return null;
      }
    }
  }
}
