import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String? id;

  final String title;
  final String notes;

  final bool isCompleted;
  final String date;
  final String starts;
  final String ends;

  final String color;

  final int alert;

  final bool isRemoved;

  Task({
    this.id,
    required this.title,
    required this.notes,
    this.isCompleted = false,
    required this.date,
    required this.starts,
    required this.ends,
    required this.color,
    this.alert = -1,
    this.isRemoved = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        notes,
        isCompleted,
        isRemoved,
        date,
        starts,
        ends,
        color,
        alert,
      ];

  Task copyWith({
    String? id,
    String? title,
    String? notes,
    bool? isCompleted,
    String? date,
    String? starts,
    String? ends,
    String? color,
    int? alert,
    bool? isRemoved,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      starts: starts ?? this.starts,
      ends: ends ?? this.ends,
      color: color ?? this.color,
      alert: alert ?? this.alert,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'isCompleted': isCompleted,
      'date': date,
      'starts': starts,
      'ends': ends,
      'color': color,
      'alert': alert,
      'isRemoved': isRemoved,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      notes: map['notes'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      date: map['date'] ?? '',
      starts: map['starts'] ?? '',
      ends: map['ends'] ?? '',
      color: map['color'] ?? '',
      alert: map['alert']?.toInt() ?? -1,
      isRemoved: map['isRemoved'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
