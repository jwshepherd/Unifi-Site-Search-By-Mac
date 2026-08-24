#!/bin/bash

# Check if a partial MAC address argument was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <partial_or_full_mac>"
    echo "Example: $0 7e:64:3c"
    echo "Example: $0 8cede1"
    exit 1
fi

# Clean the input: convert to lowercase and remove any existing colons/dashes
CLEAN_INPUT=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d ':-')

# Format the cleaned input into a flexible regex string
REGEX_PATTERN=$(echo "$CLEAN_INPUT" | sed 's/../&:/g' | sed 's/:$//')

echo "Searching database for MAC addresses matching pattern: *$REGEX_PATTERN*"
echo "--------------------------------------------------------------------------------"

# Query MongoDB converting the device string hex ID back to an ObjectId for the site collection
mongo --port 27117 ace --quiet --eval "
    var searchPattern = '$REGEX_PATTERN';
    db.device.find({ 'mac': { '\$regex': searchPattern } }, { 'mac': 1, 'site_id': 1, 'model': 1, 'name': 1 }).forEach(function(dev) {
        var siteName = 'Unknown Site';
        var urlString = 'Unknown';
        
        if (dev.site_id) {
            // Instantiate a true database ObjectId using the 24-char text string
            var siteObj = db.site.findOne({ '_id': ObjectId(dev.site_id) });
            if (siteObj) {
                siteName = siteObj.desc ? siteObj.desc : 'Unnamed Site';
                urlString = siteObj.name ? siteObj.name : 'default';
            }
        }
        
        var devName = dev.name ? dev.name : 'Unnamed Device';
        print('MAC: ' + dev.mac + ' | Model: ' + dev.model + ' | Name: ' + devName + ' | SITE: ' + siteName + ' | URL STRING: ' + urlString);
    });
"
echo "--------------------------------------------------------------------------------"
