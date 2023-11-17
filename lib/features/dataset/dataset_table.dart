import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final List<String> columnNames;

  DataTableWidget(this.columnNames, {Key? key}) : super(key: key);

  // A method to get the data from the R Script and parse it to make rows
  
  List<DataRow> makeRows(){
       return DataRow(cells: []).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns:[
        DataColumn(label: Text('Variable'))
        DataColumn(label: Text('DataType'))
      ],
      rows: [],
      
    );
  }
}
