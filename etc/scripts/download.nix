{ pkgs, ... }:

pkgs.writeShellScriptBin "download" ''
    # Define Colors
    CYAN='\033[0;36m'
    WHITE='\033[1;37m'
    YELLOW='\033[1;33m'
    MAGENTA='\033[1;35m'
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    GRAY='\033[1;30m'
    NC='\033[0m' # No Color

    clear
    echo -e "''${CYAN}=============================================''${NC}"
    echo -e "''${WHITE}    INTERNET SPEED TEST (HOME MANAGER)       ''${NC}"
    echo -e "''${CYAN}=============================================''${NC}"

    echo -e "''${YELLOW}--- GLOBAL / CDN ---''${NC}"
    echo " 1. Cloudflare  (Nearest CDN - Fastest)"
    echo " 2. Tele2       (Global/Europe Generic)"

    echo -e "\n''${YELLOW}--- HETZNER OFFICIAL ---''${NC}"
    echo " 3. Nuremberg   (DE - nbg1)"
    echo " 4. Falkenstein (DE - fsn1)"
    echo " 5. Helsinki    (FI - hel1)"
    echo " 6. Ashburn     (US East - ash)"
    echo " 7. Hillsboro   (US West - hil)"
    echo " 8. Singapore   (Asia - sin)"

    echo -e "\n''${YELLOW}--- VULTR OFFICIAL ---''${NC}"
    echo " 9. New Jersey  (US East)"
    echo "10. Silicon Vly (US West)"
    echo "11. Singapore   (Asia)"

    echo -e "\n''${MAGENTA}--- CUSTOM ---''${NC}"
    echo " c. Custom URL  (Enter your own link)"

    echo -e "---------------------------------------------"
    echo " q. Quit"
    echo -e "---------------------------------------------"

    read -p "Select a Test Server: " selection

    dest="/dev/null"
    save_msg="(Discarding Data)"
    url=""
    name=""

    case $selection in
        1) url="https://speed.cloudflare.com/__down?bytes=100000000"; name="Cloudflare (CDN)" ;;
        2) url="http://speedtest.tele2.net/100MB.zip"; name="Tele2 (Global)" ;;
        3) url="https://nbg1-speed.hetzner.com/100MB.bin"; name="Hetzner (Nuremberg)" ;;
        4) url="https://fsn1-speed.hetzner.com/100MB.bin"; name="Hetzner (Falkenstein)" ;;
        5) url="https://hel1-speed.hetzner.com/100MB.bin"; name="Hetzner (Helsinki)" ;;
        6) url="https://ash-speed.hetzner.com/100MB.bin"; name="Hetzner (Ashburn VA)" ;;
        7) url="https://hil-speed.hetzner.com/100MB.bin"; name="Hetzner (Hillsboro OR)" ;;
        8) url="https://sin-speed.hetzner.com/100MB.bin"; name="Hetzner (Singapore)" ;;
        9) url="https://nj-us-ping.vultr.com/vultr.com.100MB.bin"; name="Vultr (New Jersey)" ;;
        10) url="https://sjo-ca-us-ping.vultr.com/vultr.com.100MB.bin"; name="Vultr (Silicon Valley)" ;;
        11) url="https://sgp-ping.vultr.com/vultr.com.100MB.bin"; name="Vultr (Singapore)" ;;
        c|C) 
            read -p "Paste your URL here: " url
            if [[ ! "$url" =~ ^http ]]; then url="http://$url"; fi
            name="Custom URL"
            
            read -p "Save this file to current folder? (y/n): " want_save
            if [[ "$want_save" == "y" || "$want_save" == "Y" ]]; then
                suggested=$(basename "$url" | cut -d? -f1)
                if [[ -z "$suggested" ]]; then suggested="speedtest_file.dat"; fi
                
                read -p "Enter filename (Enter to use '$suggested'): " user_filename
                if [[ -n "$user_filename" ]]; then dest="$user_filename"; else dest="$suggested"; fi
                save_msg="(Saving to: $(pwd)/$dest)"
            fi
            ;;
        q|Q) echo "Exiting..."; exit ;;
        *) echo "Invalid selection. Defaulting to Cloudflare."; url="https://speed.cloudflare.com/__down?bytes=100000000"; name="Cloudflare (Default)" ;;
    esac

    echo -e "\n''${YELLOW}Testing against $name...''${NC}"
    echo -e "''${GRAY}$save_msg''${NC}"
    echo -e "Please wait...\n"

    format="%{http_code}|%{time_connect}|%{time_starttransfer}|%{time_total}|%{speed_download}|%{size_download}"

    # Run curl
    result=$(curl -L -o "$dest" -# -w "$format" "$url")

    IFS='|' read -r code connect ttfb total speed_bps size_bytes <<< "$result"

    # Math with awk
    read mbs mbps size_mb <<< $(awk -v s="$speed_bps" -v z="$size_bytes" 'BEGIN { printf "%.2f %.2f %.2f", s/1048576, (s*8)/1000000, z/1048576 }')

    echo "" 
    if [[ "$code" == "200" ]]; then
        echo -e "Status:  ''${GREEN}$code (OK)''${NC}"
    else
        echo -e "Status:  ''${RED}$code (Error/Redirect)''${NC}"
    fi

    printf "Connect: %ss\n" "$connect"
    printf "TTFB:    %ss\n" "$ttfb"
    printf "Total:   %ss\n" "$total"
    echo "----------------"
    printf "Size:    %s MB\n" "$size_mb"

    is_small=$(awk -v size="$size_mb" 'BEGIN { if (size < 10) print 1; else print 0 }')
    if [[ "$is_small" -eq 1 ]]; then
        echo -e "''${MAGENTA}WARNING: File is very small (<10MB). Speed result may be inaccurate.''${NC}"
    fi
    echo "----------------"

    if [[ "$code" == "200" ]]; then
        echo -e "Speed:   ''${GREEN}$mbs MB/s  ($mbps Mbps)''${NC}"
        if [[ "$dest" != "/dev/null" ]]; then
            echo -e "\n''${CYAN}File saved successfully: $dest''${NC}"
        fi
    else
        echo -e "Speed:   ''${GRAY}$mbs MB/s  ($mbps Mbps) - (Invalid due to Error)''${NC}"
    fi
''
