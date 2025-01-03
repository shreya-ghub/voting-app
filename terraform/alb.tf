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

# Target group for "frontend" service #
resource "aws_lb_target_group" "frontend_target_group" {
  name        = "frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.voting-app-vpc.id
  target_type = "instance"
  tags = {
    Name = "frontend-tg"
  }
}

# Target group for "backend" service #
resource "aws_lb_target_group" "backend_target_group" {
  name        = "backend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.voting-app-vpc.id
  target_type = "instance"
  tags = {
    Name = "backend-tg"
  }
}

# Target group for "DB" service #
resource "aws_lb_target_group" "db_target_group" {
  name        = "db-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.voting-app-vpc.id
  target_type = "instance"
  tags = {
    Name = "db-tg"
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

# Rule for "frontend" traffic #
resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.voting_app_listener.arn
  priority     = 1
  tags = {
    Name = "frontend"
  }

  condition {
    host_header {
      values = ["frontend.example.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}

# Rule for "backend" traffic #
resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.voting_app_listener.arn
  priority     = 2
  tags = {
    Name = "backend"
  }

  condition {
    host_header {
      values = ["backend.example.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}

# Rule for "DB" traffic #
resource "aws_lb_listener_rule" "db_rule" {
  listener_arn = aws_lb_listener.voting_app_listener.arn
  priority     = 3
  tags = {
    Name = "db"
  }

  condition {
    host_header {
      values = ["db.example.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.db_target_group.arn
  }
}

##### Attach Instances to Target Groups #####

# Register "frontend" instance #
resource "aws_lb_target_group_attachment" "frontend_attachment" {
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
  target_id        = aws_instance.frontend.id
  port             = 80
}

# Register "backend" instance #
resource "aws_lb_target_group_attachment" "backend_attachment" {
  target_group_arn = aws_lb_target_group.backend_target_group.arn
  target_id        = aws_instance.backend.id
  port             = 80
}

# Register "DB" instance #
resource "aws_lb_target_group_attachment" "worker_attachment" {
  target_group_arn = aws_lb_target_group.db_target_group.arn
  target_id        = aws_instance.db.id
  port             = 80
}
