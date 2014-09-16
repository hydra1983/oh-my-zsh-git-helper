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

function _git_helper_replace_name_email_push_2_origin_master {
	user_name=$1
	user_email=$2

	git filter-branch -f --env-filter "GIT_AUTHOR_NAME='$user_name'; GIT_AUTHOR_EMAIL='$user_email'; GIT_COMMITTER_NAME='$user_name'; GIT_COMMITTER_EMAIL='$user_email';" HEAD
	git push -f origin master
}

function _git_remote_add_origin {
	remote_url=$1

	if [[ "$remote_url" != "" ]] ; then
		git remote remove origin
		git remote add origin $remote_url
	fi	
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

function ghrnep2om {
	_git_helper_replace_name_email_push_2_origin_master $1 $2
}

function ghrao {
	_git_remote_add_origin
}