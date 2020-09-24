#! /bin/sh

# This is a debconf-compatible script
. /usr/share/debconf/confmodule
NEW_UUID=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)
echo "$NEW_UUID" > /tmp/passw.value
# Create the template file
cat > /tmp/myquestion.template <<'!EOF!'
Template: my-question/title
Type: text
Description: My question text 

Template: my-question/pass
Type: note
Description: Hola mundo ${passw} 

Template: my-question/asktheuser
Type: string
Description: Just type anything here.
!EOF!

# Load your template
debconf-loadtemplate my-question /tmp/myquestion.template

# Set title for your custom dialog box
db_settitle my-question/title
db_input critical my-question/pass
# Ask it!
#db_input critical my-question/asktheuser 
# Get the answer
db_subst my-question/pass passw $NEW_UUID
db_go
#db_get my-question/asktheuser
# Save it to a file
