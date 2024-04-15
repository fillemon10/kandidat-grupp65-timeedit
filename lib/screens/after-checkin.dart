import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/blocs/check_in_bloc.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/widgets/new_booking.dart';

class AfterCheckInScreen extends StatefulWidget {
  final String? id;
  const AfterCheckInScreen({Key? key, required this.id}) : super(key: key);

  @override
  _AfterCheckInScreenState createState() => _AfterCheckInScreenState();
}

class _AfterCheckInScreenState extends State<AfterCheckInScreen> {
  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  final _roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: BlocProvider(
          create: (_) => CheckInBloc(),
          child: BlocConsumer<CheckInBloc, CheckInState>(
            listener: (context, state) {
              if (state is CheckInError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return buildBody(
                  context, state); // Updated to use builder function
            },
          ),
        ));
  }

  Widget buildBody(BuildContext context, CheckInState state) {
    if (state is CheckInInitial) {
      context.read<CheckInBloc>().add(CheckInStarted(widget.id!));
      return const Center(child: CircularProgressIndicator());
    } else if (state is CheckInLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CheckInCurrentlyBooked) {
      return _buildCurrentlyBookedBody(state);
    } else if (state is CheckInAvailableForBooking) {
      return _buildAvailableForBookingBody(state);
    } else if (state is CheckInBooked) {
      return _buildBookedBody(state);
    } else if (state is CheckInAlreadyCheckedIn) {
      return _buildAlreadyCheckedIn(state);
    } else if (state is CheckInSuccess) {
      return _buildCheckedInSuccess(state);
    } else if (state is CheckInError) {
      return Center(child: Text(state.message));
    } else {
      return const Center(child: Text("Unexpected State"));
    }
  }

  Widget _buildAlreadyCheckedIn(CheckInAlreadyCheckedIn state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Already Checked In to Room ${state.room!.name}',
                      ),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Room',
                      ),
                      Spacer(),
                      Text('${state.room!.name}'),
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
                      Text('${state.room!.size} seats'),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Location',
                      ),
                      Spacer(),
                      Text(state.room!.building),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Floor',
                      ),
                      Spacer(),
                      Text('${state.room!.floor}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Widget _buildCurrentlyBookedBody(CheckInCurrentlyBooked state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Currently Booked until ${formatdateTime(state.booking.endTime)}',
                      ),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Room',
                      ),
                      Spacer(),
                      Text('${state.room!.name}'),
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
                      Text('${state.room!.size} seats'),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Location',
                      ),
                      Spacer(),
                      Text(state.room!.building),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Floor',
                      ),
                      Spacer(),
                      Text('${state.room!.floor}'),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Booking Details',
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
                        'Start Time',
                      ),
                      Spacer(),
                      Text(formatdateTime(state.booking.startTime)),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'End Time',
                      ),
                      Spacer(),
                      Text(formatdateTime(state.booking.endTime)),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildAvailableForBookingBody(CheckInAvailableForBooking state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Room ${state.room!.name} is Available for Booking',
                      ),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Room',
                      ),
                      Spacer(),
                      Text('${state.room!.name}'),
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
                      Text('${state.room!.size} seats'),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Location',
                      ),
                      Spacer(),
                      Text(state.room!.building),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Floor',
                      ),
                      Spacer(),
                      Text('${state.room!.floor}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Spacer(),
            FilledButton(
                child: Text('Book Room'),
                onPressed: () => showModalBottomSheet(
                    showDragHandle: true,
                    useRootNavigator: true,
                    context: context,
                    builder: (context) => NewBookingBottomSheet(
                        room: state.room!, startTime: DateTime.now()))),
          ],
        )
      ]),
    );
  }

  Widget _buildBookedBody(CheckInBooked state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Booked Room ${state.room!.name}',
                      ),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Room',
                      ),
                      Spacer(),
                      Text('${state.room!.name}'),
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
                      Text('${state.room!.size} seats'),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Location',
                      ),
                      Spacer(),
                      Text(state.room!.building),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Floor',
                      ),
                      Spacer(),
                      Text('${state.room!.floor}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Widget _buildCheckedInSuccess(CheckInSuccess state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Checked In to Room ${state.room!.name}',
                      ),
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Room',
                      ),
                      Spacer(),
                      Text('${state.room!.name}'),
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
                      Text('${state.room!.size} seats'),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Location',
                      ),
                      Spacer(),
                      Text(state.room!.building),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Floor',
                      ),
                      Spacer(),
                      Text('${state.room!.floor}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  String formatdateTime(DateTime time) {
    //format with intl 14 Apr 16:00
    return DateFormat('d MMM kk:mm').format(time);
  }
}
