import 'package:about/about_page.dart';
import 'package:core/data/datasources/http_ssl_pinning.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/now_playing_movies_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/bloc/search_movies_bloc.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';
import 'package:search/search.dart';
import 'package:series/presentation/bloc/on_the_air_series/on_the_air_series_bloc.dart';
import 'package:series/presentation/bloc/popular_series/popular_series_bloc.dart';
import 'package:series/presentation/bloc/series_detail/series_detail_bloc.dart';
import 'package:series/presentation/bloc/series_recommendation/series_recommendation_bloc.dart';
import 'package:series/presentation/bloc/top_rated_series/top_rated_series_bloc.dart';
import 'package:series/presentation/bloc/watchlist_series/watchlist_series_bloc.dart';
import 'package:series/presentation/pages/home_series_page.dart';
import 'package:series/presentation/pages/on_the_air_series_page.dart';
import 'package:series/presentation/pages/popular_series_page.dart';
import 'package:series/presentation/pages/series_detail_page.dart';
import 'package:series/presentation/pages/top_rated_series_page.dart';
import 'package:series/presentation/pages/watchlist_series_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SeriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<OnTheAirSeriesBloc>(),
        ),
        BlocProvider(
            create: (_) => di.locator<TopRatedSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SeriesRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case NowPlayingMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => NowPlayingMoviesPage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchMoviesPage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => HomeSeriesPage());
            case OnTheAirSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => OnTheAirSeriesPage());
            case PopularSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularSeriesPage());
            case TopRatedSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedSeriesPage());
            case SeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => SeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchSeriesPage());
            case WatchlistSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistSeriesPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Page not found :(',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
