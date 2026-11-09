# Titanic Survival Prediction Based on Python, R and Docker

## 1. Project Overview (Project Overview)

This project uses Python and R to implement the Logistic Regression model to predict the survival status of passengers on the Titanic.

The project uses Docker to build an independent and reproducible runtime environment and conducts version control and code management through GitHub.

This README provides detailed instructions on how to clone the repository, download the dataset, configure the runtime environment, and how to build and run the model using the Dockerfiles for Python and R.

**Reproducing the project does not require installing Python, R or related dependencies locally. Just install Git, Docker, and download the Titanic dataset. **

## 2. Dataset

This project uses the Titanic - Machine Learning from Disaster dataset provided by Kaggle. 

**Data Download Address:**

https://www.kaggle.com/competitions/titanic/data

The dataset consists of the following three files:

| File Name | Content | Required? |
|---|---|---|
| train.csv | 891 records with survival labels | Yes |
| test.csv | 418 records without survival labels | Yes |
| gender_submission.csv | The sample submission file provided by Kaggle | No |

Among them:

- `train.csv` is used for training and evaluating the model.
- `test.csv` is used to generate survival predictions for unknown passengers.
- `gender_submission.csv` is a sample file provided by Kaggle. This project does not require using this file for model training.

To avoid uploading the original data to GitHub, the project excludes CSV data files through `.gitignore`.

```text

Data-Engineering-titanic-disaster/
├── .github/
│   └── CODEOWNERS
├── src/
│   ├── data/
│   │   └── .gitkeep
│   ├── python/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── titanic_model.py
│   └── r/
│       ├── Dockerfile
│       ├── install_packages.R
│       └── titanic_model.R
├── .gitignore
└── README.md
```

The functions and purposes of each folder and file:

- `.github/CODEOWNERS`: Specifies the person responsible for the project's code.
- `src/data/`: Stores the Kaggle Titanic dataset.
- `src/python/`: Stores Python models and their Docker environment configurations.
- `src/r/`: Stores R models and their Docker environment configurations.
- `.gitignore`: Excludes files that do not need to be uploaded to GitHub.
- `README.md`: Provides project introduction, configuration methods, and running guidelines.

## 4. Model Features

Both the Python and R models use the following four features:

| Feature | Meaning |
|---|---|
| Pclass | Passenger Cabin Class |
| Sex | Passenger Gender |
| Age | Passenger Age |
| Fare | Ticket Price |

### Data Preprocessing

Before model training, the following preprocessing steps are carried out:

1. Select four predictive features from the original dataset.
2. Fill in the missing values of Age and Fare with the median.
3. Encode Sex as a numerical variable:
- male = 0
- female = 1
4. Check if there are still missing values in the processed input features.
5. Use "Survived" as the target variable for the model.

The model uses logistic regression to predict the survival probability of passengers and uses 0.5 as the classification threshold:

- If the predicted probability is less than 0.5: Survived = 0
- If the predicted probability is greater than or equal to 0.5: Survived = 1

## 5. Prerequisites

Before running this project, the following tools need to be prepared:

### 5.1 Install Git

The official download link for Git:

https://git-scm.com/downloads

After the installation is completed, open Terminal and enter:

```bash
git --version
```

If the Git version number is successfully displayed, it indicates that Git has been installed.

### 5.2 Installing Docker Desktop

The official download link for Docker Desktop:

https://www.docker.com/products/docker-desktop/

Install Docker Desktop according to your operating system.

After the installation is complete:

1. Open Docker Desktop.
2. Ensure that the Docker Engine is running properly.
3. Open Terminal.
4. Enter the following command to check the Docker status.

```bash
docker --version
docker info
```

If the Docker version and server information can be output normally, it indicates that Docker is ready for use.

### 5.3 Creating a Kaggle Account

Kaggle official website:

https://www.kaggle.com/

If you don't have a Kaggle account, you need to register one first in order to download the Titanic dataset.

## 6. Clone GitHub Repository (Clone the Repository)

### Step 1: Open Terminal

Open Terminal on your local computer.

Select a directory where you want to store the project.

### Step 2: Clone the Repository

Execute the following command:

