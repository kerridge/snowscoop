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
  @protected
  bool scraping = true;

  var _db = new SheetsConnection();

  var selected = SelectedButton.SNOW;


  @override
  void initState() {
    super.initState();


    updateField();

  }

  Field field = new Field('Cardrona', 'https://www.snow-forecast.com/resorts/Cardrona/6day/mid');

  Future updateField() async {
    
    // make API connection
    await _db.connect()
      .then((dynamic res) { // after connection accepted 
        
        print('yo');
        
    });

    field = await _db.getFieldWeather(field);
    _db.closeConnection();
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
        setState(() => selected =SelectedButton.SNOW);
        break;
      case "RAIN":
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