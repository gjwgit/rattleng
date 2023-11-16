import 'package:flutter/material.dart';

class DataTable extends StatelessWidget {
  List<String> column_names;

  DataTable(this.column_names, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Table(
      children: [
        TableRow(
          children: column_names.map((String colName) {
            return Text(colName);
          }).toList(),
        ),
      ],
    );
  }
}
