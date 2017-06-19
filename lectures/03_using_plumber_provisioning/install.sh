#! /bin/bash
# create the droplet or ec2 instance
# make sure to add your ssh key
# boot up the instance, ssh in as root
# get and run this code with
# wget ...

# create swap if you have a low memory instance
fallocate -l 4G /swapfile 
chmod 600 /swapfile 
mkswap /swapfile
sudo swapon /swapfile

#fetch all of the R stuff that you need and related libraries
echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get install -y r-base r-base-dev
echo "options(repos=c('http://cran.rstudio.com/'))" > .Rprofile
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install libgit2-dev
sudo apt-get install libssl-dev

# install devtools and development version of plumber
Rscript -e "install.packages('devtools', repos='https://cran.rstudio.com/')"
Rscript -e "devtools::install_github('trestletech/plumber')"


#this is where the plumber scripts go
mkdir -p /var/plumber

## copy over the example, not sure why it's put here and in the /var/plumber/hello directory
# commenting out since I don't think that this is needed
#cp /usr/local/lib/R/site-library/plumber/examples/10-welcome/* /var/plumber/


#install nginx, the web server that plumber works with
sudo apt-get install -y nginx 
rm -f /etc/nginx/sites-enabled/default

mkdir -p /var/certbot
mkdir -p /etc/nginx/sites-available/plumber-apis/

#this is the default nginx config for plumber
cp /usr/local/lib/R/site-library/plumber/server/nginx.conf /etc/nginx/sites-available/plumber
ln -sf /etc/nginx/sites-available/plumber /etc/nginx/sites-enabled/

systemctl reload nginx

ufw allow http
ufw allow ssh 
ufw -f enable

# now going to the ip should show an nginx screen

mkdir /var/plumber/hello
cp /usr/local/lib/R/site-library/plumber/examples/10-welcome/* /var/plumber/hello/
wget https://raw.githubusercontent.com/bcaffo/alexaai/master/lectures/03_using_plumber/servicefile
mv servicefile /etc/systemd/system/plumber-hello.service
systemctl daemon-reload
systemctl start plumber-hello && sleep 1
systemctl restart plumber-hello && sleep 1
systemctl enable plumber-hello

## check the status of the plumber script
systemctl status plumber-hello
## This is what I get from the status command
#● plumber-hello.service - Plumber API
#   Loaded: loaded (/etc/systemd/system/plumber-hello.service; enabled; vendor preset: enabled)
#   Active: active (running) since Mon 2017-06-12 17:41:52 UTC; 9s ago
# Main PID: 10215 (R)
#   CGroup: /system.slice/plumber-hello.service
#           └─10215 /usr/lib/R/bin/exec/R --slave --no-restore -e pr~+~<-~+~plumber::plumb('/var/plumber/hello/plumber.R');~+~pr$run(port=8000)
# DATE/TIME alexaTest systemd[1]: Stopped Plumber API.
# DATE/TIME alexaTest systemd[1]: Started Plumber API.
# DATE/TIME alexaTest Rscript[10215]: Starting server to listen on port 8000

wget https://raw.githubusercontent.com/bcaffo/alexaai/master/lectures/03_using_plumber/conf
mv conf /etc/nginx/sites-available/plumber-apis/hello.conf
systemctl reload nginx





