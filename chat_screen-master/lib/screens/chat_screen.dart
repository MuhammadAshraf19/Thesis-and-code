import 'package:chat/widgets/chat_list_view.dart';
import 'package:flutter/material.dart';
import 'package:chat/global_members.dart';
import 'package:chat/message_data_modal.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/screens/signin_screen.dart';

import 'dart:convert';




class MyChatApp extends StatefulWidget {
  const MyChatApp({Key? key}) : super(key: key);

  @override
  MyChatAppState createState() => MyChatAppState();
}

class MyChatAppState extends State<MyChatApp> {
  TextEditingController textEditingController = TextEditingController();
  late String senderMessage, receiverMessage;
  ScrollController scrollController = ScrollController();

  Future<void> scrollAnimation() async {
    return await Future.delayed(
        const Duration(milliseconds: 100),
            () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear));
  }
Future<String> sendMessageToChatbot(String message) async {
  try {
    final apiUrl = 'https://5724-182-191-12-60.ngrok-free.app/new_endpoint/';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'arg_name': message},
    );

    if (response.statusCode == 200) {
      String chatbotResponse = json.decode(response.body)['Page']; // Extract chat_response
      setState(() {
        messageList.add(MessageData(chatbotResponse, false));
        textEditingController.clear();
        scrollAnimation();
      });
      return chatbotResponse; // Return chat_response
    } else {
      throw Exception('Failed to communicate with the chatbot.');
    }
  } catch (error) {
    print('Error sending message: $error');
    return ''; // Return an empty string or handle the error as needed
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 251, 251),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 64, 211, 123),
        leadingWidth: 50.0,
        titleSpacing: -8.0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          
        ),
        title: const ListTile(
          title: Text('Islamic Banking ChatBot',
              style: TextStyle(
                color: Colors.white,
          )),
         
        ),
          actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
          ),
        ],
       
      ),
      body: Column(
        
        children: [
          Expanded(
            
            
            child: ChatListView(scrollController: scrollController),

          
          ),
          Container(
           
            // height: 50,
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFF333D56),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
                  child: Transform.rotate(
                      angle: 45,
                      ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 11.0),
                  child: Transform.rotate(
                    angle: -3.14 / 5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child:
                        GestureDetector(
            onTap: () {
              String userMessage = textEditingController.text;
              setState(() {
                messageList.add(MessageData(userMessage, true)); // Assuming true means the message is from the user
                textEditingController.clear(); // Clear the input field
                scrollAnimation();
              });
            // Send user message to the chatbot and receive response
              sendMessageToChatbot(userMessage);
            },
                        onLongPress: () {
                          setState(() {
                            messageList.add(
                                MessageData(textEditingController.text, false));
                            textEditingController.clear();
                            scrollAnimation();
                          });
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
