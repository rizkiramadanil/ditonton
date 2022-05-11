import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';

class MockOnTheAirSeriesBloc extends MockBloc<OnTheAirSeriesEvent, OnTheAirSeriesState> implements OnTheAirSeriesBloc {}

class FakeOnTheAirSeriesEvent extends Fake implements OnTheAirSeriesEvent {}

class FakeOnTheAirSeriesState extends Fake implements OnTheAirSeriesState {}

class MockPopularSeriesBloc extends MockBloc<PopularSeriesEvent, PopularSeriesState> implements PopularSeriesBloc {}

class FakePopularSeriesEvent extends Fake implements PopularSeriesEvent {}

class FakePopularSeriesState extends Fake implements PopularSeriesState {}

class MockTopRatedSeriesBloc extends MockBloc<TopRatedSeriesEvent, TopRatedSeriesState> implements TopRatedSeriesBloc {}

class FakeTopRatedSeriesEvent extends Fake implements TopRatedSeriesEvent {}

class FakeTopRatedSeriesState extends Fake implements TopRatedSeriesState {}

void main() {
  late MockOnTheAirSeriesBloc mockOnTheAirSeriesBloc;
  late MockPopularSeriesBloc mockPopularSeriesBloc;
  late MockTopRatedSeriesBloc mockTopRatedSeriesBloc;

  setUp(() {
    mockOnTheAirSeriesBloc = MockOnTheAirSeriesBloc();
    mockPopularSeriesBloc = MockPopularSeriesBloc();
    mockTopRatedSeriesBloc = MockTopRatedSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeOnTheAirSeriesEvent());
    registerFallbackValue(FakeOnTheAirSeriesState());
    registerFallbackValue(FakePopularSeriesEvent());
    registerFallbackValue(FakePopularSeriesState());
    registerFallbackValue(FakeTopRatedSeriesEvent());
    registerFallbackValue(FakeTopRatedSeriesState());
  });

  tearDown(() {
    mockOnTheAirSeriesBloc.close();
    mockPopularSeriesBloc.close();
    mockTopRatedSeriesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<OnTheAirSeriesBloc>(create: (_) => mockOnTheAirSeriesBloc),
          BlocProvider<PopularSeriesBloc>(create: (_) => mockPopularSeriesBloc),
          BlocProvider<TopRatedSeriesBloc>(create: (_) => mockTopRatedSeriesBloc),
        ],
        child: MaterialApp(
          home: body,
        ));
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockOnTheAirSeriesBloc.state).thenReturn(OnTheAirSeriesLoading());
        when(() => mockPopularSeriesBloc.state).thenReturn(PopularSeriesLoading());
        when(() => mockTopRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(HomeSeriesPage()));

        expect(progressBarFinder, findsNWidgets(3));
      });

  testWidgets('Page should display ListView On The Air Series, Popular Series and Top Rated Series when data is loaded',
          (WidgetTester tester) async {
        when(() => mockOnTheAirSeriesBloc.state).thenReturn(OnTheAirSeriesLoaded(testSeriesList));
        when(() => mockPopularSeriesBloc.state).thenReturn(PopularSeriesLoaded(testSeriesList));
        when(() => mockTopRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoaded(testSeriesList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(HomeSeriesPage()));

        expect(listViewFinder, findsWidgets);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockOnTheAirSeriesBloc.state).thenReturn(OnTheAirSeriesError('Error Message'));
        when(() => mockPopularSeriesBloc.state).thenReturn(PopularSeriesError('Error Message'));
        when(() => mockTopRatedSeriesBloc.state).thenReturn(TopRatedSeriesError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(HomeSeriesPage()));

        expect(textFinder, findsNWidgets(3));
      });
}
