resource "aws_iam_policy" "eks-xray" {
  name_prefix = "eks-xray"
  policy      = <<EOF
{
  "Version": "2012-10-17",
   "Statement": [
       {"Effect": "Allow",
        "Action": [
           "xray:PutTelemetryRecords",
           "xray:PutTraceSegments"
        ],
        "Resource": "*"
      }
   ]
}
EOF
}
