import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/util/scrape-field.dart' as scraper;
// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  // TEMP VAL
  @protected
  List<int> weather = new List(20);
  bool scraping = true;
  var selected = SelectedButton.SNOW;

  // array of ski fields
  List<Field> skifields = new List();

  @override
  void initState() {
    super.initState();

    // initialize data arrays
    for (int i = 0; i < 20; i++) {
      weather[i] = 0;
    }

    // init fields
    _initFields();

    _scrapeField("SNOW");
  }

  void _scrapeField(String scrapeQuery) async {
    setState (() => scraping = true);

    weather = await scraper.initiate(scrapeQuery, skifields[0]);

    setState (() => scraping = false);
  }

  /// initializing
  void _initFields() {
    Field temp = new Field('Cardrona', 'https://www.snow-forecast.com/resorts/Cardrona/6day/mid');
    skifields.add(temp);

    temp = new Field('Coronet Peak', 'https://www.snow-forecast.com/resorts/Coronet-Peak/6day/mid');
    skifields.add(temp);
  }

  /// switches the selected button and displays new data
  @protected
  void switchButton(String title) {
    switch (title) {
      case "SNOW":
        _scrapeField(title);
        setState(() => selected =SelectedButton.SNOW);
        break;
      case "RAIN":
        _scrapeField(title);
        setState(() => selected =SelectedButton.RAIN);
        break;
      case "WIND":
        setState(() => selected =SelectedButton.WIND);
        break;
      case "MIN":
        setState(() => selected =SelectedButton.MIN);
        break;
      case "MAX":
        setState(() => selected =SelectedButton.MAX);
        break;
      default:
        break;
    }
  }
}