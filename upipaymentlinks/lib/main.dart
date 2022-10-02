// import 'dart:ffi';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:quantupi/quantupi.dart';

class UPITransactionDetails {
  String? pa;
  String? pn;
  double? am;

  UPITransactionDetails({required this.pa, required this.pn, required this.am});
}

void main() {
  Uri? url = Uri.base;

  String? pa = url.queryParameters["pa"];
  String? pn = url.queryParameters["pn"];
  double? amount = double.parse(url.queryParameters["am"] ?? "0");

  UPITransactionDetails transactionDetails =
      UPITransactionDetails(pa: pa, pn: pn, am: amount);

  runApp(MyApp(
    transactionDetails: transactionDetails,
  ));
}

class MyApp extends StatefulWidget {
  UPITransactionDetails transactionDetails;

  MyApp({required this.transactionDetails});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String data = 'Testing plugin';

  String appname = paymentappoptions[0];

  @override
  void initState() {
    data =
        "pa = ${widget.transactionDetails.pa} pn = ${widget.transactionDetails.pn} am = ${widget.transactionDetails.am}";
    print(widget.transactionDetails.pa);

    super.initState();
  }

  Future<String> initiateTransaction(
      {UPITransactionDetails? transactionDetails,
      QuantUPIPaymentApps? app}) async {
    Quantupi upi = Quantupi(
      receiverUpiId: transactionDetails!.pa!,
      receiverName: transactionDetails!.pn!,
      transactionRefId: 'TestingId',
      transactionNote: 'Not actual. Just an example.',
      amount: transactionDetails!.am!,
      appname: app,
    );
    String response = await upi.startTransaction();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    bool isios = !kIsWeb && Platform.isIOS;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isios)
                DropdownButton<String>(
                  value: appname,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 0,
                    // color: ,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      appname = newValue!;
                    });
                  },
                  items: paymentappoptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Center(
                          child: Text(
                            value,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (isios) const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String value = await initiateTransaction(
                    transactionDetails: widget.transactionDetails,
                    app: isios ? appoptiontoenum(appname) : null,
                  );
                  setState(() {
                    data = value;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "Tap to pay",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  data,
                  style: const TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  QuantUPIPaymentApps appoptiontoenum(String appname) {
    switch (appname) {
      case 'Amazon Pay':
        return QuantUPIPaymentApps.amazonpay;
      case 'BHIMUPI':
        return QuantUPIPaymentApps.bhimupi;
      case 'Google Pay':
        return QuantUPIPaymentApps.googlepay;
      case 'Mi Pay':
        return QuantUPIPaymentApps.mipay;
      case 'Mobikwik':
        return QuantUPIPaymentApps.mobikwik;
      case 'Airtel Thanks':
        return QuantUPIPaymentApps.myairtelupi;
      case 'Paytm':
        return QuantUPIPaymentApps.paytm;

      case 'PhonePe':
        return QuantUPIPaymentApps.phonepe;
      case 'SBI PAY':
        return QuantUPIPaymentApps.sbiupi;
      default:
        return QuantUPIPaymentApps.googlepay;
    }
  }
}

const List<String> paymentappoptions = [
  'Amazon Pay',
  'BHIMUPI',
  'Google Pay',
  'Mi Pay',
  'Mobikwik',
  'Airtel Thanks',
  'Paytm',
  'PhonePe',
  'SBI PAY',
];
