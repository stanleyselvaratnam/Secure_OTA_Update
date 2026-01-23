# ==============================================================================
# Project : Secure Embedded Linux OTA System (REGA)
# File    : tdx-enc-handler_%.bbappend
# Author  : Stanley Selvaratnam
# Target  : Toradex Verdin iMX8MP
# Yocto   : Custom layer / recipe
# Email   : stanley.selvaratnam@gmail.com
# ==============================================================================

# Prepend the local 'files' directory to the search path
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add the configuration file to the source URI list
SRC_URI += "file://tdx-enc-handler-override.conf"

# Install the systemd drop-in file to the appropriate directory
do_install:append() {
    # Create the directory for the systemd service override files
    install -d ${D}${systemd_system_unitdir}/tdx-enc-handler.service.d
    
    # Install the override configuration file
    install -m 0644 ${WORKDIR}/tdx-enc-handler-override.conf \
        ${D}${systemd_system_unitdir}/tdx-enc-handler.service.d/override.conf
}

# Ensure the override file is included in the final package
FILES:${PN} += "${systemd_system_unitdir}/tdx-enc-handler.service.d/override.conf"