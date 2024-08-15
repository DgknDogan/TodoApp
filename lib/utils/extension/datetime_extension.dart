import 'package:intl/intl.dart';

extension StringExt on DateTime {
  String get mmed => DateFormat.MMMEd().format(this);
}
