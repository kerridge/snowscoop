import 'package:snowscoop/models/ski-field.dart';

class Fields {

  List<String> names = [];

  List<Field> allFields = new List<Field>();

  /// takes a list of `Field` to store and builds an array of field names
  Fields(this.allFields){allFields.forEach((f) => names.add(f.title));}


  /// returns a `Field` based on field.name + name searched
  Field getFieldByName(String name) {
    for (Field field in allFields) {
      if (field.title == name) return field;
    }
    return null;
  }

  /// returns a list of `Field` objects matching the region passed
  List<Field> getFieldsByRegion(String region) {
    List<Field> list = new List<Field>();

    for (Field field in allFields) {
      if (field.region == region) list.add(field);
    }

    return list;
  }

  String toString() {
    return names.toString();
  }
}