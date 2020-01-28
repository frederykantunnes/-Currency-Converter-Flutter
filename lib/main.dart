
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=ff7b061b";

void main() async{

//  print(await getData());

  runApp(MaterialApp(
    title: "Conversor de Moeda",
    home: Home(),

  ));
}


Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController =  TextEditingController();
  final dollarController =  TextEditingController();
  final euroController =  TextEditingController();

  void _realChanged(String text){
    double real = double.parse(text);
    dollarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dollarChanged(String text){
    double dollar = double.parse(text);
    realController.text = (dollar*this.dolar).toStringAsFixed(2);
    euroController.text = ((dollar*this.dolar)/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euto = double.parse(text);
    realController.text = (euto * this.euro).toStringAsFixed(2);
    dollarController.text = ((euto*this.euro)/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Moeda", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados", style: TextStyle(color: Colors.white),)
              );
            default:
              if(snapshot.hasError){
                return Center(
                    child: Text("Erro :(", style: TextStyle(color: Colors.white),)
                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150, color: Colors.amber,),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dollar", "\$", dollarController, _dollarChanged),
                      Divider(),
                      buildTextField("Euros", "E", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}



Widget buildTextField(String label, String prefix, TextEditingController tec, Function function){
  return TextField(
    keyboardType: TextInputType.number,
    controller: tec,
    onChanged: function,
    decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder()
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
  );
}