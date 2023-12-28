import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mechanic/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final String supervisorId = 'supervisor';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  void _sendMessage(String text) async {
    _messageController.clear();
    if (text.isNotEmpty) {
      await _firestore.collection('chats').doc(_user.uid).collection('messages').add({
        'text': text,
        'senderId': _user.uid,
        'receiverId': widget.supervisorId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Supervisor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('chats').doc(_user.uid).collection('messages').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  final messageText = message['text'];
                  final senderId = message['senderId'];
                  final receiverId = message['receiverId'];

                  // Check if the message is sent to or received from the supervisor
                  if ((senderId == _user.uid && receiverId == widget.supervisorId) ||
                      (senderId == widget.supervisorId && receiverId == _user.uid)) {
                    final messageWidget = MessageWidget(
                      text: messageText,
                      isMe: senderId == _user.uid,
                    );
                    messageWidgets.add(messageWidget);
                  }
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text);
            },
          ),
          hintText: 'Write a message...',
        ),
        onSubmitted: (_) {
          _sendMessage(_messageController.text);
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;

  MessageWidget({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor :AppColors.primary2Color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      trailing: isMe ? const Icon(Icons.check) : null,
    );
  }
}
