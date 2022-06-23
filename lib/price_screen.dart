import 'dart:io' show Platform;

import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

const apiKey = {'x-ba-key': 'NTBjNTBkOTlkYzk4NGY2MWI4ZWI0MWIyZGNlNGIxOTg'};

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // iAmConfused().then((value) => setState(() {
    //       currentPrice = value;
    //     }));
    priceFuture = getCurrentPrice(selectedCurrency);
  }

  String selectedCurrency = 'USD';
  Future<double> priceFuture;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            priceFuture = getCurrentPrice(value);
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      Text newCurrency = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      pickerItems.add(newCurrency);
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  Future<double> getCurrentPrice(String currency) async {
    NetworkData networkData = NetworkData(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC$currency');

    final currentPriceOfBitcoin = await networkData.getCurrencies();
    double currentPrice = currentPriceOfBitcoin['last'];
    print('currentPrice = $currentPrice');
    return currentPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: FutureBuilder(
        future: priceFuture,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          print('snapshot: $snapshot');
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                  child: Card(
                    color: Colors.lightBlueAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        '1 BTC = ${snapshot.data} $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.lightBlue,
                  child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error with getting price value');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
