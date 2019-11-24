# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils xdg-utils desktop

DESCRIPTION="Cross Platform file manager."
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk qt5"
REQUIRED_USE=" ^^ ( gtk qt5 )"
RESTRICT="strip"

DEPEND=">=dev-lang/lazarus-1.8"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	dev-libs/glib
	sys-libs/ncurses
	x11-libs/libX11
	gtk? ( x11-libs/gtk+:2 )
	qt5? ( >=dev-qt/qtcore-5.6
		>=dev-qt/qt5pas-1.2.6 )
"

src_prepare(){
	 eapply_user

	use gtk && export lcl="gtk2"
	use qt5 && export lcl="qt5"
	use amd64 && export CPU_TARGET="x86_64" || export CPU_TARGET="i386"

	export lazpath="/usr/share/lazarus"

	find ./ -type f -name "build.sh" -exec sed -i 's#$lazbuild #$lazbuild --lazarusdir=/usr/share/lazarus #g' {} \;
	find ./ -type f -name "install.sh" -exec sed -i 'sXinstall -m 644 \*.so\*[ ]*\$DC_INSTALL_DIR/X#install -m 644 *.so* $DC_INSTALL_DIRXg' {} \;
}

src_compile(){
	./build.sh beta ${lcl} || die
}

src_install(){
	diropts -m0755
	dodir /usr/share

	install/linux/install.sh --portable-prefix=build

	newicon pixmaps/mainicon/colored/v4_3.png ${PN}.png

	rsync -a "${S}/build/" "${D}/usr/share/" || die "Unable to copy files"

	dosym ../share/${PN}/${PN} /usr/bin/${PN}

	make_desktop_entry ${PN} "Double Commander" "${PN}" "Utility;" || die "Failed making desktop entry!"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
