import 'package:snowscoop/models/enums/regions.dart';

class Field {
  String _title;
  String _url;

  Map<String, List> weather = {
    'SNOW': null,
    'RAIN': null,
  };

  List<dynamic> rain;
  List<dynamic> snow;
  List<dynamic> max;
  List<dynamic> min;
  List<dynamic> chill;

  String get title => _title;
  String get url => _url;

  // List<int> get snowData => _snowData;
  // List<int> get rainData => _rainData;

  Field(this._title, this._url);
}