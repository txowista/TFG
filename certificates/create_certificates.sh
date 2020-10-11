#/bin/bash
uuidgen --random > GUID.txt
openssl req -newkey rsa:2048 -nodes -keyout PK.key -new -x509 -sha256 -days 36500 -subj "/CN=my Project  Key/" -out PK.crt
openssl x509 -outform DER -in PK.crt -out PK.cer 
cert-to-efi-sig-list -g "$(< GUID.txt)" PK.crt PK.esl
sign-efi-sig-list -g "$(< GUID.txt)" -k PK.key -c PK.crt PK PK.esl PK.auth
openssl req -newkey rsa:2048 -nodes -keyout KEK.key -new -x509 -sha256 -days 36500 -subj "/CN=my Key Exchange Key/" -out KEK.crt
openssl x509 -outform DER -in KEK.crt -out KEK.cer
cert-to-efi-sig-list -g "$(< GUID.txt)" KEK.crt KEK.esl
sign-efi-sig-list -g "$(< GUID.txt)" -k PK.key -c PK.crt KEK KEK.esl KEK.auth
openssl req -newkey rsa:2048 -nodes -keyout db.key -new -x509 -sha256 -days 36500 -subj "/CN=my Signature Database key/" -out db.crt
openssl x509 -outform DER -in db.crt -out db.cer
cert-to-efi-sig-list -g "$(< GUID.txt)" db.crt db.esl
sign-efi-sig-list -g "$(< GUID.txt)" -k KEK.key -c KEK.crt db db.esl db.auth
