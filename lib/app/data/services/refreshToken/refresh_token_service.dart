import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:social_login_demo/app/data/models/authModel/auth_model.dart';
import 'package:social_login_demo/app/global/app_config.dart';

part 'refresh_token_service.g.dart';

@RestApi(parser: Parser.FlutterCompute, baseUrl: AppConfig.baseUrl)
@lazySingleton
// ignore: one_member_abstracts
abstract class RefreshTokenService {
  @factoryMethod
  factory RefreshTokenService(Dio dio) = _RefreshTokenService;

  @POST(EndPoints.refreshToken)
  Future<RefreshTokenResponse> refreshToken(@Field('user_id') String userId);
}
