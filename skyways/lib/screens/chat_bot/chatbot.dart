import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:skyways/utils/utils.dart';


class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'Gemini',
    profileImage:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuy9ucswKvd8dPqg9CvrmJiEH5ngED9xLgrQ&s",
  );

  @override
  Widget build(BuildContext context) {
    return DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,

        // ✅ Customize message bubbles
        messageOptions: MessageOptions(
          currentUserContainerColor: themecolor,
          containerColor: Colors.grey.shade300,
          currentUserTextColor: Colors.white,
          textColor: Colors.black87,
          messagePadding:  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          messageDecorationBuilder: (message, previousMessage, nextMessage) {
            bool isUser = message.user == currentUser;
            return BoxDecoration(
              color: isUser ? themecolor : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            );
          },
        ),

        // ✅ Customize input field and send button
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            hintText: "Type your message...",
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
          sendButtonBuilder: (onSend) {
            return IconButton(
              icon: Icon(Icons.send, color: themecolor),
              onPressed: onSend,
            );
          },
        ),

    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;

      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;

        String response = event.content?.parts?.fold("", (previous, current) {
              if (current is TextPart) {
                return "$previous ${current.text}";
              }
              return previous;
            }) ??
            "";

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
