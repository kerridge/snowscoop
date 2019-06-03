import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:snowscoop/models/linear-weather.dart';
import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/models/all_fields.dart';

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

  factory SimpleLineChart.withCustomData(List<int> weather) {
    return new SimpleLineChart(
      _buildSeries(weather),
      animate: true,
    );
  }

  factory SimpleLineChart.withFieldList(List<Field> fields, var selected) {
    return new SimpleLineChart(
      _buildSeriesFromFieldList(fields, selected),
      animate: true
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

  static List<charts.Series<LinearWeather, int>> _buildSeriesFromFieldList(List<Field> fields, var selected) {

    var weatherKey = selected.toString().split('.')[1];

    var output = new List<charts.Series<LinearWeather, int>>();

    var primaryColors = [
      charts.MaterialPalette.blue.shadeDefault,
      charts.MaterialPalette.green.shadeDefault,
      charts.MaterialPalette.red.shadeDefault,
      charts.MaterialPalette.purple.shadeDefault,
      charts.MaterialPalette.yellow.shadeDefault
    ];

    int i = 0;

    for (Field field in fields) {
      int weatherLength = field.rain == null ? 21 : field.rain.length;

      final data = new List<LinearWeather>(weatherLength);

      var val = field.getWeatherMapped()[weatherKey];
      for (int i = 0; i < weatherLength; i++) {
        data[i] = new LinearWeather(i, val[i]);
      }
      
      // make a copy so series is not referencing array
      var currentColor = primaryColors[i];

      output.add(
        new charts.Series<LinearWeather, int>(
        id: field.title,
        colorFn: (_, __) => currentColor,
        // areaColorFn: (_, __) => currentColor.lighter,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: data
      ));

      i++;
    }

    return output;
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
      ),
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
