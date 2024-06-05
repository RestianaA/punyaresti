import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'models/user_model.dart';
import 'user_controller.dart';
import 'login_page.dart';
import 'followers_page.dart';
import 'following_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserController _userController;
  String? _username;
  final _followController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userController = UserController(Hive.box<User>('users'));
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _followUser() async {
    if (_followController.text.isNotEmpty && _username != null) {
      await _userController.followUser(_username!, _followController.text);
      _followController.clear();
      setState(() {});
    }
  }

  void _unfollowUser(String userToUnfollow) async {
    if (_username != null) {
      await _userController.unfollowUser(_username!, userToUnfollow);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _userController.getUser(_username!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('../assets/acc.jpg'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FollowersPage(user: user)),
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                user.followers.length.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FollowingPage(user: user)),
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                user.following.length.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tweets',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    user.tweets.isEmpty
                        ? Text('No tweets yet.')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: user.tweets.length,
                            itemBuilder: (context, index) {
                              final tweet = user.tweets[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    tweet.text,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    'Likes: ${tweet.favorites}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
