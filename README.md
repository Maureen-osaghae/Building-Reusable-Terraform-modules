<h1>Building Reusable Terraform modules</h1>

Creating a terraform Modules is important when working in an business environment or with teams. You need to have a standard and secure way of creating resources. This is where modules come in handy. We can create a module that defines the standard way to create certain resources, and then share that module with other teams or projects. That way, infrastructure built will always meet our required standards. Today, I learn how to create a module for an EC2 instance in this lab. 

<h2>Created Module Directory Structure and Associated Files</h2>

Create a fresh directory name: Terraform-ReuseableModules

    mkdir  Terraform-ReuseableModules && cd $_

create three files- main.tf, variables.tf and provider.tf

    touch main.tf variables.tf provider.tf

create a sub directory name  ReuseableModule/ec2

    mkdir -p ReuseableModule/ec2

create two files under this sub folder ReuseableModule/ec2

    touch ReuseableModule/ec2/main.tf ReuseableModule/ec2/variables.tf

<img width="598" height="263" alt="image" src="https://github.com/user-attachments/assets/7589b148-2e00-44b1-9bdb-1346dcba2b4c" />




