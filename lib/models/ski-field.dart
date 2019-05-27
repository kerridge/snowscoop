import 'package:snowscoop/models/enums/regions.dart';

class Field {
  String _title;
  String _region;

  List<dynamic> rain;
  List<dynamic> snow;
  List<dynamic> max;
  List<dynamic> min;
  List<dynamic> chill;


  String get title => _title;
  String get region => _region;

  Field(this._title, this._region);
}