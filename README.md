# Tag Highlight Text Library

This library will support highlight text by tags with specific styles and tap actions.

<img src="https://user-images.githubusercontent.com/48360868/153562286-7da63b43-6e18-4cb4-aa0e-3ed8540eabdd.png" width="320px" />


## Usage

To use this package, add `tag_highlight_text` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

Import the library
``` dart
import 'package:tag_highlight_text/tag_highlight_text.dart';
```

You need use tags to mark highlight texts
``` dart
final text = 'This is <highlight>Highlight <bold>Text</bold></highlight>. Click <link>here</link>';
```

After, call the `TagHighlightText` widget and define `highlightBuilder` to set style and tap actions for each tags.
``` dart
TagHighlightText(
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
```
