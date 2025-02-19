# Phase - I

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/60d474f0-0d0e-4391-9791-3015d08b8347)

# Phase - II

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/e83cee73-4397-4b3b-9201-b6f2119c2d31)


### Title: "Automated Data Pipeline for Spotify: Extracting, Transforming, and Analyzing Music Data Using AWS Lambda, S3, Glue, and Athena"

The project aims to develop an end-to-end data pipeline for extracting, transforming, and analyzing data from the Spotify API. Leveraging AWS services such as Lambda, S3, Glue, Athena, and Terraform, the pipeline automates the extraction of data, transformation into structured formats, and enables analytical queries for insights.

### The pipeline consists of three main steps:

#### Data Extraction and Loading:
* Python scripts are developed to interact with the Spotify API, utilizing the client ID and client secret obtained from the Spotify developer app for authentication.

* AWS Lambda functions are utilized to execute the Python scripts. These functions are lightweight, scalable, and can be triggered by various events.

* The scheduling of the Lambda function is managed through AWS CloudWatch Events, leveraging EventBridge's cron notation to trigger the function daily at a specified time.

* Upon execution, the Lambda function retrieves data from the Spotify API by making authenticated requests using the client ID and client secret.
* The retrieved data is stored in JSON format within an S3 landing folder.
* Integration of the client ID and client secret ensures secure communication between the Lambda function and the Spotify API, enabling the retrieval of desired data while adhering to authentication protocols.
* AWS IAM roles are configured to grant necessary permissions for the Lambda function to access the Spotify API and write data to the S3 bucket.

#### Data Transformation:
* After the raw data is extracted from the Spotify API and stored in the S3 landing folder, it undergoes transformation to prepare it for analysis.

* A dedicated AWS Lambda function is triggered by S3 Put Object events, ensuring immediate processing of newly arrived data.

* Upon triggering, the Lambda function parses the JSON files containing Spotify data and structures it into three distinct categories: albums, songs, and artists.

* For each category, the Lambda function converts the structured data into a standardized format, typically CSV, to facilitate efficient querying and analysis.

* Transformation involves cleaning and formatting the data, handling any inconsistencies or missing values, and ensuring uniformity across records.

* Once transformed, the data is organized into separate S3 folders for each category, maintaining a well-organized data hierarchy for downstream processing and storage.

* AWS IAM roles are configured to grant necessary permissions for the Lambda function to access the transformed data in the S3 buckets.

#### Data Cataloging and Analytics: 
* Upon successful transformation, the structured data is ready for cataloging and analysis.
AWS Glue, a fully managed ETL service, is leveraged to automatically catalog the transformed data stored in the S3 folders.

* Glue crawlers are configured to traverse the S3 directories containing the transformed data and infer the schema of the CSV files.

* These crawlers detect the structure of the data and create corresponding tables in the Glue Data Catalog, a centralized metadata repository.

* The Glue Data Catalog provides a unified view of the data, including table definitions, column types, and partitioning information, facilitating easy access and management of the datasets.

* With the data cataloged, Amazon Athena, a serverless interactive query service, is utilized to execute SQL queries against the Glue tables.

* Athena enables ad-hoc querying and analysis of the cataloged data using standard SQL syntax, without the need for managing infrastructure.

* Users can run analytical queries to extract insights, generate reports, and perform data exploration directly on the cataloged datasets.

* Athena integrates seamlessly with other AWS services, allowing for data visualization and further processing using tools like Amazon QuickSight or custom dashboards.



#### IInfrastructure as Code (IaC) Approach:
* Infrastructure as Code (IaC) is a methodology that enables the management and provisioning of infrastructure using code rather than manual processes.

* In this project, IaC principles are adopted to automate the provisioning and configuration of various AWS resources required for the data pipeline.
* Terraform, an open-source infrastructure provisioning tool, is selected as the primary tool for implementing the IaC approach.
* Terraform templates, written in HashiCorp Configuration Language (HCL), define the desired state of the infrastructure components.
* The Terraform templates specify the configuration of AWS resources such as S3 buckets, Lambda functions, CloudWatch events, Glue crawlers, and Glue catalog database.
* Using Terraform, infrastructure changes are managed declaratively, meaning the desired state of the infrastructure is defined in the Terraform configuration files, and Terraform ensures that the actual state matches the desired state.
* Terraform facilitates consistent and reproducible infrastructure deployments across different environments (e.g., development, staging, production), reducing the risk of configuration drift and ensuring environment parity.
* Version control systems such as Git are utilized to track changes to the Terraform codebase, enabling collaboration among team members and providing a history of infrastructure modifications.
* Continuous Integration/Continuous Deployment (CI/CD) pipelines may be integrated with Terraform to automate the deployment process, enabling rapid and reliable infrastructure updates.
* Infrastructure changes can be previewed and tested in isolated environments before being applied to production, ensuring stability and minimizing disruptions.
Overall, the IaC approach using Terraform enhances scalability, reliability, and maintainability of the data pipeline infrastructure, enabling efficient management of AWS resources throughout their lifecycle.

#### Terraform Custom Modules:

