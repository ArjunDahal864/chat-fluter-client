import 'dart:convert';

import 'package:chat/chats.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = IOWebSocketChannel.connect(
      Uri.parse('wss://api.mahajodi.space/api/v1/chat/connect?user_id=181'),
      pingInterval: Duration(microseconds: 1),
      headers: {"Authorization": "Bearer header"});

  var _currentUserID = 181;

  List<ChatsRequestResponse> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var encoded = json.decode(snapshot.data.toString());
                  print(encoded);
                  messages.add(ChatsRequestResponse.fromJson(encoded));
                  return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          _bubbleChat(messages[index]));
                } else {
                  return Text("no data");
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(ChatsRequestResponse(
              data: _controller.text, recipientId: 248, senderId: 181)
          .toString());
    }
  }

  Widget _bubbleChat(ChatsRequestResponse message) {
    return Container(
      padding: EdgeInsets.all(18.0),
      margin: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
          color: _currentUserID == message.senderId
              ? Colors.blue.shade700
              : Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(.4),
                offset: Offset(2, 5))
          ],
          borderRadius: BorderRadius.circular(18.0)),
      child: Text(
        message.data.toString(),
        style: TextStyle(
            color: _currentUserID == message.senderId
                ? Colors.white
                : Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
