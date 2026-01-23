# ==============================================================================
# Project : Secure Embedded Linux OTA System (REGA)
# File    : base-files_%.bbappend
# Author  : Stanley Selvaratnam
# Target  : Toradex Verdin iMX8MP
# Yocto   : Custom layer / recipe
# Email   : stanley.selvaratnam@gmail.com
# ==============================================================================

# Create the /securedata directory with restrictive permissions (0700)
do_install:append() {
    install -d -m 0700 ${D}/securedata
}