```bash
git clone https://github.com/Chris0488Yang/Data-Engineering-titanic-disaster.git
```

This command will download the GitHub repository to the local machine.

### Step 3: Enter the project root directory

Execute:

```bash
cd Data-Engineering-titanic-disaster
```

From now on, all Docker commands should be executed in the root directory of this project.

For macOS or Linux, you can use the following command to check the current path:

```bash
pwd
```

You can also check the project files:

```bash
ls
```

Under normal circumstances, one should see:

```text
README.md
src/
```

And other project configuration files.

## 7. Download the Titanic dataset (Download the Dataset)

### Step 1: Open the Kaggle Data Page

Visit:

https://www.kaggle.com/competitions/titanic/data

### Step 2: Log in to Kaggle

Log in to your Kaggle account.

If the system prompts you to accept the competition rules, follow the instructions on the page to complete the operation.

### Step 3: Download Data

Enter the Data page of the competition.

Click "Download All" to download the dataset.

If the browser downloads a ZIP compressed file, you need to decompress it first.

### Step 4: Locate the CSV File

After decompression, find the following file:

```text
train.csv
test.csv
gender_submission.csv
```

This project must use `train.csv` and `test.csv` during operation.

### Step 5: Copy the data to the project directory

Copy the downloaded CSV files to the project directory:

```text
Data-Engineering-titanic-disaster/src/data/
```

The final directory structure should be as follows:

```text
src/
└── data/
├── .gitkeep
├── train.csv
├── test.csv
└── gender_submission.csv
```

Notes:

1. Do not modify the CSV file name.
2. Do not place the CSV file in an additional subfolder.
3. Do not put the data in `src/python/` or `src/r/`.
4. Ensure that the CSV file is a truly decompressed file, not a ZIP compressed package.

### Step 6: Check the data files

Execute in the project root directory:

```bash
ls src/data
```

It should be possible to see:

```text
train.csv
test.csv
gender_submission.csv
```

If the files `train.csv` or `test.csv` are missing, the model will not be able to run properly.

## 8. Running the Model Using Python Dockerfile

### 8.1 Description of the Python Environment

The Python model uses:

- Python 3.11
- NumPy 1.26.4
- Pandas 2.2.3
- scikit-learn 1.5.2

The required dependencies have been recorded in:

```text
src/python/requirements.txt
```

Docker will automatically install the dependencies based on this file, so there is no need to execute pip install locally separately.

### 8.2 Building Python Docker Image

First, make sure Docker Desktop is running.

Execute the following command in the project root directory:

```bash
docker build -t titanic-python ./src/python
```

This command will:

1. Read `src/python/Dockerfile`.
2. Create a Python 3.11 runtime environment.
3. Install the packages listed in requirements.txt.
4. Copy the Python model code into the Docker image.
5. Create an image named `titanic-python`.

When building for the first time, Docker may need to download the base image and dependencies, so the build process may take some time.

When the Terminal shows that the build is successful and there are no errors, you can proceed to the next step.

### 8.3 Run the Python Model

In the Terminal of macOS or Linux, execute:

```bash
docker run --rm \
-v "$(pwd)/src/data:/app/data:ro" \
titanic-python
```

Command Description:

- `docker run`: Create and run a Docker container.
- `--rm`: Automatically delete the container after the program ends.
- `-v`: Mount the local data folder to the container.
- `$(pwd)/src/data`: Local data set directory.
- `/app/data`: The location for reading data inside the container.
- `:ro`: Mount the data in read-only mode to avoid modifying the original CSV file.
- `titanic-python`: Specify the Docker image to run.

### 8.4 Execution Flow of the Python Program

After running, the Python program will automatically:

1. Read train.csv.
2. View the structure and basic information of the dataset.
3. Check for missing values.
4. Select four features: Pclass, Sex, Age, and Fare.
5. Fill in missing values and perform numerical encoding.
6. Train the model using Logistic Regression.
7. Calculate Training Accuracy.
8. Read test.csv.
9. Generate survival predictions for 418 passengers.
10. Calculate Holdout Test Accuracy using the labeled holdout test set.

All results are displayed directly in the Terminal.

### 8.5 Expected Running Results of Python

The verified model results are:

