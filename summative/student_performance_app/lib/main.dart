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
  // Controllers for numeric fields
  final _studyTimeController = TextEditingController();
  final _absencesController = TextEditingController();

  // Selected values for dropdowns (mapped to numeric values)
  Map<String, int?> _dropdownValues = {
    "Age": null,
    "Gender": null,
    "Ethnicity": null,
    "ParentalEducation": null,
    "Tutoring": null,
    "ParentalSupport": null,
    "Extracurricular": null,
    "Sports": null,
    "Music": null,
    "Volunteering": null,
  };

  String _result = "";

  // Dropdown options mapped to their numeric values
  final Map<String, List<Map<String, dynamic>>> _dropdownOptions = {
    "Age": [
      {"display": "15 years", "value": 15},
      {"display": "16 years", "value": 16},
      {"display": "17 years", "value": 17},
      {"display": "18 years", "value": 18},
    ],
    "Gender": [
      {"display": "Male", "value": 0},
      {"display": "Female", "value": 1},
    ],
    "Ethnicity": [
      {"display": "Caucasian", "value": 0},
      {"display": "African American", "value": 1},
      {"display": "Asian", "value": 2},
      {"display": "Other", "value": 3},
    ],
    "ParentalEducation": [
      {"display": "None", "value": 0},
      {"display": "High School", "value": 1},
      {"display": "Some College", "value": 2},
      {"display": "Bachelor's", "value": 3},
      {"display": "Higher", "value": 4},
    ],
    "Tutoring": [
      {"display": "No", "value": 0},
      {"display": "Yes", "value": 1},
    ],
    "ParentalSupport": [
      {"display": "None", "value": 0},
      {"display": "Low", "value": 1},
      {"display": "Moderate", "value": 2},
      {"display": "High", "value": 3},
      {"display": "Very High", "value": 4},
    ],
    "Extracurricular": [
      {"display": "No", "value": 0},
      {"display": "Yes", "value": 1},
    ],
    "Sports": [
      {"display": "No", "value": 0},
      {"display": "Yes", "value": 1},
    ],
    "Music": [
      {"display": "No", "value": 0},
      {"display": "Yes", "value": 1},
    ],
    "Volunteering": [
      {"display": "No", "value": 0},
      {"display": "Yes", "value": 1},
    ],
  };

  Future<void> _predict() async {
    final url = Uri.parse("https://student-performance-api-wknc.onrender.com/predict"); // Replace with your Render URL
    try {
      // Check if all dropdowns are selected
      if (_dropdownValues.values.any((value) => value == null)) {
        setState(() {
          _result = "Error: Please select all dropdown options.";
        });
        return;
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Age": _dropdownValues["Age"],
          "Gender": _dropdownValues["Gender"],
          "Ethnicity": _dropdownValues["Ethnicity"],
          "ParentalEducation": _dropdownValues["ParentalEducation"],
          "StudyTimeWeekly": double.parse(_studyTimeController.text),
          "Absences": int.parse(_absencesController.text),
          "Tutoring": _dropdownValues["Tutoring"],
          "ParentalSupport": _dropdownValues["ParentalSupport"],
          "Extracurricular": _dropdownValues["Extracurricular"],
          "Sports": _dropdownValues["Sports"],
          "Music": _dropdownValues["Music"],
          "Volunteering": _dropdownValues["Volunteering"],
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

  Widget _buildDropdown(String key, String label) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(labelText: label),
      value: _dropdownValues[key],
      items: _dropdownOptions[key]!.map((option) {
        return DropdownMenuItem<int>(
          value: option["value"],
          child: Text(option["display"]),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _dropdownValues[key] = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Predict GPA")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown("Age", "Age"),
            _buildDropdown("Gender", "Gender"),
            _buildDropdown("Ethnicity", "Ethnicity"),
            _buildDropdown("ParentalEducation", "Parental Education"),
            TextField(
              controller: _studyTimeController,
              decoration: InputDecoration(labelText: "Study Time Weekly (0-20 hours)"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _absencesController,
              decoration: InputDecoration(labelText: "Absences (0-30)"),
              keyboardType: TextInputType.number,
            ),
            _buildDropdown("Tutoring", "Tutoring"),
            _buildDropdown("ParentalSupport", "Parental Support"),
            _buildDropdown("Extracurricular", "Extracurricular Activities"),
            _buildDropdown("Sports", "Sports"),
            _buildDropdown("Music", "Music"),
            _buildDropdown("Volunteering", "Volunteering"),
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