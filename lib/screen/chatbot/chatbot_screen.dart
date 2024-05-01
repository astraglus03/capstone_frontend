import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  String? sTTResult;

  final _openAI = OpenAI.instance.build(
    token: dotenv.env['OPENAI_API_KEY'],
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Kim', lastName: 'KeonDong');
  final ChatUser _gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'Gpt');

  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text(
          'ChatGPT 3.5 turbo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: (){},
          ),
        ],
      ),
      body: DashChat(
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(
            0,
            166,
            126,
            1,
          ),
          textColor: Colors.white,
        ),
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        inputOptions: const InputOptions(
          sendOnEnter: true,
        ),
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    List<Map<String, dynamic>> messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return {
          'role': 'user',
          'content': m.text,
        };
      } else {
        return {
          'role': 'assistant',
          'content': m.text,
        };
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory,
      maxToken: 200,
    );
    final resp = await _openAI.onChatCompletion(request: request);

    for (var element in resp!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }



}
