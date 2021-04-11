import 'package:flash_chat/components/bottomAppBar.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F6FA),
      appBar: AppBar(
        title: Text('Your Chats'),
        backgroundColor: Color(0xff29406B),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/chat');
          },
          child: Material(
            elevation: 5.0,
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/img.jpg'),
                      radius: 30,
                    ),
                    SizedBox(width: 20),
                    Text('Group Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(),
    );
  }
}
