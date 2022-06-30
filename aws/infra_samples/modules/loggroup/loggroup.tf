resource "aws_cloudwatch_log_group" "log_group" {
  count                     = var.var_count
  name                      = "${var.env_name}-${var.infra_type}-loggroup-${count.index + 1}"

  tags = {
    Name = "${var.env_name}-${var.infra_type}-loggroup-${count.index + 1}"
  }
}
 