| Metric | Result |
|---|---:|
| Original training dataset size | 891 |
| Kaggle test dataset size | 418 |
| Training accuracy | 79.91% |
| Holdout test accuracy | 78.77% |
| Predicted number of non-survivors | 264 |
| Predicted number of survivors | 154 |

When the model runs successfully, the Terminal should be able to display the model training and prediction results normally without any errors.

## 9. Running the model using the R Dockerfile

### 9.1 R environment description

The R model uses:

- R 4.4.2
- Base R
- The glm() function
- Binomial Logistic Regression

Model usage:

```r
glm(
Survived ~ Pclass + Sex + Age + Fare,
data = model_data,
family = binomial(link = "logit")
)
```

Since the program uses Base R, no additional R packages need to be installed.

### 9.2 Building the R Docker Image

Execute the following command in the project root directory:

```bash
docker build -t titanic-r ./src/r
```

This command will:

1. Read the file `src/r/Dockerfile`.
2. Use `rocker/r-ver:4.4.2` as the base image.
3. Set `/app` as the working directory.
4. Copy and execute `install_packages.R`.
5. Since this project only uses R standard packages, no additional third-party dependencies need to be installed.
6. Copy `titanic_model.R` into the Docker image.
7. Configure the `Rscript` run command.
8. Create a Docker image named `titanic-r`.

After the build is successful, proceed to the next step.

### 9.3 Running the R Model

Execute the following command in the Terminal on macOS or Linux:

```bash
docker run --rm \
-v "$(pwd)/src/data:/app/data:ro" \
titanic-r
```

The same as the Python model, this command will mount the local data folder into the Docker container.

The R script will read the data from `/app/data/`.

### 9.4 Execution Flow of the R Program

The R program will execute in the following sequence:

1. Read the Titanic training data.
2. Display the dimensions of the dataset.
3. Output the first five rows of data.
4. Check the data structure.
5. Count the missing values.
6. Display the distribution of survival labels.
7. Output descriptive statistics.
8. Preprocess the four input features.
9. Train the logistic regression model using glm().
10. Output the model summary and regression coefficients.
11. Calculate Training Accuracy.
12. Read the Kaggle test data.
13. Generate 418 survival predictions.
14. Calculate Holdout Test Accuracy using the held-out test set.

### 9.5 Expected Run Results

The verified results are:

| Metric | Result |
|---|---:|
| Original training data size | 891 |
| Kaggle test data size | 418 |
| Training accuracy | 80.02% |
| Holdout training samples | 712 |
| Holdout test samples | 179 |
| Holdout test accuracy | 81.01% |
| Predicted number of non-survivors | 263 |
| Predicted number of survivors | 155 |

When the program runs successfully, the Terminal should display a result similar to the following:

```text
===== R: Holdout Test Accuracy =====
Training samples: 712
Holdout test samples: 179
Holdout Test Accuracy: 0.8101
Holdout Test Accuracy (%): 81.01%
```

This indicates that the model has completed the training, prediction and evaluation processes.

## 10. Comparison of Model Results between Python and R

| Indicator | Python | R |
|---|---:|---:|
| Training Accuracy | 79.91% | 80.02% |
| Holdout Test Accuracy | 78.77% | 81.01% |
| Kaggle Test Samples | 418 | 418 |
| Predicted Survivors | 154 | 155 |

The training accuracy rates of the two models are very close.

Please note:

1. The split of the holdout test set used in Python and R are not exactly the same.
2. The scikit-learn LogisticRegression in Python defaults to using L2 regularization.
3. The glm() in R does not default to using regularization.
4. Therefore, the current results cannot be used to determine that the R model is superior to the Python model.

In addition, the `test.csv` file on Kaggle does not contain the actual survival labels, so it is not possible to directly calculate the prediction accuracy of this file.

This project uses the data in `train.csv` with real labels to divide the training set and the holdout test set for evaluating the model performance.

## 11. Common Issues and Solutions (Troubleshooting)

### Issue 1: Docker Connection Failure

Possible causes:

```text
Cannot connect to the Docker daemon
```

Solution:

1. Open Docker Desktop.
2. Wait for the Docker Engine to start up completely.
3. In the Terminal, execute:

