import 'package:snowscoop/models/enums/regions.dart';

class Field {
  String _title;
  String _url;

  String get title => _title;
  String get url => _url;

  Field(this._title, this._url);
}