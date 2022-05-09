import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/series.dart';

class MockOnTheAirSeriesBloc extends MockBloc<OnTheAirSeriesEvent, OnTheAirSeriesState> implements OnTheAirSeriesBloc {}

class FakeOnTheAirSeriesEvent extends Fake implements OnTheAirSeriesEvent {}

class FakeOnTheAirSeriesState extends Fake implements OnTheAirSeriesState {}

void main() {
  late MockOnTheAirSeriesBloc mockOnTheAirSeriesBloc;

  setUp(() {
    mockOnTheAirSeriesBloc = MockOnTheAirSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeOnTheAirSeriesEvent());
    registerFallbackValue(FakeOnTheAirSeriesState());
  });

  tearDown(() {
    mockOnTheAirSeriesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<OnTheAirSeriesBloc>(
      create: (_) => mockOnTheAirSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockOnTheAirSeriesBloc.add(GetOnTheAirSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockOnTheAirSeriesBloc.state).thenAnswer((invocation) => OnTheAirSeriesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(OnTheAirSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockOnTheAirSeriesBloc.add(GetOnTheAirSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockOnTheAirSeriesBloc.state).thenAnswer((invocation) => OnTheAirSeriesLoaded(<Series>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(OnTheAirSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockOnTheAirSeriesBloc.add(GetOnTheAirSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockOnTheAirSeriesBloc.state).thenAnswer((invocation) => OnTheAirSeriesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(OnTheAirSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
