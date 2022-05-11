import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistSeriesBloc extends MockBloc<WatchlistSeriesEvent, WatchlistSeriesState> implements WatchlistSeriesBloc {}

class FakeWatchlistSeriesEvent extends Fake implements WatchlistSeriesEvent {}

class FakeWatchlistSeriesState extends Fake implements WatchlistSeriesState {}

void main() {
  late MockWatchlistSeriesBloc mockWatchlistSeriesBloc;

  setUp(() {
    mockWatchlistSeriesBloc = MockWatchlistSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeWatchlistSeriesEvent());
    registerFallbackValue(FakeWatchlistSeriesState());
  });

  tearDown(() {
    mockWatchlistSeriesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistSeriesBloc>(
      create: (_) => mockWatchlistSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockWatchlistSeriesBloc.state).thenReturn(WatchlistSeriesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(WatchlistSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display Series Card when data is loaded',
          (WidgetTester tester) async {
        when(() => mockWatchlistSeriesBloc.state).thenReturn(WatchlistSeriesLoaded(testSeriesList));

        await tester.pumpWidget(_makeTestableWidget(WatchlistSeriesPage()));

        expect(find.byType(SeriesCard), findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockWatchlistSeriesBloc.state).thenReturn(WatchlistSeriesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(WatchlistSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
