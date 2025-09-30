FILESEXTRAPATHS:prepend := "${THISDIR}/../files:"

SRC_URI:append  = "file://mender.conf"


do_install:append() {
    install -m 0644 ${WORKDIR}/mender.conf ${D}${sysconfdir}/mender/mender.conf
}
