import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum for current button
import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/models/all_fields.dart';

import 'package:snowscoop/views/home.dart';
import 'package:snowscoop/network/get_field.dart';


class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}


abstract class HomeState extends State<Home> {
  @protected
  bool scraping = true;
  var _db = new SheetsConnection();

  SharedPreferences _prefs;

  // current button selected - default to snow
  var selected = SelectedButton.SNOW;
  var graphTitle = 'Snowfall (cm)';

  List<Field> _selectedFields = new List<Field>();

  Fields skifields =_initFields();

  List<Field> get selectedFields => _selectedFields;

  // whether to fill the area on the line graph
  bool fillArea = true;


  @override
  void initState() {
    super.initState();

    // get our cached fields then get data for them
    _getSavedFields().then((result){
      List<Field> initialFields =skifields.getFieldsFromString(result);
      
      for (Field field in initialFields){
        fieldSelected(field);
      }
    });
    
    
    print('done');
  }

  // on page teardown
  @override
  void dispose() {
    // close our db client connection
    _db.closeConnection();
    super.dispose();
  }


  /// asynchronous call to get the list of fields from cache
  Future<List<String>> _getSavedFields() async {
    _prefs = await SharedPreferences.getInstance();
    List<String> fieldsString = _prefs.getStringList('selectedFields') ?? ['Treble Cone'];
    return fieldsString;
  }


  /// initializes our list of `Field` objects and appends
  /// them to a `Fields` object.
  static Fields _initFields() {

    List<Field> fields = [
      new Field('Cardrona', 'Otago'),
      new Field('Coronet Peak', 'Otago'),
      new Field('Round Hill', 'Canterbury'),
      new Field('Treble Cone', 'Otago'),
      new Field('Remarkables', 'Otago'),
      new Field('Mount Hutt', 'Canterbury'),
    ];

    return new Fields(fields);
  }


  /// takes a `List<Field>` object and updates their weather values
  /// with data from our sheets backend
  Future updateFieldWeather(Field field) async {
    // make API connection
    await _db.connect()
      .then((dynamic res) { // after connection accepted 
        
        // print('connection accepted');
        
    });
    // get the data from our API
     field = await _db.getFieldWeather(field);
    
    // tell the UI we aren't in a call anymore
    setState(() => scraping = false);
    
    // let the field know we have completed a request
    field.hasData = true;
  }


  /// takes a field and caches it to device
  /// then updates the state to represent new graph
  @protected
  void fieldSelected(Field field) async {
    _prefs = await SharedPreferences.getInstance();
    List<String> selectedAsString = new List<String>();
    // if we don't have data yet, make API call
    if (!field.hasData) updateFieldWeather(field);
    setState(() {
      _selectedFields.contains(field)
        ? _selectedFields.remove(field)
        : _selectedFields.add(field);
    });
    for (Field field in _selectedFields){
      selectedAsString.add(field.title);
    }
    _prefs.setStringList('selectedFields', selectedAsString);
    print(_prefs.getStringList('selectedFields'));
  }


  /// switches the selected button and displays new data
  @protected
  void switchButton(String title) {
    switch (title) {
      case "SNOW":
        setState(() { 
          selected =SelectedButton.SNOW;
          fillArea =true;
          graphTitle = 'Snowfall (cm)';
        });
        break;
      case "RAIN":
        setState(() { 
          fillArea =true;
          selected =SelectedButton.RAIN;
          graphTitle = 'Rainfall (mm)';
        });
        break;
      case "CHILL":
        setState(() { 
          fillArea =false;
          selected =SelectedButton.CHILL;
          graphTitle = 'Wind Chill (\u00B0C)';
        });
        break;
      case "MIN":
        setState(() { 
          fillArea =false;
          selected =SelectedButton.MIN;
          graphTitle = 'Min Temp (\u00B0C)';
        });
        break;
      case "MAX":
        setState(() { 
          fillArea =false;
          selected =SelectedButton.MAX;
          graphTitle = 'Max Temp (\u00B0C)';
        });
        break;
      default:
        break;
    }
  }
}