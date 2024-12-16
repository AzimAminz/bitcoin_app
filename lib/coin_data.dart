
import 'package:bitcoin_ticker_flutter/network_helper.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apikey  = '3065BB43-8936-4006-984E-4E453EC39EBD';
const urlCoinData = 'https://rest.coinapi.io/v1/exchangerate/';

class CoinData {
 

  CoinData();
  Future<dynamic> getCurrency(String crypto,String currency) async{
    NetworkHelper networkHelper = NetworkHelper('${urlCoinData}${crypto}/${currency}?apikey=${apikey}');

    var coinData = await  networkHelper.getData();
    return coinData;
  }

}

