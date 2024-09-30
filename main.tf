module "vpc" {
  source                      = "./Modules/VPC"
  create_public_subnet       = true
  create_private_subnet      = true
  create_private_with_internet_access = true
  vpc_cidr                   = "10.0.0.0/16"
  public_subnet_cidrs        = ["10.0.5.0/24", "10.0.6.0/24"]  # Updated public subnets
  availability_zones         = ["ap-south-1a", "ap-south-1b"]
  private_subnet_cidrs       = ["10.0.7.0/24", "10.0.8.0/24"]
  
}

module "SG" {
  source = "./Modules/SG"
  vpc_id =  module.vpc.vpc_id
  security_name = "sg"
}

module "database" {
   source                 = "./Modules/Database"
  engine                 = "postgres"
  engine_version         = "12.16"
  vpc_security_group_ids = [module.SG.security_group_id]
  username               = "assign"
  allocated_storage      = 20
  db_name                = "templatedb"
  instance_class         = "db.t3.micro"
  identifier = "template-db-instance"
  is_public=true
  public_subnet_ids = module.vpc.public_subnet_ids_output  # Directly pass the output
  private_subnet_ids = module.vpc.private_subnet_ids_output  # Directly pass the output
  private_internet_subnet_ids = module.vpc.private_internet_subnet_ids  # Directly pass the output
  use_private_internet_access= false
}