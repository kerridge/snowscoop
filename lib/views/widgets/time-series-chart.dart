import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/util/build-date-axis.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  // final List<DateTime> dates;

  TimeSeriesChart(this.seriesList, {this.animate});

  factory TimeSeriesChart.withField(Field field) {
    return new TimeSeriesChart(
      _buildSeriesFromField(field),
      // Disable animations for image tests.
      animate: true,
      
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
      

      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
        // Display the measure axis labels below the gridline.
        //
        // 'Before' & 'after' follow the axis value direction.
        // Vertical axes draw 'before' below & 'after' above the tick.
        // Horizontal axes draw 'before' left & 'after' right the tick.
        labelAnchor: charts.TickLabelAnchor.before,

        // Left justify the text in the axis.
        //
        // Note: outside means that the secondary measure axis would right
        // justify.
        labelJustification: charts.TickLabelJustification.outside,
        
        
      )),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<LinearWeather, DateTime>> _buildSeriesFromField(Field field) {
    var dates = buildDates();

    int weatherLength = field.rain == null ? 21 : field.rain.length;

    List<LinearWeather> rainData = new List<LinearWeather>(weatherLength);
    List<LinearWeather> snowData = new List<LinearWeather>(weatherLength);

    var mappedData = field.getWeatherMapped();
    for (int i = 0; i < weatherLength; i++){
      rainData[i] = LinearWeather(dates[i], mappedData["RAIN"][i]);
      snowData[i] = LinearWeather(dates[i], mappedData["SNOW"][i]);
    }


    return [
      new charts.Series<LinearWeather, DateTime>(
        id: 'Rain',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.date,
        measureFn: (LinearWeather weather, _) => weather.weather,
        data: rainData,
      ),
      new charts.Series<LinearWeather, DateTime>(
        id: 'Snow',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.date,
        measureFn: (LinearWeather weather, _) => weather.weather,
        data: snowData,
      ),
    ];
  }
}

class LinearWeather {
  final DateTime date;
  final int weather;

  LinearWeather(this.date, this.weather);
}