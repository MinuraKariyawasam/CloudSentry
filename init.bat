@echo off
echo Installing Az CLI...
curl -sL https://aka.ms/InstallAzureCLIDeb
echo Az CLI installation complete.

@echo off
echo Installing Node modules...
start npm install
echo Node modules installation complete.

@echo off
echo Installing Terraform...
curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_windows_amd64.zip
Expand-Archive terraform.zip -DestinationPath C:\terraform
setx /M PATH "%PATH%;C:\terraform"
echo Terraform installation complete.

@echo off
echo Starting CloudSentry...
start npm start
echo receving localhost:3000/login