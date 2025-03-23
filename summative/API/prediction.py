# summative/API/prediction.py
import joblib
import numpy as np
from fastapi import HTTPException

# Load the pre-trained model and scaler
try:
    model = joblib.load("best_model.pkl")
    scaler = joblib.load("scaler.pkl")
except Exception as e:
    raise Exception(f"Error loading model or scaler: {str(e)}")

def get_grade_class(gpa):
    """Map GPA to GradeClass based on provided ranges."""
    if gpa >= 3.5:
        return {"grade": "A", "value": 0}
    elif 3.0 <= gpa < 3.5:
        return {"grade": "B", "value": 1}
    elif 2.5 <= gpa < 3.0:
        return {"grade": "C", "value": 2}
    elif 2.0 <= gpa < 2.5:
        return {"grade": "D", "value": 3}
    else:  # gpa < 2.0
        return {"grade": "F", "value": 4}

def predict_grade(data):
    try:
        # Convert input data to the format expected by the model
        input_data = np.array([
            data.Age, data.Gender, data.Ethnicity, data.ParentalEducation,
            data.StudyTimeWeekly, data.Absences, data.Tutoring, data.ParentalSupport,
            data.Extracurricular, data.Sports, data.Music, data.Volunteering
        ]).reshape(1, -1)

        # Scale the input data
        input_data_scaled = scaler.transform(input_data)

        # Make prediction
        prediction = float(model.predict(input_data_scaled)[0])

        # Get GradeClass based on predicted GPA
        grade_class = get_grade_class(prediction)

        return {
            "predicted_gpa": prediction,
            "grade_class": grade_class["grade"],
            "grade_value": grade_class["value"]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")