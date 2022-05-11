import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/search_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';

import 'search_series_bloc_test.mocks.dart';

@GenerateMocks([
  SearchSeries
])
void main() {
  late SearchSeriesBloc searchSeriesBloc;
  late MockSearchSeries mockSearchSeries;

  setUp(() {
    mockSearchSeries = MockSearchSeries();
    searchSeriesBloc = SearchSeriesBloc(mockSearchSeries);
  });

  test('initial state should be empty', () {
    expect(searchSeriesBloc.state, SearchEmpty());
  });

  final tSeriesModel = Series(
    backdropPath: '/1uegR4uAxRxiMyX4nQnpzbXhrTw.jpg',
    genreIds: [10759, 10765, 18],
    id: 92749,
    name: 'Moon Knight',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Moon Knight',
    overview: 'When Steven Grant, a mild-mannered gift-shop employee, becomes plagued with blackouts and memories of another life, he discovers he has dissociative identity disorder and shares a body with mercenary Marc Spector. As Steven/Marc’s enemies converge upon them, they must navigate their complex identities while thrust into a deadly mystery among the powerful gods of Egypt.',
    popularity: 7550.11,
    posterPath: '/x6FsYvt33846IQnDSFxla9j0RX8.jpg',
    voteAverage: 8.6,
    voteCount: 308,
  );
  final tSeriesList = <Series>[tSeriesModel];
  final tQuery = 'moon';

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tSeriesList));
      return searchSeriesBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchSeriesBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );
}
