# summative/API/models.py
from pydantic import BaseModel, Field

class StudentInput(BaseModel):
    Age: int = Field(..., ge=15, le=18, description="Student age between 15 and 18")
    Gender: int = Field(..., ge=0, le=1, description="0 for Male, 1 for Female")
    Ethnicity: int = Field(..., ge=0, le=3, description="0: Caucasian, 1: African American, 2: Asian, 3: Other")
    ParentalEducation: int = Field(..., ge=0, le=4, description="0: None, 1: High School, 2: Some College, 3: Bachelor's, 4: Higher")
    StudyTimeWeekly: float = Field(..., ge=0.0, le=20.0, description="Weekly study time in hours (0-20)")
    Absences: int = Field(..., ge=0, le=30, description="Number of absences (0-30)")
    Tutoring: int = Field(..., ge=0, le=1, description="0: No, 1: Yes")
    ParentalSupport: int = Field(..., ge=0, le=4, description="0: None, 1: Low, 2: Moderate, 3: High, 4: Very High")
    Extracurricular: int = Field(..., ge=0, le=1, description="0: No, 1: Yes")
    Sports: int = Field(..., ge=0, le=1, description="0: No, 1: Yes")
    Music: int = Field(..., ge=0, le=1, description="0: No, 1: Yes")
    Volunteering: int = Field(..., ge=0, le=1, description="0: No, 1: Yes")