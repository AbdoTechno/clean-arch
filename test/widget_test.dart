import 'package:clean_arch/app.dart';
import 'package:clean_arch/core/errors/failure.dart';
import 'package:clean_arch/features/user/presentation/cubit/user_cubit.dart';
import 'package:clean_arch/features/user/presentation/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestUserCubit extends UserCubit {
  final List<int> requests = [];

  @override
  Future<void> eitherFailureOrUser(int userId) async {
    requests.add(userId);
    emit(UserLoading());
  }

  void fail() => emit(UserError(failure: Failure(errMessage: 'No connection')));
}

void main() {
  testWidgets('App opens the profile search instead of the counter', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Meet someone new'), findsOneWidget);
    expect(find.text('Find profile'), findsOneWidget);
  });

  testWidgets('Validates IDs, displays loading and retries failed searches', (
    tester,
  ) async {
    final cubit = TestUserCubit();
    addTearDown(cubit.close);
    await tester.pumpWidget(MaterialApp(home: UserPage(cubit: cubit)));
    await tester.enterText(find.byType(TextFormField), '0');
    await tester.tap(find.text('Find profile'));
    await tester.pump();
    expect(find.text('Enter a user ID from 1 to 10'), findsOneWidget);
    expect(cubit.requests, isEmpty);
    await tester.enterText(find.byType(TextFormField), '3');
    await tester.tap(find.text('Find profile'));
    await tester.pump();
    expect(cubit.requests, [3]);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    cubit.fail();
    await tester.pump();
    expect(find.text('No connection'), findsOneWidget);
    await tester.ensureVisible(find.text('Try again'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(cubit.requests, [3, 3]);
    expect(tester.takeException(), isNull);
  });
}
