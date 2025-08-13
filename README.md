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















