#!/bin/bash
echo "Warning: Make sure that go 1.15 or higher is installed and is in path"
echo "Starting Pdiscovery Tools Update"
update_tools(){
#Nuclei
GO111MODULE=auto go get -u github.com/projectdiscovery/nuclei/v2/cmd/nuclei
#httpx
GO111MODULE=auto go get -u github.com/projectdiscovery/httpx/cmd/httpx
#subfinder
GO111MODULE=auto go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
}
update_templates(){
 nuclei -update-templates
}
update_tools
echo "Tools Updated"
update_templates
echo "Templates Updated"
