#!/bin/bash
sudo apt update
sudo apt-get install -y git python3-virtualenv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind virtualenv
sudo apt-get install -y apt-transport-https
sudo apt-get install -y python3.10-venv
sudo apt install -y openjdk-8-jre-headless
sudo export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt update && sudo apt install -y elasticsearch kibana logstash

#Configuration logstash
sudo echo -e 'input {
       stdin {
            type => "stdin-type"
       }
       file {
              path => ["/home/cowrie/cowrie/var/log/cowrie/cowrie.json"]
              codec => json
              type => "cowrie"
              start_position => "beginning"
       }
}

filter {
    if [type] == "cowrie" {
        json {
	        source => message
            target => honeypot
	}

        date {
            match => [ "timestamp", "ISO8601" ]
        }

        if [src_ip]  {

            mutate {
                add_field => { "src_host" => "%{src_ip}" }
            }

            dns {
                reverse => [ "src_host" ]
                nameserver => [ "8.8.8.8", "8.8.4.4" ]
                action => "replace"
                hit_cache_size => 4096
                hit_cache_ttl => 900
                failed_cache_size => 512
                failed_cache_ttl => 900
            }
        }

        mutate {
	        # cut out useless tags/fields
            remove_tag => [ "beats_input_codec_plain_applied"]
	        remove_field => [ "[log][file][path]", "[log][offset]" ]
        }
    }
}

output {
    if [type] == "cowrie" {
        elasticsearch {
            hosts => "localhost:9200"
        }
        file {
            path => "/tmp/cowrie-logstash.log"
            codec => json
        }
        stdout {
            codec => rubydebug
        }
    }
}' > logstash-cowrie.conf
sudo mv logstash-cowrie.conf /etc/logstash/conf.d/logstash-cowrie.conf

#Configuration kibana
sudo awk '/#server.host: "localhost"/ {$0="server.host: \"0.0.0.0\""}'1 /etc/kibana/kibana.yml > temp && sudo mv temp /etc/kibana/kibana.yml

#Install cowrie
sudo adduser cowrie --gecos "" --disabled-password
sudo su - cowrie bash -c "git clone http://github.com/cowrie/cowrie.git && cd cowrie && python3 -m venv cowrie-env && . cowrie-env/bin/activate && python3 -m pip install --upgrade pip && python3 -m pip install --upgrade -r requirements.txt"
sudo su - cowrie bash -c "echo -e 'vicent:x:1234\nadmin:x:admin\nroot:x:root\nroot:x:toor\nuser:x:qwerty\nmia:x:password' >>  /home/cowrie/cowrie/etc/userdb.txt"
sudo su - cowrie bash -c "echo -e 'vicent:x:1000:1000:Vicent Vega ,,,:/home/vincent:/bin/bash\nadmin:x:1000:1000:admin group ,,,:/home/admin:/bin/bash\nmia:x:1000:1000:Mia Wallace ,,,:/home/mia:/bin/bash' >>  /home/cowrie/cowrie/honeyfs/etc/passwd"
sudo su - cowrie bash -c "echo -e 'vicent:*:15800:0:99999:7:::\nadmin:*:15800:0:99999:7:::\nmia:*:15800:0:99999:7:::' >>  /home/cowrie/cowrie/honeyfs/etc/shadow"
sudo echo -e 'mkdir /etc/apache2\nmkdir /var/www\nmkdir /var/log/apache2\nmkdir /usr/share/doc/apache2\ntouch /etc/apache2/apache2.conf\ntouch /etc/apache2/sites-enabled\ntouch /etc/apache2/sites-available\ntouch /var/www/index.html\ntouch /var/log/apache2/access.log\ntouch /var/log/apache2/error.log\ntouch /usr/share/doc/apache2/doc.txt\nmkdir /home/vicent\nmkdir /home/admin\nmkdir /home/mia\nmkdir /home/user' > script.sh
sudo chmod +x script.sh
sudo su - cowrie bash -c "python3 /home/cowrie/cowrie/bin/fsctl /home/cowrie/cowrie/share/cowrie/fs.pickle" < ./script.sh
sudo su - cowrie bash -c "sed -i 's/guest_tag = ubuntu18.04/guest_tag = ubuntu22.04/g' /home/cowrie/cowrie/etc/cowrie.cfg.dist"
sudo su - cowrie bash -c "sed -i 's/hostname = svr04/hostname = corporationStation02/g' /home/cowrie/cowrie/etc/cowrie.cfg.dist"
sudo su - cowrie bash -c "/home/cowrie/cowrie/bin/cowrie start"

sudo systemctl start elasticsearch.service
sudo systemctl start logstash.service
sudo systemctl start kibana.service 
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash-cowrie.conf