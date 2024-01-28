import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/provider/stdout.dart'; // Import the provider for stdout
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/r/extract_types.dart';
import 'package:rattle/r/execute.dart';

class DataTableWidget extends ConsumerStatefulWidget {
  final List<String> columnNames;

  DataTableWidget(this.columnNames, {Key? key}) : super(key: key);

  //Create the initial state of the widget
  //Which in this case sets the values for the dropdown
  @override
  ConsumerState<DataTableWidget> createState() {
    //What happens when you execute the command here ??
    return _DataTableWidgetState();
  }
}

class _DataTableWidgetState extends ConsumerState<DataTableWidget> {
  //A dictionary to store the role of each column in the dataset
  //The key is the column name
  //value is the role of the parameter
  Map<String, String> dropdownValues = {};

  ///Uses the Future builder widget becauase:
  ///[extractTypes] can be passed as  snapshot , which makes implementation
  ///flexible and readable

  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);
    return FutureBuilder<List<String>>(
        future: extractTypes(stdout),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data!.length <= 1) {
            return const SizedBox(
                height: 0.001,
                width: 0.001,
                child: CircularProgressIndicator());

            //UI Element to let the user know that the future is being fetched
          } else if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          } else {
            List<String> types = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Variable')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Role')),
                ],
                rows: makeVars(extractVariables(stdout), types),
              ),
            );
          }
        });
  }

  //A method to get the variable Names from the console
  //Use execute.dart and extract to get the variable names
  //stdout is the console out
  List<String> extractVariables(String stdout) {
    List<String> varNames = List.empty(growable: true);
    varNames = rExtractVars(stdout);
    return varNames;
  }

  Future<List<String>> extractTypes(String stdout) async {
    List<String> varTypes = List.empty(growable: true);
    varTypes = await rExtractTypes(stdout);
    return varTypes;
  }

  //Rewrite the makeVars Method to implment fetching the type of variables
  //and the names of the variables
  ///[makeVars] (This method implements the [MappedIterator])
  ///[MappedIterator] extension makes the code more readable
  List<DataRow> makeVars(List<String> varNames, List<String> varTypes) {
    return varNames.mapIndexed((index, element) {
      //Process the varnames using regexp to remove "[" aretefacts

      //TODO : Refactor the text preprocessing to extract_vars
      RegExp pattern = RegExp(r'[^a-zA-Z0-9]');
      String newVar = element.replaceFirstMapped(pattern, (m) => "_");
      debugPrint('The new variable is  $newVar');
      //Default to input if a role is not selected
      dropdownValues.putIfAbsent(newVar, () => 'Input');
      return DataRow(
        cells: [
          DataCell(Text(newVar)),
          DataCell(Text(varTypes[index])),
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
}

//Defining an indexed iterator that can be used to access the members of different lists
///The implementational details are explained in Lines [makeVars]

extension MappedIterator<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) sync* {
    int index = 0;
    for (var element in this) {
      debugPrint('$index is the index');
      yield f(index, element);
      index++;
    }
  }
}
