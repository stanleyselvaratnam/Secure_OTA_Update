DESCRIPTION = "Install authorized SSH keys for root user"
LICENSE = "CLOSED"

SRC_URI = "file://authorized_keys"

do_install() {
    # Créer le dossier /etc/ssh si besoin
    install -d ${D}/etc/ssh
    # Copier authorized_keys
    install -m 600 ${WORKDIR}/authorized_keys ${D}/etc/ssh/authorized_keys
}

# Indiquer explicitement le fichier packagé
FILES_${PN} = "/etc/ssh/authorized_keys"
