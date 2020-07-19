provider "aws" {
  profile = var.profile
  region  = var.region
}

data "aws_iam_policy" "lambda_basic_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-policy-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.lambda_basic_execution.arn
}

resource "aws_lambda_function" "greet" {
  filename      = "lambda.zip"
  function_name = "greet"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_handler"

  source_code_hash = filebase64sha256("lambda.zip")

  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Hello Udacity"
    }
  }
}