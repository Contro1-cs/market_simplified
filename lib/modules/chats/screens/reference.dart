import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/modules/chats/models/message_model.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hushh_proto/widgets/snackbars.dart';

bool lightMode = false;

class Referance extends StatefulWidget {
  const Referance({super.key, required this.title});
  final String title;

  @override
  State<Referance> createState() => _ReferanceState();
}

class _ReferanceState extends State<Referance> {
  //Controllers
  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  //Variables
  bool loading = true;
  bool fetchingContent = true;
  String stats = '';

  //github
  List repoContent = [];
  Map<String, int> languageStats = {};
  Map<String, int> languagePercentStats = {};

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
                "Hey Gemini, I want to make some advancements in my career and I need your help to get me there. I need answers that are on point and dont give too long answers, short and medium size answers are appreciated."
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text":
                "Sure, I will answer your questions in short and consize way."
          }
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

  @override
  void initState() {
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
      backgroundColor: lightMode ? Pallet.white : Pallet.black30,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: lightMode ? Pallet.white : Pallet.black30,
        title: Text(
          widget.title,
          style: TextStyle(
            color: lightMode ? Pallet.black30 : Pallet.white,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: lightMode ? Pallet.black30 : Pallet.white,
            ), // Three dots icon
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    // SvgPicture.asset(
                    //   'assets/github.svg',
                    //   height: 20,
                    // ),
                    SizedBox(width: 5),
                    Text('Change Github Info'),
                  ],
                ),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Pallet.red,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Reset chat',
                      style: TextStyle(color: Pallet.red),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    chatList.clear();
                  });
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      lightMode ? Icons.dark_mode : Icons.light_mode,
                      color: Pallet.black30,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      lightMode ? 'Dark Mode' : 'Light Mode',
                      style: const TextStyle(color: Pallet.black30),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    lightMode = !lightMode;
                  });
                },
              ),
            ],
          ),
        ],
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
                              lightMode
                                  ? SvgPicture.asset("assets/logo_dark.svg")
                                  : SvgPicture.asset("assets/logo_light.svg"),
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
                                      color: lightMode
                                          ? Pallet.blue
                                          : Pallet.white,
                                    ),
                                    child: Text(
                                      message,
                                      softWrap: true,
                                      // maxLines: null,
                                      style: TextStyle(
                                        color: lightMode
                                            ? Pallet.white
                                            : Pallet.black30,
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
                            color: lightMode
                                ? Pallet.black30.withOpacity(0.2)
                                : Pallet.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: chatController,
                            cursorColor:
                                lightMode ? Pallet.black30 : Pallet.white,
                            style: TextStyle(
                              color: lightMode ? Pallet.black30 : Pallet.white,
                            ),
                            maxLines: null,
                            cursorRadius: const Radius.circular(100),
                            cursorOpacityAnimates: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Message',
                              hintStyle: TextStyle(
                                color: lightMode
                                    ? Pallet.black30.withOpacity(0.5)
                                    : Pallet.white.withOpacity(0.5),
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
                              backgroundColor:
                                  lightMode ? Pallet.black30 : Pallet.white),
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
                                  color:
                                      lightMode ? Pallet.white : Pallet.black30,
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
