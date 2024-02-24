import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(MyApp(key: UniqueKey()));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<String?> scannedCodeNotifier = ValueNotifier(null);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: ValueListenableBuilder<String?>(
            valueListenable: scannedCodeNotifier,
            builder: (context, scannedCode, _) {
              return QRTitleWidget(scannedCode: scannedCode);
            },
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: MyBody(scannedCodeNotifier: scannedCodeNotifier)),
              MyNav(),
            ],
          ),
        ),
      ),
    );
  }
}

class QRTitleWidget extends StatelessWidget {
  final String? scannedCode;

  const QRTitleWidget({Key? key, this.scannedCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(scannedCode ?? 'Scan a code');
  }
}

class MyBody extends StatefulWidget {
  final ValueNotifier<String?> scannedCodeNotifier;

  const MyBody({Key? key, required this.scannedCodeNotifier}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  late QRViewController _qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller?.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return CupertinoActivityIndicator();
    }

    var screenSize = MediaQuery.of(context).size;
    var cameraValue = _controller!.value;
    var cameraAspectRatio = cameraValue.aspectRatio;
    var scale = screenSize.aspectRatio / cameraAspectRatio;
    if (scale < 1) scale = 0.48 / scale;
    double scanArea = 300.0;

    return Stack(
      children: [
        CameraPreview(_controller!),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: scanArea,
            height: scanArea,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned.fill(
          child: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
              borderColor: const Color.fromARGB(255, 71, 39, 37),
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,
            ),
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      widget.scannedCodeNotifier.value = scanData.code;
      Future.delayed(const Duration(seconds: 3), () {
        widget.scannedCodeNotifier.value =
            'Your App Title'; // Reset to default title
      });
    });
  }
}

class MyNav extends StatelessWidget {
  const MyNav({Key? key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0), // Adjust the margin here
            child: Icon(CupertinoIcons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0), // Adjust the margin here
            child: Icon(CupertinoIcons.calendar),
          ),
          label: 'Book',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0), // Adjust the margin here
            child: Icon(CupertinoIcons.map),
          ),
          label: 'Maps',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0), // Adjust the margin here
            child: Icon(CupertinoIcons.settings),
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
