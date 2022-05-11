import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingMoviesBloc extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState> implements NowPlayingMoviesBloc {}

class FakeNowPlayingMoviesEvent extends Fake implements NowPlayingMoviesEvent {}

class FakeNowPlayingMoviesState extends Fake implements NowPlayingMoviesState {}

class MockPopularMoviesBloc extends MockBloc<PopularMoviesEvent, PopularMoviesState> implements PopularMoviesBloc {}

class FakePopularMoviesEvent extends Fake implements PopularMoviesEvent {}

class FakePopularMoviesState extends Fake implements PopularMoviesState {}

class MockTopRatedMoviesBloc extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState> implements TopRatedMoviesBloc {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingMoviesEvent());
    registerFallbackValue(FakeNowPlayingMoviesState());
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularMoviesState());
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
  });

  tearDown(() {
    mockNowPlayingMoviesBloc.close();
    mockPopularMoviesBloc.close();
    mockTopRatedMoviesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>(create: (_) => mockNowPlayingMoviesBloc),
        BlocProvider<PopularMoviesBloc>(create: (_) => mockPopularMoviesBloc),
        BlocProvider<TopRatedMoviesBloc>(create: (_) => mockTopRatedMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
      ));
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockNowPlayingMoviesBloc.state).thenReturn(NowPlayingMoviesLoading());
        when(() => mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());
        when(() => mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

        expect(progressBarFinder, findsNWidgets(3));
      });

  testWidgets('Page should display ListView Now Playing Movies, Popular Movies and Top Rated Movies when data is loaded',
          (WidgetTester tester) async {
        when(() => mockNowPlayingMoviesBloc.state).thenReturn(NowPlayingMoviesLoaded(testMovieList));
        when(() => mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoaded(testMovieList));
        when(() => mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoaded(testMovieList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

        expect(listViewFinder, findsWidgets);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockNowPlayingMoviesBloc.state).thenReturn(NowPlayingMoviesError('Error Message'));
        when(() => mockPopularMoviesBloc.state).thenReturn(PopularMoviesError('Error Message'));
        when(() => mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

        expect(textFinder, findsNWidgets(3));
      });
}
