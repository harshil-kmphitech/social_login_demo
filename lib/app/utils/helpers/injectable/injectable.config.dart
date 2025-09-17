// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_core/firebase_core.dart' as _i982;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:social_login_demo/app/controllers/app_controller.dart' as _i111;
import 'package:social_login_demo/app/controllers/auth_controller.dart'
    as _i270;
import 'package:social_login_demo/app/data/services/authService/auth_service.dart'
    as _i625;
import 'package:social_login_demo/app/data/services/refreshToken/refresh_token_service.dart'
    as _i860;
import 'package:social_login_demo/app/utils/helpers/injectable%20properties/injectable_properties.dart'
    as _i285;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.pref(),
      preResolve: true,
    );
    await gh.factoryAsync<_i982.FirebaseApp>(
      () => registerModule.initializeFireBase(),
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i111.AppController>(() => _i111.AppController());
    gh.lazySingleton<_i270.AuthController>(
      () => _i270.AuthController(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i860.RefreshTokenService>(
      () => _i860.RefreshTokenService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i625.AuthService>(
      () => _i625.AuthService(gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i285.RegisterModule {}
