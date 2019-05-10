import 'dart:convert'; // Contains the JSON encoder

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements

var scrapeURL = 'https://www.snow-forecast.com/resorts/Cardrona/6day/mid';
var rainQuery = 'td.rainy > b > span.rain';

Future initiate() async {
  var client = Client();
  Response res = await client.get(
    scrapeURL
  );
// td.rainy:nth-child(4) > b:nth-child(1) > span:nth-child(1)
// tr.lar td.rainy.day-end b span.rain

  // Use html parser and query selector
  var document = parse(res.body);
  List<Element> temps = document.querySelectorAll(rainQuery);

  // JSON map
  List<Map<String, dynamic>> linkMap = [];

  for (var temp in temps) {
    if(temp.text == '-'){
      temp.text = '0';
    }
    linkMap.add({
      'temp': temp.text,
    });
  }

  return json.encode(linkMap);
}