import 'dart:convert'; // Contains the JSON encoder

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements

var scrapeURL = 'https://www.snow-forecast.com/resorts/Cardrona/6day/mid';
var _rainQuery = 'td.rainy > b > span.rain';
var _snowQuery = 'td.snowy > b > span.snow';

Future initiate(String weather) async {
  var client = Client();
  String query = _querySwitcher(weather);

  Response res = await client.get(
    scrapeURL
  );

  // Use html parser and query selector
  var document = parse(res.body);
  List<Element> temps = document.querySelectorAll(query);

  // integer list of weather values
  List<int> values = new List(temps.length);

  for(int i = 0; i < temps.length; i++){

    // replace null placeholders
    if (temps[i].text == '-') {
      temps[i].text = '0';
    }
    // TODO: map this
    values[i] = int.parse(temps[i].text);
  }

  return values;
}

String _querySwitcher(String weather) {
  switch (weather) {
    case "SNOW":
      return _snowQuery;
      break;
    case "RAIN":
      return _rainQuery;
      break;
    case "WIND":

      break;
    case "MIN":

      break;
    case "MAX":
      break;
    default:
      break;
  }
  return null;
}

  // For when I need JSON
  
  // // JSON map
  // List<Map<String, dynamic>> linkMap = [];

  // for (var temp in temps) {

  //   // replace null placeholders
  //   if(temp.text == '-'){
  //     temp.text = '0';
  //   }

  //   linkMap.add({
  //     'temp': temp.text,
  //   });
  // }

  // return json.encode(linkMap);