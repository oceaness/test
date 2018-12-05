#!/bin/sh

# This script will automatically set your raspberry Pi's GPU memory
# split to 256mb, this should be sufficient for most feed layouts.
# You may decrease this but you may experience graphical errors.

gpu_mem="256"

# We will also be disabling overscan which will remove black
# borders from most modern screens.

# Finally we will install docker if it is not already installed and
# add the Pi user to the docker user group.


# If /boot/config.txt contains "gpu_mem"
if grep -Fq gpu_mem /boot/config.txt
then
	# Replace it with new value
	sudo sed -i "/gpu_mem=/c\gpu_mem=$gpu_mem" /boot/config.txt
else
	# Append it
	sudo sh -c "echo '\ngpu_mem=$gpu_mem' >> /boot/config.txt"
fi

# If boot/config.txt contains "disable_overscan"
if grep -Fq disable_overscan /boot/config.txt
then
	# Replace it with new value
	sudo sed -i '/disable_overscan/c\disable_overscan=1' /boot/config.txt
else
	# Append it
	sudo sh -c "echo '\ndisable_overscan=1' >> /boot/config.txt"
fi

# If docker is not installed
if ! docker -v &> /dev/null; then
	# Install docker
	curl -sSL https://get.docker.com | sh
fi

# If  pi user is not in docker group
if ! groups pi | grep -q 'docker'; then
	# Add default pi user to docker group
	sudo usermod -aG docker pi
fi

# Check if pi user password has been changed
if [ -e /run/sshwarn ] ; then
	echo "The password for the user 'pi' is still the default value, please change this by running passwd"
fi

echo "Please reboot your pi for the settings to take effect"
echo "After rebooting please see the pi_video_matrix.conf file in the conf directory"
