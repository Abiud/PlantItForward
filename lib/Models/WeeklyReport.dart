import 'dart:convert';

import 'package:plant_it_forward/Models/ProduceAvailability.dart';

class WeeklyReport {
  String id;
  String farmId;
  String farmName;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProduceAvailability? availability;
  ProduceAvailability? harvest;
  ProduceAvailability? order;
  ProduceAvailability? purchased;
  WeeklyReport({
    required this.id,
    required this.farmId,
    required this.farmName,
    this.createdAt,
    this.updatedAt,
    this.availability,
    this.harvest,
    this.order,
    this.purchased,
  });

  WeeklyReport copyWith({
    String? id,
    String? farmId,
    String? farmName,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProduceAvailability? availability,
    ProduceAvailability? harvest,
    ProduceAvailability? order,
    ProduceAvailability? purchased,
  }) {
    return WeeklyReport(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      availability: availability ?? this.availability,
      harvest: harvest ?? this.harvest,
      order: order ?? this.order,
      purchased: purchased ?? this.purchased,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'farmName': farmName,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'availability': availability?.toMap(),
      'harvest': harvest?.toMap(),
      'order': order?.toMap(),
      'purchased': purchased?.toMap(),
    };
  }

  factory WeeklyReport.fromMap(Map<String, dynamic> map) {
    return WeeklyReport(
      id: map['id'],
      farmId: map['farmId'],
      farmName: map['farmName'],
      createdAt: (map['createdAt'])?.toDate(),
      updatedAt: (map['updatedAt'])?.toDate(),
      availability: map['availability'] != null
          ? ProduceAvailability.fromMap(map['availability'])
          : null,
      harvest: map['harvest'] != null
          ? ProduceAvailability.fromMap(map['harvest'])
          : null,
      order: map['order'] != null
          ? ProduceAvailability.fromMap(map['order'])
          : null,
      purchased: map['purchased'] != null
          ? ProduceAvailability.fromMap(map['purchased'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'WeeklyReport(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, availability: $availability, harvest: $harvest, order: $order, purchased $purchased)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeeklyReport &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.availability == availability &&
        other.harvest == harvest &&
        other.purchased == purchased &&
        other.order == order;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        availability.hashCode ^
        harvest.hashCode ^
        purchased.hashCode ^
        order.hashCode;
  }
}
