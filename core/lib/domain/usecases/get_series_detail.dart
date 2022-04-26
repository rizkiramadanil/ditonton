import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/series_detail.dart';
import '../repositories/series_repository.dart';

class GetSeriesDetail {
  final SeriesRepository repository;

  GetSeriesDetail(this.repository);

  Future<Either<Failure, SeriesDetail>> execute(int id) {
    return repository.getSeriesDetail(id);
  }
}
