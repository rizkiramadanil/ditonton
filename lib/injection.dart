import 'package:core/data/datasources/db/movie_database_helper.dart';
import 'package:core/data/datasources/db/series_database_helper.dart';
import 'package:core/data/datasources/http_ssl_pinning.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/remote_data_source.dart';
import 'package:core/data/datasources/series_local_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/series_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/series_repository.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_on_the_air_series.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_popular_series.dart';
import 'package:core/domain/usecases/get_series_detail.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_top_rated_series.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:core/domain/usecases/get_watchlist_status_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status_series.dart';
import 'package:core/domain/usecases/remove_watchlist_movies.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_movies.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:core/domain/usecases/search_movies.dart';
import 'package:core/domain/usecases/search_series.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:search/presentation/bloc/search_movies_bloc.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';
import 'package:series/presentation/bloc/on_the_air_series/on_the_air_series_bloc.dart';
import 'package:series/presentation/bloc/popular_series/popular_series_bloc.dart';
import 'package:series/presentation/bloc/series_detail/series_detail_bloc.dart';
import 'package:series/presentation/bloc/series_recommendation/series_recommendation_bloc.dart';
import 'package:series/presentation/bloc/top_rated_series/top_rated_series_bloc.dart';
import 'package:series/presentation/bloc/watchlist_series/watchlist_series_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
        () => MovieDetailBloc(locator())
  );
  locator.registerFactory(
        () => NowPlayingMoviesBloc(locator())
  );
  locator.registerFactory(
        () => PopularMoviesBloc(locator())
  );
  locator.registerFactory(
        () => TopRatedMoviesBloc(locator())
  );
  locator.registerFactory(
        () => MovieRecommendationBloc(locator())
  );
  locator.registerFactory(
        () => SearchMoviesBloc(locator())
  );
  locator.registerFactory(
        () => WatchlistMoviesBloc(
          locator(),
          locator(),
          locator(),
          locator(),
        )
  );
  locator.registerFactory(
        () => SeriesDetailBloc(locator())
  );
  locator.registerFactory(
        () => OnTheAirSeriesBloc(locator())
  );
  locator.registerFactory(
        () => PopularSeriesBloc(locator())
  );
  locator.registerFactory(
        () => TopRatedSeriesBloc(locator())
  );
  locator.registerFactory(
        () => SeriesRecommendationBloc(locator())
  );
  locator.registerFactory(
        () => SearchSeriesBloc(locator())
  );
  locator.registerFactory(
        () => WatchlistSeriesBloc(
          locator(),
          locator(),
          locator(),
          locator(),
        )
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovies(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovies(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetOnTheAirSeries(locator()));
  locator.registerLazySingleton(() => GetPopularSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      movieRemoteDataSource: locator(),
      movieLocalDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<SeriesRepository>(
        () => SeriesRepositoryImpl(
      seriesRemoteDataSource: locator(),
      seriesLocalDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<RemoteDataSource>(
          () => RemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<SeriesLocalDataSource>(
          () => SeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<MovieDatabaseHelper>(() => MovieDatabaseHelper());

  locator.registerLazySingleton<SeriesDatabaseHelper>(() => SeriesDatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
