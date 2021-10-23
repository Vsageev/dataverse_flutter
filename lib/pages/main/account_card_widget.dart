import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';

class AccountCardWidget extends StatelessWidget {
  const AccountCardWidget({Key? key, required this.account}) : super(key: key);

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            account.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
