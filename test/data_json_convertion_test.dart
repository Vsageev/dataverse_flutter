import 'package:dataverse_sample/pages/main/account_list_widget.dart';
import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:dataverse_sample/shared/api_models/response_model.dart';
import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('account converts from json', () async {
    String json =
        r'{"@odata.etag":"W/\"838385\"","name":"Fourth Coffee (sample)","accountnumber":"ABSS4G45","statecode":0,"address1_stateorprovince":"TX","accountid":"fa8e8527-a428-ec11-b6e5-000d3a2ca39e","address1_composite":"TX"}';
    AccountModel rez = AccountModel.fromJson(json);
    AccountModel expexted = AccountModel(
        name: "Fourth Coffee (sample)",
        accountnumber: "ABSS4G45",
        address1_stateorprovince: "TX",
        statecode: StateCode.Active);
    expect(rez, expexted);
  });

  test('accounts response converts from json', () async {
    String json =
        r'{"@odata.context":"https://orgEXAMPLE.api.crm4.dynamics.com/api/data/v9.1/$metadata#accounts(name,accountnumber,statecode,address1_stateorprovince)","value":[{"@odata.etag":"W/\"838385\"","name":"Fourth Coffee (sample)","accountnumber":"ABSS4G45","statecode":0,"address1_stateorprovince":"TX","accountid":"fa8e8527-a428-ec11-b6e5-000d3a2ca39e","address1_composite":"TX"}]}';

    ResponseModel rez = ResponseModel.fromJson(json);
    ResponseModel expected = ResponseModel(
      value: [
        AccountModel(
            name: "Fourth Coffee (sample)",
            accountnumber: "ABSS4G45",
            address1_stateorprovince: "TX",
            statecode: StateCode.Active)
      ],
    );
    expect(rez, expected);
  });
}
