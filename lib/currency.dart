import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  Map<String, double> _exchangeRates = {};
  String _selectedCurrency = 'USD';
  double _amount = 0.0;

  final List<String> _allowedCurrencies = [
    'SGD', 'THB', 'JPY', 'KRW', 'USD', 'AUD', 'EUR'
  ]; 

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$_selectedCurrency'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _exchangeRates = (data['rates'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toDouble()));
      });
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  double _convertCurrency(double amount, String toCurrency) {
    if (_exchangeRates.containsKey(toCurrency)) {
      return amount * _exchangeRates[toCurrency]!;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: _exchangeRates.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: InputDecoration(
                labelText: 'Select Currency',
                border: OutlineInputBorder(),
              ),
              items: _allowedCurrencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                  _fetchExchangeRates();
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${_convertCurrency(_amount, 'IDR').toStringAsFixed(2)} IDR',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
