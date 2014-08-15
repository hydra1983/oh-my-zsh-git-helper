function _git_helper_add_all {
	git add -A .
}

function _git_helper_commit {
	if [[ "$1" == "" ]] ; then
		message="update"
	else
		message=$1
	fi
	git commit -m "$message"
}

function _git_helper_push_2_origin_master {
	git push origin master
}

function _git_helper_push_2_all {
	git push origin --all
}

function ghacp2all {
	_git_helper_add_all
	_git_helper_commit $1
	_git_helper_push_2_all
}

function ghacp2om {
	_git_helper_add_all
	_git_helper_commit $1
	_git_helper_push_2_origin_master
}
