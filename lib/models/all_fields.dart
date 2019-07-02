import 'package:snowscoop/models/ski-field.dart';

class Fields {
  
  List<Region> regions = new List<Region>();
  List<Field> allFields = new List<Field>();

  /// takes a list of `Field` to store and builds an array of field names
  Fields(this.allFields) {
    for (Field f in allFields) {
      addToRegion(f);
    }
  } 


  // grab field objects based on string list from cache
  List<Field> getFieldsFromString(List<String> names){
    List<Field> output = new List<Field>();
    for (String fieldName in names){
      for (Region region in regions){
        for (Field field in region.fields){
          if (field.title == fieldName) output.add(field); 
        }
      }
    }
    return output;
  }


  /// returns a `Field` based on field.name + name searched
  Field getFieldByName(String name) {
    for (Field field in allFields) {
      if (field.title == name) return field;
    }
    return null;
  }

  /// adds `Field` to `Region`
  addToRegion(Field field) {
    for (Region region in regions){
      if (region.region == field.region){
        region.fields.add(field);
        return;
      } 
    }
    Region newRegion = new Region(field, field.region);
    regions.add(newRegion);
  }

  /// returns a `Region` object matching the region passed
  Region getRegion(String region) {
    for (Region r in regions){
      if (r.region == region) return r;
    }

    return new Region.empty();
  }
}


class Region{
  List<Field> fields = new List<Field>();
  String region;

  //empty constructer
  Region.empty();

  Region(Field field, this.region){
    fields.add(field);
  }
  
}
