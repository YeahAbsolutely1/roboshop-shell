source common.sh

print_head "Install Nginx"
dnf install nginx -y  &>>${LOG}
status_check

print_head "Remove Default Nginx Content"
rm -rf /usr/share/nginx/html/*  &>>${LOG}
status_check

print_head "Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${LOG}
status_check

cd /usr/share/nginx/html  &>>${LOG}

print_head "Extract Nginx Content"
unzip /tmp/frontend.zip  &>>${LOG}
status_check

print_head "Copy Nginx Roboshop Config File"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>${LOG}
status_check

print_head "Enable Nginx"
systemctl enable nginx  &>>${LOG}
status_check

print_head "Start Nginx"
systemctl restart nginx  &>>${LOG}
status_check