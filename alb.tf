resource "aws_lb_target_group" "alb-target" {
  name     = "${var.alb-name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}


resource "aws_lb_target_group_attachment" "alb-target-attach" {
  target_group_arn = aws_lb_target_group.alb-target.arn
  target_id        = aws_instance.application-server.id
  # set port as per requested
  port = 3000
}


resource "aws_lb" "alb" {
  name               = "${var.alb-name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-80.id]
  subnets            = [module.network.subnet_id_p1, module.network.subnet_id_p2]

}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target.arn
  }
}