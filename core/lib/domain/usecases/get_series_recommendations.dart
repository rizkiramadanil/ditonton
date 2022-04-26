import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetSeriesRecommendations {
  final SeriesRepository repository;

  GetSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Series>>> execute(id) {
    return repository.getSeriesRecommendations(id);
  }
}
