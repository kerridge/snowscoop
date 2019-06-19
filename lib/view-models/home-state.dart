import 'package:flutter/material.dart';

import 'package:snowscoop/views/home.dart';

// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';

import 'package:snowscoop/network/get_field.dart';
import 'package:snowscoop/models/all_fields.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  @protected
  bool scraping = true;
  var _db = new SheetsConnection();

  SharedPreferences prefs;

  // default region is Otago
  Region selectedRegion;
  var selected = SelectedButton.SNOW;
  var graphTitle = 'Snowfall (cm)';
  List<Field> _selectedFields = new List<Field>();

  Fields skifields =_initFields();

  List<Field> get selectedFields => _selectedFields;


  @override
  void initState() {
    super.initState();

    _getSavedFields().then((result){
      List<Field> initialFields =skifields.getFieldsFromString(result);
      
      for (Field field in initialFields){
      fieldSelected(field);

    }
    });
    
    
    print('done');
  }

  @override
  void dispose() {
    // close our db client connection
    _db.closeConnection();
    super.dispose();
  }

  Future<List<String>> _getSavedFields() async {
    prefs = await SharedPreferences.getInstance();
    List<String> fieldsString = prefs.getStringList('selectedFields') ?? ['Treble Cone'];
    return fieldsString;
  }

  // Field field = new Field('Cardrona', 'Otago');

  /// initializes our list of `Field` objects and appends
  /// them to a `Fields` object.
  static Fields _initFields() {

    List<Field> fields = [
      new Field('Cardrona', 'Otago'),
      new Field('Coronet Peak', 'Otago'),
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
  Future updateFieldWeather(Field field) async {
    // make API connection
    await _db.connect()
      .then((dynamic res) { // after connection accepted 
        
        print('yo');
        
    });
     field = await _db.getFieldWeather(field);
    
    setState(() => scraping = false);
    
    field.hasData = true;
  }

  
  @protected
  void fieldSelected(Field field) async {
    prefs = await SharedPreferences.getInstance();
    List<String> selectedAsString = new List<String>();
    if (!field.hasData) updateFieldWeather(field);
    setState(() {
    if (_selectedFields.contains(field)) {
      _selectedFields.remove(field);
      } else _selectedFields.add(field);
    });
    for (Field field in _selectedFields){
      selectedAsString.add(field.title);
    }
    prefs.setStringList('selectedFields', selectedAsString);
    print(prefs.getStringList('selectedFields'));
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