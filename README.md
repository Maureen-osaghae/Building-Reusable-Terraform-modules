<h1>Building Reusable Terraform modules</h1>

Creating a terraform Modules is important when working in an business environment or with teams. You need to have a standard and secure way of creating resources. This is where modules come in handy. We can create a module that defines the standard way to create certain resources, and then share that module with other teams or projects. That way, infrastructure built will always meet our required standards. Today, I learn how to create a module for an EC2 instance in this lab. 

<h2>Created Module Directory Structure and Associated Files</h2>

Create a fresh directory name: Terraform-ReuseableModules

    mkdir  Terraform-ReuseableModules && cd $_

Create three files- main.tf, variables.tf and provider.tf

    touch main.tf variables.tf provider.tf

Create a sub directory name  ReuseableModule/ec2

    mkdir -p ReuseableModule/ec2

Create two files under this sub folder ReuseableModule/ec2

    touch ReuseableModule/ec2/main.tf ReuseableModule/ec2/variables.tf

<img width="598" height="263" alt="image" src="https://github.com/user-attachments/assets/7589b148-2e00-44b1-9bdb-1346dcba2b4c" />

<h2>Open in VS Code</h2>

<img width="699" height="302" alt="image" src="https://github.com/user-attachments/assets/0842e9e1-9651-4db8-a00e-4968e6eb6ab9" />

Let start writing code on our files

First is to copy the provider block and paste it in the root directory 

    provider.tf 

<img width="506" height="310" alt="image" src="https://github.com/user-attachments/assets/6935a9c5-0133-4fe8-a610-c31702111c9f" />

Open the /variables.tf file in my root directory and add the region: 

    /variables.tf

<img width="637" height="218" alt="image" src="https://github.com/user-attachments/assets/1f7865b8-349d-4ba1-a58e-ffaf41ea06f8" />

<h1>Building the EC2 Module</h1>

Open the ReuseableModule/ec2main.tf file and add the following code:

        resource "aws_instance" "instance" {
      ami           = ""
      instance_type = ""
      root_block_device {}
      tags = ""
    }

<h2>Ensuring the EC2 is Encrypted</h2>

One of the requirements for our module was to ensure the instance is encrypted. We set this with theroot_block_deviceblock. The encrypted field is set to true to ensure the root volume is encrypted. If this were set to false, the root volume would not be encrypted.

     ReuseableModule/ec2main.tf

<img width="576" height="191" alt="image" src="https://github.com/user-attachments/assets/a5f52b3e-0971-4efe-a702-a206b314739b" />

<h2>Limiting the Instance Type Options</h2>

We also need to ensure that only t2.micro or t3.micro instances are created. This is set with the instance_type argument but we don’t want to hardcode this as the user should have a choice.
What we can do is set this value to a variable var.instance_type like so:

    ReuseableModule/ec2main.tf

<img width="444" height="212" alt="image" src="https://github.com/user-attachments/assets/d8e52c9f-7808-43a1-84a3-b7912144d9a2" />

However, for this variable to work, we need to define it in the modules/ec2/variables.tf file. Let’s do that now.

    ReuseableModule/ec2variables.tf

<img width="607" height="187" alt="image" src="https://github.com/user-attachments/assets/ba89b38a-167d-4f58-86f8-a9db2520b02a" />

<h2>Ensuring the Instance is Tagged with BusinessUnit</h2>

Next, we’re going to ensure that any tags added include the BusinessUnit tag. In the same way we did with the instance_type variable, we’ll create a variable for the instance tags.

    ReuseableModule/ec2variables.tf

<img width="534" height="200" alt="image" src="https://github.com/user-attachments/assets/9defc81b-62e5-4804-bba5-b4d47ee64a57" />

When we use the tags argument in the aws_instance resource, we have to pass a map of strings. This is what the type field is set to. An example of how tags are passed as a map of strings is shown below: 

<img width="516" height="247" alt="image" src="https://github.com/user-attachments/assets/8802e4ee-f447-4044-86fb-4aabd5426810" />

he validation block checks that the map of strings passed includes the BusinessUnit tag. If it doesn’t, Terraform will output the error_message and the tag will not be added to the resource.
Let’s add the tagging variable to the aws_instance resource in the ReuseableModule/ec2main.tf file.

    ReuseableModule/ec2main.tf

<img width="650" height="188" alt="image" src="https://github.com/user-attachments/assets/4150ff36-6bbf-411b-8670-d999a614f943" />

<h2>Using the Latest Ubuntu Server or Amazon Linux AMI</h2>

