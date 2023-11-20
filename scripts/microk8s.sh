#!/bin/bash
echo "------- Running microk8s.sh --------"

echo "Installing snap"

mkdir installer_dependencies
cd installer_dependencies

dependencies=(
libsepol-2.5-10
libselinux-2.5-15
libselinux-utils-2.5-15
libselinux-python-2.5-15
libsemanage-2.5-14
libsemanage-python-2.5-14
policycoreutils-2.5-34
policycoreutils-python-2.5-34
setools-libs-3.3.8-4
)

for i in ${dependencies[@]}; do
wget -q "http://mirror.centos.org/centos/7/os/x86_64/Packages/"$i".el7.x86_64.rpm"
done

for i in "selinux-policy" "selinux-policy-targeted"; do
wget -q "http://mirror.centos.org/centos/7/updates/x86_64/Packages/"$i"-3.13.1-268.el7_9.2.noarch.rpm"
done

yum -y install *
yum -y install snapd

systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap

# restarting snap
systemctl restart snapd.seeded.service

sleep 30

echo "Installing microk8s"
snap install microk8s --classic --channel=1.28/stable

echo "Granting privileges"
usermod -aG microk8s ${user}
chown -fR ${user} ~/.kube

export PATH="$PATH:/snap/bin"

echo "Adding sudo privileges"
line=$(sed -n '/secure_path/ =' /etc/sudoers)
output=$(sed -n "${line}p" /etc/sudoers)
echo "${output}:/var/lib/snapd/snap/bin/" > ~/sudoers
mv ~/sudoers /etc/sudoers.d/.

echo "Checking microk8s status"
microk8s status --wait-ready

echo "Enabling Add-ons"
microk8s enable dns host-access ingress storage dashboard prometheus
sleep 5

echo "Generating aliases for kubectl: (k or kubectl)"

tee /home/${user}/.bash_aliases<<EOF
alias kubectl='microk8s.kubectl'
alias k='microk8s.kubectl'
EOF

tee -a /home/${user}/.bashrc<<EOF
if [ -f /home/${user}/.bash_aliases ]; then
. /home/${user}/.bash_aliases
fi
EOF
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload

# change the configuration files on k8s
args_dir='/var/snap/microk8s/current/args'

if [ -z $(cat ${args_dir}/kubelet | grep "\--image-gc-high-threshold=100") ]; then
# disable image garbage collector
echo "--image-gc-high-threshold=100" >> "${args_dir}/kubelet"

# disable pods eviction"
eviction_line=$(sed -n '/--eviction-hard/=' "${args_dir}/kubelet")
sed -i -e "${eviction_line}d" "${args_dir}/kubelet"

microk8s stop
microk8s start
microk8s version
fi
