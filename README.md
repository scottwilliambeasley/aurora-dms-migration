# Aurora DMS Migration Tool

A Terragrunt template for streamlining SQL migrations to Aurora DB via Amazon DMS.

Use this to establish your replication instance, and your source and destination endpoints within AWS.

After establishing these, you can use the AWS Console to convert the schema from source to destination (using the DMS Migration Project Tool), and create the migration task to finish replication.

## Why Terragrunt and not simply Terraform?

While Terragrunt is useful as an IaC tool, Terraform alone presents the following problems:
- it is difficult to reuse code across multiple deployments
- it is not easy to automatically inject values into them according to region and environment.
- defining dependencies between multiple different Terraform deployment targets can get complicated

Terragrunt solves all of these problems and more.

How?

Terragrunt does the following things:
- allows the same Terraform code to be injected uniformly across as many separate deployments as you want
- allows prepoluated configuration files (known as local files) containing variables to be automatically injected into deployments.
- allows for dependencies to be defined between different deployment targets

For the purposes of this project, we can manage all our Terraform deployments across all environments and customize each deployment using a set of configuration files.

## Prerequisites and Expectations

Both Terraform and Terragrunt must be installed on the system.

Installation of these tools is out of scope of this guide.

While not a hard prerequisite, in order to most effectively know how to work with this tool, one must have prior knowledge of both Terraform and Terragrunt.

This template expects that you already have an established VPC and subnet within the account to be used as the network infrastructure that will host the DMS migration instance.

Furthermore, it expects you to know the login details of the source and destination servers in order to establish replication between them. Don't bother using this if you don't know what or where you are migrating data to or from, solve these questions first.

## How do I use this?

1. Clone this project.
2. Configure the template according to your desired region and environment.
3. Configure the values within the .hcl local files to customize your DMS deployment.
4. Deploy the configured template.
5. Complete the DMS migration process.

Note that as the target for this is Aurora DB, you likely are going to have to translate stored procedures etc manually as DMS cannot do this automatically for you.

## How is this template structured?

This template leverages the following file/folder structure:

```
/
|-- common.hcl (a configuration file containing variables used by all deployments)
|-- git.hcl (a configuration file containing variables specific to git. used by all deployments in the context of CI/CD )
|-- terragrunt.hcl (top level configuration file)
|-- modules/ (where your individual Terraform modules go)
|-- regions/ 
    |-- $REGION/ (e.g 'us-east-1')
        |-- region.hcl (a configuration file containing variables used by all deployments of the same region)
        |-- $ENVIRONMENT (an environment name, like 'dev' or 'prod')
            |-- environment.hcl (a configuration file containing variables for all deployments of the same environment)
            |-- $DEPLOYMENT_TARGET ( a named set of Terraform resources such as 'api_gateway' or 'network_infra'. These may be used as dependencies by other deployment targets )
                |-- terragrunt.hcl ( Terragrunt code defining Terraform modules to deploy, what values to inject into them, and dependencies between deployments)
```

### Step 1: Cloning the project

Copy the URI of this project and run `git clone $URI` against it.

You should now have a local copy of the project.

## Step 2: Configuration the Template

If your target deployment region is 'us-east-2' , and your target environment is 'dev' skip this step.

Otherwise, rename the 'us-east-2' folder to be the correct region, and modify region.hcl inside of it to hold the same name.

Accordingly, modify the name of the 'dev' folder to be the name of the environment you are attempting to replicate into. Modify the environment_name variable inside of env.hcl.

## Step 3: Configuring the .hcl files

Open env.hcl inside of your desired environment folder.

Populate each value inside of it.

This includes things such as your target VPC and subnet IDs, and your DMS source and destination endpoint values. 

Note that this template expects that you have an existing VPC and pair of subnets to be used as your replication instance subnet group.

## Step 4: Deploy the template

1. `cd` into the environment folder you're attempting to deploy resources into. .e.g. `cd regions/us-east-2/dev`

2. Ensure that your shell is populated with environment variables used to programmatically access AWS, and that these are exported to child processes.

e.g. 

```
# Note: these credentials are obviously fake AF and only used for illustration purposes
export AWS_ACCESS_KEY_ID=ASIATS2CVMTP4BN4FXYJ
export AWS_SECRET_ACCESS_KEY=g8SQRJpmL7fbdTkjt9/bvxbGscnTKzX7glt4we6W
export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEKb//////////wEaCXVzLWVhc3QtMSJHMEUCIQDDsYxFMtXpEzY1R9q/hqG0+sgNTUW46BfusJ77AOF2IwIgN7PZ3ZOA4yXtVPgsJj6skrYtZTakG6nv4PUCx/oekSQqsQMIv///////////ARABGgwyNDY1NjM1NjI3MTkiDGDeDAURhMvYmDOEuCqFA+Kl81IjRNCVQRcFbdYIIiDfTt1cymR0JQFKPUixFd4EtXtba90Fez+PWv7HU1C6GT+JrL3ZjCiO0qFwG8fnhG0eylwLMAZdKUAfoDaBZasDXgHmhtHq0tXURkD4bpnynI5LPO5JvX3PKFHOYM4cpz2Pq1X6ZCZpTN1NrQKitEDCMfN5TMLAKXS0+Xi+z51/y9nLyPGMA27ClShrmTCIRab8YppmXp3G/4wanzuXOdnea6z7kQvL5ojcDYijI1NPfICYPAsT3/hRhgmXOI6H202jrDx2ZQ1VMnFcl7/Nqdf/Rrmj43qRN8D8aNxBv3ZqC2XdaczGjOV+ABnINLjakdFUtFO8ECPsu/flice5LFzOYqPlxkr3D06hqhVRXsfd8u1DD08pc2yScxpMYXSjdorBiZriuK7DRAkrz/d4E9pbAnsCdZ4Puo/XPukPvYZ8OCOQEuPYyFDDoDk3EoSmZbD5xkOQ5z5NAlsZCPDd6leQh71hFOgUHKBsCdKZw6laSRQoNq91MIqirZwGOt0B+HfeB/7atpz3+RouwfQSSrDGK9o6hiXvSLWg9hi4Oi9LPevWU8kiYzujXixN64Qwn/+gPMmqwYJf8vBd55PCJkOFm7Tew46tWJsJtixqx7bHQ7pcIWShAUJaO/rOIwvCFRyhzJ/3Q/pIunFYjHWJtcHdHkZN0tEomorj5bL0kXisHjbSoF52GXk80HZDarLap9KlND9W80Efyevw7Vu+uzUqZBguyTrmA8eSvIyn+/oKbzwyRdVE/v8nvRaP0noTD1UH/7Ps9tUqEtR/85K1HooGadVriCg2Z59QqAU=
```

3. Run `terragrunt run-all apply`

4. Follow the prompts, wait for Terraform to do its thing.

## Step 5: Complete the DMS Migration Process (Manual Steps)

1. Use the Migration Project tool to convert the source SQL schema + prepared statements into the database configuration of your Aurora instance. This cannot be automated and must be done manually.

2. Create the database migration task.

3. Wait for replication to finish.

4. ???

5. Profit!!!