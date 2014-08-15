
function gacp2om {
	git add -A .
	if [[ "$1" == "" ]] ; then
		message="update"
	else
		message=$1
	fi
	git commit -m "$message"
	git push origin master
}
