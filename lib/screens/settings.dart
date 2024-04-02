import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';



class SettingsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
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
  Widget build(BuildContext context){
    var notifications = Provider.of<SwitchStates>(context).notifications;
    var colorBlindMode = Provider.of<SwitchStates>(context).colorBlindMode;
    
    return Scaffold(
      /**
       * The appbar of the page
       * 
       * Might want to add some styling.
       */
      appBar: AppBar(
          title: const Text('Settings',),
          centerTitle: true,
        ),
      
      /**
       * The main container for all widgets in the settings page
       */
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(10),
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
                  child: Column(
                    children: [
                      
                      /**
                       * Container for the 'account details' textbox at the top of the screen
                       */
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFBFD5BC),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: const Text(
                          'Account Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300
                          )
                        )
                      ),
                      
                      /**
                       * Container for the CID text
                       * 
                       * TODO, need to add so that the CID is gotten from the login
                       */
                      Container(
                        child: const Text(
                          'CID: to-be added in the future',
                          style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                          )
                        )
                      ),

                      /**
                       * Container for the Account Type Text
                       * 
                       * TODO, need to add so that the account type is gottent from the login
                       */
                      Container(
                        child: const Text(
                          'Account Type: to-be added in the future',
                          style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                          )
                        )
                      ),
                    
                    ],
                  ),
                ),

                /**
                 * Switch buttons container
                 */
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Enable Notifications:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                          /**
                           * Notification switch
                           * 
                           * TODO: Make the switch switch states
                           */
                          Switch(
                            value: notifications, 
                            onChanged: (bool value) {
                              Provider.of<SwitchStates>(context, listen: false).setNotifications(value);    
                              print('Notifications: $value');
                            }
                          ),
                        ]
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          
                          const Text(
                            'Enable Color Blind Mode:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300
                            ),
                          ),

                          /**
                           * Colorblind switch
                           * 
                           * TODO: Make the switch switch states
                           */
                          Switch(
                            value: colorBlindMode, 
                            onChanged: (bool value) {
                              Provider.of<SwitchStates>(context, listen: false).setColorBlindMode(value);
                              print('ColorBlindMode: $value');
                            }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /**
                 * Edit Favourite Rooms button's container
                 */
                
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                      heroTag: 'editFavouriteRoomsButton',
                      elevation: 2,
                      onPressed: () {
                        context.push('/favourite_rooms');
                        //print('Edit Favourite Rooms Clicked!');
                      },
                      label: const Text(
                        'Edit Favourite Rooms',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                
                /**
                 * A row container to hold the bottom-most 2 buttons on the screen.
                 */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  
                  /**
                   * View Rules button's container
                   */
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton.extended(
                      heroTag: 'viewRulesButton',
                      elevation: 2,
                      onPressed: () {
                        print('View Rules Clicked!');
                      },
                      label: const Text(
                        'View\nRules',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                  
                  /**
                   * Report an Issue button's container
                   */
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      heroTag: 'reportAnIssueButton',
                      elevation: 2,
                      onPressed: () {
                        print('Report an Issue Clicked!');
                      },
                      label: const Text(
                        'Report an\nIssue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ],
              ),
            ),
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
