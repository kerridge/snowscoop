import 'package:snowscoop/models/enums/regions.dart';

class Field {
  String _title;
  String _url;

  Map<String, List> weather = {
    'SNOW': null,
    'RAIN': null,
  };

  String get title => _title;
  String get url => _url;

  // List<int> get snowData => _snowData;
  // List<int> get rainData => _rainData;

  Field(this._title, this._url);
}