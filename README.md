# Student GPA Prediction Project

This repository contains my summative assignment for BSE Mathematics for Machine Learning, deploying a linear regression model to predict student GPA using Flutter. The project addresses a specific use case - predicting student academic performance based on demographic and behavioral factors — and avoids generic or housing-related datasets as per instructions. It is structured into four tasks:

- Task 1: Model training
- Task 2: API development
- Task 3: Flutter app creation
- Task 4: Video demo

## File Structure

```text
linear_regression_model/
├── summative/
│   ├── linear_regression/
│   │   ├── multivariate.ipynb  
│   ├── API/
│   │   ├── main.py             
│   │   ├── models.py           
│   │   ├── prediction.py       
│   │   ├── best_model.pkl      
│   │   ├── scaler.pkl          
│   │   ├── requirements.txt    
│   ├── FlutterApp/             
│   │   ├── lib/
│   │   │   ├── main.dart       
│   │   ├── pubspec.yaml        
├── README.md                   
```

## Mission

Enhance student academic success by predicting GPA based on key factors, enabling targeted interventions for at-risk students.

**Dataset Description**: The dataset used is the "Student Performance" dataset from Kaggle, containing 2,392 student records with 12 features (e.g., Age, Gender, StudyTimeWeekly, Absences) and GPA as the target variable. It’s rich in volume (thousands of rows) and variety (demographic, academic, and extracurricular variables). 

**Sourced from**: [Kaggle: Students Performance Dataset](https://www.kaggle.com/datasets/rabieelkharoua/students-performance-dataset)

**Visualizations**:
1. **Correlation Heatmap**: Shows strong correlations between GPA and features like `StudyTimeWeekly` (positive) and `Absences` (negative).
2. **Variable Distribution**: Histogram of `StudyTimeWeekly` reveals most students study 5-15 hours weekly, impacting model training.

---

## Task 1: Linear Regression Task

### Description
- **File**: `summative/linear_regression/multivariate.ipynb`
- **Objective**: Build and optimize a linear regression model using gradient descent to predict student GPA, comparing it with Decision Trees and Random Forest.
- **Process**:
  - Loaded the Kaggle "Student Performance" dataset (non-housing, non-generic).
  - Preprocessed data (normalized using `StandardScaler`).
  - Trained three models using `scikit-learn`:
    1. Linear Regression
    2. Decision Trees
    3. Random Forest
  - Plotted loss curves (Mean Squared Error) for train and test data.
  - Compared performance:
    - Linear Regression: MSE = 0.15 (lowest loss)
    - Random Forest: MSE = 0.18
    - Decision Trees: MSE = 0.22
  - Saved the best model (Linear Regression) as `best_model.pkl` and scaler as `scaler.pkl`.
  - Included code to predict GPA for one test data point, with a scatter plot of the fitted linear regression line.

### Artifacts
- `best_model.pkl`: Trained Linear Regression model.
- `scaler.pkl`: Scaler for input normalization.

---

## Task 2: API Development

### Description
- **Directory**: `summative/API/`
- **Objective**: Create a FastAPI endpoint to predict GPA using the Task 1 model.
- **Endpoint**: `/predict` (POST)
- **Input**: JSON with 12 fields (e.g., `Age`, `Gender`, `StudyTimeWeekly`).
- **Output**: JSON with `predicted_gpa`, `grade_class` (A-F), and `grade_value` (0-4).

### Files
- `main.py`: FastAPI app with CORS middleware.
- `models.py`: Pydantic `BaseModel` enforcing data types (e.g., `int`, `float`) and ranges (e.g., `Age: 15-18`, `StudyTimeWeekly: 0-20`).
- `prediction.py`: Loads model/scaler, predicts GPA, and maps to grade class.
- `requirements.txt`: Lists dependencies (`fastapi`, `pydantic`, `uvicorn`, `scikit-learn`, `joblib`).

### Deployment
- **Platform**: Render
- **Public URL**: [https://student-performance-api-wknc.onrender.com/docs](https://student-performance-api-wknc.onrender.com/docs)
- **API Endpoint**: [https://student-performance-api-wknc.onrender.com/predict](https://student-performance-api-wknc.onrender.com/predict)
- **Instructions**:
  1. Pushed `summative/API/` to GitHub.
  2. Deployed on Render:
     - **Runtime**: Python 3
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
  3. Verified Swagger UI at `/docs`.

### Example Request

```json
{
  "Age": 16,
  "Gender": 0,
  "Ethnicity": 0,
  "ParentalEducation": 2,
  "StudyTimeWeekly": 10.5,
  "Absences": 5,
  "Tutoring": 1,
  "ParentalSupport": 3,
  "Extracurricular": 1,
  "Sports": 0,
  "Music": 1,
  "Volunteering": 0
}
```

### Response

```json
{
  "predicted_gpa": 3.75,
  "grade_class": "A",
  "grade_value": 0
}
```

## Task 3: Flutter App

### Description
- **Directory**: `summative/FlutterApp/`
- **Objective**: Build a mobile app to interact with the Task 2 API.
- **Features**:
  - Two pages: Home (welcome screen) and Prediction.
  - 12 input fields (10 dropdowns, 2 text fields for `StudyTimeWeekly` and `Absences`).
  - "Predict" button.
  - Output display showing GPA and grade, or error messages.

### Running Locally
1. Navigate to `summative/FlutterApp/`.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Task 4: Video Demo

### Description
- **Link**: [YouTube Video URL](https://youtube.com/your-video-link) *(Replace with actual link)*
- **Duration**: ~5 minutes

