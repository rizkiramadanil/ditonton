import 'dart:convert';

import 'package:core/data/datasources/remote_data_source.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_response.dart';
import 'package:series/data/models/series_detail_model.dart';
import 'package:series/data/models/series_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late RemoteDataSourceImpl dataSource;
  late MockIOClient mockIOClient;

  setUp(() {
    mockIOClient = MockIOClient();
    dataSource = RemoteDataSourceImpl(client: mockIOClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
        json.decode(readJson('dummy_data/movie_now_playing.json')))
        .movieList;

    test('should return list of Movie Model when the response code is 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/movie_now_playing.json'), 200));
          // act
          final result = await dataSource.getNowPlayingMovies();
          // assert
          expect(result, equals(tMovieList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getNowPlayingMovies();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular Movies', () {
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson('dummy_data/movie_popular.json')))
            .movieList;

    test('should return list of movies when response is success (200)',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/movie_popular.json'), 200));
          // act
          final result = await dataSource.getPopularMovies();
          // assert
          expect(result, tMovieList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularMovies();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
        json.decode(readJson('dummy_data/movie_top_rated.json')))
        .movieList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(mockIOClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/movie_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedMovies();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get movie detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockIOClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/movie_detail.json'), 200));
      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getMovieDetail(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get movie recommendations', () {
    final tMovieList = MovieResponse.fromJson(
        json.decode(readJson('dummy_data/movie_recommendations.json')))
        .movieList;
    final tId = 1;

    test('should return list of Movie Model when the response code is 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie_recommendations.json'), 200));
          // act
          final result = await dataSource.getMovieRecommendations(tId);
          // assert
          expect(result, equals(tMovieList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getMovieRecommendations(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
        json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .movieList;
    final tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockIOClient
          .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/search_spiderman_movie.json'), 200));
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchMovies(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Now Playing Series', () {
    final tSeriesList = SeriesResponse.fromJson(
        json.decode(readJson('dummy_data/series_on_the_air.json')))
        .seriesList;

    test('should return list of Series Model when the response code is 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/series_on_the_air.json'), 200));
          // act
          final result = await dataSource.getOnTheAirSeries();
          // assert
          expect(result, equals(tSeriesList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getOnTheAirSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular Series', () {
    final tSeriesList =
        SeriesResponse.fromJson(json.decode(readJson('dummy_data/series_popular.json')))
            .seriesList;

    test('should return list of series when response is success (200)',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/series_popular.json'), 200));
          // act
          final result = await dataSource.getPopularSeries();
          // assert
          expect(result, tSeriesList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated Series', () {
    final tSeriesList = SeriesResponse.fromJson(
        json.decode(readJson('dummy_data/series_top_rated.json')))
        .seriesList;

    test('should return list of series when response code is 200 ', () async {
      // arrange
      when(mockIOClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/series_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedSeries();
      // assert
      expect(result, tSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get series detail', () {
    final tId = 1;
    final tSeriesDetail = SeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/series_detail.json')));

    test('should return series detail when the response code is 200', () async {
      // arrange
      when(mockIOClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/series_detail.json'), 200));
      // act
      final result = await dataSource.getSeriesDetail(tId);
      // assert
      expect(result, equals(tSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getSeriesDetail(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get series recommendations', () {
    final tSeriesList = SeriesResponse.fromJson(
        json.decode(readJson('dummy_data/series_recommendations.json')))
        .seriesList;
    final tId = 1;

    test('should return list of Series Model when the response code is 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series_recommendations.json'), 200));
          // act
          final result = await dataSource.getSeriesRecommendations(tId);
          // assert
          expect(result, equals(tSeriesList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getSeriesRecommendations(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search series', () {
    final tSearchResult = SeriesResponse.fromJson(
        json.decode(readJson('dummy_data/search_moon_series.json')))
        .seriesList;
    final tQuery = 'moon';

    test('should return list of series when response code is 200', () async {
      // arrange
      when(mockIOClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/search_moon_series.json'), 200));
      // act
      final result = await dataSource.searchSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockIOClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchSeries(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}
