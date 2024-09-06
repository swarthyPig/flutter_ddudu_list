import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/event.dart';
import '../provider/store.dart';
import '../util/fn_firebase.dart';
import '../util/show_dialog.dart';

class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {

  var scroll = ScrollController();
  DateTime selectDay = DateTime.now();
  List<Event> data = List.empty();

  @override
  void initState() {
    super.initState();

    selectDay = context.read<Store>().pvSelectedDay;
    data = context.read<Store>().kEvents[selectDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(45, 30, 55, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat("yyyy년M월d일").format(selectDay), style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
              ),),
              const FaIcon(
                FontAwesomeIcons.calendarMinus,
                color: Colors.grey,
                size: 23,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            color: const Color(0xffe4eef5),
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: ListView.builder(
                itemCount: data.length,
                controller: scroll,
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(2,4), // changes position of shadow

                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: (){
                                String flag = "";

                                if(data[index].completeYn == "0"){
                                  flag = "1";
                                }else{
                                  flag = "0";
                                }

                                var result = updateCalendarComplete(data[index].id, flag);

                                result.catchError((onError) {
                                  debugPrint("UpdateData Error : $onError");
                                }).then((val){
                                  debugPrint("UpdateData");
                                  context.read<Store>().chgKEvents(context.read<Store>().pvSelectedDay);
                                }).whenComplete(() {
                                  debugPrint("UpdateData whenComplete");
                                });
                              },
                              icon: FaIcon(
                                (data[index].completeYn == '0')
                                    ? FontAwesomeIcons.circleCheck
                                    : FontAwesomeIcons.circleCheck,
                              ),
                              color: (data[index].completeYn == '0')
                                  ? Colors.grey
                                  : Colors.green,
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){ showCalendarDetailDialog(context, data[index]); },
                                child: Text(data[index].topic, style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w500,
                                  decoration: (data[index].completeYn == '0')
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                )
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  var result = deleteCalendarComplete(data[index].id);

                                  result.catchError((onError) {
                                    debugPrint("deleteData Error : $onError");
                                  }).then((val){
                                    debugPrint("deleteData");
                                    context.read<Store>().chgKEvents(context.read<Store>().pvSelectedDay);
                                  }).whenComplete(() {
                                    debugPrint("deleteData whenComplete");
                                  });
                                },
                                icon: const FaIcon(FontAwesomeIcons.trashCan),
                                iconSize: 20,
                                color:Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              })
            ),
          )
        )
      ],
    );
  }
}
