import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
// import 'package:snowscoop/models/linear-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';
import 'package:snowscoop/util/build-date-axis.dart';

class SimpleLineChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final bool fillArea;
  final Widget child;
  final Widget buttons;

  SimpleLineChart(
    this.seriesList,
    {
      this.animate,
      this.fillArea,
      this.child,
      this.buttons,
    });

  factory SimpleLineChart.withField(Field field) {
    return new SimpleLineChart(
      SimpleLineChartState.buildSeriesFromField(field),
      animate: true,
    );
  }

  factory SimpleLineChart.withFieldList(
      List<Field> fields, var selected, bool fillArea) {
    return new SimpleLineChart(
      SimpleLineChartState.buildSeriesFromFieldList(fields, selected),
      animate: true,
      fillArea: fillArea,
    );
  }

  @override
  State<StatefulWidget> createState() => new SimpleLineChartState();
}

class SimpleLineChartState extends State<SimpleLineChart> {
  Size _phoneSize;

  @override
  Widget build(BuildContext context) {
    _phoneSize = MediaQuery.of(context).size;
    _phoneSize =
        Size(_phoneSize.width, _phoneSize.height - 50); // to adjust for appbar

    List<charts.Series> seriesList = widget.seriesList;
    var axisColor;
    // a check to see if we are currently in dark mode
    CustomTheme.instanceOf(context).themeKey == MyThemeKeys.DARK
        ? axisColor = charts.MaterialPalette.white
        : axisColor = charts.MaterialPalette.black;

    var children = <Widget>[
      new SizedBox(
        height: _phoneSize.height * 0.34,
        child: new charts.TimeSeriesChart(
        seriesList,
        defaultRenderer: new charts.LineRendererConfig(
            includeArea: widget.fillArea ?? true, stacked: false),
        animate: widget.animate,
        selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
          )
        ],

        /// Assign a custom style for the domain axis.
        ///
        /// This is an OrdinalAxisSpec to match up with BarChart's default
        /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
        /// other charts).
        domainAxis: new charts.DateTimeAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(

                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    // fontSize: 18, // size in Pts.
                    color: axisColor),

                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(color: axisColor))),

        /// Assign a custom style for the measure axis.
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              // fontSize: 18, // size in Pts.
              color: axisColor),

          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(color: axisColor),
          axisLineStyle: new charts.LineStyleSpec(color: axisColor),
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
      ))
    ];

    if (widget.child != null) children.add(widget.child);

    // If there is a selection, then include the details.
    // if (_measures != null) {
    //   children.add(new Padding(
    //       padding: new EdgeInsets.only(top: 5.0),
    //       child: new Text(_measures.toString())));
    // }
    // _measures?.forEach((String series, num value) {
    //   children.add(new Text('${series}: ${value}'));
    // });

    return new Column(children: children);
  }

  static List<charts.Series<LinearWeather, DateTime>> buildSeriesFromFieldList(
      List<Field> fields, var selected) {

    var dates = buildDates();

    var weatherKey = selected.toString().split('.')[1];

    var output = new List<charts.Series<LinearWeather, DateTime>>();

    var primaryColors = [
      charts.MaterialPalette.blue.shadeDefault,
      charts.MaterialPalette.red.shadeDefault,
      charts.MaterialPalette.green.shadeDefault,
      charts.MaterialPalette.purple.shadeDefault,
      charts.MaterialPalette.yellow.shadeDefault,
      // charts.MaterialPalette.cyan.shadeDefault,
      // charts.MaterialPalette.deepOrange.shadeDefault,
      // charts.MaterialPalette.lime.shadeDefault,
      // charts.MaterialPalette.indigo.shadeDefault,

      // charts.MaterialPalette.teal.shadeDefault,

      charts.MaterialPalette.pink.shadeDefault,
      // charts.MaterialPalette.gray.shadeDefault,
      // charts.MaterialPalette.black,
    ];

    int i = 0;

    for (Field field in fields) {
      int weatherLength = field.rain == null ? 21 : field.rain.length;

      final data = new List<LinearWeather>(weatherLength);

      var val = field.getWeatherMapped()[weatherKey];
      for (int i = 0; i < weatherLength; i++) {
        data[i] = new LinearWeather(dates[i], val[i]);
      }

      // make a copy so series is not referencing array
      var currentColor = primaryColors[i];

      output.add(new charts.Series<LinearWeather, DateTime>(
          id: field.title,
          colorFn: (_, __) => currentColor,
          // areaColorFn: (_, __) => currentColor.lighter,
          domainFn: (LinearWeather weather, _) => weather.day,
          measureFn: (LinearWeather weather, _) => weather.level,
          data: data));

      i = (i + 1) % 13;
    }

    return output;
  }

  static List<charts.Series<LinearWeather, DateTime>> buildSeriesFromField(
      Field field) {

    var dates = buildDates();
    int weatherLength = field.rain == null ? 21 : field.rain.length;

    List<LinearWeather> maxData = new List<LinearWeather>(weatherLength);
    List<LinearWeather> minData = new List<LinearWeather>(weatherLength);
    List<LinearWeather> chillData = new List<LinearWeather>(weatherLength);

    var mappedData = field.getWeatherMapped();
    for (int i = 0; i < weatherLength; i++) {
      maxData[i] = LinearWeather(dates[i], mappedData["MAX"][i]);
      minData[i] = LinearWeather(dates[i], mappedData["MIN"][i]);
      chillData[i] = LinearWeather(dates[i], mappedData["CHILL"][i]);
    }

    return [
      new charts.Series<LinearWeather, DateTime>(
        id: 'min',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: minData,
      ),
      new charts.Series<LinearWeather, DateTime>(
        id: 'max',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: maxData,
      ),
      new charts.Series<LinearWeather, DateTime>(
        id: 'chill',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: chillData,
      )
    ];
  }

  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    // DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      // time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.level;
      });
    }

    // Request a build.
    // setState(() {
    //   // _time = time;
    //   _measures = measures;
    // });
  }

  /// Build a series of x,y data points
  static List<charts.Series<LinearWeather, DateTime>> buildSeries(
      List<int> weather) {

    var dates = buildDates();
    final data = new List<LinearWeather>(weather.length);

    for (int i = 0; i < weather.length; i++) {
      data[i] = new LinearWeather(dates[i], weather[i]);
    }

    return [
      new charts.Series<LinearWeather, DateTime>(
        id: 'Weather',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearWeather weather, _) => weather.day,
        measureFn: (LinearWeather weather, _) => weather.level,
        data: data,
      ),
    ];
  }
}

class LinearWeather {
  final DateTime day;
  final int level;

  LinearWeather(this.day, this.level);
}

// class InheritedDataProvider extends InheritedWidget {
//   final Data data;

//   InheritedDataProvider({
//     Widget child,
//     this.data,
//   }) : super(child: child);

//   @override
//   bool updateShouldNotify(InheritedDataProvider oldWidget) => data != oldWidget.data;

//   static InheritedDataProvider of(BuildContext context) =>
//       context.inheritFromWidgetOfExactType(InheritedDataProvider);
// }

// class Data {
//   String word = 'hey x';
// }