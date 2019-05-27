import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';

// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

import 'package:snowscoop/network/get_field.dart';
import 'package:snowscoop/models/all_fields.dart';


class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  @protected
  bool scraping = true;

  var _db = new SheetsConnection();

  var selected = SelectedButton.SNOW;

  Fields skifields =initFields();


  @override
  void initState() {
    super.initState();

    updateField();

    



    
    
    print('done');
  }

  Field field = new Field('Cardrona', 'Otago');

  /// initializes our list of `Field` objects and appends
  /// them to a `Fields` object.
  static Fields initFields() {

    List<Field> fields = [
      new Field('Coronet Peak', 'Otago'),
      new Field('Cardrona', 'Otago'),
      new Field('Round Hill', 'South Canterbury')
    ];

    return new Fields(fields);

    // List<Field> otago = allFields.getFieldsByRegion('Otago');
  }

  Future updateField() async {
    
    // make API connection
    await _db.connect()
      .then((dynamic res) { // after connection accepted 
        
        print('yo');
        
    });

    field = await _db.getFieldWeather(field);
    _db.closeConnection();
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