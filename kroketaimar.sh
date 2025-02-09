#!/bin/bash

clear

echo -e "\e[1;31m╔══════════════════════════════════════════════╗\e[0m"
echo -e "\e[1;33m"
echo "  @@@@@@   @@@  @@@@@@@@@@    @@@@@@   @@@@@@@   " 
echo " @@@@@@@@  @@@  @@@@@@@@@@@  @@@@@@@@  @@@@@@@@  "
echo " @@!  @@@  @@!  @@! @@! @@!  @@!  @@@  @@!  @@@  "
echo " !@!  @!@  !@!  !@! !@! !@!  !@!  @!@  !@!  @!@  "
echo " @!@!@!@!  !!@  @!! !!@ @!@  @!@!@!@!  @!@!!@!   "
echo " !!!@!!!!  !!!  !@!   ! !@!  !!!@!!!!  !!@!@!    "
echo " !!:  !!!  !!:  !!:     !!:  !!:  !!!  !!: :!!   "
echo " :!:  !:!  :!:  :!:     :!:  :!:  !:!  :!:  !:!  "
echo " ::   :::   ::  :::     ::   ::   :::  ::   :::  "
echo "  :   : :   :     :      :    :   : :   :   : :  "
echo -e "\e[0m"
echo -e "\e[1;31m╚══════════════════════════════════════════════╝\e[0m"
echo -e "\e[1;34m╔════════════════════════════════════════╗\e[0m"
echo -e "\e[1;34m|      cʀeⒶᴛeᴅ by kʀOkeᴛⒶiᴍⒶʀ            |\e[0m"
echo -e "\e[1;34m╚════════════════════════════════════════╝\e[0m"




read -p "eɴᴛeʀ ᴛhe ᴜʀʟ oʀ ᴅoᴍaiɴ: " website_input

if [[ ! $website_input =~ ^https?:// ]]; then
    website_url="https://$website_input"
else
    website_url="$website_input"
fi

echo "Normalized URL being used: $website_url"

output_dir="output"
mkdir -p "$output_dir"

echo "$website_url" | tools/./katana  -ps -pss waybackarchive,commoncrawl,alienvault -f qurl | uro > "$output_dir/output.txt"

tools/./katana -u "$website_url" -silent -d 6  — include-keywords “admin,login,config,api” -c 10 -rl 25 -jc -xhr -kf -fx -fx dn -f qurl -ef woff,css,png,svg,jpg,woff2,jpeg,gif,svg  | uro | tools/./anew "$output_dir/output.txt"

echo "Filtering URLs for potential SQLi endpoints..."

grep -Ei '(\?|&|%)(cid|CID|ID|pageid|page_id|id_c|languageId|table_id|action|uuid|contenthistid|fbid|notif_id|fbclid|siteid|uncid|p|id|q|item|cat|product|page|q|param|value)=' "$output_dir/output.txt" | grep -Ei 'union|select|--|#|and|or|like|into|from|drop|/*|' | sort -u > "$output_dir/sqli_output.txt"

if [[ -s "$output_dir/sqli_output.txt" ]]; then
    echo "Filtered SQLi URLs have been saved to: $output_dir/sqli_output.txt"
else
    echo "No SQLi URLs detected. Please check your filtering pattern or URLs."
fi


