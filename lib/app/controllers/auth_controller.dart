import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:social_login_demo/app/data/services/authService/auth_service.dart';
import 'package:social_login_demo/app/ui/widgets/custom_snack_bar.dart';
import 'package:social_login_demo/app/utils/helpers/exception/exception.dart';
import 'package:social_login_demo/app/utils/helpers/injectable/injectable.dart';
import 'package:social_login_demo/app/utils/helpers/loading.dart';
import 'package:social_login_demo/app/utils/helpers/logger.dart';

@i.lazySingleton
class AuthController extends GetxController {
  AuthController() {
    onInit();
  }

  @override
  @i.disposeMethod
  void dispose() {
    super.dispose();
  }

  Future<void> onContinueWithGoogle() async {
    final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

    Loading.show();
    GoogleSignInAccount? authData;
    try {
      await googleSignIn.signOut();
      authData = await googleSignIn.signInSilently();
      authData ??= await googleSignIn.signIn();
    } catch (e) {
      e.log;
      Loading.dismiss();
    }

    if (authData == null) {
      Loading.dismiss();
      return;
    }

    authData;

    await getIt<AuthService>()
        .isRegister(
          email: authData.email,
          name: authData.displayName ?? '',
          // deviceToken: 'No found',
          // deviceType: switch (Platform.operatingSystem) {
          //   'ios' => 'iOS',
          //   'android' => 'android',
          //   _ => 'Other',
          // },
          isSocialType: 'google',
          // googleId: authData.id,
        )
        .handler(
          null,
          onSuccess: (value) {
            googleSignIn.signOut();
            value.showToast();
          },
          onFailed: (value) {
            value.showToast();
          },
        );
  }

  Future<void> onContinueWithApple() async {
    final isAvailable = await SignInWithApple.isAvailable();
    if (!isAvailable) {
      Get.showSnackbar(AppSnackBar(message: 'Apple Sign-In not available on this device'));
      return;
    }

    try {
      final rawNonce = _generateNonce();
      final hashedNonce = sha256ofString(rawNonce);

      final authData = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.kmtemp.social.login.service', // Apple Service ID
          redirectUri: Uri.parse('https://flutterfire-23423.firebaseapp.com/__/auth/handler'),
        ),
        nonce: hashedNonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(idToken: authData.identityToken, accessToken: authData.authorizationCode, rawNonce: rawNonce);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        await getIt<AuthService>()
            .isRegister(email: userCredential.user?.email ?? '', name: userCredential.user?.displayName ?? '', isSocialType: 'apple')
            .handler(null, onSuccess: (value) => value.showToast(), onFailed: (value) => value.showToast());
      }
    } catch (e) {
      Get.showSnackbar(AppSnackBar(message: 'Unexpected error: $e'));
    }
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  bool? signInWIthAppleAvailable;

  Future<void> printFacebookKeyHash() async {
    try {
      const platform = MethodChannel("com.facebook.sdk/keyhash");
      final keyHash = await platform.invokeMethod<String>("printKeyHash");
      "Facebook KeyHash: $keyHash".log;
    } catch (e) {
      "Error getting key hash: $e".log;
    }
  }

  Future<void> onFacebook() async {
    try {
      Loading.show();

      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          await getIt<AuthService>()
              .isRegister(email: userCredential.user?.email ?? '', name: userCredential.user?.displayName ?? '', isSocialType: 'facebook')
              .handler(null, onSuccess: (value) => value.showToast(), onFailed: (value) => value.showToast());
        }
      } else if (loginResult.status == LoginStatus.cancelled) {
        Get.showSnackbar(AppSnackBar(message: 'Facebook login was cancelled.'));
      } else {
        Get.showSnackbar(AppSnackBar(message: loginResult.message ?? 'Facebook login failed.'));
      }
    } catch (e) {
      Get.showSnackbar(AppSnackBar(message: 'Unexpected error: $e'));
    } finally {
      Loading.dismiss();
    }
  }
}