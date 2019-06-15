import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:snowscoop/models/linear-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedBarChart(this.seriesList, {this.animate});

  factory GroupedBarChart.withField(Field field) {
    return new GroupedBarChart(
      _buildSeriesFromField(field),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<LinearWeather, String>> _buildSeriesFromField(Field field) {
    
    
    int weatherLength = field.rain == null ? 21 : field.rain.length;

    List<LinearWeather> rainData = new List<LinearWeather>(weatherLength);
    List<LinearWeather> snowData = new List<LinearWeather>(weatherLength);

    var mappedData = field.getWeatherMapped();
    for (int i = 0; i < weatherLength; i++){
      rainData[i] = LinearWeather(i, mappedData["RAIN"][i]);
      snowData[i] = LinearWeather(i, mappedData["SNOW"][i]);
    }


    return [
      new charts.Series<LinearWeather, String>(
        id: 'Rain',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.day.toString(),
        measureFn: (LinearWeather weather, _) => weather.level,
        data: rainData,
      ),
      new charts.Series<LinearWeather, String>(
        id: 'Snow',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.day.toString(),
        measureFn: (LinearWeather weather, _) => weather.level,
        data: snowData,
      ),
    ];
  }
}