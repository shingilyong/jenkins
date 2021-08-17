bastion 접속
 - ssh -i ~/.ssh/private-key/samsung-bastion-key.pem ubuntu@3.113.26.200 

master 접속
 - bastion 접속
 - ssh -i ~/.ssh/samsung-priv-key.pem ubuntu@master1

Nginx proxy
 - $ cat /etc/nginx/nginx.conf

Jenkins
 - 3.113.26.200:32000
 - admin
 - kuberix1234@#$

Harbor
 - https://3.113.26.200:32002
 - admin
 - Kuberix1234@#$