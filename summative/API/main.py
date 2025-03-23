# summative/API/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from models import StudentInput
from prediction import predict_grade

app = FastAPI(title="Student GPA Prediction API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (adjust for production)
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (e.g., POST)
    allow_headers=["*"],  # Allows all headers
)

@app.post("/predict")
def predict(student_data: StudentInput):
    prediction = predict_grade(student_data)
    return prediction

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)