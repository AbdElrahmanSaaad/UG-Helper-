#!/bin/bash
#This script to help system admin to ADD USER, DELETE USER,USER DETAILS, LIST USER, ENABLE USER, DISABLE USER, USER PASSWORD.
#Also can using in ADD GROUP, DELETE GROUP, ADD USER TO GROUP, LIST OF GROUPS.
#You can run this script by using this command on the same  path of script---> ./UG_helper.sh  <------------

function add_user(){
	read -p "Enter user name one word: " username
	id $username	&>/dev/null
	while [ $? -eq 0 ]
	do 
		username=${username}${RANDOM}
		id $username    &>/dev/null
	done
	adduser   $username
	tail -1 /etc/passwd
}
#****************************************************************************************************
function delete_user(){
	read -p $'Choose 0 for delete user\nChoose 1 to delete user and files: ' num
	read -p "Enter user name: " username
	if [ $num -eq 1  ]
	then
	userdel -r $username
	else
	userdel $username
	fi
	echo "........Check.........."
	id $username
}
#****************************************************************************************************
function user_details(){
	read -p "Enter user name: " username
	id $username
}
#****************************************************************************************************
function list_users(){
	cut -d: -f1 /etc/passwd
}
#****************************************************************************************************
function unlock_user(){
	read -p "Enter user name: " username
	passwd -u $username
	grep ^${username}: /etc/shadow
}
#****************************************************************************************************
function lock_user(){
	read -p "Enter user name: " username
	passwd -l $username
	grep ^${username}: /etc/shadow
}
#****************************************************************************************************
function user_pass(){
	read -p "Enter user name: " username
	passwd $username
	grep ^${username}: /etc/shadow
}
#****************************************************************************************************
function add_group(){
	read -p "Enter group name: " groupname
	groupadd $groupname
	tail -1 /etc/gshadow | awk -F: '{print $1}'
}
#****************************************************************************************************
function del_group(){
	read -p "Enter group name: " groupname
	groupdel $groupname
	echo "Group $groupname deleted"
}
#****************************************************************************************************
function sec_group(){
	read -p "Enter group name: " groupname
	read -p "Enter user name: " username
	usermod -a -G ${groupname} ${username}
	id $username
}
#****************************************************************************************************
function list_group(){
	cut -d: -f1 /etc/group
}
#****************************************************************************************************
function pri_group(){
	read -p "Enter user name: " username
	read -p "Enter group name: " groupname
	usermod -g ${groupname} ${username}
	id $username
}
#****************************************************************************************************
function nologin(){
	read -p "Enter user name: " username
	useradd -s /usr/sbin/nologin $username
	tail -1 /etc/passwd
}



echo "Hi, $USER! Please choose an option:"
select option in "Add User" "Nologin Shell User" "Delete User" "User Password" "List Users" "User Details" "Lock User" "Unlock User" "Add Group" "Delete Group" "Primary Group" "Supplementary Group" "List Groups" "Exit"
do
	case $option in
		"Add User")
			add_user;;
		"Nologin Shell User")
			nologin;;
		"Delete User")
			delete_user;;
		"User Password")
			user_pass;;
		"List Users")
			list_users;;
		"User Details")
			user_details;;
		"Lock User")
			lock_user;;
		"Unlock User")
			unlock_user;;
		"Add Group")
			add_group;;
		"Delete Group")
			del_group;;
		"Primary Group")
			pri_group;;
		"Supplementary Group")
			sec_group;;
		"List Groups")
			list_group;;
		"Exit")
			exit;;
		*)
			echo "Enter valid number!"
	esac
done
