import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:chat_app/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  TextEditingController messageController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(9, 238, 163, 232),
        title: Text('Feedbacks'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () async {
                try {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Feedbacks').orderBy('created_at', descending: true).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(),
                  title: Text(snapshot.data.docs[index]['username']),
                  subtitle: Text(
                      snapshot.data.docs[index]['message']),
                  // trailing: Text(snapshot.data.docs[index]['created_at'].toString()),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 30,
        color: const Color.fromARGB(255, 242, 238, 238),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var message = await FirestoreService()
                          .postFeedback(messageController.text);

                      messageController.clear();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Icon(Icons.send),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}