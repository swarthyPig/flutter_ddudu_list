import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:collection/collection.dart";
import 'package:ddudu/util/user.dart';
import 'package:flutter/cupertino.dart';

import '../model/event.dart';

final fireStore = FirebaseFirestore.instance;
final CollectionReference events = fireStore.collection('calendar');
final List<Event> _events = [];
List<Event> get eventsList => _events;

Stream<QuerySnapshot> getEventStream() {
  return events.where("insId", isEqualTo: getUserId().toString()).snapshots();
}

Future<LinkedHashMap<DateTime, List<Event>>> selectCalendarData() async {
  try {

    LinkedHashMap<DateTime, List<Event>> finalData = LinkedHashMap<DateTime, List<Event>>();

    QuerySnapshot querySnapshot = await events
      .where("insId", isEqualTo: getUserId().toString())
      .orderBy('fullDate', descending: true)
      .get();
    _events.clear();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Event event = Event(
        topic: doc['topic'],
        description: doc['description'],
        year: doc['year'],
        month: doc['month'],
        day: doc['day'],
        color: doc['color'],
        completeYn: doc['completeYn'],
        insId: doc['insId'],
        insDt: doc['insDt'],
        fullDate: doc['fullDate'],
      );
      _events.add(event);
    }

    finalData.addAll(groupBy(eventsList, (Event obj) => DateTime.parse(obj.fullDate.toDate().toString())));

    return finalData;

  }catch(e){
    debugPrint(e.toString());
    rethrow;
  }
}

Future<void> createCalendarData(Event model) async{
  try {
    await events.add(model.toJson());
    _events.add(model);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> deleteTask(String id) async {
  try {
    bool documentExists =
    await events.doc(id).get().then((doc) => doc.exists);

    if (documentExists) {
      await events.doc(id).delete();

      //_events.removeWhere((task) => task.id == id);

    } else {
      debugPrint('ID가 $id인 문서가 존재하지 않습니다.');
    }
  } catch (e) {
    debugPrint('작업 삭제 중 오류 발생: $e');
  }
}
