import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/chats/models/message_model.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hushh_proto/widgets/snackbars.dart';

class AiChatBot extends StatefulWidget {
  const AiChatBot({super.key});

  @override
  State<AiChatBot> createState() => _AiChatBotState();
}

class _AiChatBotState extends State<AiChatBot> {
  //Controllers
  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  //Variables
  bool loading = true;
  bool fetchingContent = true;
  String stats = '';
  int basicTests = 0;
  int advTests = 0;
  double basicScore = 0.0;
  double advScore = 0.0;

  //Chat
  List<Message> chatList = [];

  //function
  Future<void> geminiAPI(String prompt) async {
    List contents = [
      {
        "role": "user",
        "parts": [
          {
            "text":
                "Imagine your are a stock market wizard. You have 30 years of experience in trading and you also have a masteres degree in it. You are the smartest trader in the world"
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "Okay. I am a stock market wizard."}
        ]
      },
      {
        "role": "user",
        "parts": [
          {
            "text":
                "Now imagine I am your student and you are getting old. Hence, you decide to transfer all your knowledge to me so that I can carry the legacy."
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "Sure, I will answer all of your questions"}
        ]
      },
      {
        "role": "user",
        "parts": [
          {
            "text":
                "Now in the past ${basicTests.toStringAsFixed(2)} basic tests I scored ${basicScore.toStringAsFixed(2)}%. The basic tests includes basic level theoritical knowledge and bookish concepts. I also scored $advScore% in advance tests which includes pattern recognition, support and resistance identificaiton and more complex stuff."
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "I have noted down your test scores"}
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": "Now analyze my scores and answer my questions."}
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "I have analyzed your profile. How can I help you today?"}
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": prompt}
        ]
      },
    ];
    try {
      // Define the endpoint URL
      const String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBdUzwBDPozaAmnw8P6uku2QlkoVeXCpWA';

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "contents": contents,
            "generationConfig": {
              "temperature": 0.6,
              "topK": 1,
              "topP": 1,
              "maxOutputTokens": 1024,
              "stopSequences": []
            },
            "safetySettings": [
              {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              }
            ]
          },
        ),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        debugPrint('Prompt sent successfully');
        setState(() {
          var body = jsonDecode(response.body);

          chatList.add(
            Message(
              sender: 'model',
              content: body['candidates'][0]['content']['parts'][0]['text'],
            ),
          );

          //adding in the chat history for knowledge persistence
          contents.add({
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          });
          contents.add({
            "role": "model",
            "parts": [
              {"text": body['candidates'][0]['content']['parts'][0]['text']}
            ]
          });
        });
      } else {
        errorSnackbar(context, 'Something went wrong.');
      }
    } catch (e) {
      debugPrint('Error sending prompt: $e');
    }
    setState(() {
      loading = false;
    });
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
    );
  }

  //Functions
  void fetchScores() async {
    var data = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();
    basicScore = data['basic_score'];
    basicTests = data['basic_tests'];
    advScore = data['adv_score'];
    advTests = data['adv_tests'];
    debugPrint('$basicScore $basicTests $advScore $advTests');
    setState(() {
      fetchingContent = false;
      loading = false;
    });
  }

  @override
  void initState() {
    fetchScores();
    chatList.add(Message(
        sender: 'model',
        content:
            'I have analyzed your profile and ready to answer your question. How can I help you?'));
    super.initState();
  }

  @override
  void dispose() {
    fetchingContent = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatText(String input) {
      String formattedText = input.replaceAll("**", "");

      return formattedText;
    }

    return Scaffold(
      backgroundColor: Pallet.black15,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Pallet.black15,
        title: Text(
          'AI Chat',
          style: TextStyle(
            color: Pallet.white,
          ),
        ),
        centerTitle: true,
      ),
      body: fetchingContent
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Pallet.blue,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Fetching your Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Pallet.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                //Chat interface
                const SizedBox(height: 20),
                Expanded(
                  child: chatList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/logo_light.svg"),
                              const SizedBox(height: 20),
                              Text(
                                'Personalized Growth\nCoach',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Pallet.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RawScrollbar(
                          thickness: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          controller: chatScrollController,
                          child: ListView.builder(
                            controller: chatScrollController,
                            itemCount: chatList.length,
                            itemBuilder: (context, index) {
                              Message msg = chatList[index];
                              bool owner = msg.sender == 'user' ? true : false;
                              String message = formatText(msg.content);

                              return Wrap(
                                alignment: owner
                                    ? WrapAlignment.end
                                    : WrapAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      owner ? 50 : 10,
                                      5,
                                      owner ? 10 : 50,
                                      5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Pallet.white,
                                    ),
                                    child: Text(
                                      message,
                                      softWrap: true,
                                      // maxLines: null,
                                      style: TextStyle(
                                        color: Pallet.black30,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),

                //Chat Box
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Pallet.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: chatController,
                            cursorColor: Pallet.white,
                            style: TextStyle(
                              color: Pallet.white,
                            ),
                            maxLines: null,
                            cursorRadius: const Radius.circular(100),
                            cursorOpacityAnimates: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Message',
                              hintStyle: TextStyle(
                                color: Pallet.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: IconButton.filledTonal(
                          color: Colors.white,
                          style: IconButton.styleFrom(
                              backgroundColor: Pallet.white),
                          onPressed: () {
                            if (chatController.text.trim().isNotEmpty &&
                                !loading) {
                              setState(() {
                                chatList.add(
                                  Message(
                                    sender: 'user',
                                    content: chatController.text.trim(),
                                  ),
                                );
                                loading = true;
                              });

                              geminiAPI(chatController.text.trim());
                              chatController.clear();
                            }
                          },
                          icon: loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Pallet.black30,
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
