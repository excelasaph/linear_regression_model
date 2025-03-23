# summative/API/prediction.py
import joblib
import numpy as np
from fastapi import HTTPException

# Load the pre-trained model and scaler (adjust paths for deployment)
try:
    model = joblib.load("best_model.pkl")  # Move files to API/ for deployment
    scaler = joblib.load("scaler.pkl")
except Exception as e:
    raise Exception(f"Error loading model or scaler: {str(e)}")

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
        prediction = model.predict(input_data_scaled)[0]
        return {"predicted_gpa": float(prediction)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")