import 'package:chat_app/Widgets/chat_messages.dart';
import 'package:chat_app/Widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async{
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    // final token =await fcm.getToken();

    fcm.subscribeToTopic('ChatMsg');
  }


  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
          }, icon:  Icon(Icons.exit_to_app,color:Theme.of(context).colorScheme.primary))
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessages(),
        ],
      )
    );
  }
}
