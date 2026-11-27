locals {
  # CIS AWS Foundations Benchmark v3.0.0, section 3 (monitoring)
  cis_controls = {
    UnauthorizedAPICalls = {
      cis         = "3.1"
      description = "Unauthorized API calls"
      pattern     = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
    }
    NoMFAConsoleSignIn = {
      cis         = "3.2"
      description = "Console sign-in without MFA"
      pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.userIdentity.type = \"IAMUser\") && ($.responseElements.ConsoleLogin = \"Success\") }"
    }
    RootUsage = {
      cis         = "3.3"
      description = "Root account usage"
      pattern     = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
    }
    IAMPolicyChanges = {
      cis         = "3.4"
      description = "IAM policy changes"
      pattern     = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
    }
    CloudTrailChanges = {
      cis         = "3.5"
      description = "CloudTrail configuration changes"
      pattern     = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
    }
    ConsoleSigninFailures = {
      cis         = "3.6"
      description = "Console sign-in failures"
      pattern     = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
    }
    DisableOrDeleteCMK = {
      cis         = "3.7"
      description = "Customer managed KMS key disabled or scheduled for deletion"
      pattern     = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
    }
    S3BucketPolicyChanges = {
      cis         = "3.8"
      description = "S3 bucket policy changes"
      pattern     = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
    }
    AWSConfigChanges = {
      cis         = "3.9"
      description = "AWS Config configuration changes"
      pattern     = "{ ($.eventSource = config.amazonaws.com) && (($.eventName = StopConfigurationRecorder) || ($.eventName = DeleteDeliveryChannel) || ($.eventName = PutDeliveryChannel) || ($.eventName = PutConfigurationRecorder)) }"
    }
    SecurityGroupChanges = {
      cis         = "3.10"
      description = "Security group changes"
      pattern     = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
    }
    NACLChanges = {
      cis         = "3.11"
      description = "Network ACL changes"
      pattern     = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
    }
    NetworkGatewayChanges = {
      cis         = "3.12"
      description = "Network gateway changes"
      pattern     = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
    }
    RouteTableChanges = {
      cis         = "3.13"
      description = "Route table changes"
      pattern     = "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
    }
    VPCChanges = {
      cis         = "3.14"
      description = "VPC changes"
      pattern     = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
    }
  }

  cis_enabled_controls = {
    for k, v in local.cis_controls : k => v
    if var.enable_cis_alarms && !contains(var.cis_disabled_controls, k)
  }
}

### synthetics ##

locals {
  canary_bucket_name = "${var.name}-canary-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}"
}