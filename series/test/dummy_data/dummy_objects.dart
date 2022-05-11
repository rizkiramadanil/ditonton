import 'package:core/data/models/series_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/entities/series_detail.dart';

final testSeries = Series(
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

final testSeriesList = [testSeries];

final testSeriesDetail = SeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  episodeRunTime: [1],
  genres: [Genre(id: 1, name: 'Action & Adventure')],
  homepage: 'homepage',
  id: 1,
  inProduction: true,
  name: 'name',
  nextEpisodeToAir: 'nextEpisodeToAir',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originCountry: ['originCountry'],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistSeries = Series.watchList(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeriesTable = SeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
