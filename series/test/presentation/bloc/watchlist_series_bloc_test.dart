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
  late WatchlistSeriesBloc watchlistSeriesBloc;

  const tSeriesId = 1;

  setUp(() {
    mockGetWatchlistSeries = MockGetWatchlistSeries();
    mockGetWatchListStatusSeries = MockGetWatchListStatusSeries();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    watchlistSeriesBloc = WatchlistSeriesBloc(
        mockGetWatchlistSeries,
        mockGetWatchListStatusSeries,
        mockSaveWatchlistSeries,
        mockRemoveWatchlistSeries
    );
  });

  test('initial state should be empty', () {
    expect(watchlistSeriesBloc.state, WatchlistSeriesEmpty());
  });

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Right([testWatchlistSeries]));
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () => [
      WatchlistSeriesLoading(),
      WatchlistSeriesLoaded([testWatchlistSeries])
    ],
    verify: (bloc) {
      verify(mockGetWatchlistSeries.execute());
      return GetListEvent().props;
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Error] when get watchlist series is unsuccessful',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistSeriesBloc;
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

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loaded] when get watchlist status series is successfully',
    build: () {
      when(mockGetWatchListStatusSeries.execute(tSeriesId))
          .thenAnswer((_) async => true);
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(GetStatusSeriesEvent(tSeriesId)),
    expect: () => [
      WatchlistSeriesStatusLoaded(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusSeries.execute(tSeriesId));
      return GetStatusSeriesEvent(tSeriesId).props;
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Error] when get watchlist status series is unsuccessful',
    build: () {
      when(mockGetWatchListStatusSeries.execute(tSeriesId))
          .thenAnswer((_) async => false);
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(GetStatusSeriesEvent(tSeriesId)),
    expect: () => [
      WatchlistSeriesStatusLoaded(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusSeries.execute(tSeriesId));
      return GetStatusSeriesEvent(tSeriesId).props;
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Added] when add series to watchlist is successfully',
    build: () {
      when(mockSaveWatchlistSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Right('Add Success'));
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(AddItemSeriesEvent(testSeriesDetail)),
    expect: () => [
      WatchlistSeriesSuccess('Add Success'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistSeries.execute(testSeriesDetail));
      return AddItemSeriesEvent(testSeriesDetail).props;
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Error] when add series to watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlistSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Add Failed')));
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(AddItemSeriesEvent(testSeriesDetail)),
    expect: () => [
      WatchlistSeriesError('Add Failed'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistSeries.execute(testSeriesDetail));
      return AddItemSeriesEvent(testSeriesDetail).props;
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Removed] when remove series from watchlist is successfully',
    build: () {
      when(mockRemoveWatchlistSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Right('Remove Success'));
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(RemoveItemSeriesEvent(testSeriesDetail)),
    expect: () => [
      WatchlistSeriesSuccess('Remove Success'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistSeries.execute(testSeriesDetail));
      return RemoveItemSeriesEvent(testSeriesDetail).props;
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Error] when remove series from watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlistSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Remove Failed")));
      return watchlistSeriesBloc;
    },
    act: (bloc) => bloc.add(RemoveItemSeriesEvent(testSeriesDetail)),
    expect: () => [
      WatchlistSeriesError('Remove Failed'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistSeries.execute(testSeriesDetail));
      return RemoveItemSeriesEvent(testSeriesDetail).props;
    },
  );
}
