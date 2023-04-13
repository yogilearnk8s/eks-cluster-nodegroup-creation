//provider "aws" {
//  region     = "ap-south-1"
//}

data "aws_vpc" "yogi-vpc"{

filter {
 name = "tag:Name"
 values = ["Yogi-VPC-DevOps"]
}
}


//data "aws_subnet" "public-subnets" {
//count = "${length(var.public-subnet-cidr)}"
//  vpc_id = data.aws_vpc.yogi-vpc.id

//  filter {
//    name   = "tag:Name"
//    values = ["public-subnet-*"] 
//  }
//}

data "aws_subnet_ids" "public-subnets" {
vpc_id = data.aws_vpc.yogi-vpc.id
//count = "${length(data.aws_subnet.public-subnets.id)}"
//count = data.aws_subnet.public-subnets[count.index]
count = "${length(var.public-subnet-cidr)}"
//id = "${tolist(data.aws_subnet.public-subnets.ids)[count.index]}"
  //id = data.aws_subnet.public-subnets[count.index]
  filter {
   name = "tag:Name"
   values = ["public-subnet-*"]
  }
}

data "aws_iam_role" "example" {
  name = "sandboxcluster-eks-iam-role"
}



resource "aws_eks_cluster" "eks_sandbox_cluster" {
count = "${length(var.public-subnet-cidr)}"
 
 name = var.eks-cluster-name
 role_arn = data.aws_iam_role.example.arn


 vpc_config {
 //for_each = data.aws_subnet.public-subnets.ids
  endpoint_private_access = false
  endpoint_public_access  = true
  subnet_ids = flatten([data.aws_subnet_ids.public-subnets[*].id])
 // subnet_ids = "${element(data.aws_subnet.public-subnets.*.id, count.index)}"
 // subnet_ids = "${tolist(data.aws_subnet.public-subnets.ids)[count.index]}"
  //subnet_ids = data.aws_subnet.public-subnets[count.index]
  //subnet_ids =  data.aws_subnet.public-subnets[*]
    //subnet_ids = ["${data.aws_subnet.public-subnets.ids}"]    
	//subnet_ids = values(data.aws_subnet.public-subnets)[*].id\
	//subnet_ids = each.value
 }

// depends_on = [
//  aws_iam_role.eks-iam-role,
// ]
}

