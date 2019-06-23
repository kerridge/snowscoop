// import 'package:flutter/material.dart';

// import 'package:flutter/';


List<DateTime> buildDates() {
  var date = DateTime.now();
  List<DateTime> dates = new List();

  if (date.hour >= 0 && date.hour < 8) {
    dates.add(new DateTime(date.year, date.month, date.day, 8));
  } else if(date.hour >= 8 && date.hour < 14){
    dates.add(new DateTime(date.year, date.month, date.day, 14));
  } else if(date.hour >= 14 && date.hour <= 23){
    dates.add(new DateTime(date.year, date.month, date.day, 23));
  }

  for (int i = 0; i < 20; i++) {
      dates.add(dates[i].add(new Duration(hours: 6)));
  }

  return dates;
}