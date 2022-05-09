import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetSeriesDetail
])
void main() {
  late MockGetSeriesDetail mockGetSeriesDetail;
  late SeriesDetailBloc seriesDetailBloc;

  const tSeriesId = 1;

  setUp(() {
    mockGetSeriesDetail = MockGetSeriesDetail();
    seriesDetailBloc = SeriesDetailBloc(mockGetSeriesDetail);
  });

  test('initial state should be empty', () {
    expect(seriesDetailBloc.state, SeriesDetailEmpty());
  });

  blocTest<SeriesDetailBloc, SeriesDetailState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetSeriesDetail.execute(tSeriesId))
          .thenAnswer((_) async => Right(testSeriesDetail));
      return seriesDetailBloc;
    },
    act: (bloc) => bloc.add(GetSeriesDetailEvent(tSeriesId)),
    expect: () => [
      SeriesDetailLoading(),
      SeriesDetailLoaded(testSeriesDetail)
    ],
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(tSeriesId));
    },
  );

  blocTest<SeriesDetailBloc, SeriesDetailState>(
    'Should emit [Loading, Error] when get series detail is unsuccessful',
    build: () {
      when(mockGetSeriesDetail.execute(tSeriesId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesDetailBloc;
    },
    act: (bloc) => bloc.add(GetSeriesDetailEvent(tSeriesId)),
    expect: () => [
      SeriesDetailLoading(),
      SeriesDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(tSeriesId));
    },
  );
}
