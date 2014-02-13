# Deploy an example Drupal site.
# TODO Move this to a definition with parameters.
include_recipe "mysql"
include_recipe "drush"
include_recipe "drush_make"

#bash aliases

# Add an admin user to mysql
execute "add-admin-user" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "GRANT ALL PRIVILEGES ON *.* TO 'myadmin'@'localhost' IDENTIFIED BY 'myadmin' WITH GRANT OPTION;" +
      "GRANT ALL PRIVILEGES ON *.* TO 'myadmin'@'%' IDENTIFIED BY 'myadmin' WITH GRANT OPTION;\" " +
      "mysql"
  action :run
end

# TODO: Break this out into a vagrant only cookbook? (name: "drupal-vagrant")
# create a drupal db
execute "add-drupal-db" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE DATABASE drupal;\""
  action :run
  ignore_failure true
end

# drush make a default drupal site example
bash "install-default-drupal-makefile" do
  code <<-EOH
(mkdir -p /vagrant/public/drupal.vbox.local)
  EOH
  not_if { File.exists?("/vagrant/public/drupal.vbox.local/behat_build.make") }
end

# Copy make file to site.
cookbook_file "/vagrant/public/drupal.vbox.local/behat_build.make" do
  source "behat_build.make"
  notifies :restart, resources("service[apache2]"), :delayed
end

# drush make a default drupal site example
bash "install-default-drupal-site" do
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local  
  drush make behat_build.make docroot
  EOH
  not_if { File.exists?("/vagrant/public/drupal.vbox.local/docroot/index.php") }
end

#copy correct behat.yml to behat_editor
cookbook_file "/vagrant/public/drupal.vbox.local/docroot/sites/all/modules/behat_editor/behat/behat.yml" do
  source "behat.yml"
end

# drush make a default drupal site example
bash "install-default-drupal-files-and-ctools-directory" do
  code <<-EOH
    mkdir -p /vagrant/public/drupal.vbox.local/docroot/sites/default/files/ctools/css
    chmod -R 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/files
  EOH
end

cookbook_file "/vagrant/public/drupal.vbox.local/docroot/sites/default/settings.php" do
  source "settings.php"
end

bash "open-files-directory-permissions" do
  code <<-EOH  
  chmod 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/settings.php
  EOH
end

bash "install-drupal" do
  code <<-EOH  
  cd /vagrant/public/drupal.vbox.local/docroot
  drush si --db-url=mysql://root:root@localhost:3306/drupal --account-pass=admin --account-name=admin --site-name=Behat-Vagrant -y 
  EOH
end


#bash "turn-drupal-errors-on" do
#  code <<-EOH  
#  cd /vagrant/public/drupal.vbox.local/docroot
#  drush vset -y error_level 2
#  EOH
#end

# configure the behat software with drush
bash "configure-behat-configure-composer-directories" do
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  mkdir -p /vagrant/public/drupal.vbox.local/docroot/sites/all/modules/contrib/composer_manager/
  mkdir -p /vagrant/public/drupal.vbox.local/docroot/sites/all/vendor/
  EOH
end

bash "configure-drupal-modules" do
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  drush en og jquery_update ctools services libraries views_bulk_operations entity entityreference views features bootstrap devel -y
  drush en module_filter views_ui og_ui -y
  drush dis color update comment contextual dashboard search shortcut overlay -y
  drush vset admin_theme default -y
  EOH
end

bash "really-bad-way-to-copy-directories-into-a-vm" do
  #creates a dummy page (group) else the github editor fails
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  cp -r /vagrant/cookbooks/drupal-cookbooks/drupal/files/default/behat_organic_groups /vagrant/public/drupal.vbox.local/docroot/sites/all/modules/
  cp -r /vagrant/cookbooks/drupal-cookbooks/drupal/files/default/behat_sample_content /vagrant/public/drupal.vbox.local/docroot/sites/all/modules/  
  drush en behat_organic_groups behat_sample_content -y
  drush behat-sample-content -y
  EOH
end

bash "enable-simplenoty-module" do
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  drush en simple_noty -y
  drush nl -y
  EOH
end

bash "configure-composer-module" do
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  mkdir -p /vagrant/public/drupal.vbox.local/docroot/sites/default/files/composer
  chmod 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/files/composer
  drush vset composer_manager_file_dir public://composer
  drush en og composer_manager -y
  drush vset theme_default bootstrap
  cd /vagrant/public/drupal.vbox.local/docroot/sites/default/files/composer
  curl -sS https://getcomposer.org/installer | php
  php composer.phar install
  drush composer-manager update
  EOH
end

#install drush registry repair for later
bash "install-drush-registry-rebuild" do 
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  drush dl registry_rebuild -y
  EOH
end

#copy drush aliases fle
#cookbook_file "~/.drush/drupal.vbox.local.aliases.drushrc.php" do
# source "drupal.vbox.local.aliases.drushrc.php"
#  ignore_failure true
#end

bash "configure-behat-library" do
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  chmod -R 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/files
  drush en behat_lib -y
  chmod -R 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/files
  drush bl
EOH
end

bash "configure-behat-editor" do
  # Composer manager may fail and need to be run manually if input is required or use the php cmdline instead
  code <<-EOH
  cd /vagrant/public/drupal.vbox.local/docroot
  chmod -R 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/files
  drush en behat_editor behat_editor_limit_tags behat_editor_services -y
  drush composer-manager update
  drush en github_behat_editor -y
  chmod -R 777 /vagrant/public/drupal.vbox.local/docroot/sites/default/files  
  drush composer-manager update
  EOH
end

bash "install-selenium-server" do
  code <<-EOH
  cd /home/vagrant/
  curl -O http://selenium.googlecode.com/files/selenium-server-standalone-2.31.0.jar
  EOH
end

bash "configure-behat-editor-saucelabs-integration" do
  # this will hose the registry so rebuild it
  # there is a conflict with the version of behat somewhere which prevents the composer.json
  # getting rewritten correctly for saucelabs, so nuke the composer.json first and rebuild
  code <<-EOH
    cd /vagrant/public/drupal.vbox.local/docroot    
    chmod -R 777 sites/all/libraries
    rm sites/default/files/composer/composer.json
    drush en behat_editor_saucelabs -y
    EOH
end

bash "final-composer-rebuild" do
  code <<-EOH
    cd /vagrant/public/drupal.vbox.local/docroot
    sudo chmod -R 777 sites/default/files
    drush rr
    drush composer-manager update -y
  EOH
end


# update to php 5.4 http://www.barryodonovan.com/index.php/2012/05/22/ubuntu-12-04-precise-pangolin-and-php-5-4-again
# dont execute the grub updates as they require input
bash "udpate-php54" do
  code <<-EOH
    add-apt-repository -y ppa:ondrej/php5-oldstable
  #  echo 'grub-pc hold' | sudo dpkg --set-selections
    apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install php5
    #apt-get upgrade php5 -y
  EOH
end
