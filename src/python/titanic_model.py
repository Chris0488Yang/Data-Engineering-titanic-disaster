
import pandas as pd
import numpy as np

from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Question 13: Load the training dataset

print("===== Question 13: Loading Training Data =====")

train_df = pd.read_csv("/app/data/train.csv")

print("Training data loaded successfully!")
print("Dataset shape:", train_df.shape)

print("\nFirst 5 rows:")
print(train_df.head())

print("\nColumn names:")
print(train_df.columns.tolist())


# Question 14: Explore the dataset

print("\n===== Question 14: Data Exploration =====")

# Check data types
print("\nData types:")
print(train_df.dtypes)

# Check missing values
print("\nMissing values:")
print(train_df.isnull().sum())

# Check survival distribution
print("\nSurvival distribution:")
print(train_df["Survived"].value_counts())

# Check summary statistics
print("\nSummary statistics:")
print(train_df.describe())


# Data Preprocessing

print("\n===== Data Preprocessing =====")

# Select features
features = ["Pclass", "Sex", "Age", "Fare"]

X = train_df[features].copy()
y = train_df["Survived"]

# Handle missing values
X["Age"] = X["Age"].fillna(X["Age"].median())
X["Fare"] = X["Fare"].fillna(X["Fare"].median())

# Convert categorical variables into numeric values
X["Sex"] = X["Sex"].map({"male": 0, "female": 1})

# Verify processed data
print("\nProcessed features:")
print(X.head())

print("\nMissing values after preprocessing:")
print(X.isnull().sum())

print("\nTarget variable:")
print(y.head())


# Question 15: Build a Logistic Regression Model

print("\n===== Question 15: Logistic Regression Model =====")

# Initialize the logistic regression model
model = LogisticRegression(max_iter=1000)

# Train the model
model.fit(X, y)

print("Logistic Regression model trained successfully!")

# Display model coefficients
print("\nModel coefficients:")
for feature, coef in zip(features, model.coef_[0]):
    print(f"{feature}: {coef:.4f}")

print("\nModel intercept:")
print(model.intercept_[0])


# Question 16: Training Accuracy

print("\n===== Question 16: Training Accuracy =====")

# Predict survival outcomes on training data
y_train_pred = model.predict(X)

# Calculate training accuracy
train_accuracy = accuracy_score(y, y_train_pred)

print(f"Training Accuracy: {train_accuracy:.4f}")
print(f"Training Accuracy (%): {train_accuracy * 100:.2f}%")


# Question 17: Predict on Test Data

print("\n===== Question 17: Test Predictions =====")

# Load test dataset
test_df = pd.read_csv("/app/data/test.csv")

print("Test data shape:", test_df.shape)

# Select the same features used in training
X_test = test_df[features].copy()

# Handle missing values using training data statistics
X_test["Age"] = X_test["Age"].fillna(train_df["Age"].median())
X_test["Fare"] = X_test["Fare"].fillna(train_df["Fare"].median())

# Convert categorical values
X_test["Sex"] = X_test["Sex"].map({"male": 0, "female": 1})

# Check missing values
print("\nMissing values in test features:")
print(X_test.isnull().sum())

# Predict survival outcomes
test_predictions = model.predict(X_test)

print("\nFirst 10 predictions:")
print(test_predictions[:10])

print("\nPredicted survival distribution:")
print(pd.Series(test_predictions).value_counts())

print("\nTotal predictions:", len(test_predictions))


# Question 18: Test Accuracy

print("\n===== Question 18: Test Accuracy =====")

# Split labeled data into training and holdout test sets
X_train, X_holdout, y_train, y_holdout = train_test_split(
    train_df[features],
    train_df["Survived"],
    test_size=0.2,
    random_state=42,
    stratify=train_df["Survived"]
)

# Create copies for preprocessing
X_train = X_train.copy()
X_holdout = X_holdout.copy()

# Fill missing values using training-set statistics
for column in ["Age", "Fare"]:
    median_value = X_train[column].median()
    X_train[column] = X_train[column].fillna(median_value)
    X_holdout[column] = X_holdout[column].fillna(median_value)

# Encode Sex in both subsets
for data in [X_train, X_holdout]:
    data["Sex"] = data["Sex"].map({"male": 0, "female": 1})

# Train a separate model for holdout evaluation
holdout_model = LogisticRegression(max_iter=1000)
holdout_model.fit(X_train, y_train)

# Predict holdout test set
y_holdout_pred = holdout_model.predict(X_holdout)

# Calculate accuracy
test_accuracy = accuracy_score(y_holdout, y_holdout_pred)

print("Training samples:", len(X_train))
print("Holdout test samples:", len(X_holdout))
print(f"Holdout Test Accuracy: {test_accuracy:.4f}")
print(f"Holdout Test Accuracy (%): {test_accuracy * 100:.2f}%")

print("\nNote: Kaggle test.csv has no true survival labels.")
print("Accuracy is evaluated on a labeled holdout set.")
