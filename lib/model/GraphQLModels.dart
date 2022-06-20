
class SortedInput {
  String id;
  bool desc;

  SortedInput(this.id, this.desc);

  toJson() {
    return {
      'id': id,
      'desc': desc,
    };
  }
}

class FilteredInput {
  String id, value, operation;
//  bool ne;

//  FilteredInput(this.id, this.value);
  FilteredInput(this.id, this.value, this.operation);

  toJson() {
    return {
      'id': id,
      'value': value,
      'operation': operation,
    };
  }
}