# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Qt 5 bindings to free pascal"
HOMEPAGE="https://wiki.lazarus.freepascal.org/Qt5_Interface"
LICENSE='LGPL2-lazarus-linking-exception'
LAZARUS_VERSION="2.0.6"
LAZARUS_BASE="lazarus"
LAZARUS_ARCHIVE="lazarus-${LAZARUS_VERSION}.tar.gz"

# The qt bindings are distributed with lazarus 
SRC_URI="https://sourceforge.net/projects/lazarus/files/Lazarus%20Zip%20_%20GZip/Lazarus%20${LAZARUS_VERSION}/${LAZARUS_ARCHIVE}"
SLOT='0'

KEYWORDS="~x86 ~amd64"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwebkit:5
	dev-qt/qtgui:5
"

src_unpack(){
	unpack ${LAZARUS_ARCHIVE}

	cd "${WORKDIR}"
	mv "${LAZARUS_BASE}/lcl/interfaces/qt5/cbindings" "${PF}"
}

src_prepare(){
	eapply_user

	eqmake5 Qt5Pas.pro
}

src_install(){
	emake INSTALL_ROOT="$D" install
}

