# Introduction 
This project has been created to deploy compliant, non compliant resources of AWS  resources for scale testing purposes.

# PREREQUISITE
    1. Create IAM Role, assign the appropriate scope and get the access and secret key.
        Permission Required:
            ---> Contributor
    2. Install aws cli
       Link : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
       configure the IAM credentials
       Commands:
       aws configure
    3. Install terraform version (v0.15.3)
       Link : https://releases.hashicorp.com/terraform/
# Getting Started
### Deploying compliant, non-compliant resources & Organization Policies

    1. Ensure to enable AWS Region of Deployment
    2. Clone the project go to the aws folder and go to infra_samples/deployment folder to deploy resources.
    3. Enter command:
        service_type        -->  Name of services which need to deploy
        exclude_service     --> Name of services which you do not want to deploy (use this parameter when service_type is set to "all")
        
        terraform init      --> initialize the terraform
        
        terraform plan -var-file=terraform_compliant.tfvars -var="service_type=[\"service_name1\" , \"service_name2\"]" -var="env=<service_name_prefix>" --> list the compliant resources and its configuration to deployed
        OR
        terraform plan -var-file=terraform_noncompliant.tfvars -var="service_type=[\"service_name1\" , \"service_name2\"]" -var="env=<service_name_prefix>" --> list the non-compliant resources and its configuration to deployed

        terraform apply -auto-approve -var-file=terraform_compliant.tfvars -var="service_type=[\"service_name1\" , \"service_name2\"]" -var="env=<service_name_prefix>"  --> Will deploy the compliant resources
        OR
        terraform apply -auto-approve -var-file=terraform_noncompliant.tfvars -var="service_type=[\"service_name1\" , \"service_name2\"]" -var="env=<service_name_prefix>"  --> Will deploy the non-compliant resources

    4. To deploy all resource run below commands:
        
        Compliant Resource --> terraform apply -auto-approve -var-file=terraform_compliant.tfvars -var="service_type=[\"all\"]" -var="exclude_service=[\"service_name1\", \"service_name2\"]" -var="env=<service_name_prefix>"
        
        Non-Compliant Resource --> terraform apply -auto-approve -var-file=terraform_noncompliant.tfvars -var="service_type=[\"all\"]" -var="exclude_service=[\"service_name1\", \"service_name2\"]" -var="project_name=<project_name>" -var="env=<service_name_prefix>"

    4. Available service_type = [ kms, vpc, s3_bucket, security_group, log_group, ec2_instance ]
    

# Contribute

1. If you want to develop an infrastructure sample of service named 'x', created a folder named x in modules folder and create files in it x.tf, variables.tf & outputs.tf.
2. Create the required template and update the main.tf file for the modules.
3. Test the deployment and make sure other services are not affected by your changes before merging the code. 

You can refer the terraform documentation(https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for developing the new infrastructure samples.