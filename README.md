# Tag Highlight Text Library

This library will support highlight text by tags with specific styles and tap actions.

<img src="https://user-images.githubusercontent.com/48360868/153123301-b7a93a8c-c7a7-425a-8ba9-60b7fb5a6733.png" width="320px" />

## Usage

To use this package, add `tag_highlight_text` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

Import the library
``` dart
import 'package:tag_highlight_text/tag_highlight_text.dart';
```

You need use tags to mark highlight texts
``` dart
final text = 'This is <highlight>Highlight <bold>Text</bold></highlight>';
```

After, call the `TagHighlightText` widget and define `highlightMaps` to set style and tap actions for each tags.
``` dart
TagHighlightText(
  text: text,
  highlightMaps: {
    'highlight': HighlightData(
      style: TextStyle(
        color: Colors.red,
      ),
    ),
    'bold': HighlightData(
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      onTap: () {
        print('Click');
      },
    )
  },
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 18,
  ),
),
```
