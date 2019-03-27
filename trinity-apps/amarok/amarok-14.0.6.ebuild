# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Advanced audio player based on KDE frameworks"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+xine visual "

DEPEND="
	sys-apps/dbus
	trinity-base/tde-common-cmake
	dev-qt/tqtinterface
	trinity-base/tdelibs
	xine? ( media-libs/xine-lib )
	visual? ( media-libs/libvisual )
	media-libs/libmp4v2
	media-libs/taglib
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_configure() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DLIB_SUFFIX=${LIBDIRSUFFIX}
	-DWITH_XINE=$(usex xine)
	-DWITH_LIBVISUAL=$(usex visual)
	-DWITH_MP4V2=ON
	-DBUILD_ALL=ON
#	-DWITH_DAAP=ON
	)

	 cmake-utils_src_configure
}
