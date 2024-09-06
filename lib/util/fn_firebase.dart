import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:collection/collection.dart";
import 'package:ddudu/util/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../model/event.dart';

final fireStore = FirebaseFirestore.instance;
final CollectionReference events = fireStore.collection('calendar');
final List<Event> _events = [];
List<Event> get eventsList => _events;

Future<LinkedHashMap<DateTime, List<Event>>> selectCalendarData(DateTime currDay) async {
  try {

    LinkedHashMap<DateTime, List<Event>> finalData = LinkedHashMap<DateTime, List<Event>>();

    QuerySnapshot querySnapshot = await events
      .where("insId", isEqualTo: getUserId().toString())
      .where('year', isEqualTo: DateFormat('yyyy').format(currDay))
      .where('month', isEqualTo: DateFormat('MM').format(currDay))
      .orderBy('fullDate', descending: true)
      .get();
    _events.clear();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Event event = Event(
        id: doc['id'],
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
    debugPrint('일정 가져오는 중 오류 발생: $e');
    rethrow;
  }
}

Future<void> createCalendarData(Event model) async{
  try {
    await events.doc(model.id).set(model.toJson());
    _events.add(model);
  } catch (e) {
    debugPrint('일정 등록 중 오류 발생: $e');
  }
}

Future<void> updateCalendarComplete(String id, String flag) async{
  try {

    bool documentExists =
    await events.doc(id).get().then((doc) => doc.exists);

    if (documentExists) {
      await events.doc(id).update({"completeYn": flag});
    } else {
      debugPrint('ID가 $id인 문서가 존재하지 않습니다.');
    }
  } catch (e) {
    debugPrint('일정 업데이트 중 오류 발생: $e');
  }
}

Future<void> deleteCalendarComplete(String id) async {
  try {
    bool documentExists =
    await events.doc(id).get().then((doc) => doc.exists);

    if (documentExists) {
      await events.doc(id).delete();

    } else {
      debugPrint('ID가 $id인 문서가 존재하지 않습니다.');
    }
  } catch (e) {
    debugPrint('일정 삭제 중 오류 발생: $e');
  }
}
