#!/bin/sh


sysrc -f /etc/rc.conf redis_enable="YES"
service redis start



mkdir /opt
curl -L https://github.com/paperless-ngx/paperless-ngx/releases/download/v2.7.2/paperless-ngx-v2.7.2.tar.xz --output paperless-ngx-v2.7.2.tar.xz
tar -zxf paperless-ngx-v2.7.2.tar.xz
mv paperless-ngx /opt/paperless
pw user add -n paperless -c 'Paperless' -d /opt/paperless -m -s /bin/sh
cd /opt/paperless
chown -R paperless:paperless /opt/paperless


pip install scikit-learn


sed -i "" -e 's/#PAPERLESS_CONSUMER_POLLING/PAPERLESS_CONSUMER_POLLING/' /opt/paperless/paperless.conf
sed -i "" -e 's/#PAPERLESS_DATA_DIR/PAPERLESS_DATA_DIR/' /opt/paperless/paperless.conf
sed -i "" -e  "/PAPERLESS_DATA_DIR/ a\\
PAPERLESS_NLTK_DIR=../data/nltk\
" /opt/paperless/paperless.conf
sed -i "" -e 's/#PAPERLESS_MEDIA_ROOT/PAPERLESS_MEDIA_ROOT/' /opt/paperless/paperless.conf
sed -i "" -e 's/#PAPERLESS_CONSUMPTION_DIR/PAPERLESS_CONSUMPTION_DIR/' /opt/paperless/paperless.conf
sed -i "" -e 's/#PAPERLESS_REDIS/PAPERLESS_REDIS/' /opt/paperless/paperless.conf
sed -i "" -e  "/PAPERLESS_REDIS/ a\\
PAPERLESS_DBENGINE=sqlite\
" /opt/paperless/paperless.conf


sed -i "" -e '/PDF/s/rights="none"/rights="read|write"/' /usr/local/etc/ImageMagick-7/policy.xml


su paperless -c /tmp/paperless_install
sysrc -f /etc/rc.conf paperlessconsumer_enable="YES"
sysrc -f /etc/rc.conf paperlesswebserver_enable="YES"
sysrc -f /etc/rc.conf paperlessscheduler_enable="YES"
sysrc -f /etc/rc.conf paperlesstaskqueue_enable="YES"
service paperlesswebserver start
service paperlessconsumer start
service paperlessscheduler start
service paperlesstaskqueue start

echo "The default username and password for this install is admin for both" >> /root/PLUGIN_INFO
