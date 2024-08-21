import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_detector/bluetooth_disabled_view/bluetooth_disabled_view.dart';
import 'package:bluetooth_detector/scanner_view/scanner_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bluetooth_detector/styles/colors.dart';
import 'package:bluetooth_detector/styles/text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report/file.dart';
import 'package:bluetooth_detector/settings.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  late Report report;
  late Settings settings;

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    await readSettings().then((settings) {
      widget.settings = settings;
      print('Settings loaded');
    });
    await readReport().then((savedReport) {
      widget.report = savedReport;
      print('Data loaded');
    });
    // await Future.delayed(Duration(seconds: 3), () {
    // print('Data loaded');
    // });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SafeArea(child: HomePage(widget.report, widget.settings))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Column(children: [
            Spacer(),
            Text(
              "BL(u)E CRAB",
              selectionColor: colors.primaryText,
              style: GoogleFonts.nothingYouCouldDo(
                // style: GoogleFonts.sniglet(
                // style: GoogleFonts.caprasimo(
                // style: GoogleFonts.irishGrover(
                // style: GoogleFonts.mogra(
                textStyle: TextStyles.title,
              ),
            ),
            Spacer(),
            SpinKitFadingCircle(
              color: colors.altText,
              size: 50.0,
            ),
            Spacer(),
          ]),
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage(Report this.report, Settings this.settings, {super.key});

  Report report;
  Settings settings;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  @override
  void initState() {
    super.initState();

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? ScannerView(widget.report, widget.settings)
        : BluetoothOffView(adapterState: _adapterState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: screen),
      theme: ThemeData(),
    );
  }
}
