import 'package:flutter/material.dart';
import 'package:tag_highlight_text/tag_highlight_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        'This is <highlight>Highlight <bold>Text</bold></highlight>. Click <link>here</link>';
    return Scaffold(
      appBar: AppBar(
        title: Text("Tag Highlight Text Example"),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: TagHighlightText(
              text: text,
              highlightBuilder: (tagName) {
                switch (tagName) {
                  case 'highlight':
                    return HighlightData(
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    );
                  case 'bold':
                    return HighlightData(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case 'link':
                    return HighlightData(
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      onTap: () {
                        print('Click');
                      },
                    );
                }
              },
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          )),
    );
  }
}