These custom Terraform modules are designed with a focus on reusability, allowing them to be utilized across the enterprise ecosystem. By simply passing input arguments to the custom modules, teams can provision infrastructure tailored to their specific needs without reinventing the wheel. Whether deploying S3 buckets with multiple keys, configuring Lambda functions with various event triggers, or provisioning AWS Glue catalog databases and crawlers, these modular components streamline the infrastructure provisioning process and promote consistency and standardization across projects. This approach enables teams to leverage pre-built infrastructure templates, reducing time-to-market and enhancing collaboration and knowledge sharing within the organization



## Installation

### Terraform installation

##### On Amazon Linux

```sh
sudo yum install -y yum-utils
```
```sh
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```
```sh
sudo yum -y install terraform
```
#### Verify the installation

```sh
terraform --version
terraform -help
```

### AWS CLI installation

```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
#### Verify the installation

```sh
aws --version
```

#### configure aws credentials: provide access key and secret access key

```sh
aws configure
```
    


# Deployement - Provision S3 Bucket
#### Lets verify if we already have the bucket that we want to provision

```sh
aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | grep "spotify"
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/9610ec90-b241-42bb-b8a0-64e468ece42f)

#### Provision the S3 bucket and multiple folders using Terraform custom S3 Module
```sh
cd spotify-analytics-on-aws-athena/provision-s3/
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/7a487670-52ab-4e1c-b209-94bdc60f196b)

#### Initiate the Terraform
```sh
terraform init
```
#### Create S3 bucket with input args with the help of a custom s3 module
```sh
terraform plan
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/bd3e7fd7-0406-46fd-826b-15309f77898f)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/4371985a-7d12-41cf-931e-16639e61881f)
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/a2eda09f-8bf5-45b2-b988-f8c207504e8b)

#### Provision AWS resources
```sh
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/ccbf82ad-33cb-48cf-9c96-5b11a437c1dd)

#### Verify the bucket and folders created
```sh
aws s3api list-buckets --query 'Buckets[*].[Name]' --output text | grep "spotify"
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/b794afa1-7d83-4163-b74f-3777138cab4a)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/9da872d6-0012-4100-bf31-20e931f39d6c)


# Deployement - Provision TWO Lambda Functions to Extract RAW Data and Transform, Load the data to S3
#### Verify if we have any functions.

```sh
aws lambda list-functions
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/7df83d05-a1aa-4b9a-8bf4-c0ca724a9815)

#### Provision lambda functions one with CloudWatch event and other one with s3 event
```sh
cd spotify-analytics-on-aws-athena/provision-lambda/
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/b0553a43-4b3c-4562-bc7b-89b567959c9b)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/6b3bdd38-366c-49a0-9f72-11fef798ca25)


#### Initiate the Terraform
```sh
terraform init
```
#### Create lambda functions with a custom lambda module
```sh
terraform plan
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/a97f1515-dc17-4bd9-8bd2-2f3efe49f6e4)

#### Provision AWS resources
```sh
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/37c03913-1861-48b6-be7d-d913925d7075)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/05e4aee7-e36c-482b-b928-c17f6c707eae)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/bf43ec6f-1695-43dd-b176-2dddf867ae6b)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/b3774dc1-1527-41a0-80d4-fd59c362c5bc)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/70278a61-f06f-4e68-8758-64b616e0ca29)

## We now have both the lambda functions working. files coming to the landing folder are transformed and sent to albums, songs, and artists folders. Once Processing is done, they are archived.
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/ce1c4ba1-2170-4164-a735-fcb61ba06ad9)


# Deployement - Provision Glue Crawlers, Glue Triggers, Glue Catalog Databases and Glue catalog Tables
#### Verify if we have any of them
```sh
aws glue list-crawlers
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/faedd966-59bb-4710-adc4-4ce6d27f58c8)

```sh
aws glue list-triggers
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/277148f9-c1a8-43f8-8b9a-d6af2db183f9)

```sh
aws glue get-databases
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/0ad6ae57-e2db-46e4-ba2f-d87cc4c9a25f)

```sh
aws glue get-tables --database-name your-database-name
```
#### Initiate the Terraform
```sh
terraform init
```
#### Plan the resources
```sh
terraform plan
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/7e147026-dbb5-41c4-bf62-137e90e896b2)

#### Provisioning
```sh
terraform apply
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/45902fc4-b89b-4940-bc41-ba62221cb06d)

#### Verify

```sh
aws glue list-crawlers
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/41807836-e252-4f78-812d-3996916d0c5b)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/1968ac38-3a4a-4f86-b0b7-f279f2dd564c)


```sh
aws glue list-triggers
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/911ebbdd-bc67-47db-a324-890207271622)

```sh
aws glue get-databases
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/c4289073-458e-4707-9097-4cfbf834cf6c)
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/2501dbd2-1d2f-443c-b108-097660811fc0)

### Crawlers Running
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/fa80152d-de8d-4e42-a09d-05369f88436d)

### Crawlers ran and Succeeded

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/0b9118a7-e871-4f87-94ec-1f0d5a7a0e16)

```sh
aws glue get-tables --database-name spotify_analytics --query 'TableList[*].Name'
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/531d2ee5-ac00-481b-9b73-9ce5dce2d054)

![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/e3440203-f8cb-49a8-8892-d52af01418e3)

# Destroy
```sh
terraform destroy
```
![image](https://github.com/KiranGunturu/lakehouse-formation/assets/91672788/9453e277-544d-4bbe-9784-8292e0f84761)














