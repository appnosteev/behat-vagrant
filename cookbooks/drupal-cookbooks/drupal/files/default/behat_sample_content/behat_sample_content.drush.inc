<?php

/**
 * @file behat_sample_content.module
 * TODO: Enter file description here.
 */

/**
* Implementation of hook_drush_command().
*/
 
function behat_sample_content_drush_command() {
 
        // callback is the function that will be called when the command is executed
	$items['behat-sample-content'] = array(
	    'callback' => 'behat_sample_content_generate',
            'description' => 'Loads the sample content.',
            'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_FULL,
	);
	
	return $items;
}
 
function behat_sample_content_generate() {
  
  $node = new stdClass();
  $node->title = "sample group";
  $node->type = "page";
  $node->language = LANGUAGE_NONE;
  $node->uid = 1;
  
  node_save($node);
  
}