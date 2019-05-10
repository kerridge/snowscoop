import 'package:charts_flutter/flutter.dart' as charts;
import 'package:snowscoop/models/LinearWeather.dart';

List<charts.Series<LinearWeather, int>> buildSeries(List<int> weather) {

  final data = new List(weather.length);

  for (int i = 0; i < weather.length; i++) {
    data[i] = new LinearWeather(i, weather[i]);
  }

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