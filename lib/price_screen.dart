import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  List<String> rate = List.filled(cryptoList.length, '?');

  @override
  void initState() {
    super.initState();
    getCoinData(selectedCurrency);
  }

  Future<void> getCoinData(String currency) async {
    rate = List.filled(cryptoList.length, '?');
    try {
      for (int i = 0; i < cryptoList.length; i++) {
        var coin_data = await coinData.getCurrency(cryptoList[i], currency);
        double tempRate = coin_data["rate"];
        String Rate = tempRate.toStringAsFixed(2);
        rate[i] = Rate;
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  void updateUI(String value) {
    setState(() {
      rate = List.filled(cryptoList.length, '?');
      selectedCurrency = value;
    });
  }

  CupertinoPicker getCupertinoItems() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
        itemExtent: 32.0,
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (selectedIndex) async {
          updateUI(currenciesList[selectedIndex]);
          await getCoinData(currenciesList[selectedIndex]);
        },
        children: pickerItems);
  }

  DropdownButton<String> getDropdownItem() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );

      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        if (value != null) {
          updateUI(value);
          await getCoinData(value);
        }
      },
    );
  }

  List<Widget> buildCurrencyCards() {
    List<Widget> cards = [];
    for (int i = 0; i < cryptoList.length; i++) {
      String crypto = cryptoList[i];
      var newCard = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = ${rate.isNotEmpty ? rate[i] : '0'} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      cards.add(newCard);
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildCurrencyCards(),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getCupertinoItems() : getDropdownItem()),
        ],
      ),
    );
  }
}
