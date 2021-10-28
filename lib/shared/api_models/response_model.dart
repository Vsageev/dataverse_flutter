import 'dart:convert';

import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:equatable/equatable.dart';

class ResponseModel extends Equatable {
  List<AccountModel> value;
  ResponseModel({
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value.map((x) => x.toMap()).toList(),
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      value: List<AccountModel>.from(
          map['value']?.map((x) => AccountModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) =>
      ResponseModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [value];
}
