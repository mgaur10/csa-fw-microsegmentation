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

resource "random_password" "db_user_password" {
  length      = 15
  min_lower   = 3
  min_numeric = 3
  min_special = 5
  min_upper   = 3
  depends_on  = [time_sleep.wait_enable_service_api]
}


resource "random_password" "db_user_name" {
  length    = 8
  min_lower = 8

  depends_on = [time_sleep.wait_enable_service_api]
}


resource "google_secret_manager_secret" "sql_db_user_password" {
  project   = var.microseg_project_id
  secret_id = "sql-db-password"
  replication {
    automatic = true
  }
  depends_on = [time_sleep.wait_enable_service_api]
}


resource "google_secret_manager_secret_version" "sql_db_user_password" {
  secret      = google_secret_manager_secret.sql_db_user_password.id
  secret_data = "M1cr0segmentSQL!"
  #random_password.db_user_password.result
  depends_on = [time_sleep.wait_enable_service_api]
}

/*
data "google_compute_default_service_account" "default" {
    project  = var.microseg_project_id
     depends_on = [time_sleep.wait_enable_service_api]
}


resource "google_secret_manager_secret_iam_member" "identity_password_access" {
#  for_each  = var.proxy_access_identities
  project  = var.microseg_project_id
  member    = "serviceAccount:${data.google_compute_default_service_account.default.email}"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.sql_db_user_password.id
}
*/