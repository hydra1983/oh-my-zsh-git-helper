function __add_all__ {
	git add -A .
}

function __commit__ {
	if [[ "$1" == "" ]] ; then
		message="update"
	else
		message=$1
	fi
	git commit -m "$message"
}

function __push_2_origin_master__ {
	git push origin master
}

function __push_all__ {
	git push origin --all
}

function gacp2all {
		__add_all__
		__commit__ $1
		__push_all__
}

function gacp2om {
	__add_all__
	__commit__ $1
	__push_2_origin_master__
}
