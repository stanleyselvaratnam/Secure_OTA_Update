#!/bin/bash
set -e

# ---------------------------------------------------------------------------
# Configuration des répertoires
# ---------------------------------------------------------------------------

# Localisation du script (pour calculer les chemins relatifs)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Répertoire local pour stocker TOUTES les clés (privées + publiques)
KEY_DIR="${1:-$SCRIPT_DIR/../mender-keys}"

# Chemin vers ton layer Yocto local (on cible directement meta-key)
YOCTO_LAYER_DIR="$SCRIPT_DIR/../meta-imx8mp-rega/meta-key"

mkdir -p "$KEY_DIR"

# ---------------------------------------------------------------------------
# Définition des chemins de clés
# ---------------------------------------------------------------------------
PRIVATE_KEY="$KEY_DIR/private.key"
PUBLIC_KEY="$KEY_DIR/public.key"
PRIVATE_ROTATION_KEY="$KEY_DIR/private-rotation.key"
ROTATION_PUBLIC_KEY="$KEY_DIR/public-rotation.key"

# ---------------------------------------------------------------------------
# Étape 1 : Génération initiale de la clé principale si elle n'existe pas
# ---------------------------------------------------------------------------
if [ ! -f "$PRIVATE_KEY" ] || [ ! -f "$PUBLIC_KEY" ]; then
    echo "No main key found. Generating initial main key pair in PKCS#1 format..."
    openssl genrsa -traditional -out "$PRIVATE_KEY" 3072
    openssl rsa -in "$PRIVATE_KEY" -pubout -out "$PUBLIC_KEY"
    echo "Main key pair generated."
fi

# ---------------------------------------------------------------------------
# Étape 2 : Promotion automatique de la clé de rotation existante
# ---------------------------------------------------------------------------
if [ -f "$PRIVATE_ROTATION_KEY" ] && [ -f "$ROTATION_PUBLIC_KEY" ]; then
    echo "Promoting rotation key to main signing key..."
    mv "$PRIVATE_ROTATION_KEY" "$PRIVATE_KEY"
    mv "$ROTATION_PUBLIC_KEY" "$PUBLIC_KEY"
    echo "Promotion done: rotation key is now the main key."
else
    echo "No existing rotation key found. Keeping current main key."
fi

# ---------------------------------------------------------------------------
# Étape 3 : Génération d'une nouvelle paire de rotation en PKCS#1
# ---------------------------------------------------------------------------
echo "Generating new rotation key pair in PKCS#1 format..."
openssl genrsa -traditional -out "$PRIVATE_ROTATION_KEY" 3072
openssl rsa -in "$PRIVATE_ROTATION_KEY" -pubout -out "$ROTATION_PUBLIC_KEY"
echo "New rotation key pair generated."

# ---------------------------------------------------------------------------
# Étape 4 : Mise à jour du Layer Yocto local (meta-key)
# ---------------------------------------------------------------------------
echo "Updating public keys in Yocto layer: $YOCTO_LAYER_DIR"

DEST_MENDER_KEYS="$YOCTO_LAYER_DIR/recipes-mender/mender-keys/files"
DEST_MENDER_ROTATION="$YOCTO_LAYER_DIR/recipes-mender/mender-keys-rotation/files"

mkdir -p "$DEST_MENDER_KEYS"
mkdir -p "$DEST_MENDER_ROTATION"

cp "$PUBLIC_KEY" "$DEST_MENDER_KEYS/public.key"
cp "$ROTATION_PUBLIC_KEY" "$DEST_MENDER_ROTATION/public-rotation.key"

echo "Public keys copied successfully to meta-key."

# ---------------------------------------------------------------------------
# Étape 5 : Résumé
# ---------------------------------------------------------------------------
echo "---"
echo "Rotation completed successfully !"
echo "Keys stored in:         $KEY_DIR"
echo "Yocto layer updated:    $YOCTO_LAYER_DIR"
echo "---"
echo "Main Public:            $PUBLIC_KEY"
echo "Rotation Public:        $ROTATION_PUBLIC_KEY"
echo "Main Private (KEEP SAFE): $PRIVATE_KEY"
echo "Rotation Private:       $PRIVATE_ROTATION_KEY"