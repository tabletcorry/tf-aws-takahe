resource "aws_iam_role" "ecs_execution" {
  name               = "${local.module_tags.module}-${var.name}-ecs-execution"
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

resource "aws_iam_role_policy_attachment" "ecs_execution_service_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution.name
}

resource "aws_iam_role_policy" "ecs_execution_ssm_param_read" {
  role = aws_iam_role.ecs_execution.id

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

locals {
  ecs_task_assume_role_policy = <<EOF
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
  ecs_task_bucket_read = jsonencode({
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


resource "aws_iam_role" "ecs_task_web" {
  name               = "${local.module_tags.module}-${var.name}-ecs-task-web"
  assume_role_policy = local.ecs_task_assume_role_policy
}

resource "aws_iam_role_policy" "ecs_task_web_s3" {
  role = aws_iam_role.ecs_task_web.id

  policy = local.ecs_task_bucket_read
}

resource "aws_iam_role" "ecs_task_stator" {
  name               = "${local.module_tags.module}-${var.name}-ecs-task-stator"
  assume_role_policy = local.ecs_task_assume_role_policy
}

resource "aws_iam_role_policy" "ecs_task_stator_s3" {
  role = aws_iam_role.ecs_task_stator.id

  policy = local.ecs_task_bucket_read
}