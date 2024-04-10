import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/blocs/booking_bloc.dart';
import 'package:timeedit/screens/booking.dart';
import 'package:timeedit/widgets/filter_drawer.dart';

class BookingTabBar extends StatefulWidget {
  final DateTime today;

  const BookingTabBar({Key? key, required this.today}) : super(key: key);

  @override
  _BookingTabBarState createState() => _BookingTabBarState();
}

class _BookingTabBarState extends State<BookingTabBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late DateTime _selectedDate;
  late List<DateTime> _tabDays;
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

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
    context.read<BookingBloc>().add(FetchBookingData(_selectedDate));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final newSelectedDate = _tabDays[_tabController.index];

    // Only fetch data if not already cached
    if (newSelectedDate != _selectedDate) {
      setState(() {
        _selectedDate = newSelectedDate;
      });
      context.read<BookingBloc>().add(FetchBookingData(_selectedDate));
    }
  }

  void _generateTabDays(DateTime selectedDate) {
    _tabDays = List.generate(
        AMOUNT_OF_DAYS + 1, (i) => selectedDate.add(Duration(days: i)));
  }

  void _onDatePicked(DateTime? picked) {
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        DateTime today = DateTime.now();
        int dayBetween = _selectedDate.difference(today).inDays;

        // Adjust dayBetween to account for later dates
        if (_selectedDate.isAfter(today)) {
          dayBetween += 1;
        }
        _tabController.animateTo(dayBetween);
      });
      context.read<BookingBloc>().add(FetchBookingData(picked));
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 1,
        onPressed: () {
        },
        label: const Text('New'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Booking'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate:
                    DateTime.now().add(const Duration(days: AMOUNT_OF_DAYS)),
                initialDate: _selectedDate,
              );
              _onDatePicked(picked);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () =>
                _key.currentState!.openDrawer(), // <-- Opens drawer
          )
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabDays.map((day) => Tab(text: _formatDate(day))).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                AMOUNT_OF_DAYS + 1,
                (index) => BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    return _buildTabContent(state, _tabDays[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      key: _key,
      drawer: Drawer(
        child: FilterDrawer(),
      ),
    );
  }

  Widget _buildTabContent(BookingState state, DateTime date) {
    return BlocProvider.value(
      value: context.read<BookingBloc>(),
      child: Builder(
        builder: (context) {
          if (state is BookingLoading || state is BookingInitial) {
            // Show loading indicator or placeholder content while data is loading
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingError) {
            // Show error message if data loading failed
            return Center(child: Text(state.message));
          } else if (state is BookingLoaded) {
            return BuildingsTable(
              bookingData: state.bookingData,
            );
          } else {
            // Handle other states if necessary
            return Container();
          }
        },
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
}
