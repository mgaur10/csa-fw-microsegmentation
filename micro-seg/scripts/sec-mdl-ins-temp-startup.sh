##  Copyright 2023 Google LLC
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      https://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.


##  This code creates demo environment for CSA Network Firewall microsegmentation 
##  This demo code is not built for production workload ##

#! /bin/bash
cat <<EOF > /etc/apt/sources.list
deb https://packages.cloud.google.com/apt debian-bullseye-mirror main
deb https://packages.cloud.google.com/apt debian-bullseye-security-mirror main
deb https://packages.cloud.google.com/apt debian-bullseye-updates-mirror main
EOF
apt update
apt -y install apache2
apt -y install libapache2-mod-php
apt -y install php-mysqli
service apache2 reload
cat <<EOF > /var/www/html/api.php
<?php

header("Content-Type:application/json");

# connect to MySQL DB:
# Can we use DNS to address the DB??? 
\$con = mysqli_connect("hr_pplapp_us-west1_sqldb-microseg.microseg.private","root","M1cr0segmentSQL!","mydb");
if (mysqli_connect_errno()) {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  die();
}

# query MySQL DB
\$result = mysqli_query(\$con, "SELECT * FROM characters");
while(\$row = mysqli_fetch_array(\$result)) {
  \$id = \$row['id'];
  \$response[\$id]['name'] = \$row['name'];
  \$response[\$id]['performance'] = \$row['performance'];
}
mysqli_close(\$con);

# Respond to the API request
\$json_response = json_encode(\$response);
echo \$json_response;

?>
EOF
