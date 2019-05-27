import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/util/scrape-field.dart' as scraper;
// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

import 'package:snowscoop/network/get_field.dart';


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
  Map<String, dynamic> fieldsByRegion = new Map();

  @override
  void initState() {
    super.initState();


    updateField();

    
  }


  void updateField() async {
    var db = new SheetsConnection();
    await db.init().then((dynamic res) {
      print('done');
    });

    

    // db.closeConnection();
  }




  void _scrapeField(String scrapeQuery) async {
    setState (() => scraping = true);

    weather = await scraper.initiate(scrapeQuery, fieldsByRegion['Otago'][0]);

    setState (() => scraping = false);
  }

  void _scrapeRegion(String weatherType, String region) async {
    for (var i = 0; i < fieldsByRegion[region].length; i++) {

      fieldsByRegion[region][i].weather[weatherType] = 
      await scraper.initiate(
        weatherType,
        fieldsByRegion[region][i]
      );

    }
  }

  /// initializing
  void _initFields() {
    List<Field> otago = [
      new Field('Cardrona', 'https://www.snow-forecast.com/resorts/Cardrona/6day/mid'),
      new Field('Coronet Peak', 'https://www.snow-forecast.com/resorts/Coronet-Peak/6day/mid'),
    ];

    fieldsByRegion.putIfAbsent('Otago', () => otago);
      
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