import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student GPA Predictor",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student GPA Predictor")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PredictionPage()));
          },
          child: Text("Go to Prediction"),
        ),
      ),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _controllers = {
    "Age": TextEditingController(),
    "Gender": TextEditingController(),
    "Ethnicity": TextEditingController(),
    "ParentalEducation": TextEditingController(),
    "StudyTimeWeekly": TextEditingController(),
    "Absences": TextEditingController(),
    "Tutoring": TextEditingController(),
    "ParentalSupport": TextEditingController(),
    "Extracurricular": TextEditingController(),
    "Sports": TextEditingController(),
    "Music": TextEditingController(),
    "Volunteering": TextEditingController(),
  };
  String _result = "";

  Future<void> _predict() async {
    final url = Uri.parse("https://student-performance-api-wknc.onrender.com/predict"); 
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Age": int.parse(_controllers["Age"]!.text),
          "Gender": int.parse(_controllers["Gender"]!.text),
          "Ethnicity": int.parse(_controllers["Ethnicity"]!.text),
          "ParentalEducation": int.parse(_controllers["ParentalEducation"]!.text),
          "StudyTimeWeekly": double.parse(_controllers["StudyTimeWeekly"]!.text),
          "Absences": int.parse(_controllers["Absences"]!.text),
          "Tutoring": int.parse(_controllers["Tutoring"]!.text),
          "ParentalSupport": int.parse(_controllers["ParentalSupport"]!.text),
          "Extracurricular": int.parse(_controllers["Extracurricular"]!.text),
          "Sports": int.parse(_controllers["Sports"]!.text),
          "Music": int.parse(_controllers["Music"]!.text),
          "Volunteering": int.parse(_controllers["Volunteering"]!.text),
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = "Predicted GPA: ${data['predicted_gpa'].toStringAsFixed(2)}";
        });
      } else {
        setState(() {
          _result = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Predict GPA")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controllers["Age"], decoration: InputDecoration(labelText: "Age (15-18)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Gender"], decoration: InputDecoration(labelText: "Gender (0: Male, 1: Female)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Ethnicity"], decoration: InputDecoration(labelText: "Ethnicity (0-3)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["ParentalEducation"], decoration: InputDecoration(labelText: "Parental Education (0-4)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["StudyTimeWeekly"], decoration: InputDecoration(labelText: "Study Time Weekly (0-20)"), keyboardType: TextInputType.numberWithOptions(decimal: true)),
            TextField(controller: _controllers["Absences"], decoration: InputDecoration(labelText: "Absences (0-30)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Tutoring"], decoration: InputDecoration(labelText: "Tutoring (0: No, 1: Yes)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["ParentalSupport"], decoration: InputDecoration(labelText: "Parental Support (0-4)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Extracurricular"], decoration: InputDecoration(labelText: "Extracurricular (0: No, 1: Yes)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Sports"], decoration: InputDecoration(labelText: "Sports (0: No, 1: Yes)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Music"], decoration: InputDecoration(labelText: "Music (0: No, 1: Yes)"), keyboardType: TextInputType.number),
            TextField(controller: _controllers["Volunteering"], decoration: InputDecoration(labelText: "Volunteering (0: No, 1: Yes)"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _predict, child: Text("Predict")),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}