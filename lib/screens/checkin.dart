import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeedit/screens/after-checkin.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';


void main() => runApp(const MaterialApp(home: CheckInScreen()));

class CheckInScreen extends StatelessWidget {

  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
      ),
      body: const QrView(),
    );
  }
}

class QrView extends StatefulWidget {
  const QrView({super.key});

  @override
  State<StatefulWidget> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late TextEditingController _pinController;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      if (controller != null) {
        controller!.pauseCamera();
      }
    }
    if (Platform.isIOS) {
      if (controller != null) {
        controller!.resumeCamera();
      }
    }
  }


@override
void initState(){
  super.initState();
  _pinController = TextEditingController();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: <Widget>[
        Expanded(
          // Flex widget to expand and take up available space
          flex: 8,
          child: _buildQrView(context), // Display the QR view method
        ),
        SizedBox(height: 16), // Add spacing between QR view and buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // First ElevatedButton
            ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => AlertDialog(
                  title: Text('Write the rooms QR code manually here'),
                  content: Container(
                    width: 200, // Set desired width
                    height: 100, // Set desired height
                    child: PinCodeFields(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                    onComplete: (value) {
                    if (value.length == 6) {
                      print('Completed Pin: $value'); // Print completed pin code
              // You can perform further actions here
              } else {
              print('Invalid Pin: $value'); // Handle invalid input
            }
          },),),
                actions: [
          TextButton(
            style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 202, 211, 201)), // Set background color
    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF4D4A4A)), // Set text color
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 16)), // Adjust button height
  ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFBFD5BC)), // Set background color
    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF4D4A4A)), // Set text color
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 16)), // Adjust button height
  ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Done!'),
          ),
        ],
                ),
                );
                // Handle button tap action
                Navigator.pushNamed(context, '/after-checkin'); // Navigate to another screen
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 130, 201, 149)), // Set button background color to green
              ),
              child: Text('Enter ID',
              style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
            // Second ElevatedButton
            ElevatedButton(
              
              onPressed: () {
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                title: Text('Help'),
                content: Text('Scan the QR code outside a room to check in to your booking or see the booking status for the current room', style: TextStyle(color: Color.fromARGB(255, 55, 54, 54)),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Ok, I understand', style: TextStyle(color: Color.fromARGB(255, 49, 49, 49)),),
          ),
        ],
        
      ),
    );
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFBFD5BC)), // Set background color
    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF4D4A4A)), // Set text color
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 16)), // Adjust button height
  ),
  child: Text(
    'Help',
    style: TextStyle(color: Colors.white), // Set text color to white
  ),
),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          borderLength: 50,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        // Validate the scanned data format
        if (_isValidScan(scanData)) {
          // pause the camera
          controller.pauseCamera();
          // Navigate to BookingScreen using navbar
          context.push("/checkin/${scanData.code}");
        }
      });
    });
  }

  bool _isValidScan(Barcode scanData) {
    if (scanData.code == null) {
      return false;
    }
    // Define the regex pattern for the required format LLNNNNL
    RegExp regex = RegExp(r'^[a-zA-Z]{2}\d{4}[a-zA-Z]$');
    // Check if the scanned data matches the pattern
    return regex.hasMatch(scanData.code?.trim() as String);
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    controller?.dispose();
    super.dispose();
  }
}
