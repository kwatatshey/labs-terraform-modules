# # Deploy service IAM roles for EKS cluster and Fargate
# module "iam-eks-srv" {
#   source = "../../../modules/iam-eks-srv"

#   project_prefix = var.project_prefix
#   region         = var.region
# }


# # Deploy Fargate profile for infra kubernetes components
# module "eks-fargate-infra" {
#   source = "../../../modules/eks-fargate-infra"

#   cluster_name             = module.eks.cluster_name
#   profile_name             = "${var.project_prefix}-airflowfdna-eks-fargate-infra"
#   fargate_role_arn         = module.iam-eks-srv.fargate_role_arn
#   subnet_ids               = var.non_routable_subnets
#   coredns_replicas         = var.coredns_replicas
#   vpc_cni_addon_version    = var.vpc_cni_addon_version
#   coredns_addon_version    = var.coredns_addon_version
#   kube_proxy_addon_version = var.kube_proxy_addon_version
# }

# Deploy S3 bucket for Airflow logs
module "s3" {
  source = "./modules/s3"

  bucket_name = "${var.project_prefix}-airflowfdna-task-logs-${var.region}-${var.environment}"
}

# Deploy subnet group and security group for Elasticache Redis
module "redis-support" {
  source = "./modules/redis-support"

  redis_sg_name           = "${var.project_prefix}-airflowfdna-redis-sg"
  redis_subnet_group_name = "${var.project_prefix}-airflowfdna-redis-subnetgroup"
  redis_vpc_id            = var.target_vpc_id
  redis_subnets           = var.routable_subnets
}

# Deploy subnet group and parameter group for RDS
module "rds-support" {
  source = "./modules/rds-support"

  rds_subnet_group_name      = "${var.project_prefix}-airflowfdna-metadata-subnetgroup"
  rds_subnets                = var.routable_subnets
  rds_parameter_group_name   = "${var.project_prefix}-eks-pg${var.rds_parameter_group_family}"
  rds_parameter_group_family = var.rds_parameter_group_family
  rds_parameters             = var.rds_parameters
}


# Deploy EFS drive with mount targets and access point for prometheus
module "efs" {
  source = "./modules/efs"

  efs_name                  = "${var.project_prefix}-airflowfdna-efs-${var.environment}"
  efs_throughput_mode       = var.efs_throughput_mode
  efs_mount_targets_subnets = var.routable_subnets
  efs_mount_targets_sg      = var.cluster_security_groups_names
  efs_ap_name               = "${var.project_prefix}-airflowfdna-efs-prometheus-ap"
}