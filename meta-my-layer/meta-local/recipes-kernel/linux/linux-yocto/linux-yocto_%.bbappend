# ajouter le dossier files à la recherche
FILESEXTRAPATHS:prepend := "${THISDIR}/../files:"

# ajouter le DTS fourni
SRC_URI:append = " file://qemuarm64.dts"

# copier le DTS dans le source tree du kernel au moment de la configure
do_configure:append:qemuarm64() {
    install -m 0644 ${WORKDIR}/qemuarm64.dts ${S}/arch/arm64/boot/dts/qemuarm64.dts
    echo "dtb-$(CONFIG_ARM64) += qemuarm64.dtb" >> ${S}/arch/arm64/boot/dts/Makefile
}

# indiquer le nom du DTB à inclure dans l'image
KERNEL_DEVICETREE:append:qemuarm64 = " qemuarm64.dtb"
