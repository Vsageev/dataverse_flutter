import 'dart:io';

import 'package:dataverse_sample/keys.dart';
import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:dataverse_sample/shared/api_models/response_model.dart';
import 'package:dataverse_sample/pages/main/states/accounts_loaded.dart';
import 'package:dataverse_sample/pages/main/states/accounts_loading.dart';
import 'package:dataverse_sample/pages/main/states/accounts_state.dart';
import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MainCubit extends Cubit<AccountsState> {
  MainCubit(this.apiToken) : super(AccountsLoading()) {
    getAllAccounts();
  }

  String apiToken;

  getAllAccounts() async {
    try {
      var rez = await http.get(
        Uri.parse(
            'https://${appUrl}/api/data/v9.1/accounts?\$select=name,accountnumber,statecode,address1_stateorprovince'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': apiToken
        },
      );

      if (rez.statusCode == 200) {
        var accounts = ResponseModel.fromJson(rez.body).value;
        emit(AccountsLoaded(accounts: accounts));
      }
    } catch (e) {
      print(e);
    }
  }

  searchAccounts(
      {String? searchStr,
      StateCode? stateCode,
      String? stateOrProvince}) async {
    emit(AccountsLoading());
    try {
      String params = "";
      if (searchStr != null) {
        params +=
            "(contains(name,'${searchStr}') or contains(accountnumber,'${searchStr}'))";
      }
      if (stateCode != null) {
        if (params != "") {
          params += " and ";
        }
        params += "(statecode eq ${stateCode.index.toString()})";
      }
      if (stateOrProvince != null) {
        if (params != "") {
          params += " and ";
        }
        params += "(address1_stateorprovince eq '${stateOrProvince}')";
      }

      String uri =
          'https://${appUrl}/api/data/v9.1/accounts?\$select=name,accountnumber,statecode,address1_stateorprovince' +
              (params == "" ? "" : "&\$filter=" + params);

      print(uri);
      var rez = await http.get(
        Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': apiToken
        },
      );

      if (rez.statusCode == 200) {
        var accounts = ResponseModel.fromJson(rez.body).value;
        emit(AccountsLoaded(accounts: accounts));
      } else {
        print("error getting result");
        emit(AccountsLoaded(accounts: []));
      }
    } catch (e) {
      print(e);
    }
  }
}
