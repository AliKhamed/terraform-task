resource "aws_elasticache_subnet_group" "cache_subnets" {
  name       = "tf-test-cache-subnet"
  subnet_ids = [module.network.subnet_id_pr1, module.network.subnet_id_pr2]
}

# for redis as a special case we use resource aws_elasticache_replication_group
resource "aws_elasticache_replication_group" "example" {
  replication_group_id       = "redis-cluster"
  description                = "redis cluster"
  engine                     = "redis"
  node_type                  = "cache.t2.micro"
  engine_version             = "6.x"
  num_cache_clusters         = 2
  port                       = 6379
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.cache_subnets.name
  security_group_ids         = [aws_security_group.allow-ssh.id, aws_security_group.allow-3000.id, aws_security_group.allow-3306.id, aws_security_group.allow-6379.id]
}

# use system manager service to store environment variable 
resource "aws_ssm_parameter" "redis_endpoint" {
  name        = "/dev/redis/endpoint"
  description = "redis endpoint"
  type        = "SecureString"
  value       = aws_elasticache_replication_group.example.primary_endpoint_address

  tags = {
    environment = "dev"
  }
}