import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSeriesDetailBloc extends MockBloc<SeriesDetailEvent, SeriesDetailState> implements SeriesDetailBloc {}

class FakeSeriesDetailEvent extends Fake implements SeriesDetailEvent {}

class FakeSeriesDetailState extends Fake implements SeriesDetailState {}

class MockSeriesRecommendationBloc extends MockBloc<SeriesRecommendationEvent, SeriesRecommendationState> implements SeriesRecommendationBloc {}

class FakeSeriesRecommendationEvent extends Fake implements SeriesRecommendationEvent {}

class FakeSeriesRecommendationState extends Fake implements SeriesRecommendationState {}

class MockWatchlistSeriesBloc extends MockBloc<WatchlistSeriesEvent, WatchlistSeriesState> implements WatchlistSeriesBloc {}

class FakeWatchlistSeriesEvent extends Fake implements WatchlistSeriesEvent {}

class FakeWatchlistSeriesState extends Fake implements WatchlistSeriesState {}

void main() {
  late MockSeriesDetailBloc mockSeriesDetailBloc;
  late MockSeriesRecommendationBloc mockSeriesRecommendationBloc;
  late MockWatchlistSeriesBloc mockWatchlistSeriesBloc;

  setUp(() {
    mockSeriesDetailBloc = MockSeriesDetailBloc();
    mockSeriesRecommendationBloc = MockSeriesRecommendationBloc();
    mockWatchlistSeriesBloc = MockWatchlistSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeSeriesDetailState());
    registerFallbackValue(FakeSeriesDetailEvent());
    registerFallbackValue(FakeSeriesRecommendationEvent());
    registerFallbackValue(FakeSeriesRecommendationState());
    registerFallbackValue(FakeWatchlistSeriesEvent());
    registerFallbackValue(FakeWatchlistSeriesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SeriesDetailBloc>(create: (_) => mockSeriesDetailBloc),
        BlocProvider<SeriesRecommendationBloc>(create: (_) => mockSeriesRecommendationBloc),
        BlocProvider<WatchlistSeriesBloc>(create: (_) => mockWatchlistSeriesBloc),
      ],
      child: MaterialApp(
        home: body,
      ));
  }

  testWidgets(
      'Watchlist button should display add icon when series not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockSeriesDetailBloc.state).thenReturn(SeriesDetailLoaded(testSeriesDetail));
        when(() => mockSeriesRecommendationBloc.state).thenReturn(SeriesRecommendationLoaded(testSeriesList));
        when(() => mockWatchlistSeriesBloc.state).thenReturn(WatchlistSeriesStatusLoaded(false));

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when series is added to wathclist',
          (WidgetTester tester) async {
        when(() => mockSeriesDetailBloc.state).thenReturn(SeriesDetailLoaded(testSeriesDetail));
        when(() => mockSeriesRecommendationBloc.state).thenReturn(SeriesRecommendationLoaded(testSeriesList));
        when(() => mockWatchlistSeriesBloc.state).thenReturn(WatchlistSeriesStatusLoaded(true));

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button not display SnackBar when add to watchlist failed',
          (WidgetTester tester) async {
        when(() => mockSeriesDetailBloc.state).thenReturn(SeriesDetailLoaded(testSeriesDetail));
        when(() => mockSeriesRecommendationBloc.state).thenReturn(SeriesRecommendationLoaded(testSeriesList));
        when(() => mockWatchlistSeriesBloc.state).thenReturn(WatchlistSeriesStatusLoaded(false));

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byType(SnackBar), findsNothing);
      });
}
