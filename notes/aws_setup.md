# Lock Down root
1. So in the console, i loggedin as root and registered an MFA
2. I went to account, made sure that i have no existing access keys and stuff
3. Still on account, i went to Alternate contacts, under Security contacts, i added an email that AWS will contact if they detect that my keys have been leaked online.
4. Still under account, I went to IAM user and role access to Bill information, changed it to Activate. This action is to allow my admin user to see the bill, so that i dont need to always login as root when i want to see the bill.

Now that i did all that, the only reason i will loging as  root is for root-only trasks, such as closing the account or chaninbging the support team.

# Billing guardrails
1. I went to billing, then opened Budget and created a monthly cost budget of $5, with email allerts at 80-% actual, and 100% forcasted.
2. Under billing, i made sure that i am using the free plan/credits.I currently have %119.95 remaining 

The Actaul alert is 80%, it fires when i have spent $4. Its after the fact
The Forecast alert 100% fires when AWS predicts that i will pass $5 by month end, based on my spending so far. It is the early warning.

I need both because they catch different things. The Forcast catches a slow leak early, and the Actual alert catches a sudden spike the forcast hasnt noticed yet.

# My Daily Admin identity (IAM)
1. Create a user group called Admins and attach AdministratorAccess to the group.
2. I created the IAM user called bennet-admin with console access and a strong password then added it to Admins group. I dint attach any poliicies directly to the user.
3. I signed  out of root, signed in as bennet-admmin, and assigned the MFA straight away. I also used bennet-dev as my alias

Why a group: permissions follow roles in the team, not individuals. When a second engineer joins, you add them to the Admis, when someone leaves, you remove them. So that way nothing has to be audited user by user.

And also, AdministratorAccee is broader than least privilege. For a learning account where I am the only engineer its an acceptable trade-off. But in a company, i will get a narrower permission set from my platform team.

# CLI without access keys.
1. I will check if the old creditials are still in here.
 1 Environment variables: any AWS_ lines here?
* Get-ChildItem Env: | Where-Object Name -like "AWS*"
 2 & 3. What's in the files?
* Get-Content $HOME\.aws\credentials
* Get-Content $HOME\.aws\config

 Which profiles exist, and where would the CLI get credentials from right now?
* aws configure list-profiles
* aws configure list

2. Now i will remove the creditials 
# Delete the credentials file (it only held access keys, which we no longer use)
* Remove-Item $HOME\.aws\credentials

 If step 1 showed AWS_ environment variables, remove them permanently:
[Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", $null, "User")
[Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", $null, "User")

3. Verify if they are still in place
* aws sts get-caller-identity

# CLI configurations without access keys.
1. I ran aws --version to ensure that i am using a version higher than 2.32.0
2. ran aws login --profile learning, and chose us-east-1 then i signed in as bennet-admin in the same browser that i had a console session.
3. i ran aws sts get-caller-identity --profile learning to confirm everything is working

Why this is better: CLI receives temporary creditials that rotate every 15 minutes and expire after at most 12 hours. There's nothing to leak to GitHub, because nothing permanent exists