We can use the aws_ami data source to get the latest AMI. Add the following code to the  ReuseableModule/ec2main.tf file.

<img width="670" height="347" alt="image" src="https://github.com/user-attachments/assets/28a1414b-ae13-4d51-825b-e9132ed73753" />

Thelocalsblock stores the AMI IDs that we retrieve, which will make more sense once we explain the data blocks.
 
     ReuseableModule/ec2main.tf

<img width="573" height="85" alt="image" src="https://github.com/user-attachments/assets/10592522-a70a-4ac4-9ecb-3a7c6b963572" />

The data block lets us read data from an external source rather than create it. In this case, we’re using the aws_ami data source to get the latest Amazon Linux and Ubuntu Server AMIs (with most_recent = true). 

But where do the filters come from?
The filters are used to narrow down the search for the AMI as there are thousands to choose from on AWS. We can leverage an CLI command to find the AMIs and then use filters to narrow down the search.

    Configure the AWS CLI : aws configure 

    aws ec2 describe-images –region us-east-1

<img width="743" height="204" alt="image" src="https://github.com/user-attachments/assets/88575987-4ebc-4e48-a562-91a303fd1dcf" />

So for this code: 

<img width="302" height="56" alt="image" src="https://github.com/user-attachments/assets/79b953c8-550c-4cdc-b4f6-f25d53ed54cd" />

It’s looking for the AMI with the name containing*ubuntu-jammy-22.04-amd64-server* which is stored in the field Images[].Name in the example output above. 
The * is a wildcard character that allows us to search for any AMI with the name containing ubuntu-jammy-22.04-amd64-server.

Likewise, for this code:

<img width="264" height="58" alt="image" src="https://github.com/user-attachments/assets/d088a970-f91e-4975-83d1-9020662aa9f2" />

It’s looking for the AMI with the PlatformDetails field set to Linux/UNIX in the example output above.
An equivalent AWS CLI command to find the Ubuntu Server AMI would be:

    aws ec2 describe-images --owners amazon --filters "Name=name,Values=*ubuntu-jammy-22.04-amd64-server*" "Name=platform-details,Values=Linux/UNIX" "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64" 

You would have to manipulate the output to get the latest AMI ID but thankfully, Terraform does this for us with the most_recent = true argument.
So back to our code, once this information is retrieved from their respective data.aws_ami resources, they get stored in our locals.

<h2>Giving users the ability to select an AMI</h2>
Finally, let’s discuss how the user is able to select the AMI they want to use. We’ll need a variable defined in  ReuseableModule/ec2variables.tf file like so:
    
    ReuseableModule/ec2variables.tf

<img width="568" height="159" alt="image" src="https://github.com/user-attachments/assets/d12df0d8-ff19-4a16-a8fb-a43e0e2565a1" />

This variable expects the user to type either ubuntu or amazon linux. If anything else is typed, Terraform will output the error_message and prevent the resource from being created. 
Essentially, the flow goes like this: if the user selected ubuntu as the AMI, the ubuntu local variable will store the AMI ID from the data.aws_ami.ubuntu_server_latest resource, otherwise it will be null. The same goes for the amazon local variable. If the user instead selected amazon linux then then AMI ID from the data.aws_ami.amazon_linux_latest resource will be stored in the amazon local variable.

The coalesce function is used to return the first non-null value. So, if the user chose ubuntu, the image local variable will store the AMI ID from the ubuntu local variable. If the user instead chose to use amazon linux, the image local variable would store the AMI ID from the amazon local variable.

We can now update the ami field in the aws_instance resource to use the image local variable. 

<h2>Using the EC2 Module</h2>

We’ve built a module in Terraform! Now, let’s learn how to use it!
Earlier we created a main.tf file in the root directory. This is the file we’ll update to use the module we just created. That’s why we have two separate main.tf files.
main.tf

<img width="772" height="245" alt="image" src="https://github.com/user-attachments/assets/47ff8855-b90d-4036-a3da-616ee9a2888e" />

In themodule block, we’re defining the module ec2_instance and setting the source to the modules/ec2 directory since this is where the module code is stored. We’re also passing the instance_type, image_os, and tagging variables to the module as these are required.
Remember, you’re able to set the instance_type to either t2.micro or t3.micro, the image_os to either ubuntu or amazon linux, and the tagging must include the BusinessUnit tag but you’re free to add any other tags you’d like.

