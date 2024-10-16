import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  TextEditingController conMessage = TextEditingController();

  @override
  void dispose() {
    conMessage.dispose();
    super.dispose();
  }

  void submitMessage() async{
    final enteredMessage = conMessage.text;
    if(enteredMessage.trim().isEmpty){
      return;
    }

    FocusScope.of(context).unfocus();
    conMessage.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    //LOGIC TO SEND MESSAGES IN FIREBASE
    FirebaseFirestore.instance
        .collection('Chats')
        .add({
            'Text' : enteredMessage,
            'CreatedAt' : Timestamp.now(),
            'UserID' : user.uid,
            'Username' :userData.data()!['userName'],
            'userImage':userData.data()!['ImageUrl'],
         });

  }

  @override
  Widget build(BuildContext context) {
    return   Padding(
        padding: const EdgeInsets.only(left: 16,right: 2,bottom: 15),
      child: Row(
        children: [
           Expanded(
              child: TextField(
                controller:conMessage ,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  hintText: 'Send a message...'
                ),
              )
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
              onPressed: submitMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
