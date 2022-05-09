import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'on_the_air_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirSeries
])
void main() {
  late MockGetOnTheAirSeries mockGetOnTheAirSeries;
  late OnTheAirSeriesBloc onTheAirSeriesBloc;

  setUp(() {
    mockGetOnTheAirSeries = MockGetOnTheAirSeries();
    onTheAirSeriesBloc = OnTheAirSeriesBloc(mockGetOnTheAirSeries);
  });

  test('initial state should be empty', () {
    expect(onTheAirSeriesBloc.state, OnTheAirSeriesEmpty());
  });

  blocTest<OnTheAirSeriesBloc, OnTheAirSeriesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return onTheAirSeriesBloc;
    },
    act: (bloc) => bloc.add(GetOnTheAirSeriesEvent()),
    expect: () => [
      OnTheAirSeriesLoading(),
      OnTheAirSeriesLoaded(testSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirSeries.execute());
    },
  );

  blocTest<OnTheAirSeriesBloc, OnTheAirSeriesState>(
    'Should emit [Loading, Error] when get on the air series is unsuccessful',
    build: () {
      when(mockGetOnTheAirSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirSeriesBloc;
    },
    act: (bloc) => bloc.add(GetOnTheAirSeriesEvent()),
    expect: () => [
      OnTheAirSeriesLoading(),
      OnTheAirSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirSeries.execute());
    },
  );
}
