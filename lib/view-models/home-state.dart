import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/util/scrape-field.dart' as scraper;
// enum for current button
import 'package:snowscoop/models/current-button.dart';

class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  // TEMP VAL
  @protected
  List<int> rain = new List(20);
  bool scraping = true;
  var selected = SelectedButton.SNOW;

  @override
  void initState() {
    super.initState();

    // initialize data arrays
    for (int i = 0; i < 20; i++) {
      rain[i] = 0;
    }

    print(selected.toString());

    scrapeField();
  }

  void scrapeField() async {
    // scraping = true;
    rain = await scraper.initiate();
    setState(() {
      scraping = false;  
    });
  }
}