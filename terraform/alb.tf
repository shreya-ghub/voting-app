##### Application Load Balancer #####
resource "aws_lb" "voting_app_alb" {
  name               = "voting-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_security_group.id]
  subnets = [
    aws_subnet.public_subnet.id,
    aws_subnet.private_subnet.id
  ]

  enable_deletion_protection = false
  idle_timeout               = 60
  drop_invalid_header_fields = true

  tags = {
    Name = "voting-app-alb"
  }
}


##### Target Groups #####

# Target group for 'vote' service #
resource "aws_lb_target_group" "vote_target_group" {
  name        = "vote-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.voting-app-vpc.id
  target_type = "instance"
  tags = {
    Name = "vote-tg"
  }
}

# Target group for 'result' service #
resource "aws_lb_target_group" "result_target_group" {
  name        = "result-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.voting-app-vpc.id
  target_type = "instance"
  tags = {
    Name = "result-tg"
  }
}

# Target group for 'worker' service #
resource "aws_lb_target_group" "worker_target_group" {
  name        = "worker-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.voting-app-vpc.id
  target_type = "instance"
  tags = {
    Name = "worker-tg"
  }
}

##### Listeners #####

# HTTP Listener for ALB #
resource "aws_lb_listener" "voting_app_listener" {
  load_balancer_arn = aws_lb.voting_app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "This is the default action."
      status_code  = "404"
    }
  }
}

##### Listener Rules #####

# Rule for 'vote' traffic #
resource "aws_lb_listener_rule" "vote_rule" {
  listener_arn = aws_lb_listener.voting_app_listener.arn
  priority     = 1
  tags = {
    Name = "vote"
  }

  condition {
    host_header {
      values = ["vote.example.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vote_target_group.arn
  }
}

# Rule for 'result' traffic #
resource "aws_lb_listener_rule" "result_rule" {
  listener_arn = aws_lb_listener.voting_app_listener.arn
  priority     = 2
  tags = {
    Name = "result"
  }

  condition {
    host_header {
      values = ["result.example.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.result_target_group.arn
  }
}

# Rule for 'worker' traffic #
resource "aws_lb_listener_rule" "worker_rule" {
  listener_arn = aws_lb_listener.voting_app_listener.arn
  priority     = 3
  tags = {
    Name = "worker"
  }

  condition {
    host_header {
      values = ["worker.example.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.worker_target_group.arn
  }
}

##### Attach Instances to Target Groups #####

# Register 'vote' instance #
resource "aws_lb_target_group_attachment" "vote_attachment" {
  target_group_arn = aws_lb_target_group.vote_target_group.arn
  target_id        = aws_instance.vote.id
  port             = 80
}

# Register 'result' instance #
resource "aws_lb_target_group_attachment" "result_attachment" {
  target_group_arn = aws_lb_target_group.result_target_group.arn
  target_id        = aws_instance.result.id
  port             = 80
}

# Register 'worker' instance #
resource "aws_lb_target_group_attachment" "worker_attachment" {
  target_group_arn = aws_lb_target_group.worker_target_group.arn
  target_id        = aws_instance.worker.id
  port             = 80
}
