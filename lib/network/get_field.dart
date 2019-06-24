import 'package:snowscoop/models/ski-field.dart';

import 'package:http/http.dart' as http; // Contains a client for making API calls
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SheetsConnection {

  auth.AuthClient client;
  sheets.SheetsApi api; 

  // default constructor
  SheetsConnection();

  // the key from our spreadsheets url, needed to connect
  static const _SHEET_KEY = '18kc6EsRQuMGBw2JtIoTzeVNTTd0w2xAmWQ3cfHifmrI';

  Future<Map<String,dynamic>> getAPIKey() async {
    var temp = await rootBundle.loadString('drive_creds.json');
    var val = jsonDecode(temp);
    return val;
  }

  Future connect() async {
    
    // which Google API to use
    const _SCOPES = const [sheets.SheetsApi.SpreadsheetsScope];

    final _key = await getAPIKey();

    print('Attempting Google OAuth Connection...');
    try{
      await auth
        .obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(_key),
            _SCOPES,
            http.Client())
        .then((auth.AccessCredentials cred) {
          print('Connection Accepted');

          client = auth.authenticatedClient(http.Client(), cred);
          api = new sheets.SheetsApi(client);
          return;
        });
    } on Exception catch(e) {
      print(e.toString());
      print('Connection Refused');
      return;
    }
  }


  /// retreives all weather values and updates the model passed by reference
  Future<Field> getFieldWeather(Field field) async {
    List<String> ranges = [
      '${field.title}!B1:V1',
      '${field.title}!B2:V2',
      '${field.title}!B3:V3',
      '${field.title}!B4:V4',
      '${field.title}!B5:V5',
      '${field.title}!B6:C6'
    ];

    print('Retreiving values');
    await api.spreadsheets.values
      .batchGet(_SHEET_KEY, ranges: ranges)
      .then((sheets.BatchGetValuesResponse r) {

        field.rain = _cleanValuesInt(r.valueRanges[0], false);
        field.snow = _cleanValuesInt(r.valueRanges[1], false);
        field.max =_cleanValuesInt(r.valueRanges[2], false);
        field.min =_cleanValuesInt(r.valueRanges[3], false);
        field.chill =_cleanValuesInt(r.valueRanges[4], false);

        field.coords =_cleanValuesInt(r.valueRanges[5], true);

        print('GET request for ${field.title} completed');
      });

    return field;
  }



  /// Takes the response object and transforms to List<int>
  List<dynamic> _cleanValuesInt(dynamic res, bool isDouble) {
    List<dynamic> list = res.values[0]
      .toList()
      .map((val) => !isDouble ? int.parse(val) :double.parse(val))
      .toList();

    return list;
  }
  
  
  // /// Takes the response object and transforms to List<double>
  // List<dynamic> _cleanValuesDouble(dynamic res) {
  //   List<dynamic> list = res.values[0]
  //     .toList()
  //     .map((val) => double.parse(val))
  //     .toList();

  //   return list;
  // }

  void closeConnection(){
    print('Closing Connection');
    client.close();
  }
}