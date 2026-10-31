# 1. A User
resource "aws_iam_user" "test_user" {
  name = "test-user-dev" 
}

# 2. Put that user into the group
resource "aws_iam_user_group_membership" "test_user_membership" {
    user = aws_iam_user.test_user.name
    groups = [aws_iam_group.developers.name]
}

