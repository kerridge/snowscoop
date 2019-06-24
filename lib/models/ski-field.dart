class Field {
  String _title;
  String _region;
  bool hasData;

  List<dynamic> _mockData;

  List<dynamic> rain;
  List<dynamic> snow;
  List<dynamic> max;
  List<dynamic> min;
  List<dynamic> chill;
  
  List<dynamic> coords;

  /// returns the real weather values or a list of 0's
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
        'RAIN':_mockData,
        'SNOW':_mockData,
        'MAX':_mockData,
        'MIN':_mockData,
        'CHILL':_mockData
      };
  }

  String get title => _title;
  String get region => _region;

  Field(this._title, this._region) {
    _mockData = new List.generate(21, (_) => 0);
    this.hasData = false;
  }
}