DESCRIPTION = "Wi-Fi configuration for Raspberry Pi"
LICENSE = "CLOSED"

SRC_URI = "file://wpa_supplicant-wlan0.conf"

S = "${WORKDIR}"

inherit systemd

# Activer automatiquement au démarrage les services wpa_supplicant@wlan0 et dhcpcd
SYSTEMD_SERVICE_${PN} = "wpa_supplicant@wlan0.service dhcpcd.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    install -d ${D}/etc/wpa_supplicant
    install -m 600 ${WORKDIR}/wpa_supplicant-wlan0.conf ${D}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

    # Supprimer le fichier générique global pour éviter les conflits au démarrage
    rm -f ${D}/etc/wpa_supplicant.conf

    # Créer explicitement le lien systemd pour forcer l'activation du service au boot
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    ln -sf ${systemd_unitdir}/system/wpa_supplicant@.service \
        ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
}

FILES_${PN} = "/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"
