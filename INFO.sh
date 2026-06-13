#!/bin/bash

package="docker"

. "/pkgscripts-ng/include/pkg_util.sh"

version=${SPK_PACKAGE_VERSION:-1.0.0}
os_min_ver="7.0-40761"
maintainer="appkins-org"
thirdparty="yes"
arch="${SPK_ARCH:-x86_64}"
reloadui="yes"
dsmuidir="ui"
dsmappname="appkins-org.docker"
silent_install="no"
silent_upgrade="no"
adminprotocol="http"
adminurl=""
adminport="8581"
install_dep_packages=""

displayname="Docker"
description="Docker on Synology DSM."
maintainer_url="https://github.com/appkins-org/docker-syno-spk"
support_url="https://github.com/appkins-org/docker-syno-spk"

[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
