#! /bin/sh

# This is a debconf-compatible script
. /usr/share/debconf/confmodule
PASS=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)
FIRST_DISK=`list-devices disk | head -n1`
# Create the template file
cat > /tmp/randompass.template <<'!EOF!'
Template: random-pass/title
Type: text
Description: LVM PASSWORD 

Template: random-pass/pass
Type: note
Description: Please Keep it:${passw} 

!EOF!

# Load your template
debconf-loadtemplate random-pass /tmp/randompass.template

# Set title for your custom dialog box
db_settitle random-pass/title
db_input critical random-pass/pass
# Ask it!
db_subst random-pass/pass passw $PASS
db_go
debconf-set partman-auto/disk "$FIRST_DISK"
db_set partman-crypto/passphrase $PASS
db_set partman-crypto/passphrase-again $PASS
