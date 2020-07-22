### How to deploy infrastructure defined in Terraform

Steps are:

- Install Terraform
- Setup `main.tf`
- Navigate to directory that contain the `mani.tf`
- Run `terraform init`, that's because when you create a new configuration — or check out an existing configuration from version control — you need to initialize the directory with terraform init.
- Setup `variables.tf` that contains definitions of all variables
- Validate your configuration. If your configuration is valid, Terraform will return a success message, run `terraform validate`
- Apply the script

```
terraform apply -var 'profile=udacity-training' -var 'region=us-east-1'
```

### How to destroy infrastructure deployed by Terraform

```
terraform destroy
```

**Note** If there are some infrastructure defined manually, for example the script created VPN, but you manually setup a security group, then the `terraform destory` process won't be able to clean up the VPN. You must remove the security group first.

### How to find the name of an AWS AMI

Run the command by providing specifc region and AMI.

```
aws ec2 describe-images --region us-east-1 --image-ids ami-08f3d892de259504d
```

### Setup environment variable

Type in the command in the bash and execute it:

```
export greeting="Hello world"
```

### Create zip archive that contains AWS Lambda source code

```
zip lambda.zip lambda.py
```
