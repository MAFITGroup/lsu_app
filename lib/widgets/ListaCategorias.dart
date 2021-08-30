import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaCategorias extends StatefulWidget {
  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {

  List<Item> _data = generateItem(10);

  Widget _buildPanelList(){
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded){
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item){
        return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded){
              return ListTile(
                title: Text(item.headerValue),
              );
        },
        body: ListTile(
        title: Text(item.expandedValue),
        subtitle: Text('Eliminar'),
        trailing: Icon(Icons.delete),
        onTap: (){
          setState(() {
            _data.removeWhere((currentItem) => item == currentItem);
          });
        }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanelList(),
        ),
      ),
    );
  }
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({this.expandedValue, this.headerValue, this.isExpanded =false});
}

List<Item> generateItem(int numberOfItems) {
  return List.generate(numberOfItems, (index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is the item $index'
    );
  });
}
