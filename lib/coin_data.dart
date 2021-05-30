import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'price_screen.dart';

PriceScreen priceScreen = PriceScreen();

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

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];
//
const coinAPIURL =
    'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?CMC_PRO_API_KEY=';

//TODO: Enter Your API Key Below
const apiKey = 'your_apiKey_here';

class CoinData {
  BuildContext context;
  Future getCoinData(String selectedCurrency) async {
    String errorMsg = 'hello';

    //4: Use a for loop here to loop through the cryptoList and request the data for each of them in turn.
    //5: Return a Map of the results instead of a single value.
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      //Update the URL to use the crypto symbol from the cryptoList
      final String requestURL =
          '$coinAPIURL$apiKey&symbol=$crypto&convert=$selectedCurrency';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice =
            decodedData['data'][crypto]['quote'][selectedCurrency]['price'];
        //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        if (response.statusCode == 401) {
          errorMsg = "This API Key is invalid.";
        } else if (response.statusCode == 402) {
          errorMsg = "Your API Key's subscription plan has expired.";
        } else if (response.statusCode == 403) {
          errorMsg = "This API Key has been disabled. Please contact support.";
        } else if (response.statusCode == 429) {
          errorMsg = "You've exceeded request limits";
        }
        Fluttertoast.showToast(
            msg: errorMsg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 20.0);
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
