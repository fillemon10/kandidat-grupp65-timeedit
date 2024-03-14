import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class BookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookingTabBar(
      today: DateTime.now(),
    );
  }
}

class BookingTabBar extends StatefulWidget {
  final DateTime today;

  const BookingTabBar({Key? key, required this.today}) : super(key: key);

  @override
  _BookingTabBarState createState() => _BookingTabBarState();
}

class _BookingTabBarState extends State<BookingTabBar> {
  late DateTime _today;
  late List<DateTime> _tabDays;
  late int _initialTabIndex = 0; // Initialize _initialTabIndex to 0

  @override
  void initState() {
    super.initState();
    _today = widget.today;
    _generateTabDays();
    _initialTabIndex = _getInitialTabIndex();
  }

  void _generateTabDays() {
    _tabDays = [];
    for (int i = 0; i < 14; i++) {
      _tabDays.add(_today.add(Duration(days: i)));
    }
  }

  int _getInitialTabIndex() {
    for (int i = 0; i < _tabDays.length; i++) {
      if (_tabDays[i].year == _today.year &&
          _tabDays[i].month == _today.month &&
          _tabDays[i].day == _today.day) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _initialTabIndex,
      length: _tabDays.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.calendar_month_sharp),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: _today,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2025),
                ).then((DateTime? newSelectedDay) {
                  if (newSelectedDay != null) {
                    setState(() {
                      _today = newSelectedDay;
                      _generateTabDays();
                      _initialTabIndex = _getInitialTabIndex();
                    });
                    // Navigate to the selected tab
                    DefaultTabController.of(context)!
                        .animateTo(_initialTabIndex);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {
                context.push('/filter');
              },
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabDays.map((day) {
              return Tab(
                text: _formatDate(day),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabDays.map((day) {
            return Center(
              child: Text(_formatDate(day)),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _generateMoreTabs() {
    setState(() {
      for (int i = 0; i < 7; i++) {
        _tabDays.add(_tabDays.last.add(Duration(days: i + 1)));
      }
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE dd MMM').format(date);
  }
}
