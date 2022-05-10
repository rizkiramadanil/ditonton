import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/series.dart';

class MockTopRatedSeriesBloc extends MockBloc<TopRatedSeriesEvent, TopRatedSeriesState> implements TopRatedSeriesBloc {}

class FakeTopRatedSeriesEvent extends Fake implements TopRatedSeriesEvent {}

class FakeTopRatedSeriesState extends Fake implements TopRatedSeriesState {}

void main() {
  late MockTopRatedSeriesBloc mockTopRatedSeriesBloc;

  setUp(() {
    mockTopRatedSeriesBloc = MockTopRatedSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeTopRatedSeriesEvent());
    registerFallbackValue(FakeTopRatedSeriesState());
  });

  tearDown(() {
    mockTopRatedSeriesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedSeriesBloc>(
      create: (_) => mockTopRatedSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockTopRatedSeriesBloc.add(GetTopRatedSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockTopRatedSeriesBloc.state).thenAnswer((invocation) => TopRatedSeriesLoading());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockTopRatedSeriesBloc.add(GetTopRatedSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockTopRatedSeriesBloc.state).thenAnswer((invocation) => TopRatedSeriesLoaded(<Series>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockTopRatedSeriesBloc.add(GetTopRatedSeriesEvent())).thenAnswer((invocation) {});
        when(() => mockTopRatedSeriesBloc.state).thenAnswer((invocation) => TopRatedSeriesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
