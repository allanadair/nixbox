# Install GNU guix
curl https://alpha.gnu.org/gnu/guix/guix-binary-0.15.0.x86_64-linux.tar.xz --output /tmp/guix-binary-0.15.0.x86_64-linux.tar.xz
cd /tmp
tar --warning=no-timestamp -xf guix-binary-0.15.0.x86_64-linux.tar.xz
mv var/guix /var/ && mv gnu /
ln -sf /var/guix/profiles/per-user/root/guix-profile ~root/.guix-profile
GUIX_PROFILE="`echo ~root`/.guix-profile" ; source $GUIX_PROFILE/etc/profile
mkdir -p /usr/local/bin
cd /usr/local/bin
ln -s /var/guix/profiles/per-user/root/guix-profile/bin/guix
mkdir -p /usr/local/share/info
cd /usr/local/share/info
for i in /var/guix/profiles/per-user/root/guix-profile/share/info/* ; do ln -s $i ; done
nixos-rebuild switch
/usr/local/bin/guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub
/usr/local/bin/guix package -i glibc-utf8-locales
export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale
