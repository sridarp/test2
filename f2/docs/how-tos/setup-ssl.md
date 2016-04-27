# Setup Jellyfish to use SSL

This guide will walk you through how to setup Jellyfish to use SSL.  This is
done by using Nginx as a reverse proxy / SSL gateway.


##### Install Nginx
Please install Nginx via Nginx documented process.

##### Configure Nginx
Delete the default site config

```
sudo rm /etc/nginx/conf.d/default.conf
```

##### Create `jellyfish-api.conf`
```
sudo vi /etc/nginx/conf.d/jellyfish-api.conf
```

##### File contents for `jellyfish-api.conf`
Replace `JELLYFISH_URL` in the contents below before saving

```
upstream myapp_puma {
  server unix:///tmp/myapp_puma.sock;
}

server {
  listen  80;
  root /home/jellyfish/api/public;

  location / {
        #all requests are sent to the UNIX socket
        proxy_pass http://JELLYFISH_URL;
        proxy_redirect     off;

        proxy_set_header   Host             $host:$proxy_port;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;

        client_max_body_size       10m;
        client_body_buffer_size    128k;

        proxy_connect_timeout      90;
        proxy_send_timeout         90;
        proxy_read_timeout         90;

        proxy_buffer_size          4k;
        proxy_buffers              4 32k;
        proxy_busy_buffers_size    64k;
        proxy_temp_file_write_size 64k;
  }
}
```

##### Restart Nginx
```
sudo /etc/init.d/nginx restart
```

##### Start API
```
cd /home/jellyfish/api
bundle exec puma -e production -d -b unix:///tmp/myapp_puma.sock
```

#### Upkeep Rake Tasks
The following rake commands need to be executed to maintain Jellyfish Core.

```
# Updates the budgets for projects
rake upkeep:update_budgets

# Run the delayed job workers (this is what processes the orders to the various systems
rake jobs:work
```


Copyright 2015 Booz Allen Hamilton
