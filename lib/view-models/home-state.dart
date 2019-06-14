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

  // default region is Otago
  Region selectedRegion;
  var selected = SelectedButton.SNOW;
  var graphTitle = 'Snowfall (cm)';

  Fields skifields =_initFields();


  @override
  void initState() {
    super.initState();

    // Otago is the default region when app is opened
    selectedRegion = skifields.getRegion('Otago');
    updateRegionWeather(selectedRegion);
    
    print('done');
  }

  @override
  void dispose() {
    // close our db client connection
    _db.closeConnection();
    super.dispose();
  }

  // Field field = new Field('Cardrona', 'Otago');

  /// initializes our list of `Field` objects and appends
  /// them to a `Fields` object.
  static Fields _initFields() {

    List<Field> fields = [
      new Field('Coronet Peak', 'Otago'),
      new Field('Cardrona', 'Otago'),
      new Field('Round Hill', 'South Canterbury'),
      new Field('Treble Cone', 'Otago'),
      new Field('Remarkables', 'Otago'),
      new Field('Mount Hutt', 'South Canterbury'),
    ];

    return new Fields(fields);

    // List<Field> otago = allFields.getFieldsByRegion('Otago');
  }

  /// takes a `List<Field>` object and updates their weather values
  /// with data from our sheets backend
  Future updateRegionWeather(Region region) async {
    if (region.hasData) return setState(() => scraping = false);
    // make API connection
    await _db.connect()
      .then((dynamic res) { // after connection accepted 
        
        print('yo');
        
    });
    for (Field field in region.fields) {
     field = await _db.getFieldWeather(field);
    }
    setState(() => scraping = false);
    
    region.hasData = true;
  }


  /// switches the selected button and displays new data
  @protected
  void switchButton(String title) {
    switch (title) {
      case "SNOW":
        setState(() { 
          selected =SelectedButton.SNOW;
          graphTitle = 'Snowfall (cm)';
        });
        break;
      case "RAIN":
        setState(() { 
          selected =SelectedButton.RAIN;
          graphTitle = 'Rainfall (mm)';
        });
        break;
      case "CHILL":
        setState(() { 
          selected =SelectedButton.CHILL;
          graphTitle = 'Wind Chill (\u00B0C)';
        });
        break;
      case "MIN":
        setState(() { 
          selected =SelectedButton.MIN;
          graphTitle = 'Min Temp (\u00B0C)';
        });
        break;
      case "MAX":
        setState(() { 
          selected =SelectedButton.MAX;
          graphTitle = 'Max Temp (\u00B0C)';
        });
        break;
      default:
        break;
    }
  }
}