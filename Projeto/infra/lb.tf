resource "aws_autoscaling_group" "autoScalingGroup" {
    vpc_zone_identifier = [aws_subnet.privateSubnet.id, aws_subnet.privateSubnet2.id]
    health_check_type = "ELB"
    name = "backendASG"
    max_size = 4
    min_size = 1
    target_group_arns = [ aws_lb_target_group.loadBalancerTarget[0].arn ]
    launch_template {
        id = aws_launch_template.backendTemplate.id
        version = "$Latest"
    }
    health_check_grace_period = "120"
    depends_on = [
       aws_db_instance.RDSMySql
    ]
}

resource "aws_autoscaling_policy" "scaleupPolicy" {
    name = "scaleupPolicy"
    autoscaling_group_name = aws_autoscaling_group.autoScalingGroup.name
    policy_type = "SimpleScaling"
    scaling_adjustment = "1"
    cooldown = "120"
    adjustment_type = "ChangeInCapacity"
}

resource "aws_autoscaling_policy" "scaledownPolicy" {
    name = "scaledownPolicy"
    autoscaling_group_name = aws_autoscaling_group.autoScalingGroup.name
    policy_type = "SimpleScaling"
    scaling_adjustment = "-1"
    cooldown = "120"
    adjustment_type = "ChangeInCapacity"
}

resource "aws_cloudwatch_metric_alarm" "scaleupAlarm"{
    alarm_name = "scaleupAlarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    period = "60"
    statistic = "Average"
    threshold = "50"
    namespace = "AWS/EC2"
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.autoScalingGroup.name
    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.scaleupPolicy.arn]
}

resource "aws_cloudwatch_metric_alarm" "scaledownAlarm"{
    alarm_name = "scaledownAlarm"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    period = "60"
    statistic = "Average"
    threshold = "50"
    namespace = "AWS/EC2"
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.autoScalingGroup.name
    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.scaledownPolicy.arn]
}

resource "aws_lb_target_group" "loadBalancerTarget" {
    name = "targetEC2"
    port = "8080"
    protocol = "HTTP"
    vpc_id = aws_vpc.myvpc.id
    count = 1

    health_check {
        path                = "/registro"
        port                = 8080
        protocol            = "HTTP"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        matcher             = "200-499"
    }
}

resource "aws_lb_listener" "lbEntry" {
    load_balancer_arn = aws_lb.loadBalancer[0].arn
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.loadBalancerTarget[0].arn
    }
    count = 1
}

resource "aws_lb" "loadBalancer" {
    internal = true
    subnets = [aws_subnet.privateSubnet.id, aws_subnet.privateSubnet2.id]
    security_groups = [aws_security_group.lbAccess.id]
    count =  1
}