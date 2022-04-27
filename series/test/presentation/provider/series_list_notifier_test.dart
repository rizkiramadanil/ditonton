import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/usecases/get_on_the_air_series.dart';
import 'package:series/domain/usecases/get_popular_series.dart';
import 'package:series/domain/usecases/get_top_rated_series.dart';
import 'package:series/presentation/provider/series_list_notifier.dart';

import 'series_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirSeries,
  GetPopularSeries,
  GetTopRatedSeries
])
void main() {
  late SeriesListNotifier provider;
  late MockGetOnTheAirSeries mockGetOnTheAirSeries;
  late MockGetPopularSeries mockGetPopularSeries;
  late MockGetTopRatedSeries mockGetTopRatedSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnTheAirSeries = MockGetOnTheAirSeries();
    mockGetPopularSeries = MockGetPopularSeries();
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    provider = SeriesListNotifier(
      getOnTheAirSeries: mockGetOnTheAirSeries,
      getPopularSeries: mockGetPopularSeries,
      getTopRatedSeries: mockGetTopRatedSeries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tSeries = Series(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeriesList = <Series>[tSeries];

  group('now playing series', () {
    test('initialState should be Empty', () {
      expect(provider.onTheAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnTheAirSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchOnTheAirSeries();
      // assert
      verify(mockGetOnTheAirSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnTheAirSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchOnTheAirSeries();
      // assert
      expect(provider.onTheAirState, RequestState.Loading);
    });

    test('should change series when data is gotten successfully', () async {
      // arrange
      when(mockGetOnTheAirSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      await provider.fetchOnTheAirSeries();
      // assert
      expect(provider.onTheAirState, RequestState.Loaded);
      expect(provider.onTheAirSeries, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnTheAirSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirSeries();
      // assert
      expect(provider.onTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchPopularSeries();
      // assert
      expect(provider.popularSeriesState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change series data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularSeries.execute())
              .thenAnswer((_) async => Right(tSeriesList));
          // act
          await provider.fetchPopularSeries();
          // assert
          expect(provider.popularSeriesState, RequestState.Loaded);
          expect(provider.popularSeries, tSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularSeries();
      // assert
      expect(provider.popularSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchTopRatedSeries();
      // assert
      expect(provider.topRatedSeriesState, RequestState.Loading);
    });

    test('should change series data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedSeries.execute())
              .thenAnswer((_) async => Right(tSeriesList));
          // act
          await provider.fetchTopRatedSeries();
          // assert
          expect(provider.topRatedSeriesState, RequestState.Loaded);
          expect(provider.topRatedSeries, tSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedSeries();
      // assert
      expect(provider.topRatedSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
