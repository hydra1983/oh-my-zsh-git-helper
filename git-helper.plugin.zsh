if [ -L $0 ] ; then
    _gh_helper_base=$(dirname $(readlink -f $0))
else
    _gh_helper_base=$(dirname $0)
fi

function _git_helper_add_all {
	git add -A .
}

function _git_helper_commit {
	if [[ "$1" == "" ]] ; then
		message="update"
	else
		message="$1"
	fi
	git commit -m "$message"
}

function _git_helper_push_2_origin_master {
	git push origin master
}

function _git_helper_push_2_origin_current_branch {
	local readonly CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	git push origin ${CURRENT_BRANCH}
}

function _git_helper_push_2_upstream_master {
	git push upstream master
}

function _git_helper_push_2_upstream_current_branch {
	local readonly CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	git push upstream ${CURRENT_BRANCH}
}

# function _git_helper_push_2_all {
# 	git push origin --all
# }

function _git_helper_pull_from_origin_master {
	git pull --rebase origin master
}

function _git_helper_pull_from_origin_current_branch {
	local readonly CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	git pull --rebase origin ${CURRENT_BRANCH}
}

function _git_helper_pull_from_upstream_master {
	git pull --rebase upstream master
}

function _git_helper_pull_from_upstream_current_branch {
	local readonly CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	git pull --rebase upstream ${CURRENT_BRANCH}
}

# function _git_helper_replace_name_email_push_2_origin_master {
# 	user_name="$1"
# 	user_email="$2"

# 	git filter-branch -f --env-filter "GIT_AUTHOR_NAME='${user_name}'; GIT_AUTHOR_EMAIL='${user_email}'; GIT_COMMITTER_NAME='${user_name}'; GIT_COMMITTER_EMAIL='${user_email}';" HEAD
# 	git push -f origin master
# }

function _git_remote_add {
	remote="$1"
	remote_url="$2"

	if [[ "${remote}" != "" ]] && [[ "${remote_url}" != "" ]] ; then
		[[ "$(git remote | grep ${remote})" == "" ]] || git remote remove "${remote}"

		echo "Add remote : [${remote}] ${remote_url}"
		git remote add "${remote}" "${remote_url}"
	fi
}

function _git_helper_push_2_all_masters {
	 git remote | xargs -I {} git push {} master
}

function _git_helper_remove_all_local_branches {
	git ls-remote origin refs/heads/* | \
		grep -v 'master' | \
		awk '{print $2}' | \
		sed -E 's|^refs\/heads\/(.*)$|\1|' | \
		xargs -I {} git branch -D {}
}

function _git_helper_remove_all_remote_branches {
	git ls-remote origin refs/heads/* | \
		grep -v 'master' | \
		awk '{print $2}' | \
		sed -E 's|^refs\/heads\/(.*)$|\1|' | \
		xargs -I {} git push origin :{}
}

function _git_helper_remove_all_local_stable_branches {
	git ls-remote origin refs/heads/* | \
		grep -v 'master' | \
		sed -E 's|^.*(stable(-[0-9]+\.[0-9]+)?).*$|\1|' | \
		xargs -I {} git branch -D {}
}

function _git_helper_remove_all_remote_stable_branches {
	git ls-remote origin refs/heads/* | \
		grep -v 'master' | \
		sed -E 's|^.*(stable(-[0-9]+\.[0-9]+)?).*$|\1|' | \
		xargs -I {} git push origin :{}
}

function _git_helper_remove_all_local_tags {
	git ls-remote origin "refs/tags/*" | \
		sed -E 's|^.*(v[0-9]+\.[0-9]+\.[0-9]+).*$|\1|' | \
		sort -uV | \
		xargs -I {} git tag -d {}
}

function _git_helper_remove_all_remote_tags {
	git ls-remote origin "refs/tags/*" | \
		sed -E 's|^.*(v[0-9]+\.[0-9]+\.[0-9]+).*$|\1|' | \
		sort -uV | \
		xargs -I {} git push origin :{}
}

function _git_helper_list_all_local_git_repos {
	local dir git_conf_dir
	dir="$1"

	if [[ ! -d "${dir}" ]]; then
		echo "${dir} is not a directory"
		exit 1;
	fi

	git_conf_dir="$(find "${dir}" -d | grep -E "^${dir}/.git$")"
	if [[ "${git_conf_dir}" != "" ]]; then
		
	fi
}

function _git_helper_remove_local_origin_branch {
	local branchName
	readonly branchName="$1"

	if [[ "${branchName}" == "" ]]; then
		echo "Require 'branchName'"
		exit 0
	fi
	
	echo "Removing branch '${branchName}'"
	if [[ "$(git branch|grep "${branchName}")" != "" ]]; then
		git branch -D "${branchName}"
		echo "Local branch '${branchName}' removed"
	fi

	if [[ "$(git branch -a|grep "origin/${branchName}")" != "" ]]; then
		git branch -r -d "origin/${branchName}"
		echo "Origin branch 'origin/${branchName}' removed"
	fi
}

function _git_helper_checkout_track_branch_from_master {
	local branchName
	readonly branchName="$1"

	if [[ "${branchName}" == "" ]]; then
		echo "Require 'branchName'"
		exit 0
	fi

	git checkout --track -b "${branchName}" master
}

########################################
# exports
########################################
# function ghusage {
	
# }

function ghac {
	_git_helper_add_all
	_git_helper_commit "$1"
}

function ghacp2om {
	_git_helper_add_all
	_git_helper_commit "$1"
	_git_helper_push_2_origin_master
}

function ghacp2oc {
	_git_helper_add_all
	_git_helper_commit "$1"
	_git_helper_push_2_origin_current_branch
}

function ghacp2um {
	_git_helper_add_all
	_git_helper_commit "$1"
	_git_helper_push_2_upstream_master
}

function ghacp2uc {
	_git_helper_add_all
	_git_helper_commit "$1"
	_git_helper_push_2_upstream_current_branch
}

function ghacp2am {
	_git_helper_add_all
	_git_helper_commit "$1"
	_git_helper_push_2_all_masters
}

function ghp2om {
	_git_helper_push_2_origin_master
}

function ghp2oc {
	_git_helper_push_2_origin_current_branch
}

function ghp2um {
	_git_helper_push_2_upstream_master
}

function ghp2uc {
	_git_helper_push_2_upstream_current_branch
}

function ghp4om {
	_git_helper_pull_from_origin_master
}

function ghp4oc {
	_git_helper_pull_from_origin_current_branch
}

function ghp4um {
	_git_helper_pull_from_upstream_master
}

function ghp4uc {
	_git_helper_pull_from_upstream_current_branch
}

function ghrao {
	_git_remote_add origin "$1"
}

function ghruo {
	_git_remote_add upstream "$1"
}

function ghrmab {
	_git_helper_remove_all_local_branches
	_git_helper_remove_all_remote_branches
}

function ghrmasb {
	_git_helper_remove_all_local_stable_branches
	_git_helper_remove_all_remote_stable_branches
}

function ghrmat {
	_git_helper_remove_all_local_tags
	_git_helper_remove_all_remote_tags
}

function ghrmlob {
	_git_helper_remove_local_origin_branch "$1"
}

function ghctb4m {
	_git_helper_checkout_track_branch_from_master "$1"
}