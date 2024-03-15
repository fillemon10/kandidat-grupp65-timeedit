import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

const int AMOUNT_OF_DAYS = 14; // Global variable for the number of tab days

class BookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AMOUNT_OF_DAYS + 1,
      child: BookingTabBar(
        today: DateTime.now(),
      ),
    );
  }
}

class BookingTabBar extends StatefulWidget {
  final DateTime today;

  const BookingTabBar({Key? key, required this.today}) : super(key: key);

  @override
  _BookingTabBarState createState() => _BookingTabBarState();
}

class _BookingTabBarState extends State<BookingTabBar>
    with TickerProviderStateMixin {
  late DateTime _selectedDate;
  late List<DateTime> _tabDays;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.today;
    _generateTabDays(_selectedDate);
    _tabController = TabController(
      length: AMOUNT_OF_DAYS + 1,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _selectedDate = _tabDays[_tabController.index];
    });
  }

  void _generateTabDays(DateTime selectedDate) {
    _tabDays = List.generate(
        AMOUNT_OF_DAYS + 1, (i) => selectedDate.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: AMOUNT_OF_DAYS)),
                initialDate: _selectedDate,
              );
              _onDatePicked(picked);
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
          controller: _tabController,
          tabs: _tabDays.map((day) => Tab(text: _formatDate(day))).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabDays.map((day) {
          return Center(
            child: Text(
              'Bookings for ${_formatDate(day)}',
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    //if date is today, return 'Today'
    if (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day) {
      return 'Today';
    }
    //if date is tomorrow, return 'Tomorrow'
    if (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day + 1) {
      return 'Tomorrow';
    }
    //else return the date in the format 'EEE dd MMM'
    return DateFormat('EEE dd MMM').format(date);
  }

  void _onDatePicked(DateTime? picked) {
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        DateTime today = DateTime.now();
        int dayBetween = _selectedDate.difference(today).inDays;
        // Check if 'picked' is later today and add 1 if so
        if (_selectedDate.isAfter(today)) {
          dayBetween += 1;
        }
        _tabController.animateTo(dayBetween);
      });
    }
  }
}
