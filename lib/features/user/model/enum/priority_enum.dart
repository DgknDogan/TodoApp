import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PriorityEnum {
  @JsonValue(1)
  low(value: 1, text: "trivial"),
  @JsonValue(2)
  mid(value: 2, text: "important"),
  @JsonValue(3)
  high(value: 3, text: "urgent");

  final int value;
  final String text;

  const PriorityEnum({required this.value, required this.text});

  static PriorityEnum getPriorityByValue(int value) {
    for (var priority in PriorityEnum.values) {
      if (priority.value == value) {
        return priority;
      }
    }
    throw "Priority not found";
  }
}
