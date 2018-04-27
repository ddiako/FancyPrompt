#/bin/bash
# This script is released under the MIT license, see https://github.com/ddiako/FancyPrompt

outdir="out"
tmpldir="tmpl"

if [ ! -d $outdir ]
then
    echo -e "\n[1;31m*** ERROR: Your output directory doesn't exist ! ***[0m"
    exit 1
fi
if [ ! -d $tmpldir ]
then
    echo -e "\n[1;31m*** ERROR: Your template directory doesn't exist ! ***[0m"
    exit 1
fi

# SERVER NAME
read -p "Enter the server name: " sname
if [[ "x$sname" == "x" ]]
then
    echo -e "\n[1;31m*** ERROR: Server name is mandatory ! ***[0m"
    exit 1
fi

# RELEASE INFO
read -p "Enter the release info or press enter for autodiscover: " rinfo
if [[ "x$rinfo" == "x" ]]
then
    releasepart=`lsb_release -d | cut -d ':' -f 2 | sed 's/\t//g'`
else
    releasepart=$rinfo
fi

{
    # MOTD generation
    motdpart=`figlet -f "fonts/3D Diagonal" "$sname"`
    # Templating with tags in template noted ${VAR} or $VAR
    MOTD_ART=$motdpart envsubst < $tmpldir/motd > $outdir/motd

    # ISSUE generation
    issuepart=`figlet -f "fonts/big" "$sname"`
    ISSUE_ART=$issuepart OS_DESC=$releasepart envsubst < $tmpldir/issue > $outdir/issue
} 2>/dev/null || { 
    echo -e "\n[1;31m*** ERROR: Please install 'figlet' before using this script ! ***[0m"
    exit 1 
}

echo -e "\n[1;32m* SUCCESS: You will find your generated files in <$outdir>.\n* Place them in </etc> when ready.[0m"

read -p "Preview the files ? [y,N] " preview
if [[ "$preview" == "y" ]]
then
    echo "=== MOTD ==="
    cat $outdir/motd
    echo "--------------------------------------------------------"
    echo -e "\n=== ISSUE ==="
    cat $outdir/issue
fi

