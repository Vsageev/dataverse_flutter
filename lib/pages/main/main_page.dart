import 'package:dataverse_sample/pages/main/account_card_widget.dart';
import 'package:dataverse_sample/pages/main/account_list_widget.dart';
import 'package:dataverse_sample/pages/main/main_cubit.dart';
import 'package:dataverse_sample/pages/main/states/accounts_loaded.dart';
import 'package:dataverse_sample/pages/main/states/accounts_state.dart';
import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';
import 'package:dataverse_sample/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ViewType viewType = ViewType.list;
  bool showFilters = false;
  StateCode? stateCode;
  String? stateOrProvince;
  List<String> stateOrProvinceList = const ["TX", "TN", "KA", "WA", "CA"];
  TextEditingController findText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, AccountsState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: backrgound,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              optionsWidget(context, state),
              Expanded(
                child: accountsList(context, state),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget optionsWidget(BuildContext context, AccountsState state) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                BlocProvider.of<MainCubit>(context).searchAccounts(
                  stateCode: stateCode,
                  searchStr: findText.text == "" ? null : findText.text,
                  stateOrProvince: stateOrProvince,
                );
              },
              icon: const Icon(Icons.search),
            ),
            Expanded(
              child: TextField(
                controller: findText,
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  showFilters = !showFilters;
                });
              },
              icon: Icon(showFilters ? Icons.close : Icons.filter_alt),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  viewType = ViewType.list;
                });
              },
              icon: const Icon(Icons.list),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  viewType = ViewType.card;
                });
              },
              icon: const Icon(Icons.view_module),
            ),
          ],
        ),
        if (showFilters)
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: filters(context, state)),
        Container(height: 10),
      ],
    );
  }

  Widget accountsList(BuildContext context, AccountsState state) {
    if (state is AccountsLoaded) {
      if (viewType == ViewType.list) {
        return ListView.builder(
          itemCount: state.accounts.length,
          itemBuilder: (context, i) {
            return AccoluntListWidget(
              account: state.accounts[i],
            );
          },
        );
      }
      if (viewType == ViewType.card) {
        return GridView.builder(
          itemCount: state.accounts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2,
          ),
          itemBuilder: (BuildContext context, int i) {
            return AccountCardWidget(
              account: state.accounts[i],
            );
          },
        );
      }
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget filters(BuildContext context, AccountsState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' state',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(height: 10),
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<StateCode?>(
                          value: null,
                          groupValue: stateCode,
                          onChanged: (StateCode? value) {
                            setState(() {
                              stateCode = value;
                            });
                          },
                        ),
                        const Text(
                          'no filters',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<StateCode?>(
                          value: StateCode.Active,
                          groupValue: stateCode,
                          onChanged: (StateCode? value) {
                            setState(() {
                              stateCode = value;
                            });
                          },
                        ),
                        const Text(
                          'active',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<StateCode?>(
                          value: StateCode.Inactive,
                          groupValue: stateCode,
                          onChanged: (StateCode? value) {
                            setState(() {
                              stateCode = value;
                            });
                          },
                        ),
                        const Text(
                          'inactive',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' state or province',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(height: 10),
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String?>(
                          value: null,
                          groupValue: stateOrProvince,
                          onChanged: (String? value) {
                            setState(() {
                              stateOrProvince = value;
                            });
                          },
                        ),
                        const Text(
                          'no filters',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...stateOrProvinceList.map(
                    (e) => Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String?>(
                            value: e,
                            groupValue: stateOrProvince,
                            onChanged: (String? value) {
                              setState(() {
                                stateOrProvince = value;
                              });
                            },
                          ),
                          Text(
                            e,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

enum ViewType {
  list,
  card,
}
