#Ensure that encryption is enabled for RDS MySQL Instances
resource "aws_db_instance" "mysql_instance" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_mysql1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-mysql1-${count.index + 1}"
  engine = "mysql"
  engine_version = "5.7.28"
  instance_class = "db.t2.medium"
  db_name = "mysql_instance"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption is enabled for RDS MariaDB Instances
resource "aws_db_instance" "MariaDB1_instance" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_MariaDB1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-mariadb1-${count.index + 1}"
  engine = "mariadb"
  instance_class = "db.t2.medium"
  db_name = "mariadb1_instance"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption is enabled for RDS aurora SQL Instance
 #aws_rds_cluster complaint resourse
 resource "aws_rds_cluster_instance" "cluster_instances_demo" {
   count              = var.infra_type == "compliant" ? var.var_count : 0
  #  name               = "${var.env_name}-${var.infra_type}-rds_cluster-${count.index + 1}"
   identifier         = "${var.env_name}-${var.infra_type}-rds-aurora-cluster-${count.index + 1}"
   cluster_identifier = aws_rds_cluster.cluster_storage[count.index].id
   instance_class     = "db.t3.small"
   engine             = aws_rds_cluster.cluster_storage[count.index].engine
 }
resource "aws_rds_cluster" "cluster_storage" {
   count                     = var.infra_type == "compliant" ? var.var_count : 0
  #  name                      = "${var.env_name}-${var.infra_type}-storage_cluster-${count.index + 1}"
   cluster_identifier        = "${var.env_name}-${var.infra_type}-storage-cluster-${count.index + 1}"
   engine                    = "aurora-mysql"
   skip_final_snapshot = true
   storage_encrypted         = true
   #storage_type = "standard"
   backup_retention_period = 8
   master_username = var.username
   master_password = var.password
   }

#Ensure that encryption is enabled for RDS oracle Instances
  resource "aws_db_instance" "oracledb" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_oracle11-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-oracle11-${count.index + 1}"
  engine = "oracle-ee"
  instance_class = "db.t3.small"
  db_name = "oracledb"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption is enabled for RDS postgresql Instances
resource "aws_db_instance" "PostgreSQL_instance" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_postgresql-inst-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-postgresql-inst-${count.index + 1}"
  engine = "postgres"
  instance_class = "db.t3.micro"
  db_name = "postgresql1_instance"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption is enabled for RDS sql Instances
resource "aws_db_instance" "SQL_instance" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_SQL-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-default-sqlserver-${count.index + 1}"
  license_model = "license-included"
  engine               = "sqlserver-web"
  engine_version       = "14.00.3281.6.v1"
  instance_class       = "db.t2.medium"
  db_name = ""
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption for storage done with KMS CMKs for each RDS SQL Server Instances
resource "aws_db_instance" "demo_SQL1" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_SQL1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-sqlserver-${count.index + 1}"
  engine = "sqlserver-web"
  engine_version = "14.00.3281.6.v1"
  license_model = "license-included"
  instance_class = "db.t2.medium"
  db_name = ""
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  kms_key_id             = var.infra_type == "compliant" ? var.kms_key : ""
  storage_type = "standard"
  storage_encrypted = true
  
}
#Ensure that encryption for storage done with KMS CMKs for each RDS postgreSQL Instances
resource "aws_db_instance" "demo_PostgreSQL1" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_PostgreSQL1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-postgressql1-${count.index + 1}"
  engine = "postgres"
  instance_class = "db.t3.micro"
  db_name = "postsql1"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  kms_key_id             = var.infra_type == "compliant" ? var.kms_key : ""
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption for storage done with KMS CMKs for each RDS oracle Instances
resource "aws_db_instance" "demo_oracle2" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_oracle-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-oracle2-${count.index + 1}"
  engine = "oracle-se2"
  instance_class = "db.t3.small"
  db_name = "oracle2"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  license_model = "license-included"
  kms_key_id             = var.infra_type == "compliant" ? var.kms_key : ""
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption for storage done with KMS CMKs for each RDS aurora-SQL Instances
resource "aws_rds_cluster_instance" "demo_cluster_instances1" {
   count              = var.infra_type == "compliant" ? var.var_count : 0
    #name               = "${var.env_name}-${var.infra_type}-rds_cluster-${count.index + 1}"
   identifier         = "${var.env_name}-${var.infra_type}-rds-aurora-cluster-inst-${count.index + 1}"
   cluster_identifier = aws_rds_cluster.demo_storage_cluster1[count.index].id
   instance_class     = "db.t3.small"
   engine             = aws_rds_cluster.demo_storage_cluster1[count.index].engine
   }
