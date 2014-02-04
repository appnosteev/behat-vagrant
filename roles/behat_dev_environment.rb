name "pfizer_behat_dev_environment"
description "A full implementation of pfizer behat environment."
run_list(
  "recipe[curl]",
  "recipe[zip]",
  "recipe[vim]",
  "role[apache2_mod_php]",
  "role[drupal]",
  "role[drupal_dev]",
  "role[memcached]",
  "role[mysql_server]",
  "recipe[drupal::drupal_apps]"
)
