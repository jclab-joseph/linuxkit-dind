#!/bin/bash

cloud_user_data_file=/run/config/userdata
[ -e "${cloud_user_data_file}" ] || exit 1

user=$(yq -r ".user" "${cloud_user_data_file}")
if [ -n "${user}" ]; then
	uid=$(id -u "${user}" 2>/dev/null)
	has_user=$?
	password=$(yq -r ".password" "${cloud_user_data_file}")
	[ ${has_user} -eq 0 ] || (adduser -s /bin/bash -D "${user}" && addgroup "${user}")
	existing_passwd=$(cat /etc/shadow | grep -E "^${user}:" | cut -d':' -f2)
	if [ -n "${password}" ] && [[ "${existing_passwd}" == "!" || -z "${existing_passwd}" ]]; then
		[[ "${password:1:1}" = '$' || "${password:1:1}" = '' ]] && echo "${user}:${password}" | chpasswd -e || echo "${user}:${password}" | chpasswd
	fi
	[ "${user}" = "root" ] && home_dir="/root" || home_dir="/home/${user}"
	ssh_authorized_keys=$(yq -r ".ssh_authorized_keys" "${cloud_user_data_file}")
	mkdir -p "${home_dir}/.ssh"
	touch "${home_dir}/.ssh/authorized_keys"
	if [ -n "${ssh_authorized_keys}" ]; then
		while read line; do
			echo "$line" >> "${home_dir}/.ssh/authorized_keys"
		done <<< $(yq -r ".ssh_authorized_keys[]" "${cloud_user_data_file}")
	fi
	chmod 400 "${home_dir}/.ssh/authorized_keys"
	chown "${user}:${user}" -R "${home_dir}/.ssh"
fi

exit 0

