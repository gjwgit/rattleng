import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final List<String> columnNames;

  DataTableWidget(this.columnNames, {Key? key}) : super(key: key);

  // A method to make rows from variable names
  // In a given row , the first element is the row name ,
  //The second element is the datatype
  //The third element is a drop down with 5 options {Input , Text , Risk , Ident , Weight}
  List<DataRow> makeVarNames(List<String> varNames) {
    return varNames.map((String varName) {
      return DataRow(
        cells: [
          DataCell(Text(varName)),
          DataCell(const Text("Type")),
          DataCell(
            DropdownButton<String>(
              value: "input",
              items: [
                DropdownMenuItem(
                  child: Text("Input"),
                  value: 'input',
                ),
                DropdownMenuItem(
                  child: Text("Target"),
                  value: 'text',
                ),
                DropdownMenuItem(
                  child: Text("Risk"),
                  value: 'risk',
                ),
                DropdownMenuItem(
                  child: Text("Ident"),
                  value: 'weight',
                ),
              ],
              onChanged: (String? value) {
                print(value);
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Variable')),
        DataColumn(label: Text('DataType')),
        DataColumn(label: Text('Role'))
      ],
      rows: makeVarNames(["a", "b", "c"].toList()),
    );
  }
}
