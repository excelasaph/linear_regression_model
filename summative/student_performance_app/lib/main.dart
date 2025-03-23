import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student GPA Predictor",
      theme: ThemeData(
        primaryColor: Color(0xFF1E88E5),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Student GPA Predictor",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PredictionPage()),
                );
              },
              child: Text("Start Predicting", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ],
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
  final _studyTimeController = TextEditingController();
  final _absencesController = TextEditingController();

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
  Color _resultColor = Colors.black87; // Default color

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
    final url = Uri.parse("https://student-performance-api-wknc.onrender.com/predict"); 
    List<String> errors = [];

    if (_dropdownValues.values.any((value) => value == null)) {
      setState(() {
        _result = "Please select all dropdown options.";
        _resultColor = Colors.red;
      });
      return;
    }

    double? studyTime;
    try {
      studyTime = double.parse(_studyTimeController.text);
      if (studyTime < 0 || studyTime > 20) {
        errors.add("Study Time Weekly must be between 0 and 20 hours.");
      }
    } catch (e) {
      errors.add("Invalid Study Time Weekly: Enter a number (e.g., 10.5).");
    }

    int? absences;
    try {
      absences = int.parse(_absencesController.text);
      if (absences < 0 || absences > 30) {
        errors.add("Absences must be between 0 and 30.");
      }
    } catch (e) {
      errors.add("Invalid Absences: Enter a whole number (e.g., 5).");
    }

    if (errors.isNotEmpty) {
      setState(() {
        _result = errors.join("\n• ");
        _resultColor = Colors.red;
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Age": _dropdownValues["Age"],
          "Gender": _dropdownValues["Gender"],
          "Ethnicity": _dropdownValues["Ethnicity"],
          "ParentalEducation": _dropdownValues["ParentalEducation"],
          "StudyTimeWeekly": studyTime,
          "Absences": absences,
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
        String gradeClass = data['grade_class'];
        setState(() {
          _result = "Predicted GPA: ${data['predicted_gpa'].toStringAsFixed(2)}\nGrade: $gradeClass";
          // Assign color based on GradeClass
          switch (gradeClass) {
            case 'A':
              _resultColor = Colors.green[700]!; // Dark green for success
              break;
            case 'B':
              _resultColor = Colors.green[400]!; // Light green
              break;
            case 'C':
              _resultColor = Colors.yellow[700]!; // Yellow
              break;
            case 'D':
              _resultColor = Colors.orange[700]!; // Orange
              break;
            case 'F':
              _resultColor = Colors.red[900]!; // Deep red for failure
              break;
            default:
              _resultColor = Colors.black87; // Fallback
          }
        });
      } else {
        setState(() {
          _result = "API Error: ${response.body}";
          _resultColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _result = "Network Error: $e";
        _resultColor = Colors.red;
      });
    }
  }

  Widget _buildDropdown(String key, String label) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
        dropdownColor: Colors.white,
        style: TextStyle(color: Colors.black87),
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
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black87),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predict GPA"),
        backgroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enter Student Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildDropdown("Age", "Age"),
            _buildDropdown("Gender", "Gender"),
            _buildDropdown("Ethnicity", "Ethnicity"),
            _buildDropdown("ParentalEducation", "Parental Education"),
            _buildTextField(_studyTimeController, "Study Time Weekly (0-20 hours)"),
            _buildTextField(_absencesController, "Absences (0-30)"),
            _buildDropdown("Tutoring", "Tutoring"),
            _buildDropdown("ParentalSupport", "Parental Support"),
            _buildDropdown("Extracurricular", "Extracurricular Activities"),
            _buildDropdown("Sports", "Sports"),
            _buildDropdown("Music", "Music"),
            _buildDropdown("Volunteering", "Volunteering"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predict,
              child: Text("Predict", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _result,
                style: TextStyle(
                  fontSize: 18,
                  color: _resultColor, // Use dynamic color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// https://student-performance-api-wknc.onrender.com/predict