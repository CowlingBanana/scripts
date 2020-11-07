#!/bin/bash
#Installation Phase

#install_golang(){

#if [ ! -f /usr/bin/go ];then
#cd ~ && wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash
#export GOROOT=$HOME/.go
#export PATH=$GOROOT/bin:$PATH
#export GOPATH=$HOME/go
#echo 'export GOROOT=$HOME/.go' >> ~/.bash_profile
#
#echo 'export GOPATH=$HOME/go'   >> ~/.bash_profile
#echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile
#source ~/.bash_profile
#
configure_packagemanager(){
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
}
install_local_tools(){
sudo apt install firefox vlc terminator git 
python3 -m pip install --upgrade youtube-dlc
}
install_packaged_tools(){
sudo apt install -y tmux vim git openvpn magic-wormhole screenfetch aria2 iputils-ping gcc make libpcap-dev
sudo apt install -y build-essential libssl-dev libffi-dev python-dev python-setuptools python3-pip
sudo apt install -y apt-transport-https
sudo apt install -y libcurl4-openssl-dev libssl-dev jq ruby-full libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev libldns-dev python-dnspython
sudo apt install -y nmap npm phantomjs gem perl parallel
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs
return 0

}


install_go_tools(){
echo "Warning: Make sure that go 1.15 or higher is installed and is in path"

echo "Starting Pdiscovery Tools Update"

go get -u github.com/projectdiscovery/nuclei/v2/cmd/nuclei && git clone https://github.com/projectdiscovery/nuclei-templates

go get -u github.com/projectdiscovery/httpx/cmd/httpx

go get -u github.com/projectdiscovery/subfinder/v2/cmd/subfinder

echo "Pdiscovery Main tools installed & template updated"

#Other Tools
echo "Installing Waybackurls"
go get -u github.com/tomnomnom/waybackurls
echo "Done"

echo "Installing gau"
go get -u github.com/lc/gau
echo "Done"

echo "Installing anew"
go get -u github.com/tomnomnom/anew
echo "Done"

echo "Installing CROC"
go get -v github.com/schollz/croc/v8
echo "Done"

echo "Installing gf"
go get -u github.com/tomnomnom/gf
echo "Done"
git clone https://github.com/tomnomnom/gf
mkdir ~/.gf
mv ~/gf/examples/*.json ~/gf/gf-completion.* ~/.gf
echo "Configuring Template auto-completion"
echo 'source ~/.gf/gf-completion.zsh' >> ~/.zshrc
echo 'source ~/.gf/gf-completion.bash' >> ~/.bashrc
echo "auto-completion configured"

echo "Tomnomnom's Patterns Installed"

echo "Downloading Gf-patterns"
git clone https://github.com/1ndianl33t/Gf-Patterns
echo "Downloaded"
mv ~/Gf-Patterns/*.json ~/.gf
echo "Indianl33t Gf Patterns Installed"

echo "Downloading ffuf"
go get -u github.com/ffuf/ffuf
echo "Downloaded"

echo "Downloading Amass"
go get -u github.com/OWASP/Amass/...
echo "Downloaded Amass"

echo "Installing Rust & Cargo"
curl https://sh.rustup.rs -sSf | sh && source ~/.cargo/env
echo "Rust & Cargo Installed"

echo "Install rustscan"
cargo install rustscan
echo "Rustscan installed"

echo "Install aquatone"
gem install aquatone
echo "Aquatone Installed"

echo "Install Latest Version of NMAP"
wget "https://nmap.org/dist/nmap-7.91-1.x86_64.rpm"
sudo alien -d "nmap-7.91-1.x86_64.rpm"
dpkg -i nmap_7.91-1.x86_64.deb
echo "NMAP Installed"
return 0
}

#Installing tools that need to be cloned and installed
installbyclone(){
cd ~/ && mkdir tools && cd ~/tools/

echo "Downloading ParamSpider"
git clone https://github.com/devanshbatham/ParamSpider && python3 -m pip install -r ParamSpider/requirements.txt && chmod +x ParamSpider/paramspider.py
echo "Done"
cd ~/tools/
echo "Downloading OpenRedirex"
git clone https://github.com/devanshbatham/OpenRedireX 
echo "Done"
cd ~/tools/
echo "Downloading GmapsAPIscanner"
git clone https://github.com/ozguralp/gmapsapiscanner/
echo "Done"
cd ~/tools/
echo "Downloading Eyewitness"
git clone https://github.com/FortyNorthSecurity/EyeWitness
cd EyeWitness/Python/setup && ./setup.sh
echo "Eyewitness Installed"
cd ~/tools/
echo "Downloading wafw00f"
git clone https://github.com/EnableSecurity/wafw00f
cd wafw00f && sudo python3 setup.py install
echo "wafw00f installed"
cd ~/tools/
echo 'Downloading dirsearch'
https://github.com/maurosoria/dirsearch
cd ~/tools/
echo "Downloading Masscan"
git clone https://github.com/robertdavidgraham/masscan && cd masscan && make -j && sudo cp bin/masscan /usr/local/bin
echo "Masscan installed"
cd ~/tools/
echo "Downloading MassDNS"
git clone https://github.com/blechschmidt/massdns && cd massdns && make -j && sudo cp bin/massdns /usr/local/bin
echo "Massdns installed"
cd ~/tools/
echo "Downloading and Installing Chromium"
git clone https://github.com/chromium-unofficial-latest-linux/chromium-latest-linux
cd chromium-latest-linux && ./update-and-run.sh
}

#Clearout Phase
clear_residue(){
cd ~/
echo "Starting Clearout"
rm -rf ~/gf
rm -rf ~/Gf-Patterns
rm -rf 'nmap-7.91-1.x86_64.rpm' 'nmap_7.91-1.x86_64.deb'
return 0
}
configure_packagemanager
#install_local_tools
install_packaged_tools
echo install_packaged_tools status $?
install_go_tools
echo install_tools Status $?
installbyclone
echo installbyclone Status $?
clear_residue
echo residue_clearance Status $?
