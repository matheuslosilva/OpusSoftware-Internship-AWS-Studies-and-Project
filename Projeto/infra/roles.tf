
resource "aws_iam_policy" "S3AccessPolicy" {
  name        = "S3AccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [  "s3:Get*",
                    "s3:GetObject",
                    "s3:List*",
                    "s3:Read*",
                    "s3-object-lambda:Get*",
                    "s3-object-lambda:List*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

#Por um breve periodo o aws security token service garante ao ec2 credenciais para assumir o role
resource "aws_iam_role" "S3AccessForEC2" {
    name = "S3AccessForEC2"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF 
}

#Permite que a EC2 seja reconhecida como uma instancia de  gerencia da aws e acesse S3 para leituras
resource "aws_iam_role_policy_attachment" "policyAttachment" {
  role       = aws_iam_role.S3AccessForEC2.name
  policy_arn = aws_iam_policy.S3AccessPolicy.arn
}

# Encapsula um role para que a instância assuma
resource "aws_iam_instance_profile" "EC2Profile" {
    name = "EC2Profile"
    role = aws_iam_role.S3AccessForEC2.name
}
