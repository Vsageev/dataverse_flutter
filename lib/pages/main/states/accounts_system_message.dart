import 'package:dataverse_sample/pages/main/states/accounts_state.dart';

class AccountsSystemMessage extends AccountsState {
  String message;
  AccountsSystemMessage({
    required this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
