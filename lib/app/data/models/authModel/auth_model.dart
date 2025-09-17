// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:social_login_demo/app/data/models/apiResponse/api_response.dart';

part 'auth_model.g.dart';

RefreshTokenResponse deserializeRefreshTokenResponse(Map<String, dynamic> json) =>
    RefreshTokenResponse.fromJson(json);

@JsonSerializable()
class RefreshTokenResponse extends ApiResponse {
  const RefreshTokenResponse({
    required super.statusCode,
    required super.isSuccess,
    required super.message,
    required this.data,
  });

  final Map<String, dynamic> data;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}
