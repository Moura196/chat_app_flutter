import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/feed_page.dart';
import 'package:chat_app/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : AssetImage('assets/default_profile.png'),
              radius: 50,
            ),
            Text(user?.displayName ?? 'Welcome!'),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.feedback),
          onPressed: () async {
                try {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => FeedPage(),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
                try {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
          },
            icon: Icon(Icons.logout)
          )
        ],
      )
    );
  }
}