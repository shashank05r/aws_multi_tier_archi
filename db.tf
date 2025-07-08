












resource "aws_db_instance" "sample_db" {

vpc_security_group_ids = [aws_security_group.db_sg.id]
    
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name


      identifier             = "mydb-instance"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.db_user_name
  password               = var.db_password
  db_name                = "myappdb"
  port                   = 3306
  publicly_accessible    = false
  multi_az               = false
  storage_encrypted      = true
  skip_final_snapshot    = true
}