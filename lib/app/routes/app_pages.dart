import 'package:get/get.dart';
import 'package:social_login_demo/app/routes/app_routes.dart';
import 'package:social_login_demo/app/ui/pages/social_login_page.dart';
import 'package:social_login_demo/app/ui/pages/splash_page.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.socialLogin, page: () => const SocialLoginPage()),
  ];
}
