import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> messages = [];
  WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    // channel = IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));
    channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:8081'));
    channel.stream.listen((message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close(status.goingAway);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    void _sendMessage() {
      if (_controller.text.isNotEmpty) {
        channel.sink.add(_controller.text);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket chat app'),
      ),
      body: ListView(
        children: [
          ...messages.map((element) => ListTile(title: Text(element)))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 100.0,
          child: Form(
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.message),
                labelText: 'Send message',
              ),
              textInputAction: TextInputAction.next,
              controller: _controller,
              validator: (String value) {
                return null;
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }
}
