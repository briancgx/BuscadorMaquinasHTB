#!/bin/bash

# Author: briancgx

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Exiting...${endColour}\n"
    tput cnorm && exit 1
}

# Ctrl + C
trap ctrl_c INT

# Variables Globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Usage:${endColour}"
    echo -e "\t${purpleColour}u)${endColour}${grayColour} Update files${endColour}"
    echo -e "\t${purpleColour}m)${endColour}${grayColour} Search by machine name${endColour}"
    echo -e "\t${purpleColour}i)${endColour}${grayColour} Search by IP address${endColour}"
    echo -e "\t${purpleColour}o)${endColour}${grayColour} Search by operating system${endColour}"
    echo -e "\t${purpleColour}s)${endColour}${grayColour} Search by skill${endColour}"
    echo -e "\t${purpleColour}c)${endColour}${grayColour} Search by certification${endColour}"
    echo -e "\t${purpleColour}y)${endColour}${grayColour} Get link to the machine resolution${endColour}"
    echo -e "\t${purpleColour}d)${endColour}${grayColour} Search by difficulty (Fácil, Media, Difícil, Insane)${endColour}"
    echo -e "\t${purpleColour}h)${endColour}${grayColour} Display this help panel${endColour}\n"
}

function updateFiles() {
    if [ ! -f bundle.js ]; then
        tput civis
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Downloading necessary files...${endColour}"
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Files Downloaded${endColour}"
        echo -e  "\n"
        tput cnorm
    else
        tput civis
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Checking for updates...${endColour}"
        curl -s $main_url > bundle_temp.js
        js-beautify bundle_temp.js | sponge bundle_temp.js
        md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
        md5_original_value=$(md5sum bundle.js | awk '{print $1}')
        if [ "$md5_temp_value" == "$md5_original_value" ]; then
            echo -e "\n${yellowColour}[+]${endColour}${grayColour}No updates detected${endColour}\n"
            rm bundle_temp.js
        else
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Updates are available${endColour}"
            sleep 1
            rm bundle.js && mv bundle_temp.js  bundle.js
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}The files have been updated${endColour}\n"
        fi        
        tput cnorm
    fi
}

function searchMachine(){
    machineName="$1"
    machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
    if [ "$machineName_checker" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the properties of the machine ${endColour}${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The machine ${endColour}${blueColour}$machineName${endColour}${grayColour} does not exist${endColour}\n"
    
    fi
}

function searchIP(){
    ipAddress="$1"
    machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    if [ "$machineName" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the properties of the machine ${endColour}${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The IP address ${endColour}${blueColour}$ipAddress${endColour}${grayColour} does not exist${endColour}\n"
    fi
}

function getYouTubeLink(){
    machineName="$1"
    youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
    if [ $youtubeLink ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} The link to the resolution of the machine ${endColour}${blueColour}$machineName${endColour}${grayColour} is:${endColour}\n"
        echo -e "${grayColour} $youtubeLink${endColour}\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The machine ${endColour}${blueColour}$machineName${endColour}${grayColour} does not exist${endColour}\n"
    fi
}

function getMachineDifficulty(){
    difficulty="$1"
    results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    if [ "$results_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the machines with difficulty ${endColour}${blueColour}$difficulty${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The difficulty ${endColour}${blueColour}$difficulty${endColour}${grayColour} is incorrect, please try (Fácil, Media, Difícil, Insane).${endColour}\n"
    fi
}

function getOperatingSystem(){
    os="$1"
    results_check="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    if [ "$results_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the machines with operating system ${endColour}${blueColour}$os${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The operating system ${endColour}${blueColour}$os${endColour}${grayColour} is incorrect, please try (Linux, Windows).${endColour}\n"
    fi
}

function getOSDifficultyMachine(){
    difficulty="$1"
    os="$2"
    results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

    if [ "$results_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the machines with difficulty ${endColour}${blueColour}$difficulty${endColour}${grayColour} and operating system ${endColour}${blueColour}$os${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The difficulty ${endColour}${blueColour}$difficulty${endColour}${grayColour} or operating system ${endColour}${blueColour}$os${endColour}${grayColour} are incorrect, please try (Fácil, Media, Difícil, Insane) and (Linux, Windows).${endColour}\n"
    fi
}

function getSkillsMachine(){
    skill="$1"
    check_skills="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6| grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    
    if [ "$check_skills" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the machines with the skill ${endColour}${blueColour}$skill${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6| grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The skill ${endColour}${blueColour}$skill${endColour}${grayColour} is incorrect, please try other skills.${endColour}\n"
    fi
}

function getCertMachine(){
    certification="$1"
    check_cert="$(cat bundle.js | grep "like: " -B 8 | grep "$certification" -i -B 8 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    
    if [ "$check_cert" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing the machines with the certification ${endColour}${blueColour}$certification${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "like: " -B 8 | grep "$certification" -i -B 8 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        echo -e  "\n"
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} The certification ${endColour}${blueColour}$certification${endColour}${grayColour} is incorrect, please try other certifications.${endColour}\n"
    fi
}

# Indicadores
declare -i parameter_counter=0

# Chismosos
declare -i chismoso_difficulty=0
declare -i chismoso_os=0

while getopts "m:ui:y:d:o:s:c:h" arg; do
    case $arg in 
        m) machineName="$OPTARG"; let parameter_counter+=1;;
        u) let parameter_counter+=2;;
        i) ipAddress="$OPTARG"; let parameter_counter+=3;;
        y) machineName="$OPTARG"; let parameter_counter+=4;;
        d) difficulty="$OPTARG"; let chismoso_difficulty=1; let parameter_counter+=5;;
        o) os="$OPTARG"; let chismoso_os=1; let parameter_counter+=6;;
        s) skill="$OPTARG"; let parameter_counter+=7;;
        c) certification="$OPTARG"; let parameter_counter+=8;;
        h) helpPanel;;
    esac
done

if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
    updateFiles
elif [ $parameter_counter -eq 3 ]; then
    searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
    getYouTubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
    getMachineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
    getOperatingSystem $os
elif [ $chismoso_difficulty -eq 1 ] && [ $chismoso_os -eq 1 ]; then
    getOSDifficultyMachine $difficulty $os
elif [ $parameter_counter -eq 7 ]; then
    getSkillsMachine "$skill"
elif [ $parameter_counter -eq 8 ]; then
    getCertMachine "$certification"
else
    helpPanel
fi

