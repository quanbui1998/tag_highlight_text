import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HighlightData {
  HighlightData({
    this.style,
    this.onTap,
    this.builder,
  });
  final TextStyle? style;

  /// [onTap] is only effective for events that directly hit the
  /// [text] in a tag which has not parent tag, not any of tag in tag.
  final void Function(String text)? onTap;

  /// [builder] allow custom build
  final InlineSpan Function(String text)? builder;
}

class TagHighlightText extends StatelessWidget {
  const TagHighlightText({
    Key? key,
    required this.text,
    required this.highlightBuilder,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaller = TextScaler.noScaling,
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
  final TextScaler textScaller;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;

  final HighlightData? Function(String tagName) highlightBuilder;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildTextSpan(),
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textScaler: textScaller,
      textDirection: textDirection,
    );
  }

  InlineSpan _buildTextSpan() {
    final matches = RegExp(r'</?[a-zA-Z0-9_-]+>').allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(text: text, style: textStyle);
    }

    final List<InlineSpan> childrenOfRoot = [];
    final List<_HighlightTag> listTagOpen = [];
    bool isValidText = true;

    for (int i = 0; i < matches.length; i++) {
      final element = matches.elementAt(i);
      final tag = text.substring(element.start, element.end);
      final isEnd = tag.startsWith('</');
      final tagName = tag.replaceAll(RegExp(r'[</>]'), '');
      if (isEnd) {
        if (listTagOpen.isNotEmpty && listTagOpen.last.tagName == tagName) {
          final highlightData = highlightBuilder(tagName);
          final textStart = matches.elementAt(i - 1).end;
          final textEnd = element.start;
          InlineSpan? childSpan;
          if (textStart < textEnd) {
            if (listTagOpen.last.children.isNotEmpty) {
              listTagOpen.last.children
                  .add(TextSpan(text: text.substring(textStart, textEnd)));
              childSpan = TextSpan(
                children: listTagOpen.last.children,
                style: highlightData?.style,
              );
            } else {
              final subText = text.substring(textStart, textEnd);
              childSpan = highlightData?.builder?.call(subText) ??
                  TextSpan(
                    text: subText,
                    style: highlightData?.style,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        highlightData?.onTap?.call(subText);
                      },
                  );
            }
          } else if (listTagOpen.last.children.isNotEmpty) {
            childSpan = TextSpan(
              children: listTagOpen.last.children,
              style: highlightData?.style,
            );
          }
          listTagOpen.removeLast();
          if (childSpan != null) {
            if (listTagOpen.isNotEmpty) {
              listTagOpen.last.children.add(childSpan);
            } else {
              childrenOfRoot.add(childSpan);
            }
          }
        } else {
          isValidText = false;
          break;
        }
      } else {
        final statusText = _HighlightTag(
          tagName: tagName,
          positionStart: element.start,
          positionEnd: element.end,
        );
        final textStart = i > 0 ? matches.elementAt(i - 1).end : 0;
        final textEnd = statusText.positionStart;
        if (textStart < textEnd) {
          final textSpan = TextSpan(text: text.substring(textStart, textEnd));
          if (listTagOpen.isNotEmpty) {
            listTagOpen.last.children.add(textSpan);
          } else {
            childrenOfRoot.add(textSpan);
          }
        }
        listTagOpen.add(statusText);
      }
    }

    if (isValidText && listTagOpen.isEmpty) {
      if (matches.last.end < text.length) {
        childrenOfRoot.add(TextSpan(text: text.substring(matches.last.end)));
      }
      return TextSpan(children: childrenOfRoot, style: textStyle);
    } else {
      return TextSpan(text: text, style: textStyle);
    }
  }
}

class _HighlightTag {
  _HighlightTag({
    required this.tagName,
    required this.positionStart,
    required this.positionEnd,
  });

  final String tagName;
  final int positionStart;
  final int positionEnd;
  List<InlineSpan> children = [];
}
