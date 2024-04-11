import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';
import 'package:timeedit/blocs/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SwitchStates(),
      child: SettingsScreenContent(),
    );
  }
}

///TODO:
///
///1. Add the account information "box"
///
///2. Add missing images to buttons
///     Get these from figma
///
///3. Make the "Edit Favourite Rooms" button change scene
class SettingsScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    var notifications = Provider.of<SwitchStates>(context).notifications;
    var colorBlindMode = Provider.of<SwitchStates>(context).colorBlindMode;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonSize = screenWidth * 0.4;


    return Scaffold(
      /**
       * The appbar of the page
       * 
       * Might want to add some styling.
       */
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        centerTitle: true,
      ),

      /**
       * The main container for all widgets in the settings page
       */
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: screenWidth - 48.0,
            height: double.infinity,
            //margin: const EdgeInsets.all(10),
            /**
             * Creating a Column widget to be able to hold multiple other
             * child widgets. This allows for more creative freedom in the 
             * styling as far as im aware.
             */
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              // Declare any children of the Column widget within the []
              children: [
                /**
                 * Account information container
                 */
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /**
                       * Container for the 'account details' textbox at the top of the screen
                       */
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Container(                  
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: const EdgeInsets.all(8),
                          
                          child: const Text('Account Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300
                            )
                          ),
                        ),
                      ),
                      /**
                       * Container for the CID text
                       * 
                       * TODO, need to add so that the CID is gotten from the login
                       */
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text('CID: ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)
                        ),
                      ),

                      /**
                           * Container for the Account Type Text
                           * 
                           * TODO, need to add so that the account type is gottent from the login
                           */
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Account Type: ',
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300)
                        )
                      ),
                    ],
                  ),
                ),

                /**
                 * Switch buttons container
                 */
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /**
                       * Notifications Switch
                       */
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          
                          children: [
                            const Text(
                              'Enable Notifications:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                            Switch(
                                value: notifications,
                                onChanged: (bool value) {
                                  Provider.of<SwitchStates>(context, listen: false)
                                      .setNotifications(value);
                                  print('Notifications: $value');
                                }),
                          ]
                        ),
                      ),
                      /**
                       * 
                       */
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Toggle Dark Mode:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                            ThemeToggleWidget(),
                          ],
                        ),
                      )
                    ],
                  
                  ),
                ),

                /**
                 * Edit Favourite Rooms button's container
                 */

                Container(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      heroTag: 'editFavouriteRoomsButton',
                      icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      elevation: 2,
                      onPressed: () {
                        context.push('/favourite_rooms');
                        //print('Edit Favourite Rooms Clicked!');
                      },
                      label: const Text(
                        'Edit Favourite Rooms',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ),
                ),
                ),
                /**
                 * A row container to hold the bottom-most 2 buttons on the screen.
                 */
                Container(
                  //alignment: Alignment.center,
                  //margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /**
                       * View Rules button's container
                       */
                      Container(
                        width: buttonSize,
                        height: buttonSize,
                        child: FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          heroTag: 'viewRulesButton',
                          elevation: 2,
                          onPressed: () {
                            context.push('/view-rules');
                          },
                          label: const Text(
                            'View\nRules',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),

                      /**
                         * Report an Issue button's container
                         */
                      Container(
                        width: buttonSize,
                        height: buttonSize,
                        child: FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          heroTag: 'reportAnIssueButton',
                          elevation: 2,
                          
                          onPressed: () {
                            context.push('/report-an-issue');
                          },
                          label: const Text(
                            'Report an\nIssue',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}

class SwitchStates extends ChangeNotifier {
  bool _colorBlindMode = false;
  bool get colorBlindMode => _colorBlindMode;

  bool _notifications = false;
  bool get notifications => _notifications;

  void setColorBlindMode(bool value) {
    _colorBlindMode = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    notifyListeners();
  }
}

class ThemeToggleWidget extends StatefulWidget {
  const ThemeToggleWidget({Key? key}) : super(key: key);

  @override
  _ThemeToggleWidgetState createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget> {
  bool _isDarkMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update _isDarkMode based on the current theme
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isDarkMode,
      onChanged: (newValue) {
        setState(() {
          _isDarkMode = newValue;
        });
        // Dispatch the ThemeEvent
        BlocProvider.of<ThemeBloc>(context).add(
          ThemeEvent(themeMode: newValue ? ThemeMode.dark : ThemeMode.light),
        );
      },
    );
  }  
}
