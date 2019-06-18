class Field {
  String _title;
  String _region;
  bool hasData;

  List<dynamic> mockData;

  List<dynamic> rain;
  List<dynamic> snow;
  List<dynamic> max;
  List<dynamic> min;
  List<dynamic> chill;
  
  List<dynamic> coords;

  Map<String, List<dynamic>> getWeatherMapped() {
    if (rain !=null) {
      return {
        'RAIN':rain,
        'SNOW':snow,
        'MAX':max,
        'MIN':min,
        'CHILL':chill
      };
    }
    return {
        'RAIN':mockData,
        'SNOW':mockData,
        'MAX':mockData,
        'MIN':mockData,
        'CHILL':mockData
      };
  }

  String get title => _title;
  String get region => _region;

  Field(this._title, this._region) {
    mockData = new List.generate(21, (_) => 0);
    this.hasData = false;
  }
}