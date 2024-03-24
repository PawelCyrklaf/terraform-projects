resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ECS_Cluster"
}

resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 100
  }
}

resource "aws_ecs_task_definition" "nginx_task_definition" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::177394270612:role/ecsTaskExecutionRole"
  container_definitions    = jsonencode([
    {
      name        = "nginx"
      image       = "nginx"
      cpu         = 256
      memory      = 512
      essential   = true
      healthCheck = {
        retries = 3
        command = ["CMD-SHELL", "curl -f http://localhost || exit 1"]
      }
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-group"         = "tester",
          "awslogs-region"        = "eu-central-1"
          "awslogs-stream-prefix" = "ecs-stream"
        }
      }
    },
  ])
}

resource "aws_ecs_service" "nginx_service" {
  name                 = "nginx-service"
  task_definition      = aws_ecs_task_definition.nginx_task_definition.arn
  cluster              = aws_ecs_cluster.ecs_cluster.id
  desired_count        = 2
  launch_type          = "FARGATE"
  force_new_deployment = true

  triggers = {
    redeployment = plantimestamp()
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx"
    container_port   = var.app_port
  }

  network_configuration {
    subnets          = [module.vpc.public_subnets[1]]
    security_groups  = [aws_security_group.task_security_group.id]
    assign_public_ip = true
  }
}