<h2>Adding our Custom VPC resources</h2>
Before I can deploy this instance, I need to create a custom VPC since I am using Cybr’s lab environment.
Otherwise, add the following to the ReuseableModule/ec2/main.tf file:

    # Custom VPC
    resource "aws_vpc" "custom_vpc" {
      cidr_block = "10.0.0.0/16"
    }
    
    # Get available AZs
    data "aws_availability_zones" "available" {
      state = "available"
    }
    
    locals {
      filtered_azs = [for az in data.aws_availability_zones.available.names : az if contains(["us-east-1f", "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"], az)]
    }
    
    # Subnet within the VPC
    resource "aws_subnet" "main" {
      vpc_id            = aws_vpc.custom_vpc.id
      cidr_block        = "10.0.1.0/24"
      availability_zone = element(local.filtered_azs, 0)
    }
    
    # Security group
    resource "aws_security_group" "example" {
      name        = "Example Security Group"
      description = "Example security group for EC2 instance"
      vpc_id      = aws_vpc.custom_vpc.id
    }
    
    # Ingress rule
    resource "aws_vpc_security_group_ingress_rule" "allow_http" {
      security_group_id = aws_security_group.example.id
    
      cidr_ipv4   = aws_vpc.custom_vpc.cidr_block
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
    }
    
    # Egress rule
    resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
      security_group_id = aws_security_group.example.id
    
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }


We also need to add these two lines to our resource "aws_instance" "instance" in that same file: 

<img width="619" height="151" alt="image" src="https://github.com/user-attachments/assets/583ab931-0b8b-49b3-b51a-f5d99ea42242" />

<h2>Deploying our resources</h2>
Before planning or applying, make sure to runterraform init to download the necessary plugins and initialize the module.
Let’s validate the attributes for our variables are correct by running terraform validate.

<img width="703" height="447" alt="image" src="https://github.com/user-attachments/assets/ab85b3e0-8173-4fdf-8403-cc94f2265a87" />

        terraform validate

<img width="665" height="78" alt="image" src="https://github.com/user-attachments/assets/71a37a45-d48c-428e-b155-3f4d9f892fd6" />

The validate command is very useful here. If we update our code to not conform to the requirements set in the variables, we’ll see error messages.

<h2>Configure AWS CLI</h2>

<img width="722" height="182" alt="image" src="https://github.com/user-attachments/assets/b716b2c4-fdec-4420-81be-dd8c5a08a2ce" />

terraform plan then follow by terraform apply

        terraform apply -var 'tagging={name="maureen-instance", BusinessUnit="infosec"}'

<img width="757" height="238" alt="image" src="https://github.com/user-attachments/assets/cd272e95-2650-4374-9c07-c3aac5b5796d" />

<img width="854" height="96" alt="image" src="https://github.com/user-attachments/assets/30d91e4c-c0dc-45eb-b907-92c96d4cca2b" />

<img width="707" height="251" alt="image" src="https://github.com/user-attachments/assets/20cae614-18ed-4ba1-a1da-07dda7efff6a" />

can validate the instance was successfully created by running the following AWS CLI command: 

    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text 

 <img width="770" height="92" alt="image" src="https://github.com/user-attachments/assets/09957948-1841-4126-b215-886e5948327c" />

 <img width="555" height="312" alt="image" src="https://github.com/user-attachments/assets/616ff5cb-f86d-4120-858d-b61ed8271589" />

view subnets 

    aws ec2 describe-subnets

<img width="601" height="317" alt="image" src="https://github.com/user-attachments/assets/5d56cdd3-4130-4b74-a944-b9703020e718" />

And our security group:  

    aws ec2 describe-security-groups

<img width="620" height="332" alt="image" src="https://github.com/user-attachments/assets/333d4fc9-9f8e-4dfa-ba84-8bdc881eca57" />

<h2>Tear Down</h2>
Nice work! You’ve successfully built a reusable Terraform module for creating an EC2 instance and built in some validation rules to ensure the instance is created to your standards. The code can be shared and reused across multiple projects or teams and the EC2 will always be created to the required standard.

Now, let’s clean up our lab and destroy the resources we created. Run terraform destroy and then confirm:

    terraform destroy -var 'tagging={name="maureen-instance", BusinessUnit="infosec"}'

<img width="735" height="303" alt="image" src="https://github.com/user-attachments/assets/95551765-545c-47bb-a3cb-9583c96d61c7" />

<img width="702" height="278" alt="image" src="https://github.com/user-attachments/assets/ca8d092d-5d32-41e7-ab32-8045bd63977e" />


































