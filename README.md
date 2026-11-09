# Titanic Survival Prediction with Python, R, and Docker
## Project Overview
This project implements logistic regression models using Python and R, respectively, to predict the survival of Titanic passengers.
The project uses Docker to provide a reproducible runtime environment and GitHub for code version control.
## Dataset
Dataset: Kaggle Titanic - Machine Learning from Disaster
Data source: https://www.kaggle.com/competitions/titanic/data
- train.csv: Contains 891 passenger records with survival labels.
- test.csv: Contains 418 passenger records without survival labels.
- gender_submission.csv: An example submission file provided by Kaggle.
The `.gitignore` file is used to exclude the dataset from Git version control to avoid uploading the raw data files.
## Project Structure

```text
Data-Engineering-titanic-disaster/
├── .github/
│   └── CODEOWNERS
├── src/
│   ├── data/
│   ├── python/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── titanic_model.py
│   └── r/
│       ├── Dockerfile
│       └── titanic_model.R
├── .gitignore
└── README.md
```

## Model Features
This project selects the following four features to predict whether passengers survived:
- Pclass: Passenger cabin class.
- Sex: Passenger gender.
- Age: Passenger age.
- Fare: Passenger ticket fare.
### Data Preprocessing
To ensure the data can be used for the logistic regression model, the following preprocessing steps were performed:
1. Select Pclass, Sex, Age, and Fare as the model input features.
2. Impute missing values in numerical variables with the median.
3. Convert Sex into a binary numerical variable:
   - male = 0
   - female = 1
4. Check the processed data to ensure that there are no missing values in any of the model input features.
## Python Implementation
The Python model uses the following environment and tools:
- Python 3.11
- NumPy
- Pandas
- scikit-learn
- Logistic Regression

### Build a Python Docker Image

Run the following in the project root directory:

```bash
docker build -t titanic-python ./src/python
```

This command builds a Docker image using `src/python/Dockerfile` and automatically installs the dependencies specified in `requirements.txt`.
### Running the Python Model

```bash
docker run --rm \
  -v "$(pwd)/src/data:/app/data:ro" \
  titanic-python
```

This command mounts the local data folder to the Docker container in read-only mode and runs the Python survival prediction program.
After the program runs, the following will be output in the Terminal:
- Basic dataset information
- Data exploration and missing value statistics
- Data preprocessing results
- Logistic Regression model training results
- Training Accuracy
- Test set prediction results
- Holdout Test Accuracy

## R Implementation
The R model uses the following environment and tools:
- R 4.4.2
- Base R
- glm() function
- Binomial Logistic Regression

The R model uses the `glm()` function with `family = binomial(link = "logit")` to build a logistic regression model.
### Build the R Docker image
Run the following command in the project root directory:

```bash
docker build -t titanic-r ./src/r
```

This command builds a Docker image using the R 4.4.2 environment.
### Running R Models

```bash
docker run --rm \
  -v "$(pwd)/src/data:/app/data:ro" \
  titanic-r
```

This command mounts the local Titanic dataset into the container and runs `titanic_model.R`.
After the program runs, the following will be output in the Terminal:
- Data reading and basic information
- Data structure and statistical summary
- Missing value detection and data preprocessing
- Logistic Regression model summary
- Model coefficients and significance test results
- Training Accuracy
- Test set prediction results
- Holdout Test Accuracy

## Model Results
This project trains logistic regression models using Python and R, respectively, and evaluates their prediction accuracy.
| Evaluation Metric | Python | R |
|---|---:|---:|
| Training Accuracy | 79.91% | 80.02% |
| Holdout Test Accuracy | 78.77% | 81.01% |
| Number of Samples in Kaggle Test Set | 418 | 418 |
| Number of Predicted Survivors | 154 | 155 |
### Results Analysis
The Python model achieved an accuracy of 79.91% on the full training data, while the R model achieved 80.02%, with the two results being very close.
On the holdout test set:
- The Python model achieved an accuracy of 78.77%.
- The R model achieved an accuracy of 81.01%.
It should be noted that Python and R used different 80/20 data splits, so the test sets for the two models are not exactly the same. In addition, scikit-learn’s Logistic Regression in Python uses L2 regularization by default, whereas R’s glm() does not use regularization by default.
Therefore, we cannot directly conclude that the R model is better than the Python model based solely on the current accuracy results.
### Test Set Description
The official Kaggle `test.csv` does not contain the true Survived labels, so the true test accuracy for these 418 records cannot be calculated directly.
This project evaluates the models’ predictive performance by splitting the training set and holdout test set from `train.csv`, which contains the true labels.
## Git Workflow
This project uses three branches for Git version control:
1. main: stores stable project versions.
2. develop: used to integrate completed development code.
3. feature/titanic-docker: used to develop Python, R, and Docker-related features.
### Version Management Process
Code changes are first made on the feature branch and saved as commit records.
Then, Pull Requests are used to merge the changes according to the following process:

```text
feature/titanic-docker
        |
        v
     develop
        |
        v
       main
```

Pull requests include a summary of changes and detailed descriptions to ensure traceability throughout the project development process.
In addition, the project specifies code owners through the `.github/CODEOWNERS` file.
## Reproducibility
To reproduce the results of this project, follow the steps below:
### Step 1: Clone the GitHub Repository
Clone this project to your local machine.
### Step 2: Download the Titanic Dataset
Download the Titanic data from Kaggle:

https://www.kaggle.com/competitions/titanic/data

### Step 3: Place the Dataset
Place the following files in the `src/data/` folder:

- train.csv
- test.csv
- gender_submission.csv (optional)
### Step 4: Install and Start Docker
Make sure Docker Desktop is installed and running properly.
You can check this with the following command:

```bash
docker --version
docker info
```

### Step 5: Build and Run the Python Model

```bash
docker build -t titanic-python ./src/python

docker run --rm \
  -v "$(pwd)/src/data:/app/data:ro" \
  titanic-python
```

### Step 6: Build and Run the R Model

```bash
docker build -t titanic-r ./src/r

docker run --rm \
  -v "$(pwd)/src/data:/app/data:ro" \
  titanic-r
```

### Step 7: View the Results
Both the Python and R programs output data exploration, preprocessing, model training, prediction results, and accuracy in the Terminal.
Users can run the project using Docker without manually installing the Python or R dependency environments.
## Project Summary (Conclusion)
This project completed the full workflow for predicting Titanic passenger survival using Python and R, including:
- Data reading and exploration
- Missing value handling and feature encoding
- Logistic regression model training
- Accuracy evaluation on the training set and held-out test set
- Survival prediction on the Kaggle test set
- Docker containerized deployment
- GitHub branch management and Pull Requests
Ultimately, both the Python and R models can run independently via Docker and output complete prediction and evaluation results in the Terminal, ensuring good reproducibility of the project.