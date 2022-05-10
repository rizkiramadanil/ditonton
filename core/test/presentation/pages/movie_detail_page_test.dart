import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState> implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailState {}

class FakeMovieDetailState extends Fake implements MovieDetailEvent {}

class MockMovieRecommendationBloc extends MockBloc<MovieRecommendationEvent, MovieRecommendationState> implements MovieRecommendationBloc {}

class FakeMovieRecommendationEvent extends Fake implements MovieRecommendationEvent {}

class FakeMovieRecommendationState extends Fake implements MovieRecommendationState {}

class MockWatchlistMoviesBloc extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState> implements WatchlistMoviesBloc {}

class FakeWatchlistMoviesEvent extends Fake implements WatchlistMoviesEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistMoviesState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeMovieRecommendationEvent());
    registerFallbackValue(FakeMovieRecommendationState());
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieDetailBloc>(create: (_) => mockMovieDetailBloc),
          BlocProvider<MovieRecommendationBloc>(create: (_) => mockMovieRecommendationBloc),
          BlocProvider<WatchlistMoviesBloc>(create: (_) => mockWatchlistMoviesBloc),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.add(GetMovieDetailEvent(1))).thenAnswer((invocation) {});
        when(() => mockMovieDetailBloc.state).thenAnswer((invocation) => MovieDetailLoaded(testMovieDetail));
        when(() => mockMovieRecommendationBloc.add(GetMovieRecommendationEvent(1))).thenAnswer((invocation) {});
        when(() => mockMovieRecommendationBloc.state).thenAnswer((invocation) => MovieRecommendationLoaded(testMovieList));
        when(() => mockWatchlistMoviesBloc.add(GetStatusMovieEvent(1))).thenAnswer((invocation) {});
        when(() => mockWatchlistMoviesBloc.state).thenAnswer((invocation) => WatchlistMoviesStatusLoaded(false));

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
          (WidgetTester tester) async {
            when(() => mockMovieDetailBloc.add(GetMovieDetailEvent(1))).thenAnswer((invocation) {});
            when(() => mockMovieDetailBloc.state).thenAnswer((invocation) => MovieDetailLoaded(testMovieDetail));
            when(() => mockMovieRecommendationBloc.add(GetMovieRecommendationEvent(1))).thenAnswer((invocation) {});
            when(() => mockMovieRecommendationBloc.state).thenAnswer((invocation) => MovieRecommendationLoaded(testMovieList));
            when(() => mockWatchlistMoviesBloc.add(GetStatusMovieEvent(1))).thenAnswer((invocation) {});
            when(() => mockWatchlistMoviesBloc.state).thenAnswer((invocation) => WatchlistMoviesStatusLoaded(true));

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button not display SnackBar when add to watchlist failed',
          (WidgetTester tester) async {
            when(() => mockMovieDetailBloc.add(GetMovieDetailEvent(1))).thenAnswer((invocation) {});
            when(() => mockMovieDetailBloc.state).thenAnswer((invocation) => MovieDetailLoaded(testMovieDetail));
            when(() => mockMovieRecommendationBloc.add(GetMovieRecommendationEvent(1))).thenAnswer((invocation) {});
            when(() => mockMovieRecommendationBloc.state).thenAnswer((invocation) => MovieRecommendationLoaded(testMovieList));
            when(() => mockWatchlistMoviesBloc.add(GetStatusMovieEvent(1))).thenAnswer((invocation) {});
            when(() => mockWatchlistMoviesBloc.state).thenAnswer((invocation) => WatchlistMoviesStatusLoaded(false));

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byType(SnackBar), findsNothing);
      });
}
