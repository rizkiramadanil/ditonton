import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status_movies.dart';
import 'package:core/domain/usecases/remove_watchlist_movies.dart';
import 'package:core/domain/usecases/save_watchlist_movies.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatusMovies,
  SaveWatchlistMovies,
  RemoveWatchlistMovies
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatusMovies mockGetWatchListStatusMovies;
  late MockSaveWatchlistMovies mockSaveWatchlistMovies;
  late MockRemoveWatchlistMovies mockRemoveWatchlistMovies;
  late WatchlistMoviesBloc watchlistMoviesBloc;

  const tMovieId = 1;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatusMovies = MockGetWatchListStatusMovies();
    mockSaveWatchlistMovies = MockSaveWatchlistMovies();
    mockRemoveWatchlistMovies = MockRemoveWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(
      mockGetWatchlistMovies,
      mockGetWatchListStatusMovies,
      mockSaveWatchlistMovies,
      mockRemoveWatchlistMovies
    );
  });

  test('initial state should be empty', () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesLoaded([testWatchlistMovie])
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
      return GetListEvent().props;
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, Error] when get watchlist movies is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loaded] when get watchlist status movies is successfully',
    build: () {
      when(mockGetWatchListStatusMovies.execute(tMovieId))
          .thenAnswer((_) async => true);
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetStatusMovieEvent(tMovieId)),
    expect: () => [
      WatchlistMoviesStatusLoaded(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusMovies.execute(tMovieId));
      return GetStatusMovieEvent(tMovieId).props;
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Error] when get watchlist status movies is unsuccessful',
    build: () {
      when(mockGetWatchListStatusMovies.execute(tMovieId))
          .thenAnswer((_) async => false);
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetStatusMovieEvent(tMovieId)),
    expect: () => [
      WatchlistMoviesStatusLoaded(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatusMovies.execute(tMovieId));
      return GetStatusMovieEvent(tMovieId).props;
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Added] when add movie to watchlist is successfully',
    build: () {
      when(mockSaveWatchlistMovies.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Add Success'));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(AddItemMovieEvent(testMovieDetail)),
    expect: () => [
      WatchlistMoviesSuccess('Add Success'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovies.execute(testMovieDetail));
      return AddItemMovieEvent(testMovieDetail).props;
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Error] when add movie to watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlistMovies.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Add Failed')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(AddItemMovieEvent(testMovieDetail)),
    expect: () => [
      WatchlistMoviesError('Add Failed'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovies.execute(testMovieDetail));
      return AddItemMovieEvent(testMovieDetail).props;
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Removed] when remove movie from watchlist is successfully',
    build: () {
      when(mockRemoveWatchlistMovies.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Remove Success'));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(RemoveItemMovieEvent(testMovieDetail)),
    expect: () => [
      WatchlistMoviesSuccess('Remove Success'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
      return RemoveItemMovieEvent(testMovieDetail).props;
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Error] when remove movie from watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlistMovies.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Remove Failed")));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(RemoveItemMovieEvent(testMovieDetail)),
    expect: () => [
      WatchlistMoviesError('Remove Failed'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
      return RemoveItemMovieEvent(testMovieDetail).props;
    },
  );
}
