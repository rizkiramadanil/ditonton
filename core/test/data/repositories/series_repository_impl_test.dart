import 'dart:io';

import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/series_detail_model.dart';
import 'package:core/data/models/series_model.dart';
import 'package:core/data/repositories/series_repository_impl.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockSeriesLocalDataSource();
    repository = SeriesRepositoryImpl(
      seriesRemoteDataSource: mockRemoteDataSource,
      seriesLocalDataSource: mockLocalDataSource,
    );
  });

  final tSeriesModel = SeriesModel(
    backdropPath: '/1uegR4uAxRxiMyX4nQnpzbXhrTw.jpg',
    genreIds: [10759, 10765, 18],
    id: 92749,
    name: 'Moon Knight',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Moon Knight',
    overview: 'When Steven Grant, a mild-mannered gift-shop employee, becomes plagued with blackouts and memories of another life, he discovers he has dissociative identity disorder and shares a body with mercenary Marc Spector. As Steven/Marc’s enemies converge upon them, they must navigate their complex identities while thrust into a deadly mystery among the powerful gods of Egypt.',
    popularity: 7550.11,
    posterPath: '/x6FsYvt33846IQnDSFxla9j0RX8.jpg',
    voteAverage: 8.6,
    voteCount: 308,
  );

  final tSeries = Series(
    backdropPath: '/1uegR4uAxRxiMyX4nQnpzbXhrTw.jpg',
    genreIds: [10759, 10765, 18],
    id: 92749,
    name: 'Moon Knight',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Moon Knight',
    overview: 'When Steven Grant, a mild-mannered gift-shop employee, becomes plagued with blackouts and memories of another life, he discovers he has dissociative identity disorder and shares a body with mercenary Marc Spector. As Steven/Marc’s enemies converge upon them, they must navigate their complex identities while thrust into a deadly mystery among the powerful gods of Egypt.',
    popularity: 7550.11,
    posterPath: '/x6FsYvt33846IQnDSFxla9j0RX8.jpg',
    voteAverage: 8.6,
    voteCount: 308,
  );

  final tSeriesModelList = <SeriesModel>[tSeriesModel];
  final tSeriesList = <Series>[tSeries];

  group('Now Playing Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirSeries())
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.getOnTheAirSeries();
          // assert
          verify(mockRemoteDataSource.getOnTheAirSeries());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getOnTheAirSeries();
          // assert
          verify(mockRemoteDataSource.getOnTheAirSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getOnTheAirSeries();
          // assert
          verify(mockRemoteDataSource.getOnTheAirSeries());
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular Series', () {
    test('should return series list when call to data source is success',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularSeries())
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.getPopularSeries();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularSeries();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularSeries();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated Series', () {
    test('should return series list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedSeries())
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.getTopRatedSeries();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedSeries();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedSeries();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get Series Detail', () {
    final tId = 1;
    final tSeriesResponse = SeriesDetailResponse(
        adult: false,
        backdropPath: 'backdropPath',
        episodeRunTime: [1],
        genres: [GenreModel(id: 1, name: 'Action & Adventure')],
        homepage: 'homepage',
        id: 1,
        inProduction: true,
        name: 'name',
        nextEpisodeToAir: 'nextEpisodeToAir',
        numberOfEpisodes: 1,
        numberOfSeasons: 1,
        originCountry: ['originCountry'],
        originalLanguage: 'originalLanguage',
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        status: 'status',
        tagline: 'tagline',
        type: 'type',
        voteAverage: 1,
        voteCount: 1
    );

    test(
        'should return Series data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getSeriesDetail(tId))
              .thenAnswer((_) async => tSeriesResponse);
          // act
          final result = await repository.getSeriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getSeriesDetail(tId));
          expect(result, equals(Right(testSeriesDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getSeriesDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getSeriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getSeriesDetail(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getSeriesDetail(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getSeriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getSeriesDetail(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get Series Recommendations', () {
    final tSeriesList = <SeriesModel>[];
    final tId = 1;

    test('should return data (series list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getSeriesRecommendations(tId))
              .thenAnswer((_) async => tSeriesList);
          // act
          final result = await repository.getSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getSeriesRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tSeriesList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getSeriesRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getSeriesRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getSeriesRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getSeriesRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getSeriesRecommendations(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Seach Series', () {
    final tQuery = 'moon';

    test('should return series list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchSeries(tQuery))
              .thenAnswer((_) async => tSeriesModelList);
          // act
          final result = await repository.searchSeries(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tSeriesList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchSeries(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchSeries(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchSeries(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchSeries(tQuery);
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getSeriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist series', () {
    test('should return list of Series', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistSeries())
          .thenAnswer((_) async => [testSeriesTable]);
      // act
      final result = await repository.getWatchlistSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistSeries]);
    });
  });
}
