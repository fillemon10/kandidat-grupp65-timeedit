import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new
import '../app_state.dart'; // new
import 'package:go_router/go_router.dart';



///TODO:
///
///1. Add shadows to buttons
///     There is a possibility that the current way the buttons are set
///     up wont work and that it needs to be reconsidered.
///
///2. Add toggle buttons above "edit favourite rooms" button
///     These buttons should be in their own container as the background
///     behind them is supposed to be a slightly different color
///
///3. Add the account information "box"
///
///4. Add missing images to buttons
///     Get these from figma
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  bool notifications = false;
  bool colorBlindMode = false;

  @override
  Widget build(BuildContext context){
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                 * Switch buttons container
                 */
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
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
                              notifications = value;
                              print('Notifications');
                            }
                          ),
                        ]
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          
                          Text(
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
                              colorBlindMode = value;
                              print('ColorBlindMode');
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
                  child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        shadowColor: Color.fromARGB(0, 83, 80, 80),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onPressed: () {
                        print('Edit Favourite Rooms Clicked!');
                      },
                      child: const Text(
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
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                          shadowColor: Color.fromARGB(0, 83, 80, 80),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      onPressed: () {
                        print('View Rules Clicked!');
                      },
                      child: const Text(
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
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                          shadowColor: Color.fromARGB(0, 83, 80, 80),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              
                          ),
                        ),
                      onPressed: () {
                        print('Report an Issue Clicked!');
                      },

                      child: const Text(
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