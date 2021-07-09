import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:plant_it_forward/Models/Product.dart';

class ProduceAvailable {
  String farm;
  String farmID;
  String userID;
  DateTime postDateTime;
  DateTime postDate;
  String? comments;
  List<Product> products;

  ProduceAvailable({
    required this.farm,
    required this.farmID,
    required this.userID,
    required this.postDateTime,
    required this.postDate,
    this.comments,
    required this.products,
  });

  ProduceAvailable copyWith({
    String? farm,
    String? farmID,
    String? userID,
    DateTime? postDateTime,
    DateTime? postDate,
    String? comments,
    List<Product>? products,
  }) {
    return ProduceAvailable(
      farm: farm ?? this.farm,
      farmID: farmID ?? this.farmID,
      userID: userID ?? this.userID,
      postDateTime: postDateTime ?? this.postDateTime,
      postDate: postDate ?? this.postDate,
      comments: comments ?? this.comments,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farm': farm,
      'farmID': farmID,
      'userID': userID,
      'postDateTime': postDateTime.millisecondsSinceEpoch,
      'postDate': postDate.millisecondsSinceEpoch,
      'comments': comments,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory ProduceAvailable.fromMap(Map<String, dynamic> map) {
    return ProduceAvailable(
      farm: map['farm'],
      farmID: map['farmID'],
      userID: map['userID'],
      postDateTime: DateTime.fromMillisecondsSinceEpoch(map['postDateTime']),
      postDate: DateTime.fromMillisecondsSinceEpoch(map['postDate']),
      comments: map['comments'],
      products:
          List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProduceAvailable.fromJson(String source) =>
      ProduceAvailable.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProduceAvailable(farm: $farm, farmID: $farmID, userID: $userID, postDateTime: $postDateTime, postDate: $postDate, comments: $comments, products: $products)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProduceAvailable &&
        other.farm == farm &&
        other.farmID == farmID &&
        other.userID == userID &&
        other.postDateTime == postDateTime &&
        other.postDate == postDate &&
        other.comments == comments &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return farm.hashCode ^
        farmID.hashCode ^
        userID.hashCode ^
        postDateTime.hashCode ^
        postDate.hashCode ^
        comments.hashCode ^
        products.hashCode;
  }
}
