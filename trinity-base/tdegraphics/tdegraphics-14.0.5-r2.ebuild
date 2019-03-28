# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils git-r3

DESCRIPTION="TDE graphics system"
HOMEPAGE="http://trinitydesktop.org/"

EGIT_REPO_URI="https://git.trinitydesktop.org/cgit/tdegraphics"
EGIT_COMMIT="0f786c3188b027ba156dca04f16ffd0482f19a55"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+pdf paper t1lib"

DEPEND="
	trinity-base/tdebase
	trinity-base/tdelibs
	trinity-base/tdemultimedia
	paper? ( app-text/libpaper )
	dev-libs/libgamin
	dev-util/desktop-file-utils
	net-dns/libidn
	virtual/libusb:0
	media-libs/libmng
	media-libs/tiff:0
	dev-libs/libpcre
	virtual/acl
	media-libs/giflib
	media-libs/libgphoto2
	t1lib? ( media-libs/t1lib )
	media-gfx/sane-backends
	x11-libs/libXxf86vm
	x11-libs/libXmu
	media-libs/mesa
	x11-base/xorg-server
	media-libs/openexr
	pdf? ( app-text/poppler )
	media-libs/lcms
	dev-libs/fribidi
	dev-libs/openssl
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${P}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_prepare() {
	epatch ${FILESDIR}/${PN}-poppler.patch
	cmake-utils_src_prepare
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DLIB_SUFFIX=${LIBDIRSUFFIX}
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	-DCMAKE_SKIP_RPATH=OFF
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
	-DCMAKE_NO_BUILTIN_CHRPATH=ON
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF

	-DCMAKE_INSTALL_PREFIX="${TDEDIR}"

	-DBIN_INSTALL_DIR="${TDEDIR}/bin"
	-DCONFIG_INSTALL_DIR="/etc/trinity"
	-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DPKGCONFIG_INSTALL_DIR="${TDEDIR}/$(get_libdir)/pkgconfig"

	-DWITH_T1LIB=$(usex t1lib)
	-DWITH_LIBPAPER=$(usex paper)
	-DWITH_TIFF=ON
	-DWITH_OPENEXR=ON
	-DWITH_PDF=$(usex pdf)
	-DBUILD_ALL=ON
	-DBUILD_KUICKSHOW=OFF
	-DBUILD_KMRML=OFF
	-DBUILD_KAMERA=ON
#	%{!?build_kamera:-DBUILD_KAMERA=OFF} \
	)

	 cmake-utils_src_configure
}