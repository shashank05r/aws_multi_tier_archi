variable "ami_id" {
  description = "ami-05ffe3c48a9991133"
  type=string
}

variable "instance_type" {

    description = "t2.micro"
    type=string
}

variable "db_user_name" {
  description = "db_username"
  type=string
  
}

variable "db_password" {
  description = "db_password"
  type= string 
  
}
