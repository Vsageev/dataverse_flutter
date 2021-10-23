import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';

class AccoluntListWidget extends StatelessWidget {
  const AccoluntListWidget({Key? key, required this.account}) : super(key: key);

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          Text(
            account.name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Container(height: 13),
          Text(
            "account number: " + account.accountnumber.toString(),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Text(
            "state: " + account.statecode.name(),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Text(
            "state or province: " + account.address1_stateorprovince.toString(),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
