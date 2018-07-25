#!/bin/bash - 
#===============================================================================
#
#          FILE: pre-workstation-setup.sh
# 
#         USAGE: ./pre-workstation-setup.sh 
# 
#   DESCRIPTION: Use this on your workstation to get basic things setup
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Nick Henry (NSH)
#  ORGANIZATION: 
#       CREATED: 07/25/2018 14:37
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [[ "$(id -un)" != "root" ]]
then
  echo "You must be root in order to run this script!"
  exit 1
fi

dnf -y install \
  python2 \
  python-pip

pip install ansible

mkdir -p /etc/ansible/roles

pushd /etc/ansible/roles

  cat <<-EOF > /etc/ansible/hosts
		[local]
		localhost ansible_connection=local
	EOF

  rm -fr master.zip workstation-setup-master workstation_role
  
  wget https://github.com/nshenry03/workstation-setup/archive/master.zip
  unzip master.zip
  
  mv workstation-setup-master workstation_role

popd

cat <<-EOF
	All set! Please run the following as root:
	
	  ANSIBLE_FORCE_COLOR=1 ansible-playbook -v /etc/ansible/roles/workstation_role/travis/test.yml
EOF
