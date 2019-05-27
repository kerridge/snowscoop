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

  // factory SimpleLineChart.withRegionData(List<Field> fields, var selected) {
  //   return new SimpleLineChart(
  //     _buildSeriesFromRegion(fields, selected),
  //     animate: true,
  //   );
  // }

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

    for (Field field in fields) {
      final data = new List<LinearWeather>();

      for (int i = 0; i < 22; i++) {
        var val = field.getWeatherMaped()[weatherKey][i];
        data[i] = new LinearWeather(i, val);
      }
      
      output.add(
        new charts.Series<LinearWeather, int>(
        id: 'Weather',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: data
      ));
    }

    return output;
  }

  // static List<charts.Series<LinearWeather, int>> _buildSeriesFromRegion(List<Field> fields, var selected) {

  //   var weatherKey = selected.toString().split('.')[1];
  //   // List<List<int>> weather = new List(fields.length);

  //   var output = new List<charts.Series<LinearWeather, int>>();

  //   for(int i = 0; i < fields.length; i++) {
  //     output.add(
  //       new charts.Series<LinearWeather, int>(
  //       id: 'Weather',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
  //       domainFn: (LinearWeather weather, _) => weather.day,
  //       measureFn: (LinearWeather weather, _) => weather.level,
  //       data: fields[i].weather[weatherKey],
  //     ));
  //   }

  //   return output;
  // }

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
