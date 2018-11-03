# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/08/44/78/ddbb8308c27be2831b418076eb2e43710a048ea2/epson-inkjet-printer-escpr2-1.0.26-1lsb3.2.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/1.6.26-warnings.patch"
)

inherit rpm

src_unpack () {
	rpm_src_unpack ${A}
}


# the version on the website is defferent inside the tar file
S=${WORKDIR}/epson-inkjet-printer-escpr2-1.0.26

src_prepare () {
	for i in  "${PATCHES[@]}" ; do
		eapply "${i}"
	done
	eapply_user
}


src_configure() {
	econf --disable-shared

	# Makefile calls ls to generate a file list which is included in Makefile.am
	# Set the collation to C to avoid automake being called automatically
	unset LC_ALL
	export LC_COLLATE=C
}

src_install() {
	emake -C ppd DESTDIR="${D}" install
	emake -C src DESTDIR="${D}" install
	einstalldocs
}
