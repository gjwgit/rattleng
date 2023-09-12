import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkDownWidget extends StatelessWidget {
  late String data;
  MarkDownWidget(this.data);
  @override
  Widget build(BuildContext context) {
    print("The widget is created with data " + this.data);
    // TODO: implement build
    return Markdown(data: data);
  }
}
