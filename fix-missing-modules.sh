#!/bin/bash
echo "cd /vagrant/public/sites/default/modules && for f in  *; do echo \$f && sudo -E rsync -qr $(whoami)@web2:/home/drupal/contrib/\$f /home/drupal/contrib; done" | vagrant ssh
echo "cd /vagrant/public/sites/default/libraries && for f in  *; do echo \$f && sudo -E rsync -qr $(whoami)@web2:/home/drupal/libraries/\$f /home/drupal/libraries; done" | vagrant ssh
