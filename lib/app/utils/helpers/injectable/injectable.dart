import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:social_login_demo/app/utils/helpers/Interceptor/token_interceptor.dart';
import 'package:social_login_demo/app/utils/helpers/injectable/injectable.config.dart';
import 'package:social_login_demo/app/utils/helpers/loading.dart';

final getIt = GetIt.instance;

@i.injectableInit
void configuration({required Widget myApp}) {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await getIt.init();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      Loading().configLoading();

      getIt<Dio>().interceptors.addAll([
        RefreshTokenInterceptor(),
        if (kDebugMode) PrettyDioLogger(requestBody: true),
      ]);

      runApp(myApp);
    },
    (error, stackTrace) => FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true),
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (
        Zone zone,
        ZoneDelegate delegate,
        Zone parent,
        Object error,
        StackTrace stackTrace,
      ) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      },
    ),
  );
}
