import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/user_model.dart';
import 'user_controller.dart';

class FollowingPage extends StatefulWidget {
  final User user;

  FollowingPage({required this.user});

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late UserController _userController;
  late List<String> _following;
  final _followController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _userController = UserController(Hive.box<User>('users'));
    _following = widget.user.following;
  }

  void _followUser() async {
    final usernameToFollow = _followController.text;
    if (usernameToFollow.isNotEmpty) {
      await _userController.followUser(widget.user.username, usernameToFollow);
      setState(() {
        _following.add(usernameToFollow);
        _followController.clear();
      });
    }
  }

  void _unfollowUser(String username) async {
    await _userController.unfollowUser(widget.user.username, username);
    setState(() {
      _following.remove(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _followController,
              decoration: InputDecoration(
                labelText: 'Follow Username',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _followUser,
            child: Text('Follow', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue
            ),
          ),
          SizedBox(height: 20),
          _following.isEmpty
              ? Center(child: Text('You are not following anyone.'))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _following.length,
                    itemBuilder: (context, index) {
                      final followedUser = _following[index];
                      return ListTile(
                        title: Text(followedUser),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            _unfollowUser(followedUser);
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
