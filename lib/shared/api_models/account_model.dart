import 'dart:convert';

import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';

class AccountModel {
  String name;
  String? accountnumber;
  String? address1_stateorprovince;
  StateCode statecode;
  AccountModel({
    required this.name,
    required this.accountnumber,
    required this.address1_stateorprovince,
    required this.statecode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accountnumber': accountnumber,
      'address1_stateorprovince': address1_stateorprovince,
      'statecode': statecode.index,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      name: map['name'],
      accountnumber: map['accountnumber'],
      address1_stateorprovince: map['address1_stateorprovince'],
      statecode: StateCode.values[map['statecode']],
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountModel.fromJson(String source) =>
      AccountModel.fromMap(json.decode(source));
}
