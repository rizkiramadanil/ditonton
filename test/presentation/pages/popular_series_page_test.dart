import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/series.dart';

class MockPopularSeriesBloc extends MockBloc<PopularSeriesEvent, PopularSeriesState> implements PopularSeriesBloc {}

class FakePopularSeriesEvent extends Fake implements PopularSeriesEvent {}

class FakePopularSeriesState extends Fake implements PopularSeriesState {}

void main() {
  late MockPopularSeriesBloc mockPopularSeriesBloc;

  setUp(() {
    mockPopularSeriesBloc = MockPopularSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakePopularSeriesEvent());
    registerFallbackValue(FakePopularSeriesState());
  });

  tearDown(() {
    mockPopularSeriesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularSeriesBloc>(
      create: (_) => mockPopularSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockPopularSeriesBloc.add(GetPopularSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockPopularSeriesBloc.state).thenAnswer((invocation) => PopularSeriesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockPopularSeriesBloc.add(GetPopularSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockPopularSeriesBloc.state).thenAnswer((invocation) => PopularSeriesLoaded(<Series>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(PopularSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockPopularSeriesBloc.add(GetPopularSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockPopularSeriesBloc.state).thenAnswer((invocation) => PopularSeriesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
