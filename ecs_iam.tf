resource "aws_iam_role" "primary_web_execution" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "primary_web_execution_managed" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.primary_web_execution.name
}

resource "aws_iam_role_policy" "primary_web_execution_ssm" {
  role = aws_iam_role.primary_web_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters"
        ]
        Effect = "Allow"
        Resource = [
          for secret in local.primary_web_secrets : secret.arn
        ]
      },
    ]
  })
}


resource "aws_iam_role" "primary_web_task" {
  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Service":[
               "ecs-tasks.amazonaws.com"
            ]
         },
         "Action":"sts:AssumeRole",
         "Condition":{
            "ArnLike":{
            "aws:SourceArn":"arn:aws:ecs:us-west-2:${data.aws_caller_identity.self.account_id}:*"
            },
            "StringEquals":{
               "aws:SourceAccount":"${data.aws_caller_identity.self.account_id}"
            }
         }
      }
   ]
}
EOF
}

resource "aws_iam_role_policy" "primary_web_task_s3" {
  role = aws_iam_role.primary_web_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:Put*",
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.media.arn,
          "${aws_s3_bucket.media.arn}/*",
        ]
      },
    ]
  })
}