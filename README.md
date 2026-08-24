# Unifi-Site-Search-By-Mac
Search the Unifi UOS database for sites that contain  specified mac addresses


To enter the new UOS server on your linux installation:
`sudo uosserver shell`

download the file. Unifi does not come with wget, nano,vi or many other editors

 `curl -o findSite.sh https://raw.githubusercontent.com/jwshepherd/Unifi-Site-Search-By-Mac/refs/heads/main/findSite.sh`

 Make the file executable
 `chmod +x findSite.sh`

 Run it with the full or partial mac address
 `./findSite.sh ea6c`
 
