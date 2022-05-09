import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'series_recommendation_bloc_test.mocks.dart';

@GenerateMocks([
  GetSeriesRecommendations
])
void main() {
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;
  late SeriesRecommendationBloc seriesRecommendationBloc;

  const tSeriesId = 1;

  setUp(() {
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    seriesRecommendationBloc = SeriesRecommendationBloc(mockGetSeriesRecommendations);
  });

  test('initial state should be empty', () {
    expect(seriesRecommendationBloc.state, SeriesRecommendationEmpty());
  });

  blocTest<SeriesRecommendationBloc, SeriesRecommendationState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetSeriesRecommendations.execute(tSeriesId))
          .thenAnswer((_) async => Right(testSeriesList));
      return seriesRecommendationBloc;
    },
    act: (bloc) => bloc.add(GetSeriesRecommendationEvent(tSeriesId)),
    expect: () => [
      SeriesRecommendationLoading(),
      SeriesRecommendationLoaded(testSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetSeriesRecommendations.execute(tSeriesId));
    },
  );

  blocTest<SeriesRecommendationBloc, SeriesRecommendationState>(
    'Should emit [Loading, Error] when get series recommendation is unsuccessful',
    build: () {
      when(mockGetSeriesRecommendations.execute(tSeriesId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesRecommendationBloc;
    },
    act: (bloc) => bloc.add(GetSeriesRecommendationEvent(tSeriesId)),
    expect: () => [
      SeriesRecommendationLoading(),
      SeriesRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetSeriesRecommendations.execute(tSeriesId));
    },
  );
}
