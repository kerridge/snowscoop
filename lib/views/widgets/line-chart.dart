import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:snowscoop/models/linear-weather.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  factory SimpleLineChart.withCustomData(List<int> weather){
    return new SimpleLineChart(
      _buildSeries(weather),
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      defaultRenderer:
        new charts.LineRendererConfig(includeArea: true, stacked: true),
      animate: animate);
  }

  /// Build a series of x,y data points
  static List<charts.Series<LinearWeather, int>> _buildSeries(List<int> weather) {

    final data = new List<LinearWeather>(weather.length);

    for (int i = 0; i < weather.length; i++) {
      data[i] = new LinearWeather(i, weather[i]);
    }

    return [
      new charts.Series<LinearWeather, int>(
        id: 'Weather',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearWeather, int>> _createSampleData() {
    final data = [
      new LinearWeather(0, 5),
      new LinearWeather(1, 25),
      new LinearWeather(2, 100),
      new LinearWeather(3, 75),
    ];

    return [
      new charts.Series<LinearWeather, int>(
        id: 'Weather',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: data,
      )
    ];
  }
}
