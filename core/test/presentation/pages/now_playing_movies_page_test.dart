import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

class MockNowPlayingMoviesBloc extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState> implements NowPlayingMoviesBloc {}

class FakeNowPlayingMoviesEvent extends Fake implements NowPlayingMoviesEvent {}

class FakeNowPlayingMoviesState extends Fake implements NowPlayingMoviesState {}

void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingMoviesEvent());
    registerFallbackValue(FakeNowPlayingMoviesState());
  });

  tearDown(() {
    mockNowPlayingMoviesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingMoviesBloc>(
      create: (_) => mockNowPlayingMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockNowPlayingMoviesBloc.add(GetNowPlayingMoviesEvent())).thenAnswer((invocation) {});
        when(() => mockNowPlayingMoviesBloc.state).thenAnswer((invocation) => NowPlayingMoviesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockNowPlayingMoviesBloc.add(GetNowPlayingMoviesEvent())).thenAnswer((invocation) {});
        when(() => mockNowPlayingMoviesBloc.state).thenAnswer((invocation) => NowPlayingMoviesLoaded(<Movie>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockNowPlayingMoviesBloc.add(GetNowPlayingMoviesEvent())).thenAnswer((invocation) {});
        when(() => mockNowPlayingMoviesBloc.state).thenAnswer((invocation) => NowPlayingMoviesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}
