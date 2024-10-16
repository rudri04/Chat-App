import 'package:chat_app/Widgets/bubble_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
final authenticateUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Chats').orderBy('CreatedAt',descending: true).snapshots(),
        builder: (context,snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if(!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Messages Found'));
          }

          if(snapshot.hasError){
            return const Center(child: Text('Oops!! \n Something went wrong...'));
          }

          final loadedMessages = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40,left: 15,right: 15),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (context,index){
                final chatMessage = loadedMessages[index].data();
                final nextMessage = index + 1 < loadedMessages.length
                                    ? loadedMessages[index + 1].data()
                                    : null;
                final currentMessageUserId = chatMessage['UserID'];
                final nextMessageUserId = nextMessage != null ? nextMessage['UserID'] : null;
                final nextUserIsSame = currentMessageUserId == nextMessageUserId;
                print("nextMessageUserId: ${chatMessage['UserID']}");
                print("currentMessageUserId: ${currentMessageUserId != null ? chatMessage['UserID'] : null}");
                print(nextUserIsSame);

          if (nextUserIsSame){
            return MessageBubble.next(
              message: chatMessage['Text'],
              isMe: authenticateUser.uid == currentMessageUserId,
            );
          }
          else {


            return MessageBubble.first(
              userImage: chatMessage['userImage'],
              username: chatMessage['Username'],
              message: chatMessage['Text'],
               isMe: authenticateUser.uid == currentMessageUserId,
            );
          }

          }

          );
        });
  }
}
