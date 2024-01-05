import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/provider/stdout.dart'; // Import the provider for stdout
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/r/extract_types.dart';

class DataTableWidget extends ConsumerStatefulWidget {
  final List<String> columnNames;

  DataTableWidget(this.columnNames, {Key? key}) : super(key: key);

  //Create the initial state of the widget
  //Which in this case sets the values for the dropdown
  @override
  ConsumerState<DataTableWidget> createState() {
    return _DataTableWidgetState();
  }
}

class _DataTableWidgetState extends ConsumerState<DataTableWidget> {
  //A dictionary to store the role of each column in the dataset
  //The key is the column name
  //value is the column name
  Map<String, String> dropdownValues = {};

  // A method to make rows from variable names
  // In a given row , the first element is the row name ,
  //The second element is the datatype
  //The third element is a drop down with 5 options {Input , Text , Risk , Ident , Weight}
  //Widget should also also accomodate other parameters such as sK
  List<DataRow> makeVarNames(List<String> varNames) {
    return varNames.map((String varName) {
      //Process the varnames using regexp to remove "[" aretefacts
      RegExp pattern = RegExp(r'[^a-zA-Z0-9]');
      String newVar = varName.replaceFirstMapped(pattern, (m) => "_");
      print('The new variable is  ${newVar}');
      //Default to input if a role is not selected
      dropdownValues.putIfAbsent(newVar, () => 'Input');
      return DataRow(
        cells: [
          DataCell(Text(newVar)),
          const DataCell(Text("Type")),
          DataCell(
            DropdownButton<String>(
              value: dropdownValues[newVar],
              items: const [
                DropdownMenuItem(
                  value: 'Input',
                  child: Text("Input"),
                ),
                DropdownMenuItem(
                  value: 'Target',
                  child: const Text("Target"),
                ),
                DropdownMenuItem(
                  value: 'Risk',
                  child: Text("Risk"),
                ),
                DropdownMenuItem(
                  value: 'Weight',
                  child: Text("Weight"),
                ),
              ],
              //Set the current value of the dropdown
              //Use the setstate() method that comes with
              //a stateful widget
              onChanged: (String? value) {
                setState(() {
                  dropdownValues[newVar] = value!;
                  print(value);
                });
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  //Building the data table widget.
  //TODO : Implement a scrollable widget so
  //that all the variables can be viewed
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Variable')),
          DataColumn(label: Text('DataType')),
          DataColumn(label: Text('Role')),
        ],
        rows: makeVarNames(ExtractVariables(stdout)),
      ),
    );
  }

  //A method to get the variable Names from the console
  //Use execute.dart and extract to get the variable names
  //stdout is the console out
  List<String> ExtractVariables(String stdout) {
    List<String> varNames = List.empty(growable: true);
    varNames = rExtractVars(stdout);
    return varNames;
  }

  //A method to get the variable types from the console
  List<String> ExtractTypes(String stdout) {
    List<String> varTypes = List.empty(growable: true);
    varTypes = rExtractTypes(stdout);
  }
}
