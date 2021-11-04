/*
import 'package:flutter/material.dart';
import 'package:lsu_app/modelo/Noticia.dart';


class BuscadorNoticias extends SearchDelegate {
  final List<Noticia> noticia;
  final List<Noticia> noticiaSugerida;
  final bool isUsuarioAdmin;

  BuscadorNoticias(this.noticia, this.noticiaSugerida, this.isUsuarioAdmin);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }


}
 // Widget de buscador
class buscador extends StatefulWidget{
  final String texto;
  final ValueChanged<String> onChanged;
  final String hintText;

  const buscador({
    Key key, this.texto, this.onChanged, this.hintText
}) : super(key:key);

  @override
  _buscadorState createState() => _buscadorState();

}
class _buscadorState extends State<buscador>{

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final estiloActivo = TextStyle(color: Colors.black);
    final estiloSombra = TextStyle(color: Colors.black54);
    final estilo = widget.texto.isEmpty ? estiloSombra : estiloActivo;

    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.close, color: estilo.color),
          hintText: widget.texto,
          border: InputBorder.none,
          hintStyle: estilo,
          suffixIcon: widget.texto.isNotEmpty
            ? GestureDetector(
            child: Icon(Icons.close, color: estilo.color),
            onTap: (){
              controller.clear();
              widget.onChanged('');
              FocusScope.of(context).requestFocus(Focus.of(context));
            },
          )
            : null,
        ),
        style: estilo,
        onChanged: widget.onChanged,
      ),
    );
  }
}

*/