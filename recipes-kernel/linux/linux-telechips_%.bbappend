FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc803x tcc805x', ' file://update.cfg', '', d)}"
