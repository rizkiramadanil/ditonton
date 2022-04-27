import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:series/presentation/provider/on_the_air_series_notifier.dart';
import 'package:series/presentation/widgets/series_card_list.dart';

class OnTheAirSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-series';

  @override
  State<OnTheAirSeriesPage> createState() => _OnTheAirSeriesPageState();
}

class _OnTheAirSeriesPageState extends State<OnTheAirSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OnTheAirSeriesNotifier>(context, listen: false)
            .fetchOnTheAirSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnTheAirSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = data.series[index];
                  return SeriesCard(series);
                },
                itemCount: data.series.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(
                  data.message,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
