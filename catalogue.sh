script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Configuring NodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m Installing NodeJs\e[0m"
yum install nodejs -y  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m Adding Virtual Application User\e[0m"
useradd roboshop  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

mkdir -p /app  &>>${LOG}

echo -e "\e[35m Downloading Catalogue Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m Removing Previous Content\e[0m"
rm -rf /app/*  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

cd /app  &>>${LOG}

echo -e "\e[35m Extracting NodeJS Content\e[0m"
unzip /tmp/catalogue.zip  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

cd /app

echo -e "\e[35m Installing NodeJS Dependencies\e[0m"
npm install  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m Copying Catalogue App Content\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m daemon-reload\e[0m"
systemctl daemon-reload  &>>${LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m Enable Catalogue\e[0m"
systemctl enable catalogue  &>>{$LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35m Start Catalogue\e[0m"
systemctl start catalogue  &>>{$LOG}
if [ $? -eq 0 ] then;
   echo SUCCSESS
 else
   echo FAILURE
fi

echo -e "\e[35mConfiuring Mongo Repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

echo -e "\e[35m Installing Mongo-client\e[0m"
dnf install mongodb-org-shell -y  &>>{$LOG}
if [ $? -eq 0 ] then;
  echo SUCCSESS
else
  echo FAILURE
fi

echo -e "\e[35m Load Schema\e[0m"
mongo --host mongodb-dev.perfectandupright.online </app/schema/catalogue.js  &>>{$LOG}