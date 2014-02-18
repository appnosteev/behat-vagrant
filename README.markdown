# VirtualBox Vagrant Chef Drupal Behat Editor install
Installs a complete preconfigured environment to use the behat_editor, behat_editor_saucelabs and behat_editor_github modules

Based on [drupal.org/project/vagrant](http://drupal.org/project/vagrant/)

Maintained by steve@appnovation.com

--------
# HOW TO INSTALL

1. Download and Install [VirtualBox](http://www.virtualbox.org/) (ensure you are on the latest version 4.0.8+)
2. Install [vagrant](http://vagrantup.com/v1/docs/getting-started/index.html)
3. Download or Clone this project go to the folder and launch the box:

```cd [vagrant project directory];```

``` vagrant up```

4. Add this line to your /etc/hosts (or windows equivalent):

    ```33.33.33.10        drupal.vbox.local dev-site.vbox.local```
    
This will install and configure the behat_editor and associated modules at : [http://drupal.vbox.local/](http://drupal.vbox.local/)

Username: admin

Password: admin

To connect to the console of you instance: ```vagrant ssh```
    
--------
# HOW TO TEST
* Navigate to /admin/behat/add
* Follow the link to add your saucelabs credentials 
* Load the wikipedia sample test 
* Run the test on saucelabs
* You should see the test complete and be able to view the video in the browser

--------
# SAUCELABS

The behat_editor_saucelabs module is enabled and must be configured here before use:
http://drupal.vbox.local/admin/

--------
# SELENIUM

* The vagrant build will download the selenium server but will not configure or start it automatically. 
* To start the server:

```vagrant ssh```

```cd /vagrant```

```java -jar selenium-server-standalone-2.31.0.jar```

* TODO instructions to use selenium server
    
--------
# REBUILD
To rebuild the software and OS (keeping the vm intact)

```/usr/bin/mysql -u root -proot -e \"DROP DATABASE drupal;\"```

```sudo rm -rf public;vagrant provision```

To rebuild from scratch change to the install directory and do:

```vagrant destroy -f```

```sudo rm -rf public```

```vagrant up```

(you will be prompted for your password for nfs setup. Do this, THEN grab some coffee)

--------
# ISSUES

Composer manager requires input
Sometimes the composer manager update fails as it requires manual intervention.  The symptoms of this are modules not working as expected and class/wrapper not found errors. We are working on this fix workaround:
First try:

```vagrant ssh```

```cd /vagrant/public/drupal.vbox.local/docroot/```

```drush composer-manager update```

 if that doesnt work then try:

```vagrant ssh```

```cd /vagrant/public/drupal.vbox.local/docroot/sites/default/files/composer```

```php composer.phar update```

* You will likely see a prompt to update a module from git or some files have changed somewhere.
* TODO This can likely be fixed with a silent flag for the most part. 

Fatal error: Class 'Drupal\BehatEditor\FileController' not found in /vagrant/public/drupal.vbox.local/docroot/sites/all/
This means the composer manager failed somewhere.  I have seen this where github has asked for credentials duing the update and the script wasn't completed. To fix do this

```vagrant ssh```

```cd /vagrant/public/drupal.vbox.local/docroot/```

```drush composer-manager update``` 

--------

You can add ```XDEBUG_PROFILE``` to your GET parameter to generate an xdebug profile, e.g. [http://dev-site.vbox.local/?XDEBUG_PROFILE](http://dev-site.vbox.local/?XDEBUG_PROFILE)

You can then investigate at [http://dev-site.vbox.local/webgrind/](http://dev-site.vbox.local/webgrind/)

Phpmyadmin is available [http://dev-site.vbox.local/phpmyadmin/](http://dev-site.vbox.local/phpmyadmin/). User ```myadmin```, Password ```myadmin```
