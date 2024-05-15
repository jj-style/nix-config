dir="$HOME/Pictures/.wallpapers"
default="/etc/wallpapers/default.jpg"
numfiles=$(ls -l "$dir" | grep '-' | wc -l)

direction=$1

if [[ -z "$direction" ]]; then
	gsettings set org.gnome.desktop.background picture-uri-dark "'file://$(realpath $default)'";
	exit 0;
fi

# get basepath without extension: i.e. /path/to/file.jpg => file
found=$(gsettings get org.gnome.desktop.background picture-uri-dark | tr -d "'")
current=${found#file://}
current=${current##*/}
current=${current%.jpg}

# if current file name isn't just a number, then start at 0
if [[ ! "$current" =~ ^[0-9]+$ ]]; then
	current=0
fi

echo "current $current"
if [[ "$direction" == "next" ]]; then
	next=$(( ($current + 1) % $numfiles ))
elif [[ "$direction" == "prev" ]]; then
	next=$(( (($current - 1) + $numfiles) % $numfiles ))
fi

echo "next $next"
nextpath=$(realpath "$dir/$next.jpg")
echo "path $nextpath"

gsettings set org.gnome.desktop.background picture-uri-dark "'file://$nextpath'";
