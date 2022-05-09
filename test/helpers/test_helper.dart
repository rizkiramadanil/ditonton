import 'package:core/data/datasources/remote_data_source.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:movie/data/datasources/db/movie_database_helper.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:series/data/datasources/db/series_database_helper.dart';
import 'package:series/data/datasources/series_local_data_source.dart';
import 'package:series/domain/repositories/series_repository.dart';

@GenerateMocks([
  RemoteDataSource,
  MovieRepository,
  MovieLocalDataSource,
  MovieDatabaseHelper,
  SeriesRepository,
  SeriesLocalDataSource,
  SeriesDatabaseHelper,
], customMocks: [
  MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}