resource "aws_rds_cluster" "demo_storage_cluster1" {
   count                     = var.infra_type == "compliant" ? var.var_count : 0
    #name                      = "${var.env_name}-${var.infra_type}-storage_cluster-${count.index + 1}"
   cluster_identifier        = "${var.env_name}-${var.infra_type}-storage-cluster1-${count.index + 1}"
   engine                    = "aurora-mysql"
   kms_key_id             = var.infra_type == "compliant" ? var.kms_key : ""
   #storage_type = "standard"
   storage_encrypted = true
   backup_retention_period = 8
   skip_final_snapshot = true
   master_username = var.username
   master_password = var.password
   }
#Ensure that encryption for storage done with KMS CMKs for each RDS mariadb Instances
resource "aws_db_instance" "demo_MariaDB2" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_MariaDB1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-mariadb2-${count.index + 1}"
  engine = "mariadb"
  instance_class = "db.t2.medium"
  db_name = "mariadb2"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  kms_key_id             = var.infra_type == "compliant" ? var.kms_key : ""
  storage_type = "standard"
  storage_encrypted = true
}
#Ensure that encryption for storage done with KMS CMKs for each RDS mysql Instances
resource "aws_db_instance" "demo_mysql3" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-rds_mysql3-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-mysql2-${count.index + 1}"
  engine = "mysql"
  engine_version = "5.7.28"
  instance_class = "db.t2.medium"
  db_name = "mysql3"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  kms_key_id             = var.infra_type == "compliant" ? var.kms_key : ""
  storage_type = "standard"
  storage_encrypted = true

}
##################non-complaint###########################

#Ensure that encryption is disabled for RDS MySQL Instances
resource "aws_db_instance" "non_mysql1" {
  count              = var.infra_type == "non-compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-non_mysql1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-mysql-${count.index + 1}"
  engine = "mysql"
  engine_version = "5.7.28"
  instance_class = "db.t2.medium"
  db_name = "MySQL1"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = false
}
#Ensure that encryption is disabled for RDS MariaDB Instances
resource "aws_db_instance" "non_MariaDB1" {
  count              = var.infra_type == "non-compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-non_MariaDB1-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-mariadb-${count.index + 1}"
  engine = "mariadb"
  engine_version = "10.5"
  instance_class = "db.t2.medium"
  db_name = "mariadb1"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = false
}
#Ensure that encryption is disabled for RDS aurora SQL Instances
resource "aws_rds_cluster_instance" "non_cluster_instances" {
   count              = var.infra_type == "non-compliant" ? var.var_count : 0
  #  name               = "${var.env_name}-${var.infra_type}-rds_cluster-${count.index + 1}"
   identifier         = "${var.env_name}-${var.infra_type}-rds-aurora-cluster-${count.index + 1}"
   cluster_identifier = aws_rds_cluster.non_storage_cluster[count.index].id
   instance_class     = "db.t3.small"
   engine             = aws_rds_cluster.non_storage_cluster[count.index].engine
   engine_version     = aws_rds_cluster.non_storage_cluster[count.index].engine_version
 }
resource "aws_rds_cluster" "non_storage_cluster" {
   count                     = var.infra_type == "non-compliant" ? var.var_count : 0
  #  name                    = "${var.env_name}-${var.infra_type}-storage_cluster-${count.index + 1}"
   cluster_identifier        = "${var.env_name}-${var.infra_type}-rds-storagecluster-${count.index + 1}"
   engine                    = "aurora-mysql"
   engine_version            = "5.7"
   master_username = var.username
   master_password = var.password
   #storage_type = "standard"
   storage_encrypted         = false
   skip_final_snapshot = true
   apply_immediately = true
 }
 
#Ensure that encryption is disabled for RDS oracle  Instances
resource "aws_db_instance" "non_oracle1" {
  count              = var.infra_type == "noncompliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-non_oracle11-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-oracle1-${count.index + 1}"
  engine = "oracle-ee"
  engine_version = "12.1.0.2.v1"
  instance_class = "db.t3.small"
  db_name = "prodoracle_3"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = false
}
#Ensure that encryption is disabled for RDS postgresql Instances
resource "aws_db_instance" "non_PostgreSQL" {
  count              = var.infra_type == "non-compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-non_PostgreSQL-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-postgresql-${count.index + 1}"
  engine = "postgres"
  instance_class = "db.t3.micro"
  db_name = "prodpostgresql_3"
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = false
}
#Ensure that encryption is disabled for RDS sql Instances
resource "aws_db_instance" "noncompliant_SQL" {
  count              = var.infra_type == "non-compliant" ? var.var_count : 0
  #name               = "${var.env_name}-${var.infra_type}-non_SQL-${count.index + 1}"
  identifier = "${var.env_name}-${var.infra_type}-rds-sql-${count.index + 1}"
  engine = "sqlserver-web"
  license_model = "license-included"
  engine_version       = "14.00.3281.6.v1"
  instance_class = "db.t2.medium"
  db_name = ""
  username = var.username
  password = var.password
  allocated_storage = var.allocated_storage
  skip_final_snapshot = true
  storage_type = "standard"
  storage_encrypted = false
}