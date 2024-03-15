provider "aws" {
    region = "us-east-1"
  
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name       = "s3_full_access"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

variable "lambda_function_name" {
    description = "name of the lambda funciton"
    default = null
  
}

variable "lambda_handler_name" {
    description = "name of the lambda function handler"
    default = null
  
}

variable "lambda_timeout" {
    description = "value of the lambda timeout in secs"
    default = 3
  
}

variable "lambda_file_to_be_uploaded" {
    description = "name of the zip file to be uploaded"
    default = "test.zip"
  
}

variable "lambda_runtime" {
    description = "value of the lambda runtime"
    default = "python3.2"
  
}

variable "lambda_memory_size" {
    description = "size of the memory required for lambda function"
    default = 128
  
}

variable "client_id_env_var" {
    description = "value of the spotify client id"
    default = null

  
}

variable "client_secret_env_var" {
    description = "value of the spotify client id"
    default = null

  
}

variable "source_code_hash" {
    description = "value of the source_code_hash to address code change and deployment"
  
}

variable "lambda_layer_zip_file" {
    description = "file name of the lambda layer that we want to create the layer as"
  
}

variable "lambda_layer_name" {
    description = "name of the lambda layer name"
  
}

variable "lambda_layer_runtime" {
    description = "value of the lambda layer runtime"
  
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = var.lambda_layer_zip_file
  layer_name = var.lambda_layer_name
  compatible_runtimes = [var.lambda_layer_runtime]
}


resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = var.lambda_file_to_be_uploaded
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler_name
  timeout = var.lambda_timeout
  runtime = var.lambda_runtime
  memory_size = var.lambda_memory_size
  source_code_hash = var.source_code_hash

  environment {
    variables = {
      client_id = var.client_id_env_var
      client_secret = var.client_secret_env_var
    }
  }

  layers = [aws_lambda_layer_version.lambda_layer.arn]

}

