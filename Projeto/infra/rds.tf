# data "aws_db_snapshot" "dbSnapshot" {
#     most_recent = true
#     db_instance_identifier = "rdsmysql"
# }

resource "aws_db_subnet_group" "privateRDS" {
  name       = "privaterds"
  subnet_ids = [aws_subnet.privateSubnet.id, aws_subnet.privateSubnet2.id]

  tags = {
    Name = "privaterds"
  }
}

resource "aws_db_instance" "RDSMySql" {
    allocated_storage   = 10
    storage_type        = "gp2"
    identifier          = "rdsmysql"
    engine              = "mysql"
    engine_version      = "8.0.25"
    instance_class      = "db.t2.micro"
    username            = "admin"
    password            = "admin123"
    skip_final_snapshot = true
    multi_az = false
    db_subnet_group_name   = aws_db_subnet_group.privateRDS.name
    vpc_security_group_ids = [aws_security_group.rdsAccess.id]

    publicly_accessible = false

    tags = {
        Name = "MyRDS"
    }

    //snapshot_identifier = "${data.aws_db_snapshot.dbSnapshot.id}"
}