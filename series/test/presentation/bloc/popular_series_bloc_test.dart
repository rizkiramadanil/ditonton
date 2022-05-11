import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_popular_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetPopularSeries
])
void main() {
  late MockGetPopularSeries mockGetPopularSeries;
  late PopularSeriesBloc popularSeriesBloc;

  setUp(() {
    mockGetPopularSeries = MockGetPopularSeries();
    popularSeriesBloc = PopularSeriesBloc(mockGetPopularSeries);
  });

  test('initial state should be empty', () {
    expect(popularSeriesBloc.state, PopularSeriesEmpty());
  });

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(GetPopularSeriesEvent()),
    expect: () => [
      PopularSeriesLoading(),
      PopularSeriesLoaded(testSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
    },
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'Should emit [Loading, Error] when get popular series is unsuccessful',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(GetPopularSeriesEvent()),
    expect: () => [
      PopularSeriesLoading(),
      PopularSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
    },
  );
}
