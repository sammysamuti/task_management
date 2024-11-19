import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_management/Screens/Home.dart';
import 'package:task_management/Screens/task_card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime _selectedDate = DateTime.now();
  bool showCompletedTasks = false;
  final ref = FirebaseFirestore.instance.collection('Task');

  DateTime combineDateTime(DateTime date, String timeString) {
    final timeParts = timeString.split(' ');
    final hourMinuteParts = timeParts[0].split(':');
    int hour = int.parse(hourMinuteParts[0]);
    int minute = int.parse(hourMinuteParts[1]);
    final isPm = timeParts[1].toLowerCase() == 'pm';

    if (isPm && hour != 12) {
      hour += 12;
    } else if (!isPm && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Calendar'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendar Section
            Container(
              height: 150,
              color: Colors.grey.shade300,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2099),
                    focusedDay: _selectedDate,
                    calendarFormat: CalendarFormat.week,
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.black),
                      weekendTextStyle: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonTextStyle:
                          const TextStyle(fontSize: 15.0, color: Colors.black),
                      leftChevronIcon:
                          const Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon:
                          const Icon(Icons.chevron_right, color: Colors.black),
                      titleCentered: true,
                      formatButtonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      titleTextStyle: const TextStyle(color: Colors.black),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                    },
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black),
                      weekendStyle: TextStyle(color: Colors.red),
                    ),
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      todayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(20),
            // Toggle Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 146, 145, 145),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showCompletedTasks = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: showCompletedTasks
                                ? Colors.transparent
                                : const Color.fromARGB(255, 65, 64, 65),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'Today',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showCompletedTasks = true;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: showCompletedTasks
                                ? const Color.fromARGB(255, 65, 64, 65)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'Completed',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),
            // Task List Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: ref
                      .where('doc_id', isEqualTo: auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: Colors.deepPurple),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No tasks available'),
                      );
                    }

                    var allTasks = snapshot.data!.docs;

                    var filteredTasks = allTasks.where((task) {
                      var taskDate = DateTime.tryParse(task['date']);

                      bool isToday = taskDate != null &&
                          taskDate.year == _selectedDate.year &&
                          taskDate.month == _selectedDate.month &&
                          taskDate.day == _selectedDate.day;

                      if (showCompletedTasks) {
                        return task['completed'] == true;
                      } else {
                        return isToday && task['completed'] == false;
                      }
                    }).toList();

                    filteredTasks.sort((a, b) {
                      DateTime timeA =
                          combineDateTime(_selectedDate, a['time']);
                      DateTime timeB =
                          combineDateTime(_selectedDate, b['time']);
                      return timeA.compareTo(timeB);
                    });

                    if (filteredTasks.isEmpty) {
                      return const Center(
                        child: Text('No tasks found for the selected criteria'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        var task = filteredTasks[index];
                        return TaskCard(
                          title: task['title'],
                          description: task['description'],
                          time: task['time'],
                          iconCodePoint: task['icon'],
                          isCompleted: task['completed'],
                          id: task.id,
                          priority: task['priority'].toString(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
