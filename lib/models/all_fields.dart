import 'package:snowscoop/models/ski-field.dart';

class Fields {
  List<String> names = [];
  List<String> regions = [];

  List<Field> allFields = new List<Field>();

  /// takes a list of `Field` to store and builds an array of field names
  Fields(this.allFields) {
    for (Field f in allFields) {
      names.add(f.title);
      _updateRegion(f.region);
    }
  }

  /// returns a `Field` based on field.name + name searched
  Field getFieldByName(String name) {
    for (Field field in allFields) {
      if (field.title == name) return field;
    }
    return null;
  }

  /// takes a `region` and adds to `regions` if not already there
  _updateRegion(String region) {
    if (!regions.contains(region)) regions.add(region);
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
