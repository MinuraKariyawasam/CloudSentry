echo Installing Az CLI...
curl -L https://aka.ms/InstallAzureCliWindows -o AzureCLI.msi
call msiexec /i AzureCLI.msi
echo Az CLI installation complete.

echo Installing Node modules...
call npm install
echo Node modules installation complete.

echo Installing Terraform...
curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_windows_amd64.zip
Expand-Archive terraform.zip -DestinationPath C:\terraform
setx /M PATH "%PATH%;C:\terraform"
echo Terraform installation complete.

echo Starting CloudSentry...
echo receiving localhost:3000/login
call npm start
