
# Titanic Survival Prediction in R

# Load training dataset
cat("===== R: Loading Training Data =====\n")

train_df <- read.csv("/app/data/train.csv")

cat("Training data loaded successfully!\n")
cat("Dataset dimensions:", dim(train_df), "\n")

cat("\nFirst 5 rows:\n")
print(head(train_df, 5))

cat("\nColumn names:\n")
print(names(train_df))


# Data Exploration

cat("\n===== R: Data Exploration =====\n")

# Check data structure
cat("\nData structure:\n")
str(train_df)

# Check missing values
cat("\nMissing values:\n")
print(colSums(is.na(train_df)))

# Check survival distribution
cat("\nSurvival distribution:\n")
print(table(train_df$Survived))

# Summary statistics
cat("\nSummary statistics:\n")
print(summary(train_df))


# Data Preprocessing

cat("\n===== R: Data Preprocessing =====\n")

# Select features
features <- c("Pclass", "Sex", "Age", "Fare")

X <- train_df[, features]
y <- train_df$Survived

# Handle missing values
X$Age[is.na(X$Age)] <- median(X$Age, na.rm = TRUE)
X$Fare[is.na(X$Fare)] <- median(X$Fare, na.rm = TRUE)

# Encode Sex
X$Sex <- ifelse(X$Sex == "male", 0, 1)

# Verify processed data
cat("\nProcessed features:\n")
print(head(X, 5))

cat("\nMissing values after preprocessing:\n")
print(colSums(is.na(X)))

cat("\nTarget variable:\n")
print(head(y, 5))


# Logistic Regression Model

cat("\n===== R: Logistic Regression Model =====\n")

# Combine features and target variable
model_data <- X
model_data$Survived <- y

# Train logistic regression model
model <- glm(
  Survived ~ Pclass + Sex + Age + Fare,
  data = model_data,
  family = binomial(link = "logit")
)

cat("\nLogistic Regression model trained successfully!\n")

# Display model summary
cat("\nModel summary:\n")
print(summary(model))

# Display model coefficients
cat("\nModel coefficients:\n")
print(coef(model))



# Training Accuracy

cat("\n===== R: Training Accuracy =====\n")

# Predict survival probabilities on training data
train_prob <- predict(model, newdata = model_data, type = "response")

# Convert probabilities to binary predictions
train_pred <- ifelse(train_prob >= 0.5, 1, 0)

# Calculate training accuracy
train_accuracy <- mean(train_pred == y)

cat(sprintf("Training Accuracy: %.4f\n", train_accuracy))
cat(sprintf("Training Accuracy (%%): %.2f%%\n", train_accuracy * 100))


# Test Predictions

cat("\n===== R: Test Predictions =====\n")

# Load test dataset
test_df <- read.csv("/app/data/test.csv")

cat("Test data dimensions:", dim(test_df), "\n")

# Select the same features
X_test <- test_df[, features]

# Fill missing values using training data statistics
X_test$Age[is.na(X_test$Age)] <- median(train_df$Age, na.rm = TRUE)
X_test$Fare[is.na(X_test$Fare)] <- median(train_df$Fare, na.rm = TRUE)

# Encode Sex
X_test$Sex <- ifelse(X_test$Sex == "male", 0, 1)

# Check missing values
cat("\nMissing values in test features:\n")
print(colSums(is.na(X_test)))

# Predict survival probabilities
test_prob <- predict(model, newdata = X_test, type = "response")

# Convert probabilities to binary predictions
test_pred <- ifelse(test_prob >= 0.5, 1, 0)

cat("\nFirst 10 predictions:\n")
print(head(test_pred, 10))

cat("\nPredicted survival distribution:\n")
print(table(test_pred))

cat("\nTotal predictions:", length(test_pred), "\n")


# Holdout Test Accuracy

cat("\n===== R: Holdout Test Accuracy =====\n")

set.seed(42)

# Stratified 80/20 split
class_0 <- which(train_df$Survived == 0)
class_1 <- which(train_df$Survived == 1)

train_idx <- c(
  sample(class_0, floor(0.8 * length(class_0))),
  sample(class_1, floor(0.8 * length(class_1)))
)

train_subset <- train_df[train_idx, ]
holdout_subset <- train_df[-train_idx, ]

# Select features
X_train_r <- train_subset[, features]
X_holdout_r <- holdout_subset[, features]

# Handle missing values using training subset statistics
for (column in c("Age", "Fare")) {
  median_value <- median(X_train_r[[column]], na.rm = TRUE)

  X_train_r[[column]][is.na(X_train_r[[column]])] <- median_value
  X_holdout_r[[column]][is.na(X_holdout_r[[column]])] <- median_value
}

# Encode categorical variable
X_train_r$Sex <- ifelse(X_train_r$Sex == "male", 0, 1)
X_holdout_r$Sex <- ifelse(X_holdout_r$Sex == "male", 0, 1)

# Train model on training subset
X_train_r$Survived <- train_subset$Survived

holdout_model_r <- glm(
  Survived ~ Pclass + Sex + Age + Fare,
  data = X_train_r,
  family = binomial(link = "logit")
)

# Predict holdout data
holdout_prob_r <- predict(
  holdout_model_r,
  newdata = X_holdout_r,
  type = "response"
)

holdout_pred_r <- ifelse(holdout_prob_r >= 0.5, 1, 0)

# Calculate accuracy
test_accuracy_r <- mean(
  holdout_pred_r == holdout_subset$Survived
)

cat("Training samples:", nrow(X_train_r), "\n")
cat("Holdout test samples:", nrow(X_holdout_r), "\n")

cat(sprintf("Holdout Test Accuracy: %.4f\n", test_accuracy_r))
cat(sprintf("Holdout Test Accuracy (%%): %.2f%%\n", test_accuracy_r * 100))
