import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetPopularSeries {
  final SeriesRepository repository;

  GetPopularSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getPopularSeries();
  }
}
