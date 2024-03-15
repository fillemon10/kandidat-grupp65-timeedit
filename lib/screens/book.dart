import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const int AMOUNT_OF_DAYS = 14; // Global variable for the number of tab days

enum BookingFilter { AvailableNow, House, Amenities, Seats, ClearAll }

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
  bool _showFilters = false; // Track filter chips visibility

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
                lastDate:
                    DateTime.now().add(const Duration(days: AMOUNT_OF_DAYS)),
                initialDate: _selectedDate,
              );
              _onDatePicked(picked);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters; // Toggle filter chips visibility
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) // Show filter chips if _showFilters is true
            const Align(
              alignment: Alignment.centerLeft,
              child: FilterChipExample(),
            ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabDays.map((day) {
              return Tab(
                text: _formatDate(day),
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                AMOUNT_OF_DAYS + 1,
                (index) => AllCollapsibleTables(),
              ),
            ),
          ),
        ],
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

class FilterChipExample extends StatefulWidget {
  const FilterChipExample({Key? key}) : super(key: key);

  @override
  State<FilterChipExample> createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  Set<BookingFilter> filters = <BookingFilter>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: BookingFilter.values.map((filter) {
            return FilterChip(
              visualDensity: VisualDensity.compact,
              label: Text(filter.toString().split('.').last),
              selected: filters.contains(filter),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    filters.add(filter);
                  } else {
                    filters.remove(filter);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AllCollapsibleTables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < 10; i++) ...[
          CollapsibleTable(
            title: 'ED-blocket',
            table: BookingTable(),
          ),
        ],
      ],
    );
  }
}

class CollapsibleTable extends StatefulWidget {
  final String title;
  final Widget table;

  const CollapsibleTable({Key? key, required this.title, required this.table})
      : super(key: key);

  @override
  _CollapsibleTableState createState() => _CollapsibleTableState();
}

class _CollapsibleTableState extends State<CollapsibleTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          childrenPadding: EdgeInsets.all(0),
          initiallyExpanded: true,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          title: Text('ED-blocket'),
          // Contents
          children: [
            BookingTable(),
          ],
        ),
      ],
    );
  }
}

class BookingTable extends StatefulWidget {
  const BookingTable({Key? key}) : super(key: key);

  @override
  _BookingTableState createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: DataTable(
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          return Theme.of(context).colorScheme.primary.withOpacity(0.1);
        }),
        showBottomBorder: false,
        columnSpacing: 15.0,
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text('Room'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('8'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('9'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('10'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('11'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('12'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('13'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('14'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('15'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('16'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('17'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('18'),
            ),
          ),
        ],
        rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('ED-3123A')),
              DataCell(
                // Use SizedBox.expand to fill the cell
                SizedBox.expand(
                    // Use container to fill the background color
                    child: Container(
                  color: Colors.green,
                )),
              ),
              DataCell(
                // Use SizedBox.expand to fill the cell
                SizedBox.expand(
                    // Use container to fill the background color
                    child: Container(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      " ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
              ),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('B')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text(''))
            ],
          )
        ],
      ),
    );
  }
}
