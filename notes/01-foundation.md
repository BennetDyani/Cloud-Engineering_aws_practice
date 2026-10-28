Questions & Anwers for the AWS setup

1. Why is leaked access key worse than leacked aws login session?
# A leaked access key is permenant, once someone gets their hands on it they have it forever, but a login session will expire in 12hours and getting a new one will require a password and MFA.
# A stolen key needs niether, and it works untill someone notices and deletes it.

2. Your admin user and the ECS service you will build later both need AWS permissios. Why does a person get a user here, but services gets role?
# A person gets a usuer because they can keep a secret safe. In this instance, the password and MFA can only be kept pysically on the person (password in their heads and MFA device can be thier phone) therefore no one can get it from them remotely.
# A service getys a  role because it cant keep a secret without storing it in a file somewhere it can be able to read. And the danger is that once someone else gets their hands on that file, they permenantly have the secret. 
# A role gives the service temporary creditials that AWS delivers and roatates, with nothing to store. 

* Anology
# Part 1: You at CPUT = an IAM user
At CPUT	In AWS	Why it matches
Your student number	Your username / ARN	It identifies you, but it isn’t secret. Lecturers and classmates know it.
Your password + Microsoft Authenticator	Password + MFA	Only you know or hold them, and you need both to sign in.
Being a 2nd-year Diploma IT student	Being in the Admins group	You get Blackboard access to your modules because of the group you’re in, not because someone set it up for you personally. When you graduate, you leave the group and the access goes with it.
What you can do once signed in (view results, load printing credits)	The policy	You can view your results, but you can’t edit marks. The rules decide what’s allowed.
Your student card opening only the gates	A narrow, single-purpose permission	It grants exactly one thing. That’s least privilege in plastic form.
Part 2: The campus printer = a service that needs a role

When you print, the printer itself has to talk to CPUT’s finance system to deduct your credits. So how does the printer prove it’s allowed to do that?

The bad way (a user with an access key): IT types a staff member’s username and password into the printer’s settings. Now that password is stored inside the machine. Anyone who opens the settings menu, any technician repairing it, or anyone who copies its configuration has a staff login. It works for everything that staff member can do, and it keeps working until someone notices.

The right way (a role): IT creates a “Print Billing” role:

Trust policy: “only printers registered on the campus network may use this role.” That’s the Principal = ec2.amazonaws.com line, but for printers.
Permissions policy: “may deduct printing credits.” That’s all. It can’t view results, can’t change marks, and can’t open the gates.
Temporary credentials: each morning when the printer starts up, the system gives it a pass that expires that night. There’s no password stored in the printer, so there’s nothing to steal from it. If someone carried the printer off campus, it would no longer be a registered campus printer, and the next pass would never be issued.

# The core idea: you can keep a secret, because it lives in your head and on your phone. A printer can’t keep a secret, because anything it “knows” is written into it somewhere. So people get users and machines get roles.


3. Name two tasks that genuanely requre root.
# Deleting and Account and changing the support plan. 
# Changing the root email or password, and restoring access if you accidentally lock every admin out of IAM