import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class WorldClockPage extends StatefulWidget {
  @override
  _WorldClockPageState createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage> {
  late Timer _timer;
  late DateTime _jakartaTime;
  late DateTime _makassarTime;
  late DateTime _jayapuraTime;
  late DateTime _londonTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _fetchWorldTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _fetchWorldTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fetchWorldTime() {
    _jakartaTime = tz.TZDateTime.now(tz.getLocation('Asia/Jakarta'));
    _makassarTime = tz.TZDateTime.now(tz.getLocation('Asia/Makassar')); 
    _jayapuraTime = tz.TZDateTime.now(tz.getLocation('Asia/Jayapura')); 
    _londonTime = tz.TZDateTime.now(tz.getLocation('Europe/London'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Clock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClockCard('WIB (Jakarta)', _jakartaTime),
            _buildClockCard('WITA (Makassar)', _makassarTime),
            _buildClockCard('WIT (Jayapura)', _jayapuraTime),
            _buildClockCard('London', _londonTime),
          ],
        ),
      ),
    );
  }

  Widget _buildClockCard(String location, DateTime time) {
    String formattedTime = DateFormat.Hm().format(time); 
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), 
      ),
      color: Colors.white, 
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue, 
              ),
            ),
            SizedBox(height: 8),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
