import 'package:json_annotation/json_annotation.dart';

part 'courier_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CourierModel {
  final int id;
  final String name;
  final String? photo;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? gender;
  final int online;
  final String deliveryMethod;
  final String? cachedAverageRating;

  CourierModel(
      this.id,
      this.name,
      this.photo,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.gender,
      this.online,
      this.deliveryMethod,
      this.cachedAverageRating);

  factory CourierModel.fromJson(Map<String, dynamic> json) =>
      _$CourierModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourierModelToJson(this);
}
