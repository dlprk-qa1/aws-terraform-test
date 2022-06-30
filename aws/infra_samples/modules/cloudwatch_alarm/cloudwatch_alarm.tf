##################################################### Common Resource #########################################################################

# List of metric filters with pattern
locals {
  metric_filter_list = [
    {
      name                  = "Unauthorized API calls"
      pattern               = "{ ($.errorCode =\"*UnauthorizedOperation\") || ($.errorCode =\"AccessDenied*\") }"
    },
    {
      name                  = "Management Console sign-in without MFA"
      pattern               = "{ ($.eventName =\"ConsoleLogin\") && ($.additionalEventData.MFAUsed !=\"Yes\") }"
    },
    {
      name                  = "Usage of root account"
      pattern               = "{ $.userIdentity.type =\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\" }"
    },
    {
      name                  = "IAM policy changes"
      pattern               = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
    },
    {
      name                  = "CloudTrail configuration changes"
      pattern               = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
    },
    {
      name                  = "AWS Management Console authentication failures"
      pattern               = "{ ($.eventName = ConsoleLogin) && ($.errorMessage =\"Failed authentication\") }"
    },
    {
      name                  = "Disabling or scheduled deletion of customer created CMKs"
      pattern               = "{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion)) }"
    },
    {
      name                  = "S3 bucket policy changes"
      pattern               = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
    },
    {
      name                  = "AWS Config configuration changes"
      pattern               = "{ ($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }"
    },
    {
      name                  = "Security group changes"
      pattern               = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
    },
    {
      name                  = "Changes to network gateways"
      pattern               = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
    },
    {
      name                  = "Route table changes"
      pattern               = "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
    },
    {
      name                  = "VPC changes"
      pattern               = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
    },
    {
      name                  = "AWS Organizations changes"
      pattern               = "{ ($.eventSource = organizations.amazonaws.com) && ($.eventName = AcceptHandshake) || ($.eventName = AttachPolicy) || ($.eventName = CancelHandshake) || ($.eventName = CreateAccount) || ($.eventName = CreateOrganization) || ($.eventName = CreateOrganizationalUnit) || ($.eventName = CreatePolicy) || ($.eventName = DeclineHandshake) || ($.eventName = DeleteOrganization) || ($.eventName = DeleteOrganizationalUnit) || ($.eventName = DeletePolicy) || ($.eventName = EnableAllFeatures) || ($.eventName = EnablePolicyType) || ($.eventName = InviteAccountToOrganization) || ($.eventName = LeaveOrganization) || ($.eventName = DetachPolicy) || ($.eventName = DisablePolicyType) || ($.eventName = MoveAccount) || ($.eventName = RemoveAccountFromOrganization) || ($.eventName = UpdateOrganizationalUnit) || ($.eventName = UpdatePolicy) }"
    },
    {
      name                  = "Network Access Control Lists NACL"
      pattern               = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
    }
  ]
}

# Dynamic block of configuration for multiple resource count
locals {
  metric_filter_config = [
    for i in range(1,var.var_count+1) : [
      for metric_filter in local.metric_filter_list : {
        metric_filter_name  = "${var.env_name}-${var.infra_type}-${metric_filter.name}-${i}"
        alarm_name          = "${var.env_name}-${var.infra_type}-Alarm for ${metric_filter.name}-${i}"
        pattern             = var.infra_type == "compliant" ? metric_filter.pattern : ""
        metric_name         = "Metric for ${metric_filter.name}"
      }
    ]
  ]
}

locals {
  metric_filter_config_list = flatten(local.metric_filter_config)
}

# Metric filter
# pattern is set to empty for non-compliant case
resource "aws_cloudwatch_log_metric_filter" "log_metric_filter" {
  for_each                  = {
    for metric_filter in local.metric_filter_config_list : metric_filter.metric_filter_name => metric_filter
  }

  name                      = each.value.metric_filter_name
  pattern                   = each.value.pattern
  log_group_name            = var.log_group_name

  metric_transformation {
    name                    = each.value.metric_name
    namespace               = "CISBenchmark"
    value                   = "1"
  }
}

# Metric alarm
resource "aws_cloudwatch_metric_alarm" "metric_alarm" {
  for_each                  = {
    for metric_filter in local.metric_filter_config_list : metric_filter.metric_filter_name => metric_filter
  }

  alarm_name                = each.value.alarm_name
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = each.value.metric_name
  namespace                 = "CISBenchmark"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "12.0"
  actions_enabled           = "true"
  alarm_actions             = [var.sns_topic_arn]

  tags = {
    Name                    = each.value.alarm_name
  }
}