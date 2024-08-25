import 'package:ddudu/util/fn_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/store.dart';

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

showCreateDialog(context, pvSelectedDay){
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _yearController = TextEditingController(text:DateFormat("yyyy").format(pvSelectedDay));
  final TextEditingController _monthController = TextEditingController(text:DateFormat("MM").format(pvSelectedDay));
  final TextEditingController _dayController = TextEditingController(text:DateFormat("dd").format(pvSelectedDay));

  String topic = "";
  String description = "";
  int year = 0;
  int month = 0;
  int day = 0;
  String color = "";
  String complete = "0";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
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
            TextFormField(
              maxLength: 100,
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
                labelText: "일정내용",
                hintText: "일정내용을 입력해주세요.",
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
                      year = value! as int;
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
                      month = value! as int;
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
                      day = value! as int;
                    },
                    decoration: const InputDecoration(
                      hintText: "일",
                    ),
                  ),
                )
              ],
            ),
            TextFormField(
              maxLength: 100,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return '일정내용을 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                color = value!;
              },
              decoration: const InputDecoration(
                labelText: "색상",
                hintText: "일정내용을 입력해주세요.",
                //counterText: ''
              ),
            ),
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

              //Event model = new Event(topic, description, year, month, day, color, complete)
            }
          },
          child: const Text('확인')),
      ],
    ),
  );
}