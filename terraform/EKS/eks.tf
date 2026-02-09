module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  # 🔹 IMPORTANT: define node groups ONLY here
  eks_managed_node_groups = {
    default = {
      name = "flask-notes-ng"

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      # 🔒 These flags prevent custom launch-template GPU blocks
      use_custom_launch_template = false
      enable_bootstrap_user_data = true

      labels = {
        role = "worker"
      }

      tags = {
        Name = "flask-notes-ng"
      }
    }
  }

  tags = {
    Project = "flask-notes"
    Owner   = "hariharan"
  }
}
