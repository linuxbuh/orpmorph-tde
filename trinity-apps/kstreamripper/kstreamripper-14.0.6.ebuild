# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="KStreamRipper is a small frontend for the streamripper command"
HOMEPAGE="http://trinitydesktop.org"
SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-lang/python:2.7
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-util/desktop-file-utils
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	sys-devel/m4
	virtual/pkgconfig
	app-misc/fdupes
	dev-util/scons
	media-sound/streamripper
"

RDEPEND=""


TDEDIR="/opt/trinity"
S="${WORKDIR}/${PN}-r${PV}"

src_configure() {
        unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
        export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
        export QTDIR=${TDEDIR}
	escons configure prefix=${TDEDIR}
}
