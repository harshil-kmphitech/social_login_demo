import 'package:get/get.dart';
import 'package:social_login_demo/l10n/app_localizations.dart';

class AppStrings {
  AppStrings._();
  static AppLocalizations get T => AppLocalizations.of(Get.context!)!;

  /// Use other temporary string here.
  /// Make sure your string is defined same as this.
  static String hello = 'Hello world';
}
