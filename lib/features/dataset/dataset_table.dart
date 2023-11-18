import 'package:flutter/material.dart';

class DataTableWidget extends StatefulWidget {
  final List<String> columnNames;

  DataTableWidget(this.columnNames, {Key? key}) : super(key: key);

  //Create the initial state of the widget
  //Which in this case sets the values for the dropdown
  @override
  State<StatefulWidget> createState() {
    return _DataTableWidgetState();
  }
}

class _DataTableWidgetState extends State<DataTableWidget> {
  //A dictionary to store the role of each column in the dataset
  //The key is the column name
  //value is the column name
  Map<String, String> dropdownValues = {};

  // A method to make rows from variable names
  // In a given row , the first element is the row name ,
  //The second element is the datatype
  //The third element is a drop down with 5 options {Input , Text , Risk , Ident , Weight}
  List<DataRow> makeVarNames(List<String> varNames) {
    return varNames.map((String varName) {
      //Default to input if a role is not selected
      dropdownValues.putIfAbsent(varName, () => 'Input');
      return DataRow(
        cells: [
          DataCell(Text(varName)),
          DataCell(const Text("Type")),
          DataCell(
            DropdownButton<String>(
              value: dropdownValues[varName],
              items: [
                DropdownMenuItem(
                  child: Text("Input"),
                  value: 'Input',
                ),
                DropdownMenuItem(
                  child: Text("Target"),
                  value: 'Target',
                ),
                DropdownMenuItem(
                  child: Text("Risk"),
                  value: 'Risk',
                ),
                DropdownMenuItem(
                  child: Text("Weight"),
                  value: 'Weight',
                ),
              ],
              //Set the current value of the dropdown
              //Use the setstate() method that comes with
              //a stateful widget
              onChanged: (String? value) {
                setState(() {
                  dropdownValues[varName] = value!;
                  print(value);
                });
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
