part of 'search_series_bloc.dart';

abstract class SearchSeriesState extends Equatable {
  const SearchSeriesState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchSeriesState {
  final String message = 'No Results Found';
}

class SearchLoading extends SearchSeriesState {}

class SearchError extends SearchSeriesState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchSeriesState {
  final List<Series> result;

  const SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
