ctr=$(buildah from alpine:latest)
buildah run $ctr apk --no-cache update
buildah run $ctr apk --no-cache upgrade
buildah run $ctr apk add --no-cache gnupg curl ca-certificates dovecot dovecot-gssapi dovecot-ldap dovecot-lmtpd dovecot-pigeonhole-plugin dovecot-mysql dovecot-submissiond dovecot-pop3d netcat-openbsd bash dovecot-pigeonhole-plugin-ldap dovecot-sql mariadb-client openssl
buildah run $ctr rm -rf /etc/dovecot
buildah run $ctr rm -rf /var/lib/dovecot
buildah run $ctr mkdir /var/lib/dovecot
buildah run $ctr mkdir /etc/dovecot
buildah copy $ctr entrypoint.sh /entrypoint.sh
buildah run $ctr chmod +x /entrypoint.sh
buildah run $ctr addgroup -g 5000 vmail
buildah run $ctr adduser -D -H -s /sbin/nologin -G vmail -u 5000 vmail
buildah run $ctr sed -i "s/\/home\/vmail/\/dev\/null/g" /etc/passwd
buildah run $ctr mkdir /mail
buildah run $ctr chown vmail:vmail -R /mail
#the below are not necessary theoretically as I will initialize the ports through kubernetes
#buildah config --port 110/tcp $ctr
#buildah config --port 995/tcp $ctr
#buildah config --port 143/tcp $ctr
#buildah config --port 993/tcp $ctr
#buildah config --port 587/tcp $ctr
#buildah config --port 24/tcp $ctr
buildah config --entrypoint "/entrypoint.sh" $ctr
buildah config --author "Manuel" --label name="dovecot for k8s application" $ctr
buildah config --label source="https://github.com/kubernetes-mail-server/dovecot" $ctr
img=$(buildah commit $ctr dovecot:0.2)
