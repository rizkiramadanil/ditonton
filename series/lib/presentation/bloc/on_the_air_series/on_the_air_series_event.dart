part of 'on_the_air_series_bloc.dart';

abstract class OnTheAirSeriesEvent extends Equatable {
  const OnTheAirSeriesEvent();

  @override
  List<Object> get props => [];
}

class GetOnTheAirSeriesEvent extends OnTheAirSeriesEvent {}
