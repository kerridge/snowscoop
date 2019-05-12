import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/util/scrape-field.dart' as scraper;

class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  // TEMP VAL
  @protected
  List<int> rain = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  bool scraping = true;

  @override
  void initState() {
    super.initState();

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