import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Expense {
  String id = '';
  String value;
  String time = '';
  String name;

  Expense({required this.name, required this.value}) {
    id = const Uuid().v4();
    time = DateFormat('dd.MM.yyyy HH:MM').format(DateTime.now()).toString();
  }

  Expense.complete(this.id, this.time, this.name, this.value);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "time": time,
      "name": name,
      "value": value,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense.complete(
      json['id'] as String,
      json['time'] as String,
      json['name'] as String,
      json['value'] as String,
    );
  }
}
