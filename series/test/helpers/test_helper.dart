import 'package:core/data/datasources/remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:series/data/datasources/db/series_database_helper.dart';
import 'package:series/data/datasources/series_local_data_source.dart';
import 'package:series/domain/repositories/series_repository.dart';

@GenerateMocks([
  RemoteDataSource,
  SeriesRepository,
  SeriesLocalDataSource,
  SeriesDatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
