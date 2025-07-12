provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "test_lambda" {
  function_name    = "TestFunction"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec_role.arn
  filename         = "${path.module}/code.zip"
  source_code_hash = filebase64sha256("${path.module}/code.zip")
  timeout          = 10
}
