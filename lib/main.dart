import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: "Temperature Converter",
    theme: ThemeData(
      // Define the default Brightness and Colors
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
      accentColor: Colors.blueGrey,
    ),
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Temperature Converter"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: getImage(),
              ),
              Temperature(),
            ],
          ),
        ));
  }
}

Widget getImage() {
  AssetImage asset = AssetImage('images/temp.png');
  Image image = Image(
    image: asset,
    width: 160.0,
    height: 160.0,
  );
  return image;
}

class Temperature extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TemperatureState();
  }
}

class _TemperatureState extends State<Temperature> {
  var tempInputUnit = ['Celsius', 'Fahrenheit', 'Kelvin'];
  var currentTempInputUnit = 'Celsius';

  var tempOutputUnit = ['Celsius', 'Fahrenheit', 'Kelvin'];
  var currentTempOutputUnit = 'Kelvin';

  double inputTemperature;
  double kelvinTemperature;
  double outputTemperature;

  String outputStr='';

  void setKelvinT() {
    switch (currentTempInputUnit) {
      case 'Celsius':
        kelvinTemperature = inputTemperature + 273;
        break;
      case 'Kelvin':
        kelvinTemperature = inputTemperature;
        break;
      case 'Fahrenheit':
        kelvinTemperature = (inputTemperature - 32) * 5 / 9 + 273;
        break;
    }
  }

  void setOutputT() {
    switch (currentTempOutputUnit) {
      case 'Celsius':
        outputTemperature = kelvinTemperature - 273;
        break;
      case 'Kelvin':
        outputTemperature = kelvinTemperature;
        break;
      case 'Fahrenheit':
        outputTemperature = (kelvinTemperature - 273) * 9 / 5 + 32;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //input lint
      Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10.0),
              width: 200,
              //  padding: EdgeInsets.all(10.0),

              child: TextField(
                onSubmitted: (T) {
                  setState(() {
                    double input = double.parse(T);
                    inputTemperature = input;
                    setKelvinT();
                    setOutputT();
                    outputStr= outputTemperature.toStringAsFixed(2);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    
                    labelText: "Temperature",
                    helperText: "In $currentTempInputUnit"),
              )),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: DropdownButton<String>(
              items: tempInputUnit.map((String dropTempInputUnit) {
                return DropdownMenuItem<String>(
                  value: dropTempInputUnit,
                  child: Text(dropTempInputUnit),
                );
              }).toList(),
              onChanged: (String newSelectedUnit) {
                setState(() {
                  currentTempInputUnit = newSelectedUnit;
                  setKelvinT();
                  setOutputT();
                  outputStr= outputTemperature.toStringAsFixed(2);
                });
              },
              value: currentTempInputUnit,
            )),
          ),
        ],
      ),

      //output line
      Padding(
          padding: EdgeInsets.only(top: 50.0, left: 30.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(top: 35.0),
                      width: 200,
                      height: 100,
                      child: Text(
                        outputStr,
                        style: TextStyle(fontSize: 32.0),
                      ))),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                child: DropdownButton<String>(
                  items: tempOutputUnit.map((String dropTempOutputUnit) {
                    return DropdownMenuItem<String>(
                      value: dropTempOutputUnit,
                      child: Text(dropTempOutputUnit),
                    );
                  }).toList(),
                  onChanged: (String newSelectedUnit) {
                    setState(() {
                      currentTempOutputUnit = newSelectedUnit;
                      setOutputT();
                      outputStr= outputTemperature.toStringAsFixed(2);
                    });
                  },
                  value: currentTempOutputUnit,
                ),
              )),
            ],
          )),
    ]);
  }
}
