import 'package:snowscoop/models/enums/regions.dart';

class Field {
  String _title;
  String _url;

  List<int> snowData = new List(20);
  List<int> rainData = new List(20);

  String get title => _title;
  String get url => _url;

  // List<int> get snowData => _snowData;
  // List<int> get rainData => _rainData;

  Field(this._title, this._url);
}