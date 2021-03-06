#!/bin/sh

#######################################
# Script pour automatiser la post-installation de machine sous Debian 9 (Stretch).
# Écrit par stéphane >> https://tutodebian.fr
#######################################

# Modification des dépôts
echo -e "\e[38;5;75mModification des dépôts..\e[0m"
rm /etc/apt/sources.list
wget -P /etc/apt/ https://raw.githubusercontent.com/stephaneeee/tutodebian/master/sources.list

# Mise à jour du système
echo -e "\e[38;5;75mMise à jour du système..\e[0m"
apt-get update && apt-get upgrade -y

# Modification des droits sudoers
echo -e "\e[38;5;75mModification des droits sudoers..\e[0m"
apt-get install sudo
echo "Entrez le nom de l'utilisateur : "
read nom
sed -i "21i\ "$nom" ALL=(ALL:ALL) ALL" /etc/sudoers

# Installation du thème graphique
echo -e "\e[38;5;75mInstallation du thème graphique..\e[0m"
apt-get install autoconf automake libgtk-3-dev git gnome-themes-standard gtk2-engines-murrine arc-theme conky-all lightdm-gtk-greeter-settings -y
wget -P /usr/share/backgrounds https://raw.githubusercontent.com/stephaneeee/tutodebian/master/wallpaper.jpg
wget -P /usr/share/icons https://raw.githubusercontent.com/stephaneeee/tutodebian/master/logodebianflat.png
wget -P /usr/share/icons https://raw.githubusercontent.com/stephaneeee/tutodebian/master/logomenu.png
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install-papirus-root.sh | sh
rm /home/$nom/.config/xfce4/terminal/terminalrc
wget -P /home/$nom/.config/xfce4/terminal/ https://raw.githubusercontent.com/stephaneeee/tutodebian/master/terminalrc
chown $nom:$nom /home/$nom/.config/xfce4/terminal/terminalrc
rm /home/$nom/.config/xfce4/panel/whiskermenu-7.rc
wget -P /home/$nom/.config/xfce4/panel/ https://raw.githubusercontent.com/stephaneeee/tutodebian/master/whiskermenu-7.rc
chown $nom:$nom /home/$nom/.config/xfce4/panel/whiskermenu-7.rc
rm /home/$nom/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
wget -P /home/$nom/.config/xfce4/xfconf/xfce-perchannel-xml/ https://raw.githubusercontent.com/stephaneeee/tutodebian/master/xfce4-panel.xml
chown $nom:$nom /home/$nom/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

# Configuration de grub et lightdm
echo -e "\e[38;5;75mConfiguration de grub et lightdm..\e[0m"
rm /etc/lightdm/lightdm-gtk-greeter.conf
wget -P /etc/lightdm/ https://raw.githubusercontent.com/stephaneeee/tutodebian/master/lightdm-gtk-greeter.conf
sed -i "105i\if background_image /usr/share/backgrounds/wallpaperflat.png; then" /boot/grub/grub.cfg
sed -i "107i\if background_image /usr/share/backgrounds/wallpaperflat.png; then" /boot/grub/grub.cfg

# Installation de différents logiciels
echo -e "\e[38;5;75mInstallation de différents logiciels..\e[0m"
apt-get install thunderbird-l10n-fr filezilla enigmail lightning-l10n-fr gtk-redshift youtube-dl transmission guvcview simplescreenrecorder gparted gdebi simple-scan gufw mplayer mpv xboard gnuchess crawl-tiles xterm hexchat quodlibet inkscape wget inxi nmap screenfetch netselect-apt apt-transport-https menulibre higan openshot handbrake pidgin keepass2 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav build-essential vim -y

# Configuration de Firefox
echo -e "\e[38;5;75mConfiguration de Firefox..\e[0m"
apt-get remove firefox-esr -y
sed -i "1i\deb http://ftp.fr.debian.org/debian/ unstable main\n" /etc/apt/sources.list
apt-get update
apt-get install firefox -t unstable -y
apt-get install firefox-l10n-fr -t unstable -y
sed -i "1i\#deb http://ftp.fr.debian.org/debian/ unstable main\n" /etc/apt/sources.list
apt-get update

# Personnalisation Utilisateur
echo -e "\e[38;5;75mPersonnalisation Utilisateur..\e[0m"
su $nom -c "xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus"
su $nom -c "xfconf-query -c xsettings -p /Net/ThemeName -s Arc-Darker"
su $nom -c "xfconf-query -c xfwm4 -p /general/theme -s Arc-Darker"
su $nom -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /usr/share/backgrounds/wallpaper.jpg"

# Fin du script
echo -e "$Blue \n Fin du script :) Redémarrage nécessaire $Color_Off"
exit
