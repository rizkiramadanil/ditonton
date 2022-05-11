import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistMoviesBloc extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState> implements WatchlistMoviesBloc {}

class FakeWatchlistMoviesEvent extends Fake implements WatchlistMoviesEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistMoviesState {}

void main() {
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUp(() {
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());
  });

  tearDown(() {
    mockWatchlistMoviesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>(
      create: (_) => mockWatchlistMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display Movie Card when data is loaded',
          (WidgetTester tester) async {
        when(() => mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesLoaded(testMovieList));

        await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

        expect(find.byType(MovieCard), findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}
