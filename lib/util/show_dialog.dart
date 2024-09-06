import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ddudu/util/fn_calendar.dart';
import 'package:ddudu/util/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/event.dart';
import '../provider/store.dart';
import 'fn_firebase.dart';

showAlertDialog(context, msg){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('알림'),
      content: Text(msg.toString()),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인')),
      ],
    ),
  );
}

showFnDialog(context, msg, callback){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('알림'),
      content: Text(msg.toString()),
      actions: [
        ElevatedButton(
            onPressed: () => callback,
            child: const Text('확인')),
      ],
    ),
  );
}

showConfirmDialog(context, msg, callback){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('알림'),
      content: Text(msg.toString()),
      actions: [
        ElevatedButton(
            onPressed: () => callback,
            child: const Text('확인')),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소')),
      ],
    ),
  );
}

Future<dynamic> showCreateDialog(BuildContext context, pvSelectedDay) async {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _yearController = TextEditingController(text:DateFormat("yyyy").format(pvSelectedDay));
  final TextEditingController _monthController = TextEditingController(text:DateFormat("MM").format(pvSelectedDay));
  final TextEditingController _dayController = TextEditingController(text:DateFormat("dd").format(pvSelectedDay));

  String topic = "";
  String description = "";
  String year = "";
  String month = "";
  String day = "";
  String color = "";
  String complete = "0";

  // 색상 초기값 정의
  Color pickerColor = Colors.blue;
  Color currentColor = Colors.blue;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {

        // 색상 변경 함수
        changeColor(color) {
          setState(() => pickerColor = color);
        }

        return AlertDialog(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          actionsPadding: const EdgeInsets.all(15),
          title: const Text('일정등록', style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800,
          )),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '일정명을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    topic = value!;
                  },
                  decoration: const InputDecoration(
                    labelText: "일정명",
                    hintText: "일정명을 입력해주세요.",
                    //counterText: ''
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLength: 100,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '일정내용을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    labelText: "일정내용",
                    hintText: "일정내용을 입력해주세요.",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    //counterText: ''
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 180) * 0.3,
                      child: TextFormField(
                        readOnly: true,
                        controller: _yearController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '년도';
                          }
                          return null;
                        },
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: context.read<Store>().pvSelectedDay,
                            firstDate: kFirstDay,
                            lastDate: kLastDay,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  appBarTheme: const AppBarTheme(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              _yearController.text = DateFormat('yyyy').format(selectedDate);
                              _monthController.text = DateFormat('MM').format(selectedDate);
                              _dayController.text = DateFormat('dd').format(selectedDate);
                            }
                          });
                        },
                        onSaved: (value) {
                          year = value!;
                        },
                        decoration: const InputDecoration(
                          hintText: "년도",
                        ),
                      ),
                    ),SizedBox(
                      width: (MediaQuery.of(context).size.width - 180) * 0.3,
                      child: TextFormField(
                        readOnly: true,
                        controller: _monthController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '월';
                          }
                          return null;
                        },
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: context.read<Store>().pvSelectedDay,
                            firstDate: kFirstDay,
                            lastDate: kLastDay,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  appBarTheme: const AppBarTheme(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              _yearController.text = DateFormat('yyyy').format(selectedDate);
                              _monthController.text = DateFormat('MM').format(selectedDate);
                              _dayController.text = DateFormat('dd').format(selectedDate);
                            }
                          });
                        },
                        onSaved: (value) {
                          month = value!;
                        },
                        decoration: const InputDecoration(
                          hintText: "월",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 180) * 0.3,
                      child: TextFormField(
                        readOnly: true,
                        controller: _dayController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '일';
                          }
                          return null;
                        },
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: context.read<Store>().pvSelectedDay,
                            firstDate: kFirstDay,
                            lastDate: kLastDay,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  appBarTheme: const AppBarTheme(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              _yearController.text = DateFormat('yyyy').format(selectedDate);
                              _monthController.text = DateFormat('MM').format(selectedDate);
                              _dayController.text = DateFormat('dd').format(selectedDate);
                            }
                          });
                        },
                        onSaved: (value) {
                          day = value!;
                        },
                        decoration: const InputDecoration(
                          hintText: "일",
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text("색상", style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Raleway',
                        )),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: currentColor,
                          ),
                        ),
                        Container(
                            width: 100,
                            height: 35,
                            margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: ElevatedButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('색상을 선택하세요.'),
                                      content: SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: changeColor,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('색 선택'),
                                          onPressed: () {
                                            setState(() => currentColor = pickerColor);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              , child: const Text('색상선택')
                            )
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소')
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final id = FirebaseFirestore.instance.collection('party').doc().id;
                    var result = createCalendarData(
                        Event(
                          id: id,
                          topic: topic,
                          description: description,
                          year: year,
                          month: month,
                          day: day,
                          color: "0x${currentColor.toHexString()}",
                          completeYn: complete,
                          insId: getUserId().toString(),
                          insDt: Timestamp.now(),
                          fullDate: Timestamp.fromDate(DateTime(int.parse(year), int.parse(month), int.parse(day))),
                        )
                    );

                    result.catchError((onError) {
                      debugPrint("CreteData Error : $onError");
                    }).then((val){
                      debugPrint("CreteData");
                      context.read<Store>().chgKEvents(context.read<Store>().pvSelectedDay);
                    }).whenComplete(() {
                      debugPrint("CreteData whenComplete");
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: const Text('확인')),
          ],
        );
      });
    }
  );
}

showCalendarDetailDialog(BuildContext context, Event data){
  debugPrint(data.toString());
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 8,
                  backgroundColor: Color(int.parse(data.color)),
                ),
                const SizedBox(width: 12,),
                Text(data.topic, style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    decoration: (data.completeYn == '0')
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                    ),
                ),
                const SizedBox(width: 10,),
                const Expanded(flex: 1, child: Divider(thickness: 1,color: Colors.grey),),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.calendarMinus,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text("${data.month}월 ${data.day}일",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              children: [
                Text(data.description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: (){
                    String flag = "";

                    if(data.completeYn == "0"){
                      flag = "1";
                    }else{
                      flag = "0";
                    }

                    var result = updateCalendarComplete(data.id, flag);

                    result.catchError((onError) {
                      debugPrint("UpdateData Error : $onError");
                    }).then((val){
                      debugPrint("UpdateData");
                      context.read<Store>().chgKEvents(context.read<Store>().pvSelectedDay);
                    }).whenComplete(() {
                      Navigator.of(context).pop();
                      debugPrint("UpdateData whenComplete");
                    });
                  },
                  icon: FaIcon(
                    (data.completeYn == '0')
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circleCheck,
                  ),
                  color: (data.completeYn == '0')
                      ? Colors.grey
                      : Colors.green,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text("완료",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              var result = deleteCalendarComplete(data.id);

              result.catchError((onError) {
                debugPrint("deleteData Error : $onError");
              }).then((val){
                debugPrint("deleteData");
                context.read<Store>().chgKEvents(context.read<Store>().pvSelectedDay);
              }).whenComplete(() {
                Navigator.of(context).pop();
                debugPrint("deleteData whenComplete");
              });
            },
            child: InkWell(
              child: Container(
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("삭제",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Raleway'
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),
        ],
      )
    ),
  );
}