import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/user_model.dart';
import 'user_controller.dart';

class FollowersPage extends StatefulWidget {
  final User user;

  FollowersPage({required this.user});

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  late UserController _userController;
  late List<String> _followers;

  @override
  void initState() {
    super.initState();
    _userController = UserController(Hive.box<User>('users'));
    _followers = widget.user.followers;
  }

  void _removeFollower(String username) async {
    await _userController.unfollowUser(username, widget.user.username);
    setState(() {
      _followers.remove(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: _followers.isEmpty
          ? Center(child: Text('You have no followers.'))
          : ListView.builder(
              itemCount: _followers.length,
              itemBuilder: (context, index) {
                final follower = _followers[index];
                return ListTile(
                  title: Text(follower),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      _removeFollower(follower);
                    },
                  ),
                );
              },
            ),
    );
  }
}
