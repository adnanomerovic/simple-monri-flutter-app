import 'dart:convert';

import 'package:MonriPayments/MonriPayments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monri Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Monri Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map _data = {};
  final monriPayments = MonriPayments.create();
  static const platform = MethodChannel('monri.create.payment.session.channel');

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _continuePayment() async {
    Map data = {};
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var clientSecret = await platform.invokeMethod('monri.create.payment.session.method');
      var arguments = jsonDecode(_getJsonData(
          isDevelopment: true,
          clientSecret: clientSecret,
          cardNumber: "4341792000000044",
          cvv: 123,
          expirationMonth: 12,
          expirationYear: 2030,
          cardHolderName: "Adnan Omerovic",
          tokenizePan: true
      ));
      data = (await monriPayments.confirmPayment(CardConfirmPaymentParams.fromJSON(arguments))).toJson();
      // print(data);
    } on PlatformException {
      data = {};
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _data = data;
    });
  }


  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Start payment by pressing button below',
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,//.horizontal
                child: SelectableText(_data.toString()),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _continuePayment,
        tooltip: 'Continue with Payment',
        child: const Icon(Icons.credit_card),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

String _getJsonData({
  required String clientSecret,
  required bool isDevelopment,
  required String cardNumber,
  required int cvv,
  required int expirationMonth,
  required int expirationYear,
  required String cardHolderName,
  required bool tokenizePan
}){
  return """
{
  "is_development_mode": $isDevelopment,
  "authenticity_token": "a6d41095984fc60fe81cd3d65ecafe56d4060ca9",
  "client_secret": "$clientSecret",
  "card": {
    "pan": "$cardNumber",
    "cvv": "$cvv",
    "expiryMonth": "$expirationMonth",
    "expiryYear": "$expirationYear",
    "tokenize_pan": $tokenizePan
  },
  "transaction_params": {
      "full_name": "$cardHolderName",
      "address": "N/A",
      "city": "Sarajevo",
      "zip": "71000",
      "phone": "N/A",
      "country": "BA",
      "email": "monri.flutter@gmail.com",
      "custom_params": ""
  }
}
""";
}

 // String _readFromPreference() async {
 //   SharedPreferences prefs = await SharedPreferences.getInstance();
 // }


}
