import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final List<String> columnNames;

  DataTableWidget(this.columnNames, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: columnNames.map((String colName) {
            return TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  colName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
        // Add more rows as needed
      ],
    );
  }
}
