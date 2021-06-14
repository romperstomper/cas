#!/bin/bash
cd /tmp/appname
pg_ctl start &
rake db:create
bin/rails s --binding=0.0.0.0