```bash
docker info
```

Confirm that the Docker Server is running normally.

### Question 2: Unable to find train.csv

Possible reasons:

- The dataset has not been downloaded.
- The ZIP file has not been decompressed.
- The CSV file is in the wrong location.
- The Docker command is not run from the project root directory.

Solution:

Execute in the project root directory:

```bash
ls src/data
```

Confirm the existence of:

```text
train.csv
test.csv
```

Then restart the Docker container.

### Question 3: Unable to Find Docker Image

Possible causes include:

```text
Unable to find image 'titanic-python:latest' locally
```

Solution:

First, create the mirror image:

```bash
docker build -t titanic-python ./src/python
```

For R:

```bash
docker build -t titanic-r ./src/r
```

After the build is successful, execute the corresponding docker run command.

### Question 4: Python Dependency Installation Failed

You can try to rebuild the Docker image:

```bash
docker build --no-cache -t titanic-python ./src/python
```

This command will reinstall the dependent packages specified in requirements.txt.

### Question 5: Code modification not taking effect

The Docker image will copy the program files during the build process.

Therefore, if you modify `titanic_model.py` or `titanic_model.R`, you need to re-execute the corresponding docker build command.

For example:

```bash
docker build -t titanic-python ./src/python
```

Or:

```bash
docker build -t titanic-r ./src/r
```

Then run the container again.

### Question 6: How to run on Windows

This project mainly uses macOS/Linux Terminal commands.

If using Windows PowerShell, you can execute:

Python:

```powershell
docker run --rm -v "${PWD}/src/data:/app/data:ro" titanic-python
```

R:

```powershell
docker run --rm -v "${PWD}/src/data:/app/data:ro" titanic-r
```

Before running, make sure that Docker Desktop is using Linux Containers and that the data files are placed in the correct directory.

## 12. Quick Start Guide

If Git and Docker Desktop have been installed and the Titanic dataset is ready, you can quickly run the entire project using the following steps.

### Step 1: Clone the Repository

```bash
git clone https://github.com/Chris0488Yang/Data-Engineering-titanic-disaster.git

cd Data-Engineering-titanic-disaster
```

### Step 2: Place the Data

Download and extract the dataset from Kaggle:

https://www.kaggle.com/competitions/titanic/data

Put `train.csv` and `test.csv` into:

```text
src/data/
```

Step 3: Build and Run Python

```bash
docker build -t titanic-python ./src/python

docker run --rm \
-v "$(pwd)/src/data:/app/data:ro" \
titanic-python
```

Step 4: Build and Run R

```bash
docker build -t titanic-r ./src/r

docker run --rm \
-v "$(pwd)/src/data:/app/data:ro" \
titanic-r
```

After completing the above operations, both programs will automatically execute and the training, prediction and accuracy results will be output in the Terminal.

The entire process does not require local installation of Python, R or any machine learning dependencies.

## 13. Version Control with Git (Git Workflow)

This project manages code versions through GitHub.

The main branches used are:

- `main`: Stable project version.
- `develop`: Integrated development completed code.
- `feature/titanic-docker`: Development of Python, R and Docker functions.
- `docs/final-readme`: Modification of README documentation.

The project mainly adopts the following workflow:

```text
feature/titanic-docker
|
v
develop
|
v
main
```

The document update follows a similar process:

```text
docs/final-readme
|
v
develop
|
v
main
```

All major modifications were merged through Pull Request, and the complete version control history was retained.

This project completed 10 Pull Request Merges.

## 14. Project Summary (Conclusion)

This project implemented Titanic survival prediction based on Python and R, and used Docker to provide an independent and reproducible execution environment.

The project includes the following contents:

1. Titanic data reading and exploration.
2. Missing value filling and feature encoding.
3. Python Logistic Regression model.
4. R Logistic Regression model.
5. Accuracy evaluation of training set and hold-out test set.
6. Kaggle test set survival prediction.
7. Docker image building for Python and R.
8. GitHub branches and Pull Request management.
9. Complete data download and Docker running instructions.

Through this README, users can clone the repository from GitHub, download the Titanic dataset, and independently run the Python and R models using a small number of Docker commands, without the need to configure a complex programming environment locally.
