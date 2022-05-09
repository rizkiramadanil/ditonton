part of 'watchlist_series_bloc.dart';

abstract class WatchlistSeriesEvent extends Equatable {
  const WatchlistSeriesEvent();

  @override
  List<Object> get props => [];
}

class GetListEvent extends WatchlistSeriesEvent {}

class GetStatusSeriesEvent extends WatchlistSeriesEvent {
  final int id;

  const GetStatusSeriesEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddItemSeriesEvent extends WatchlistSeriesEvent {
  final SeriesDetail seriesDetail;

  const AddItemSeriesEvent(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}

class RemoveItemSeriesEvent extends WatchlistSeriesEvent {
  final SeriesDetail seriesDetail;

  const RemoveItemSeriesEvent(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}
