#!/bin/bash

set -e

build_dir=$PWD/build
mkdir -p $build_dir

org_name=temp

platforms="linux/amd64"

function build_pkg() {
	local pkg_name=$1
	local pkg_dir="pkg/${pkg_name}"
	computed_image=$(linuxkit pkg show-tag -org ${org_name} "${pkg_dir}" 2>/dev/null || true)
	build_opts=("-network" "-org" "${org_name}")
	if [ -z "${computed_image}" ]; then
		temp_tag=$(openssl rand -hex 8)
		computed_image=${org_name}/linuxkit-${pkg_name}:${temp_tag}
		build_opts+=("-hash" "${temp_tag}")
	fi
	echo "[build_pkg] $pkg_name image tag: ${computed_image}"
	linuxkit pkg build -platforms "$platforms" ${build_opts[@]} "${pkg_dir}"
	echo "[build_pkg] ${pkg_name}_image_tag=${computed_image}"
	declare -g "$(echo "$pkg_name" | sed -e "s|-|_|g")_image_tag"="${computed_image}"
}

pkgs="sshd dind"

replace_patterns=""
for pkg in ${pkgs}; do
	build_pkg $pkg
	vname="$(echo "${pkg}_image_tag" | sed -e 's|-|_|g')"
        rep_name="$(echo "${pkg^^}" | sed -e 's|-|_|g')_IMAGE"
	replace_patterns="${replace_patterns}s|<${rep_name}>|${!vname}|g; "
done

echo "replace_patterns: ${replace_patterns}"

sed -e "${replace_patterns}" dind.yaml.in > dind.yaml

time linuxkit build -format iso-efi -dir "${build_dir}" dind.yaml

