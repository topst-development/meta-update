DESCRIPTION = "Telechips Update Engine"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://include/update-engine.h;beginline=1;endline=21;md5=4b28161e2474d4d17e8aab7e8098bff5"
SECTION = "libs"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_APP_GIT}/tc-update-engine;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "10dcb4f126eae62d4d16518665999fb924cb7eb5"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', ' file://tc-update-engine.service', ' file://tc-update-engine.init.sh', d)} \
	"
UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"

inherit autotools pkgconfig ${UPDATE_RCD}

DEPENDS += "linux-libc-headers"
LINKER_HASH_STYLE = "sysv"

S = "${WORKDIR}/git"

PATCHTOOL = "git"

PACKAGES =+ "tc-update-app"

# for systemd
SYSTEMD_PACKAGES = "tc-update-app"
SYSTEMD_SERVICE:tc-update-app = "tc-update-engine.service"

# for sysvinit
INITSCRIPT_PACKAGES = "tc-update-app"
INIT_NAME = "tc-update-engine"

INITSCRIPT_NAME:tc-update-app = "${INIT_NAME}"
INITSCRIPT_PARAMS:tc-update-app = "start 40 S . stop 20 0 1 6 ."

EXTRA_OECONF:append = " CHIPSET=${TCC_ARCH_FAMILY}"

do_install:append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/tc-update-engine.init.sh ${D}${sysconfdir}/init.d/${INIT_NAME}
	else
		install -d ${D}/${systemd_unitdir}/system
		install -m 644 ${WORKDIR}/tc-update-engine.service ${D}/${systemd_unitdir}/system
	fi
}

FILES:tc-update-app = " \
		${sysconfdir} \
		${bindir}/TcUpdateEngine \
		${localstatedir} \
		${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
"
RDEPENDS:tc-update-app += " \
		tc-update-engine \
"
