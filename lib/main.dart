import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await FirebaseFirestore.instance
        .collection('sample')
        .doc('W1dq8PhEpmyF7LMyjt3Q')
        .update({'counter': _counter});
  }

  @override
  void initState() {
    super.initState();

    Future(() async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('sample')
          .doc('W1dq8PhEpmyF7LMyjt3Q')
          .get();
      setState(() {
        _counter = snapshot['counter'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: const Text("start ui"),
              onPressed: () async {
                final providers = [
                  AuthUiProvider.email,
                  // AuthUiProvider.apple,
                  // AuthUiProvider.github,
                  // AuthUiProvider.google,
                  // AuthUiProvider.microsoft,
                  // AuthUiProvider.yahoo,
                ];

                final result = await FlutterAuthUi.startUi(
                  items: providers,
                  tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                    tosUrl: "https://www.google.com",
                    privacyPolicyUrl: "https://www.google.com",
                  ),
                  androidOption: const AndroidOption(
                    enableSmartLock: false, // default true
                    showLogo: true, // default false
                    overrideTheme: true, // default false
                  ),
                  emailAuthOption: const EmailAuthOption(
                    requireDisplayName: true, // default true
                    enableMailLink: false, // default false
                    handleURL: '',
                    androidPackageName: '',
                    androidMinimumVersion: '',
                  ),
                );
                print(result);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
