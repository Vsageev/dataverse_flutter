import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:dataverse_sample/pages/error/error_page.dart';
import 'package:dataverse_sample/pages/main/account_card_widget.dart';
import 'package:dataverse_sample/pages/main/account_list_widget.dart';
import 'package:dataverse_sample/pages/main/main_cubit.dart';
import 'package:dataverse_sample/pages/main/main_page.dart';
import 'package:dataverse_sample/pages/main/states/accounts_system_message.dart';
import 'package:dataverse_sample/pages/main/states/accounts_loaded.dart';
import 'package:dataverse_sample/pages/main/states/accounts_loading.dart';
import 'package:dataverse_sample/pages/main/states/accounts_state.dart';
import 'package:dataverse_sample/shared/api_models/account_model.dart';
import 'package:dataverse_sample/shared/api_models/state_code_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dataverse_sample/main.dart';
import 'package:mocktail/mocktail.dart';

class MockMainCubit extends MockCubit<AccountsState> implements MainCubit {}

void main() {
  group('ui from cubit state tests', () {
    late MainCubit mockMainCubit;

    setUp(() {
      registerFallbackValue(
          AccountsSystemMessage(message: "this is a fallback value"));
      mockMainCubit = MockMainCubit();
    });

    testWidgets('loading indicator shown when loading state',
        (WidgetTester tester) async {
      whenListen(
        mockMainCubit,
        Stream.fromIterable([AccountsLoading()]),
        initialState: AccountsLoading(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockMainCubit,
            child: const MainPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('message shown when SystemMessage',
        (WidgetTester tester) async {
      whenListen(
        mockMainCubit,
        Stream.fromIterable([AccountsSystemMessage(message: 'some ERROR')]),
        initialState: AccountsSystemMessage(message: 'some ERROR'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockMainCubit,
            child: const MainPage(),
          ),
        ),
      );

      expect(find.text('some ERROR'), findsOneWidget);
    });

    testWidgets('ListView with account shown when AccountsLoaded',
        (WidgetTester tester) async {
      AccountModel testAccount = AccountModel(
          name: 'Steve',
          accountnumber: 'asdf',
          address1_stateorprovince: 'TX',
          statecode: StateCode.Inactive);

      whenListen(
        mockMainCubit,
        Stream.fromIterable(
          [
            AccountsLoaded(accounts: [testAccount])
          ],
        ),
        initialState: AccountsLoaded(accounts: [testAccount]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockMainCubit,
            child: const MainPage(),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Steve'), findsOneWidget);
      expect(find.text('account number: asdf'), findsOneWidget);
      expect(find.text('state or province: TX'), findsOneWidget);
      expect(find.text('state: ' + StateCode.Inactive.name()), findsOneWidget);
    });

    testWidgets(
        'GridView with account shown when AccountsLoaded and switched to cards',
        (WidgetTester tester) async {
      AccountModel testAccount = AccountModel(
          name: 'tst1',
          accountnumber: 'asdf',
          address1_stateorprovince: 'TX',
          statecode: StateCode.Inactive);

      whenListen(
        mockMainCubit,
        Stream.fromIterable(
          [
            AccountsLoaded(accounts: [
              testAccount,
              testAccount.copyWith(name: 'tst2'),
              testAccount.copyWith(name: 'tst3'),
              testAccount.copyWith(name: 'tst4'),
            ])
          ],
        ),
        initialState: AccountsLoaded(accounts: [
          testAccount,
          testAccount.copyWith(name: 'tst2'),
          testAccount.copyWith(name: 'tst3'),
          testAccount.copyWith(name: 'tst4'),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockMainCubit,
            child: const MainPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.view_module));
      await tester.pump();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(AccountCardWidget), findsNWidgets(4));
      expect(find.text('tst1'), findsOneWidget);
      expect(find.text('account number: asdf'), findsNothing);
      expect(find.text('tst2'), findsOneWidget);
      expect(find.text('tst3'), findsOneWidget);
      expect(find.text('tst4'), findsOneWidget);
    });
  });

  group('ui fron inner state tests', () {
    late MainCubit cubit;

    setUp(() {
      cubit = MainCubit('abc');
    });

    testWidgets('filters showing flips correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const MainPage(),
          ),
        ),
      );

      expect(find.byType(Wrap), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);

      await tester.tap(find.byIcon(Icons.filter_alt));
      await tester.pump();

      expect(find.byType(Wrap), findsNWidgets(2));
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt), findsNothing);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.byType(Wrap), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byIcon(Icons.filter_alt), findsOneWidget);
    });
  });
  group('ui state changes on interaction', () {
    late MainCubit mockMainCubit;

    setUp(() {
      registerFallbackValue(
          AccountsSystemMessage(message: "this is a fallback value"));
      mockMainCubit = MockMainCubit();
      whenListen(
        mockMainCubit,
        Stream.fromIterable([AccountsLoading()]),
        initialState: AccountsLoading(),
      );
    });

    testWidgets('no info when nothing selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockMainCubit,
            child: const MainPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      verify(() => mockMainCubit.searchAccounts());
    });

    testWidgets('info chosen correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockMainCubit,
            child: const MainPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_alt));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'smstr');
      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is Radio<StateCode?> && widget.value == StateCode.Active));
      await tester.tap(find.byWidgetPredicate(
          (widget) => widget is Radio<String?> && widget.value == "TX"));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      verify(() => mockMainCubit.searchAccounts(
          searchStr: 'smstr',
          stateCode: StateCode.Active,
          stateOrProvince: "TX"));
    });
  });
}
