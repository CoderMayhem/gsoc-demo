import 'package:flutter/material.dart';

class MyBottomAppBar extends StatefulWidget {

  const MyBottomAppBar(
      {Key key})
      : super(key: key);

  @override
  _MyBottomAppBarState createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff29406B),
      child: onClickedBottomBar(),
    );
  }

  Widget onClickedBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          onPressed: null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/Vector.png',
                  scale: 2),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'News Feed',
                  style: TextStyle(color: Color(0xffE5D7D7)),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Image.asset('images/chat.png',
                    scale: 2),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Chat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/Vector (1).png', scale: 2),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Events',
                  style: TextStyle(color: Color(0xffE5D7D7)),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/account_circle.png',
                  scale: 2),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Profile',
                  style: TextStyle(color: Color(0xffE5D7D7)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}