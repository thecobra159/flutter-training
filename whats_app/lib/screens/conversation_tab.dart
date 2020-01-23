import 'package:flutter/material.dart';
import 'package:whats_app/model/conversation.dart';

class ConversationTab extends StatefulWidget {
  @override
  _ConversationTabState createState() => _ConversationTabState();
}

class _ConversationTabState extends State<ConversationTab> {
//  var _conversationsList = List<Conversation>();
  var _conversationsList = [
    Conversation(
        "Ana Clara",
        "Olá, tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-6dd4b.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=9b570454-689f-4321-94e8-91d65b7bec02"
    ),
    Conversation(
        "Pedro Silva",
        "Me manda o nome daquela série?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-6dd4b.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=c98bdb5d-1ca5-4231-b36f-f1a62272dd37"
    ),
    Conversation(
        "Marcela Almeida",
        "Vamos sair hoje?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-6dd4b.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=e1858df1-944f-43e3-8754-0bee7a40d05d"
    ),
    Conversation(
        "José Renato",
        "Não vai acreditar no que eu tenho para te contar...",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-6dd4b.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=8d84ee9c-852e-4c6c-adfc-965688c7fd8e"
    ),
    Conversation(
        "Spoder",
        "Shazu carai!",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-6dd4b.appspot.com/o/profile%2Fperfil5.png?alt=media&token=63a7964d-15a0-4b63-a708-790af3918ce0"
    ),
    Conversation(
        "Arthur",
        "All I have are negative thoughts",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-flutter-6dd4b.appspot.com/o/profile%2Fperfil6.jpeg?alt=media&token=82418e5a-02e5-4310-9b6e-724682fef485"
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _conversationsList.length,
        itemBuilder: (context, index) {
          var conversation = _conversationsList[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 8, 15, 8),
            leading: CircleAvatar(
              maxRadius: 28,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversation.picPath),
            ),
            title: Text(
              conversation.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
            subtitle: Text(
              conversation.message,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13
              ),
            ),
          );
        },
      ),
    );
  }
}
