import 'dart:convert';

import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';
import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
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

  AccountModel copyWith(
      {String? name,
      String? accountnumber,
      String? address1_stateorprovince,
      StateCode? statecode}) {
    return AccountModel(
      name: name ?? this.name,
      accountnumber: accountnumber??this.accountnumber,
      address1_stateorprovince: address1_stateorprovince??this.address1_stateorprovince,
      statecode: statecode??this.statecode,
    );
  }

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

  @override
  List<Object?> get props =>
      [name, accountnumber, address1_stateorprovince, statecode];
}
