🌐 Static Portfolio Website on AWS using Terraform
This project demonstrates how to deploy a static portfolio website to AWS S3 using Terraform. It automates the provisioning of infrastructure and makes the website publicly accessible via a generated S3 URL.

🚀 Project Overview
Infrastructure as Code (IaC) using Terraform
Static website hosting on AWS S3
Public URL generation for easy access

🛠️ Technologies Used
Terraform – Infrastructure provisioning
AWS S3 – Static website hosting
GitHub – Version control and project sharing
HTML – Static website content


⚙️ How to Use
1. Clone the Repository
   
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

2. Configure your aws environment using AWS Configure 

3. Initialize Terraform using terraform init command

4. Apply the Configuration


Confirm the action when prompted. Terraform will create the S3 bucket and upload your website files.

4. Access the Website
After deployment, Terraform will output the public URL of your hosted portfolio. Open it in your browser to view your site.

🌍 Example Output
Website URL: http://your-bucket-name.s3-website-region.amazonaws.com

🧹 Clean Up Using terraform destroy

To destroy the infrastructure and avoid incurring AWS charges:

