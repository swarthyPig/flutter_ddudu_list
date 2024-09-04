import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String topic;
  final String description;
  final String year;
  final String month;
  final String day;
  final String color;
  final String completeYn;
  final String insId;
  final Timestamp insDt;
  final Timestamp fullDate;

  Event({
    required this.topic
    , required this.description
    , required this.year
    , required this.month
    , required this.day
    , required this.color
    , required this.completeYn
    , required this.insId
    , required this.insDt
    , required this.fullDate});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      topic : json["topic"],
      description: json["description"],
      year: json["year"],
      month: json["month"],
      day: json["day"],
      color: json["color"],
      completeYn: json["completeYn"],
      insId: json["insId"],
      insDt: json["insDt"],
      fullDate: json["fullDate"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "topic": topic,
      "description": description,
      "year": year,
      "month": month,
      "day": day,
      "color": color,
      "completeYn": completeYn,
      "insId": insId,
      "insDt": insDt,
      "fullDate": fullDate,
    };
  }
}