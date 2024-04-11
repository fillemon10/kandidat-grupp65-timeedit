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
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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
          
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              children: [
                SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ActionChip(
                          label: Text('Flash'),
                          avatar: Icon(Icons.flashlight_on),
                          side: (controller?.getFlashStatus()) == true
                              ? BorderSide(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  width: 1,
                                )
                              : BorderSide(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.1),
                                  width: 1,
                                ),
                          onPressed: () {
                            controller?.toggleFlash();
                          }),
                    ),
                    ActionChip(
                      label: Text('Enter ID'),
                      avatar: Icon(Icons.dialpad),
                      side: BorderSide(
                          color: Theme.of(context).disabledColor.withOpacity(0.1),
                          width: 1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Write the rooms QR code manually here'),
                            content: Container(
                              width: 300,
                              height: 70,
                              child: PinCodeFields(
                                autofocus: true,
                                borderColor: Theme.of(context).primaryColor,
                                activeBorderColor:
                                    Theme.of(context).primaryColorDark,
                                length: 6,
                                keyboardType: TextInputType.number,
                                onComplete: (value) {
                                  if (value.length == 6) {
                                    context.push('/checkin/${value}');
                                  } else {
                                    print(
                                        'Invalid Pin: $value'); // Handle invalid input
                                  }
                                },
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  context.pop();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: ActionChip(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Help'),
                              content: Text(
                                'Scan the QR code outside a room to check in to your booking or see the booking status for the current room',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 55, 54, 54)),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text(
                                    'Ok, I understand',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 49, 49, 49)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        side: BorderSide(
                            color: Theme.of(context).disabledColor.withOpacity(0.1),
                            width: 1),
                        avatar: Icon(Icons.help),
                        label: Text(
                          'Help',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
              ],
            ),
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
}
