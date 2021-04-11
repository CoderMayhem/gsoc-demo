import 'package:flash_chat/components/bottomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  String userName;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        await _firestore
            .collection('users')
            .getDocuments()
            .then((querySnapshot) {
          final users = querySnapshot.documents;
          for (var current in users) {
            if (current['email'] == loggedInUser.email) {
              userName = current['fname'];
            }
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage('images/img.jpg'),  radius: 20.0,),
            SizedBox(width: 8),
            Text('Group Chat'),
          ],
        ),
        backgroundColor: Color(0xff29406B),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              //decoration: kMessageContainerDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffF5F6FA),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: InputDecoration(
                              hintText: 'Write a reply...',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Color(0xff29406B),
                                ),
                                onPressed: () {
                                  _firestore.collection('messages').add({
                                    'text': messageText,
                                    'senderName': userName,
                                    'senderEmail': loggedInUser.email,
                                  });
                                  messageTextController.clear();
                                },
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.camera_alt_outlined, size: 30, color: Color(0xff29406B)),
                    Icon(Icons.attach_file_outlined, size: 30, color: Color(0xff29406B)),
                    Icon(Icons.more_vert_outlined, size: 30, color: Color(0xff29406B)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff29406B),
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSenderName = message.data['senderName'];
          final messageSenderEmail = message.data['senderEmail'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSenderName,
            text: messageText,
            isMe: messageSenderEmail == currentUser,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMe ? 'You' : '$sender',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.0, color: Color(0xff1C2650)),
          ),
          SizedBox(height: 2),
          Material(
            color: isMe ? Color(0xff29406B) : Color(0xffF5F6FA),
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0))
                : BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 9.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isMe ? Colors.white : Color(0xff1C2650),
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
