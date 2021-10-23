import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:dataverse_sample/pages/main/states/accounts_state.dart';

class AccountsLoaded extends AccountsState {
  List<AccountModel> accounts;
  AccountsLoaded({
    required this.accounts,
  });
}
