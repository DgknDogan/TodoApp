import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TodoCategoryEnum {
  @JsonValue("Work")
  work(
    color: Color(0xffFFCC80),
    text: "Work",
    icon: Icon(
      Icons.work,
      color: Color(0xffA36200),
    ),
  ),
  @JsonValue("Home")
  home(
      color: Color(0xffFF8080),
      text: "Home",
      icon: Icon(
        Icons.home,
        color: Color(0xffA30000),
      )),
  @JsonValue("University")
  university(
      color: Color(0xff809CFF),
      text: "University",
      icon: Icon(
        Icons.school,
        color: Color(0xff0055A3),
      ));

  final Color color;
  final String text;
  final Icon icon;

  const TodoCategoryEnum({
    required this.color,
    required this.text,
    required this.icon,
  });

  static TodoCategoryEnum getCategoryByText(String text) {
    for (var category in TodoCategoryEnum.values) {
      if (category.text == text) {
        return category;
      }
    }
    throw "Category not found";
  }
}
