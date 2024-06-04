import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'models/user_model.dart';
import 'user_controller.dart';
import 'profile_page.dart';
import 'timezone.dart';
import 'currency.dart';
import 'trending.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserController _userController;
  String? _username; // Change to nullable
  final _tweetController = TextEditingController();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _userController = UserController(Hive.box<User>('users'));
    _loadUsername();
  }

  Future<void> _loadUsername() async { // Ensure the method is async and returns a Future
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  void _addTweet() async {
    if (_tweetController.text.isNotEmpty && _username != null) {
      final tweet = Tweet(text: _tweetController.text);
      await _userController.addTweet(_username!, tweet);
      _tweetController.clear();
      setState(() {});
    } else {
      print('Error: _username is not initialized');
    }
  }

  void _likeTweet(Tweet tweet) async {
    if (_username != null) {
      await _userController.likeTweet(_username!, tweet);
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      // Show a loading indicator while waiting for the username
      return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _userController.getUser(_username!);
    final tweets = <Tweet>[];

    if (user != null) {
      for (var following in user.following) {
        final followingUser = _userController.getUser(following);
        if (followingUser != null) {
          tweets.addAll(followingUser.tweets);
        }
      }
      tweets.addAll(user.tweets);
      tweets.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    // Pages for bottom navigation
    final List<Widget> _pages = [
      // HomePage
      Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: user == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _tweetController,
                decoration: InputDecoration(labelText: 'What\'s happening?'),
              ),
            ),
            ElevatedButton(
              onPressed: _addTweet,
              child: Text('Tweet'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return ListTile(
                    title: Text(tweet.text),
                    subtitle: Text('Likes: ${tweet.favorites}'),
                    trailing: IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () => _likeTweet(tweet),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      TrendingPage(),
      CurrencyConverterPage(),
      WorldClockPage(),
      ProfilePage()
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Currency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'World Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
