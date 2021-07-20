import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String content;
  String idFrom;
  String idTo;
  bool read;
  DateTime timestamp;
  DocumentReference? reference;
  int? listIndex;
  bool? edited;
  Message(
      {required this.id,
      required this.content,
      required this.idFrom,
      required this.idTo,
      required this.read,
      required this.timestamp,
      this.reference,
      this.listIndex,
      this.edited});

  Message copyWith(
      {String? id,
      String? content,
      String? idFrom,
      String? idTo,
      bool? read,
      DateTime? timestamp,
      DocumentReference? reference,
      int? listIndex,
      bool? edited}) {
    return Message(
        id: id ?? this.id,
        content: content ?? this.content,
        idFrom: idFrom ?? this.idFrom,
        idTo: idTo ?? this.idTo,
        read: read ?? this.read,
        timestamp: timestamp ?? this.timestamp,
        reference: reference ?? this.reference,
        listIndex: listIndex ?? this.listIndex,
        edited: edited ?? this.edited);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'idFrom': idFrom,
      'idTo': idTo,
      'read': read,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'reference': reference,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map, String id,
      DocumentReference reference, int? listIndex) {
    return Message(
        id: id,
        content: map['content'],
        idFrom: map['idFrom'],
        idTo: map['idTo'],
        read: map['read'],
        reference: reference,
        listIndex: listIndex,
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(int.parse(map['timestamp'])),
        edited: map["edited"]);
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Message(id: $id, content: $content, idFrom: $idFrom, idTo: $idTo, read: $read, timestamp: $timestamp, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.content == content &&
        other.idFrom == idFrom &&
        other.idTo == idTo &&
        other.read == read &&
        other.timestamp == timestamp &&
        other.reference == reference;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        idFrom.hashCode ^
        idTo.hashCode ^
        read.hashCode ^
        timestamp.hashCode ^
        reference.hashCode;
  }
}
