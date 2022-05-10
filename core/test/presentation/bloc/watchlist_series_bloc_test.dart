import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:core/domain/usecases/get_watchlist_status_series.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistSeries,
  GetWatchListStatusSeries,
  SaveWatchlistSeries,
  RemoveWatchlistSeries
])
void main() {
  late MockGetWatchlistSeries mockGetWatchlistSeries;
  late MockGetWatchListStatusSeries mockGetWatchListStatusSeries;
  late MockSaveWatchlistSeries mockSaveWatchlistSeries;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;
  late WatchlistSeriesBloc watchlistMoviesBloc;

  setUp(() {
    mockGetWatchlistSeries = MockGetWatchlistSeries();
    mockGetWatchListStatusSeries = MockGetWatchListStatusSeries();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    watchlistMoviesBloc = WatchlistSeriesBloc(
        mockGetWatchlistSeries,
        mockGetWatchListStatusSeries,
        mockSaveWatchlistSeries,
        mockRemoveWatchlistSeries
    );
  });

  test('initial state should be empty', () {
    expect(watchlistMoviesBloc.state, WatchlistSeriesEmpty());
  });

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Right([testWatchlistSeries]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () => [
      WatchlistSeriesLoading(),
      WatchlistSeriesLoaded([testWatchlistSeries])
    ],
    verify: (bloc) {
      verify(mockGetWatchlistSeries.execute());
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Error] when get watchlist series is unsuccessful',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () => [
      WatchlistSeriesLoading(),
      WatchlistSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistSeries.execute());
    },
  );
}
