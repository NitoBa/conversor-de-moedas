import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=c1e69041";

void main() async {
  

  runApp(MyApp());
  
} 

    

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber))
        ),
        hintColor: Colors.amber,
        primarySwatch: Colors.amber,
      ),
      home: HomePage()
    );
  }
}

Future<Map> getData() async {

  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);

  }

  void _dolarChanged(String text){
    
    double dolar = double.parse(text);
    realController.text = (this.dolar * dolar).toStringAsFixed(2);
    euroController.text = (this.dolar * dolar / euro) .toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (this.euro * euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de moedas", style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              realController.text = "";
              dolarController.text = "";
              euroController.text = "";
            },
            iconSize: 40,
            icon: Icon(Icons.refresh, color: Colors.black),
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber, fontSize: 25
                    )
                  ),
                );
              default: 
                  if (snapshot.hasError) {
                    return Center(
                  child: Text("Erro ao carregar Dados :(",
                  style: TextStyle(
                    color: Colors.amber, fontSize: 25
                    )
                  ),
                );
                  }else{
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return 
                  

                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                          ),
                          SizedBox(height: 20),  
                            buildTextFild("Reais", "R\$", realController, _realChanged), 
                          SizedBox(height: 20),
                            buildTextFild("Dolares", "US\$", dolarController, _dolarChanged), 
                          SizedBox(height: 20),
                            buildTextFild("Euros", "£U\$", euroController, _euroChanged),
                          SizedBox(height: 40,),
                          Text("Informe os valores acima",
                          style: TextStyle(fontSize: 30, color: Colors.amber, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          
                          ),
                          SizedBox(height: 200,),
                          Text("App by Nito_b.a",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.center,
                          ),
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


Widget buildTextFild(String label, String prefix, TextEditingController controllers, Function changed){ 
  return TextField(
            controller: controllers,
            keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: label,
                  labelStyle: TextStyle(fontSize: 35),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixText: prefix,
                    prefixStyle: TextStyle(color: Colors.amber, fontSize: 20),
                ),
                    style: TextStyle(color: Colors.amber, fontSize: 20),
            onChanged: changed,         
            );
}

