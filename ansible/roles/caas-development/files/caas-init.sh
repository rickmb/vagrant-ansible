#!/bin/bash

# If a path is passed, go there, like a good little doggy
if [ -n "$1" ]; then
    cd "$1"
fi

CANARY="web/app.php"

if [ ! -f "$CANARY" ]; then
    echo #
    echo "Whoa Nelly !!"
    echo "Can't find $CANARY. CaaS isn't where I think it is..."
    echo "Either pass the root of CaaS as the one and only paramater, or just go there."
    echo #
    echo "Example: $0 /data/vhosts/current"
    echo #
    exit 1
fi

if [ ! -d web/media/upload ]; then
    mkdir web/media/upload
fi

for dir in sites/*/; do 
    if [ ! -d "$dir"/cache ]; then
        mkdir "$dir"/cache
    fi
    if [ ! -d "$dir"/logs ]; then
        mkdir "$dir"/logs
    fi
done 

APACHE_DIRS="sites/*/cache sites/*/logs web/media web/widget_cache"
APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd' | grep -v root | head -1 | cut -d\  -f1`

echo "Trying multiple ways of making dirs webserver writeable"
echo "...Trying chmod +a"
sudo chmod -Rf +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" $APACHE_DIRS >/dev/null 2>&1
if [ "$?" = "0" ]; then
    sudo chmod -Rf +a "$APACHEUSER allow delete,write,append,file_inherit,directory_inherit" $APACHE_DIRS
    echo "...Yeah, that worked!"
else
    echo "...Nope, no luck, trying ACL"
    sudo setfacl -R -m u:$APACHEUSER:rwx -m u:`whoami`:rwx $APACHE_DIRS >/dev/null 2>&1
    if [ "$?" = "0" ]; then
        sudo setfacl -dR -m u:$APACHEUSER:rwx -m u:`whoami`:rwx $APACHE_DIRS
        echo "...Yeah, that worked!"
    else
        echo "...Seriously, why do I even bother?"
        echo "...Failing everything else, just making all relevant dirs owner $APACHEUSER"
        sudo chown -R $APACHEUSER $APACHE_DIRS
        if [ "$?" = "0" ]; then
            echo "...Yeah, that worked!"
        else
            echo "...You have got to be kidding me!"
            echo "...Okay, this may happen on an NFS share or some shit like that."
            echo "...Now we're just going all out world-writable. Fuck security."
            sudo chmod -R 777 $APACHE_DIRS
        fi
    fi
fi

# Composer will crash at the end if there is no valid parameters.yml for core
if [ ! -f sites/core/config/parameters.yml ]; then
    cp app/config/parameters.dist.yml sites/core/config/parameters.yml
fi

./bin/composer.phar install --dev 
# --prefer-source
# Add the prefer-source option if this fails. Github packages tend to be b0rken.
