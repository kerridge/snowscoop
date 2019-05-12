import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/util/scrape-field.dart' as scraper;
// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';

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

  @override
  void initState() {
    super.initState();

    // initialize data arrays
    for (int i = 0; i < 20; i++) {
      weather[i] = 0;
    }

    scrapeField("SNOW");
  }

  void scrapeField(String scrapeQuery) async {
    setState (() => scraping = true);

    weather = await scraper.initiate(scrapeQuery);

    setState (() => scraping = false);
  }


  /// switches the selected button and displays new data
  @protected
  void switchButton(String title) {
    switch (title) {
      case "SNOW":
        scrapeField(title);
        setState(() => selected =SelectedButton.SNOW);
        break;
      case "RAIN":
        scrapeField(title);
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