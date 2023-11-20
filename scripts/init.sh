#!/bin/bash
#!/bin/bash
echo "------- Running init.sh --------"

if [ "$SUDO_USER" == "ec2-user" ]; then
  echo "------- Add  user trackeriq -------"
  useradd trackeriq
  usermod -aG trackeriq trackeriq
  usermod -aG wheel trackeriq # add trackeriq user sudo privileges
  echo "trackeriq:${password:-trackeriq}" | chpasswd
  echo "trackeriq  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/trackeriq
else
  echo "------- Remove Built-in user -------"
  AWS_USER="ec2-user"
  userdel "${AWS_USER}"
  rm -rf /home/"${AWS_USER}"
fi

echo "------- Updating repository -------"

amazon-linux-extras install epel -y
yum -y update

echo "-------- Disable Swap --------"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "---- Setup Firewalld ----"

yum -y install firewalld wget lvm2 zip unzip

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

if [[ "${test}" == 'true' || "$SUDO_USER" == "ec2-user" ]]; then
  echo "---- Deploying SSH-KEY ----"
  mkdir -p /home/${user}/.ssh && touch /home/${user}/.ssh/authorized_keys
  echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyaurFE4a2DRXoDZfL4GOCTI7OlzQWp9i7+RhpMkRkH evolves" >> /home/${user}/.ssh/authorized_keys

  chmod 700 /home/${user}/.ssh && chmod 600 /home/${user}/.ssh/authorized_keys
  chown -R ${user}:${user} /home/${user}/.ssh
fi