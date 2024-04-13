import 'dart:async';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _BarcodeScannerWithOverlayState createState() =>
      _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<CheckInScreen>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back);

  StreamSubscription<Object?>? _subscription;

  Barcode? _barcode;
  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
        _onQRCodeScanned(_barcode?.rawValue ?? '');
      });
    }
  }

  Future<void> _onQRCodeScanned(String qrCode) async {
    if (!_isValidScan(_barcode!)) {
      return;
    }

    context.go('/after-checkin/$qrCode');
  }

  bool _isValidScan(Barcode scanData) {
    if (scanData.rawValue == null) {
      return false;
    }
    // Define the regex pattern for the required format LLNNNNL
    RegExp regex = RegExp(r'^[a-zA-Z]{2}\d{4}[a-zA-Z]$');
    // Check if the scanned data matches the pattern
    return regex.hasMatch(scanData.rawValue?.trim() as String);
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context)
          .center(Offset.fromDirection(1.5 * pi, 100)), // Center of the screen
      width: 200,
      height: 200,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Check in'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: MobileScanner(
              controller: controller,
              scanWindow: scanWindow,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              overlayBuilder: (context, constraints) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(height: 450),
                        Text(
                          textAlign: TextAlign.center,
                          'Scan the QR code outside a room to \ncheck in or check status',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized ||
                  !value.isRunning ||
                  value.error != null) {
                return const SizedBox();
              }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ToggleFlashlightButton(controller: controller),
                      ActionChip(
                        label: const Text('Enter ID'),
                        avatar: const Icon(Icons.dialpad),
                        side: BorderSide(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.1),
                            width: 1),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                  'Write the rooms QR code manually here'),
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
                                title: const Text('Help'),
                                content: const Text(
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
                                          color:
                                              Color.fromARGB(255, 49, 49, 49)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          side: BorderSide(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.1),
                              width: 1),
                          avatar: const Icon(Icons.help),
                          label: const Text(
                            'Help',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 109, 165, 82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }
        switch (state.torchState) {
          case TorchState.off:
            return Expanded(
                child: ActionChip(
                    side: const BorderSide(color: Colors.white),
                    label: const Text('Flash'),
                    avatar: const Icon(Icons.flashlight_off),
                    onPressed: () async {
                      await controller.toggleTorch();
                    }));
          case TorchState.on:
            return Expanded(
                child: ActionChip(
                    side: const BorderSide(color: Colors.white),
                    label: const Text('Flash'),
                    avatar: const Icon(Icons.flashlight_on),
                    onPressed: () async {
                      await controller.toggleTorch();
                    }));
          case TorchState.unavailable:
            return const Expanded(
              child: ActionChip(
                  avatar: Icon(Icons.flashlight_off),
                  label: Text('Unavailable')),
            );
        }
      },
    );
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
