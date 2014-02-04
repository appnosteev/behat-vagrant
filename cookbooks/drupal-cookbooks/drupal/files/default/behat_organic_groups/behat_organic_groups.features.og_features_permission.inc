<?php
/**
 * @file
 * behat_organic_groups.features.og_features_permission.inc
 */

/**
 * Implements hook_og_features_default_permissions().
 */
function behat_organic_groups_og_features_default_permissions() {
  $permissions = array();

  // Exported og permission: 'node:page:add user'
  $permissions['node:page:add user'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  // Exported og permission: 'node:page:administer group'
  $permissions['node:page:administer group'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  // Exported og permission: 'node:page:approve and deny subscription'
  $permissions['node:page:approve and deny subscription'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  // Exported og permission: 'node:page:manage members'
  $permissions['node:page:manage members'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  // Exported og permission: 'node:page:manage permissions'
  $permissions['node:page:manage permissions'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  // Exported og permission: 'node:page:manage roles'
  $permissions['node:page:manage roles'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  // Exported og permission: 'node:page:subscribe'
  $permissions['node:page:subscribe'] = array(
    'roles' => array(
      'non-member' => 'non-member',
    ),
  );

  // Exported og permission: 'node:page:subscribe without approval'
  $permissions['node:page:subscribe without approval'] = array(
    'roles' => array(),
  );

  // Exported og permission: 'node:page:unsubscribe'
  $permissions['node:page:unsubscribe'] = array(
    'roles' => array(
      'member' => 'member',
    ),
  );

  // Exported og permission: 'node:page:update group'
  $permissions['node:page:update group'] = array(
    'roles' => array(
      'administrator member' => 'administrator member',
    ),
  );

  return $permissions;
}
