import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/blocs/new_booking_bloc.dart';

class NewBookingBottomSheet extends StatefulWidget {
  final Room room;
  final DateTime startTime;

  NewBookingBottomSheet({required this.room, required this.startTime});

  @override
  _NewBookingBottomSheetState createState() => _NewBookingBottomSheetState();
}

class _NewBookingBottomSheetState extends State<NewBookingBottomSheet> {
  final NewBookingBloc _newBookingBloc = NewBookingBloc();

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late DateTime _date;
  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay.fromDateTime(widget.startTime);
    _endTime = TimeOfDay.fromDateTime(widget.startTime.add(Duration(hours: 2)));
    _date = widget.startTime;
    //bloc
    _newBookingBloc.add(StartDateSelected(_date));
    _newBookingBloc.add(StartTimeSelected(_startTime));
    _newBookingBloc.add(EndTimeSelected(_endTime));
    _newBookingBloc.add(RoomSelected(widget.room));
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (BuildContext context, Widget? child) {
        // Add a builder
        return MediaQuery(
          // This will override the device's locale settings for this picker
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _startTime) {
      _newBookingBloc.add(StartTimeSelected(pickedTime));
    }

  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (BuildContext context, Widget? child) {
        // Add a builder
        return MediaQuery(
          // This will override the device's locale settings for this picker
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _endTime) {
      _newBookingBloc.add(EndTimeSelected(pickedTime));
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != _date) {
      _newBookingBloc.add(StartDateSelected(pickedDate));
    }
  }

  Future<void> _selectRoom() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _newBookingBloc,
      child: BlocBuilder<NewBookingBloc, BookingState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Room',
                              ),
                              Spacer(),
                              ActionChip(
                                avatar: Icon(Icons.meeting_room),
                                label: Text(state is BookingInProgress
                                    ? state.room?.name ?? 'Select' : 'Select'),
                                onPressed: () => _selectRoom(),
                              ),
                            ],
                          ),
                          Divider(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Capacity',
                              ),
                              Spacer(),
                              Text('${widget.room.size} seats'),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Location',
                              ),
                              Spacer(),
                              Text('${widget.room.building}'),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Floor',
                              ),
                              Spacer(),
                              Text('${widget.room.floor}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 5.0, right: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Date',
                                  ),
                                  Spacer(),
                                  ActionChip(
                                      avatar: Icon(Icons.calendar_today),
                                      label: Text(state is BookingInProgress
                                          ? DateFormat('d MMM y').format(
                                              state.startDate ?? DateTime.now())
                                          : 'Select'),
                                      onPressed: () =>
                                          _selectStartDate(context)),
                                ],
                              ),
                              Divider(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Start Time',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  Spacer(),
                                  ActionChip(
                                    avatar: Icon(Icons.access_time),
                                    label: Text(state is BookingInProgress
                                        ? formatTo24Hours(state.startTime!)
                                        : 'Select'),
                                    onPressed: () => _selectStartTime(context),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'End Time',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  Spacer(),
                                  ActionChip(
                                    avatar: Icon(Icons.access_time),
                                    label: Text(state is BookingInProgress
                                        ? formatTo24Hours(state.endTime!)
                                        : 'Select'),
                                    onPressed: () => _selectEndTime(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    // ... other widgets on the left
                    Spacer(), // Occupies all available space, pushing the button to the right
                    FilledButton(onPressed: () => {}, child: Text('Book')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatTo24Hours(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
