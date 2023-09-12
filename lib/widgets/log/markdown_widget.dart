import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

///A markdown widget without any scrollable behaviour
///The documentation for MarkDownBody is at
///https://pub.dev/packages/flutter_markdown#:~:text=const%20MarkdownBody(data%3A%20markdownSource)%3B
///Using the data parameter for easy access
class MarkDownWidget extends StatelessWidget {
  late String data;
  MarkDownWidget(this.data);
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(data: data);
  }
}
