source common.sh

print_head "Disable MySQL default module"
dnf module disable mysql -y  &>>${LOG}
status_check

print_head "Copy MySQL Repo File"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install MySQL"
dnf install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable MySQL"
systemctl enable mysql &>>${LOG}
status_check

print_head "Start MySQL"
systemctl restart mysql &>>${LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${LOG}
status_check