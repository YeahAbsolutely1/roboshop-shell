source common.sh

print_head "Configuring NodeJs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
status_check

print_head "Install NodeJs"
yum install nodejs -y  &>>${LOG}
status_check

print_head "Adding Virtual Application User"
id roboshop &>>${LOG}
if [ $? -ne 0 ]
then
useradd roboshop  &>>${LOG}
fi
status_check

mkdir -p /app  &>>${LOG}

print_head "Downloading Catalogue Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${LOG}
status_check

print_head "Cleanup Old Content"
rm -rf /app/*  &>>${LOG}
status_check

cd /app  &>>${LOG}

print_head "Extracting App Content"
unzip /tmp/catalogue.zip  &>>${LOG}
status_check

cd /app

print_head "Installing NodeJs Dependencies"
npm install  &>>${LOG}
status_check

print_head "Configuring Catalogue Service File"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service  &>>${LOG}
status_check

print_head "Daemon Reload"
systemctl daemon-reload  &>>${LOG}
status_check

print_head "Enable Catalogue"
systemctl enable catalogue  &>>${LOG}
status_check

print_head "Start Catalogue"
systemctl start catalogue  &>>${LOG}
status_check

print_head "Configuring Mongo Repos"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
status_check

print_head "Installing Mongo Client"
dnf install mongodb-org-shell -y  &>>${LOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.perfectandupright.online </app/schema/catalogue.js  &>>${LOG}
status_check
