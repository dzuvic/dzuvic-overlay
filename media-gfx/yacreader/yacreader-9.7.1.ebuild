# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils eutils xdg-utils

DESCRIPTION="A comic reader for cross-platform reading and managing your digital comic collection"
HOMEPAGE="http://www.yacreader.com"
REVISION="2009123"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/YACReader/${PN}.git"
else
	SRC_URI="https://github.com/YACReader/${PN}/releases/download/${PV}/${P}.${REVISION}-src.tar.xz"
	KEYWORDS="~x86 ~amd64 ~arm"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	app-text/poppler[qt5]
	dev-qt/qtdeclarative:5
	dev-qt/qtimageformats:5
	virtual/glu
	dev-qt/qtquickcontrols:5
	dev-util/desktop-file-utils
	app-arch/unarr
	app-arch/unrar
	app-arch/unzip
	media-gfx/qrencode
	app-arch/lha
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${P}.${REVISION}" "${WORKDIR}/${P}" || die
}


src_configure(){
	eqmake5 YACReader.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst(){
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm(){
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
