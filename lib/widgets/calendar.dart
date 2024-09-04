import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../provider/store.dart';
import '../util/fn_calendar.dart';
import '../util/fn_firebase.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    var result = selectCalendarData();

    result.then((val){
      context.read<Store>().kEvents = val;
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return context.read<Store>().kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      context.read<Store>().pvSelectedDay = selectedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: TableCalendar<Event>(
            locale: 'ko-KR',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            pageJumpingEnabled:true,
            daysOfWeekHeight: 30,
            rowHeight: 40,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextFormatter: (date, locale) =>
                DateFormat("yyyy년 M월").format(date),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
              //leftChevronVisible: false,
              //rightChevronVisible: false,
            ),
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            onRangeSelected: _onRangeSelected,
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                switch(day.weekday){
                  case 1:
                    return const Center(child: Text('월'),);
                  case 2:
                    return const Center(child: Text('화'),);
                  case 3:
                    return const Center(child: Text('수'),);
                  case 4:
                    return const Center(child: Text('목'),);
                  case 5:
                    return const Center(child: Text('금'),);
                  case 6:
                    return const Center(child: Text('토', style: TextStyle(color: Colors.blue),),);
                  case 7:
                    return const Center(child: Text('일', style: TextStyle(color: Colors.red),),);
                }
                return null;
              },
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {

                  // 마커가 5개 이상 나오면 깨짐
                  var arr = [];
                  for (int i = 0; i < events.length; i++) {
                    if(i < 5){
                      arr.add(i);
                    }
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: arr.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          decoration: BoxDecoration(
                            color: events[entry].color.toColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: Container(
            color: const Color(0xfff7fafc),
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(DateFormat("M월 d일").format(_focusedDay), style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                        valueListenable: _selectedEvents,
                        builder: (context, value, _) {
                          return ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  onTap: () => debugPrint(value[index].topic),
                                  title: Text("${value[index].topic} - ${value[index].completeYn}"),
                                ),
                              );
                            },
                          );
                        },
                      ),)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
