#!/bin/bash
echo "cd /home/drupal && sudo -E rsync -qr $(whoami)@web2:/home/drupal/contrib . && sudo -E rsync -qr $(whoami)@web2:/home/drupal/libraries . " | vagrant ssh
