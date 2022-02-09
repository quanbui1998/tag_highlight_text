import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HighlightData {
  HighlightData({
    this.style,
    this.onTap,
  });
  final TextStyle? style;
  final VoidCallback? onTap;
}

class TagHighlightText extends StatelessWidget {
  const TagHighlightText({
    Key? key,
    required this.text,
    required this.highlightMaps,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;

  final Map<String, HighlightData> highlightMaps;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _generate(),
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
    );
  }

  TextSpan _generate() {
    final List<_StatusTag> statusTags = [];
    highlightMaps.forEach((tagName, _) {
      statusTags
          .addAll(RegExp('<$tagName>').allMatches(text).map((e) => _StatusTag(
                tagName: tagName,
                positionStart: e.start,
                positionEnd: e.end,
                isStart: true,
              )));
      statusTags
          .addAll(RegExp('</$tagName>').allMatches(text).map((e) => _StatusTag(
                tagName: tagName,
                positionStart: e.start,
                positionEnd: e.end,
                isStart: false,
              )));
    });
    statusTags.sort((a, b) => a.positionStart - b.positionStart);
    final List<_StatusText> listStatusTexts = [];
    for (int i = 0; i < statusTags.length; i++) {
      if (!statusTags[i].isStart) {
        if (i > 0 &&
            statusTags[i].tagName == statusTags[i - 1].tagName &&
            statusTags[i - 1].isStart) {
          final List<_StatusText> statusTextChildren = [];
          for (int j = 0; j < listStatusTexts.length; j++) {
            if (listStatusTexts[j].positionStart >
                    statusTags[i - 1].positionStart &&
                listStatusTexts[j].positionEnd < statusTags[i].positionEnd) {
              statusTextChildren.add(listStatusTexts[j]);
              listStatusTexts.removeAt(j);
              j--;
            }
          }
          listStatusTexts.add(_StatusText(
            tagName: statusTags[i].tagName,
            positionStart: statusTags[i - 1].positionStart,
            positionEnd: statusTags[i].positionEnd,
            children: statusTextChildren,
          ));
          statusTags.removeRange(i - 1, i + 1);
          i -= 2;
        } else {
          return TextSpan(text: text, style: textStyle);
        }
      }
    }
    if (listStatusTexts.isEmpty) {
      return TextSpan(text: text, style: textStyle);
    }
    return _buildTextSpan(
        _StatusText(
            tagName: '',
            positionStart: 0,
            positionEnd: 0,
            children: listStatusTexts),
        true);
  }

  TextSpan _buildTextSpan(_StatusText statusText, [bool isRoot = false]) {
    final highlightHandler = isRoot
        ? HighlightData(style: textStyle)
        : highlightMaps[statusText.tagName];
    final positionTextStart = isRoot
        ? 0
        : statusText.positionStart + '<${statusText.tagName}>'.length;
    final positionTextEnd = isRoot
        ? text.length
        : statusText.positionEnd - '</${statusText.tagName}>'.length;
    if (statusText.children.isNotEmpty) {
      statusText.children.sort((a, b) => a.positionStart - b.positionStart);
      int index = positionTextStart;
      final List<TextSpan> textSpanChildren = [];
      for (final element in statusText.children) {
        if (index < element.positionStart) {
          textSpanChildren.add(
              TextSpan(text: text.substring(index, element.positionStart)));
        }
        textSpanChildren.add(_buildTextSpan(element));
        index = element.positionEnd;
      }
      if (index < positionTextEnd) {
        textSpanChildren
            .add(TextSpan(text: text.substring(index, positionTextEnd)));
      }
      return TextSpan(
          children: textSpanChildren,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              highlightHandler?.onTap?.call();
            },
          style: highlightHandler?.style);
    } else {
      return TextSpan(
          text: text.substring(positionTextStart, positionTextEnd),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              highlightHandler?.onTap?.call();
            },
          style: highlightHandler?.style);
    }
  }
}

class _StatusText {
  _StatusText({
    required this.tagName,
    required this.positionStart,
    required this.positionEnd,
    required this.children,
  });

  final String tagName;
  final int positionStart;
  final int positionEnd;
  final List<_StatusText> children;
}

class _StatusTag {
  _StatusTag({
    required this.tagName,
    required this.positionStart,
    required this.positionEnd,
    required this.isStart,
  });
  final String tagName;
  final int positionStart;
  final int positionEnd;
  final bool isStart;
}
