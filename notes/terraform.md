1. What is Terraform?
# Terraform is an infrustructure as code tool that lets yuou build, change, and version infrustructure safely and efficiently.
# This includes low-leve components like compute instances, and networking; and high-level components like DNS entries and SaaS features.

* Problem 
# Everytime I have to create a new user i have to go to AWS console and click many parts just to create 1 user, if i have 50+ users i have to repeat the same thing over and over again and  give them the same resources such as: networks, load balancers , servers. 

* Solution
# Terraform lets me write down what i want in a text file, and then it creates it for me. The infrustructure is described in code, human readable language.

2. How Terraform talks to AWS
# It downloads plugins called provider. 
# The provider is a translator: it turns your text files into AWS API calls.
# Terraform files work the same no mater what provider you use, Azure, Google Cloud Providers, GitHub etc. The skills transfer between clouds.

3. Reading a .tf file
Everything is structured as Blocks.

* provider "aws" {
  region = "us-east-1"
}

* resource "aws_iam_group" "developers" {
  name = "developers"
}
# provider "aws": uses the AWS translator, and work in the us-east-1 region
# resource: The things you want to exist. Every resource has two labels:
 a. aws_iam_group: the type or kind of aws thing you want. The name is fixed, and you look it up in the docs.
 b. "developers" : the local name, a niockname you choose so you can refer to it elsewhere in your code. AWS never sees it.
 c. You need two names so that later when another resource needs to refer to this user, you'd write aws_iam_group.developers, using a local name. if later you chjoose to rename it to ben-developer, your code references wont break.

# name = "developers": an argument, a setting for that resource. This one is the actual name AWS will show in the console.

* So aws_iam_group.developers means "the IAM group that i nicknamed developers."

# !ALWAYS CHECK THE PLAN BEFORE APPLY.
* If you ran "terraform plan" it will show you what  Terraform would create. Nothing exist yet. So the output may look something like this:

+ resource "aws_iam_user" "tester" { name = "test-user" ... }
Plan: 1 to add, 0 to change, 0 to destroy.

The + means "will be created"
The ~ means "will be changed"
The - means "will be removed"
* Always look for - before you apply.

3. The four commands.

# terraform init: Downloads the provider
# terraform plan: Shows what would change, without changing anythging
# terraform apply: Makes the changes in AWS
# terraform destroy: Deletes everything it created

* Extra commands to know
# terraform plan -out=tfplan: make the plan and save it to a file called "tfplan"
# terraform show tfplan: (optional) read the saved plan agian
# terraform apply tfplan: apply the exact plan

* What these additional commands solves.
# The terraform apply on its own, quetly makes a brand new plan and then asks you to approve it, yet taht plan matches the one you already have. 
# If something changed inbetween, then it means the plan you approved is not the one you reviiewed. 
# -out fixes it by resufing with an error saying planm is stale. You make make a new plan, read it, and try again.

* Anology # Think of it like a written quotaion from the machenic
a. Without -out: you agree to fix a car and the machenic decides what that means when the work starts.
b. With -out: you sign a quote list ing exactly which parts get replaced. 
   The machanic can only do whats on the quote. 
    If they find something new, they need a new quote and a new signature.

* On Linux and MacOS its okay to type it like this: terraform plan -out=main.tfplan
* But on Powershell its imporatant to use quotation marks: terraform plan "-out=main.tfplan" even when you are applying.


4. What do you think the 4 terraform files are for snd should they go to Git?
# These files are the infrastructure of my configurations. 
# .terraform/: the downloaded provider (AWS translator),  not supposed to go to Git.
# .terraform.lock.hcl: a record of exactly which provider version was used, so that everyone gets the same one.
# terraform.tfstate: Terrafor's mermory of what exists in AWS.  Can contain secrets.
# terraform.tfstate.backup: The previous version of that memory, from before the last change. Can have secrets.



# MAKING RESOURCES WORK TOGETHER

1. So far i only created one thing on its own, but real infrastructure is made up of connected things: a user belongs to a group, a server sits in a network, a load balancer sends trafdfic to a server.

In oprder to connect them together, one resource should *refer to another* using the following pattern.
* TYPE.LOCAL_NAME.ATTRIBUTE
 aws_iam_group.developers.name
 Read it as: "the group I nicknamed developers -> give me this name"

 * One source of truth: if I rename the group later, every reference updates automatically.
 * Terraform works out the order for you. When resource B reference resource A, Terraform knows that A must be created first. 
You never have to tell it the order. And on destroy, it revereses the order automatically. B is removed before A.
* This is called an implicit dependancy; "Implicit" because you never wrote "do A before B", the reference implied it.

# 1. A user
resource "aws_iam_user" "___" {        # choose a local name
  name = "test-dev"
}

# 2. Put that user into the group
resource "aws_iam_user_group_membership" "___" {   # choose a local name
  user   = ___     # refer to the user's name, using TYPE.LOCAL_NAME.ATTRIBUTE
  groups = [___]   # a list containing the group's name, using a reference, not plain text
}

2. Teams split files by topic once a project grows (network.ts, iam.tf, outputs.tf) so that people can know where to find things. 