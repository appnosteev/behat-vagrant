$aliases['vbox'] = array(    
    'uri' => 'drupal.vbox.local',
    'root' => '/vagrant/public/drupal.vbox.local/docroot',
    'db-url' => 'mysql://root:root@127.0.0.1/drupal',
    'path-aliases' => array(
      '%drush' => '/usr/bin/drush',
      '%dump-dir' => '/tmp/',
      '%files' => 'sites/default/files',
     ),
);
