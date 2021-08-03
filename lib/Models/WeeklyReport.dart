import 'dart:convert';

import 'package:plant_it_forward/Models/Order.dart';
import 'package:plant_it_forward/Models/ProduceAvailability.dart';

class WeeklyReport {
  String id;
  DateTime date;
  String farmId;
  String farmName;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProduceAvailability? availability;
  ProduceAvailability? harvest;
  Order? order;
  WeeklyReport({
    required this.id,
    required this.date,
    required this.farmId,
    required this.farmName,
    this.createdAt,
    this.updatedAt,
    this.availability,
    this.harvest,
    this.order,
  });

  WeeklyReport copyWith({
    String? id,
    String? farmId,
    String? farmName,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProduceAvailability? availability,
    ProduceAvailability? harvest,
    Order? order,
  }) {
    return WeeklyReport(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      availability: availability ?? this.availability,
      harvest: harvest ?? this.harvest,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'farmName': farmName,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'availability': availability?.toMap(),
      'harvest': harvest?.toMap(),
      'order': order?.toMap(),
    };
  }

  factory WeeklyReport.fromMap(Map<String, dynamic> map) {
    return WeeklyReport(
      id: map['id'],
      farmId: map['farmId'],
      farmName: map['farmName'],
      date: (map['date']).toDate(),
      createdAt: (map['createdAt'])?.toDate(),
      updatedAt: (map['updatedAt'])?.toDate(),
      availability: map['availability'] != null
          ? ProduceAvailability.fromMap(map['availability'])
          : null,
      harvest: map['harvest'] != null
          ? ProduceAvailability.fromMap(map['harvest'])
          : null,
      order: map['order'] != null ? Order.fromMap(map['order']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'WeeklyReport(id: $id, date: $date, createdAt: $createdAt, updatedAt: $updatedAt, availability: $availability, harvest: $harvest, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeeklyReport &&
        other.id == id &&
        other.date == date &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.availability == availability &&
        other.harvest == harvest &&
        other.order == order;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        availability.hashCode ^
        harvest.hashCode ^
        order.hashCode;
  }
}
