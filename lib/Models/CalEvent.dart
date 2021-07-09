import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:plant_it_forward/Models/UserData.dart';

class CalEvent {
  String title;
  String? description;
  DateTime startDateTime;
  DateTime startDate;
  DateTime? endDateTime;
  DateTime? endDate;
  bool needVolunteers = false;
  List<UserData>? volunteers;
  String userId;
  String id;

  CalEvent({
    required this.title,
    this.description,
    required this.startDateTime,
    required this.startDate,
    this.endDateTime,
    this.endDate,
    required this.needVolunteers,
    this.volunteers,
    required this.userId,
    required this.id,
  });

  CalEvent copyWith({
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? startDate,
    DateTime? endDateTime,
    DateTime? endDate,
    bool? needVolunteers,
    List<UserData>? volunteers,
    String? userId,
    String? id,
  }) {
    return CalEvent(
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      startDate: startDate ?? this.startDate,
      endDateTime: endDateTime ?? this.endDateTime,
      endDate: endDate ?? this.endDate,
      needVolunteers: needVolunteers ?? this.needVolunteers,
      volunteers: volunteers ?? this.volunteers,
      userId: userId ?? this.userId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDateTime': startDateTime.millisecondsSinceEpoch,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDateTime': endDateTime?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'needVolunteers': needVolunteers,
      'volunteers': volunteers?.map((x) => x.toMap()).toList(),
      'userId': userId,
      'id': id,
    };
  }

  factory CalEvent.fromMap(Map<String, dynamic> map) {
    return CalEvent(
      title: map['title'],
      description: map['description'],
      startDateTime: DateTime.fromMillisecondsSinceEpoch(map['startDateTime']),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDateTime: DateTime.fromMillisecondsSinceEpoch(map['endDateTime']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      needVolunteers: map['needVolunteers'],
      volunteers: List<UserData>.from(
          map['volunteers']?.map((x) => UserData.fromMap(x))),
      userId: map['userId'],
      id: map['id'],
    );
  }

  factory CalEvent.fromSnapshot(String id, Map<String, dynamic> map) {
    return CalEvent(
      title: map['title'],
      description: map['description'],
      startDateTime: (map['startDateTime']).toDate(),
      startDate: (map['startDate']).toDate(),
      endDateTime: (map['endDateTime'])?.toDate(),
      endDate: (map['endDate'])?.toDate(),
      userId: map['userId'],
      needVolunteers: map['needVolunteers'],
      volunteers: map['volunteers'] != null
          ? List<UserData>.from(
              map['volunteers']?.map((x) => UserData.fromMap(x)))
          : map['volunteers'],
      id: id,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalEvent.fromJson(String source) =>
      CalEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CalEvent(title: $title, description: $description, startDateTime: $startDateTime, startDate: $startDate, endDateTime: $endDateTime, endDate: $endDate, needVolunteers: $needVolunteers, volunteers: $volunteers, userId: $userId, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalEvent &&
        other.title == title &&
        other.description == description &&
        other.startDateTime == startDateTime &&
        other.startDate == startDate &&
        other.endDateTime == endDateTime &&
        other.endDate == endDate &&
        other.needVolunteers == needVolunteers &&
        listEquals(other.volunteers, volunteers) &&
        other.userId == userId &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        startDateTime.hashCode ^
        startDate.hashCode ^
        endDateTime.hashCode ^
        endDate.hashCode ^
        needVolunteers.hashCode ^
        volunteers.hashCode ^
        userId.hashCode ^
        id.hashCode;
  }
}
