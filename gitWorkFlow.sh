#!/bin/bash

###########################################
#---------------) Colors (----------------#
###########################################

C=$(printf '\033')
RED="${C}[1;31m"
SED_RED="${C}[1;31m&${C}[0m"
GREEN="${C}[1;32m"
SED_GREEN="${C}[1;32m&${C}[0m"
YELLOW="${C}[1;33m"
SED_YELLOW="${C}[1;33m&${C}[0m"
SED_RED_YELLOW="${C}[1;31;103m&${C}[0m"
BLUE="${C}[1;34m"
SED_BLUE="${C}[1;34m&${C}[0m"
ITALIC_BLUE="${C}[1;34m${C}[3m"
LIGHT_MAGENTA="${C}[1;95m"
SED_LIGHT_MAGENTA="${C}[1;95m&${C}[0m"
LIGHT_CYAN="${C}[1;96m"
SED_LIGHT_CYAN="${C}[1;96m&${C}[0m"
LG="${C}[1;37m" #LightGray
SED_LG="${C}[1;37m&${C}[0m"
DG="${C}[1;90m" #DarkGray
SED_DG="${C}[1;90m&${C}[0m"
NC="${C}[0m"
UNDERLINED="${C}[5m"
ITALIC="${C}[3m"

echo
echo "${YELLOW}[-] ${GREEN}Hi, welcome to the git workflow script${NC}"
echo "Current path:${RED}" 
pwd
echo
echo "${ITALIC_BLUE}# Type the absolute path of the project: ${NC}"
echo
read PROJECT_PATH
echo 
echo "${NC}The entered path is ${RED}$PROJECT_PATH"
read -r -p "${ITALIC_BLUE}# Are you sure? [y/N] ${NC}" response
case "$response" in
    [yY][eE][sS]|[yY]) 
	;;
    *)
	echo "${ITALIC_BLUE}# Retype the path: ${NC}"
	read PROJECT_PATH
	;;
esac
echo
cd $PROJECT_PATH
ls
echo
git status
echo
read -r -p "${ITALIC_BLUE}# Did you make any changes? [y/n] ${NC}" changes
case "$changes" in
	[yY][eE][sS]|[yY]) 
	#Changes done
	echo
	read -r -p "${ITALIC_BLUE}# Do you have to add all the files? [y/n] ${NC}" add
	case "$add" in
    		[yY][eE][sS]|[yY]) 
		#Add all the files
		#git add *
        	;;
    		[nN])
		#Add only the entered files
		echo
        	git status
		echo
		read -r -p "${ITALIC_BLUE}# Enter the files with their above path in the same line separated by space:  ${NC}" -a arr
		for file in "${arr[@]}"; do 
   			echo "${GREEN}$file"
			#git add $file
		done
        	;;
	esac
	;;
	[nN])
 	#Changes not done
	echo 
	read -r -p "${ITALIC_BLUE}# Are you on the wrong branch? [y/n] ${NC}" wrong_branch
	case "$wrong_branch" in
    		[yY][eE][sS]|[yY]) 
		#Currently on the wrong branch
		#git pull
		echo "${ITALIC_BLUE}# Enter the name of the branch (${RED}if it doesn't exist create it${NC}) "
		read branch
		#git checkout $branch
		echo 
		git status
		;;
		[nN])
		#In the right branch
		;;
	esac
	;;
esac
echo 
read -r -p "${ITALIC_BLUE}# Do you have one or more submodules? [y/n] ${NC}" submodules
case "$submodules" in
    	[yY][eE][sS]|[yY]) 
	#One or more submodule
	echo
	git status
	echo
	read -r -p "${ITALIC_BLUE}# Enter the submodules with their above path in the same line separated by space:  ${NC}" -a arr
		for submodule in "${arr[@]}"; do 
			echo
   			echo "#### ${GREEN}$submodule${NC} ####"
			echo
			cd $submodule
			git status
			echo
			read -r -p "${ITALIC_BLUE}# Did you make any changes? [y/n] ${NC}" changes
			case "$changes" in
				[yY][eE][sS]|[yY]) 
				#Changes done
				echo
				read -r -p "${ITALIC_BLUE}# Do you have to add all the files? [y/n] ${NC}" add
				case "$add" in
    				[yY][eE][sS]|[yY]) 
					#Add all the files
					#git add *
        			;;
    				[nN])
					#Add only the entered files
					echo
					git status
					echo
					read -r -p "${ITALIC_BLUE}# Enter the files with their above path in the same line separated by space:  ${NC}" -a arr
					for file in "${arr[@]}"; do 
   						echo "${GREEN}$file"
						#git add $file
					done
					;;
				esac
				;;
				[nN])
 				#Changes not done
				echo 
				read -r -p "${ITALIC_BLUE}# Are you on a Detached HEAD? [y/n] ${NC}" detached
				case "$detached" in
					[yY][eE][sS]|[yY]) 
					#Currently on a detached HEAD
					#git stash
					#git pull
					echo "${ITALIC_BLUE}# Enter the name of the branch (${RED}if it doesn't exist create it${NC}) "
					read branch
					#git checkout $branch
					echo 
					git status
					;;
					[nN])
					#Not in Detached HEAD
					#git pull
					;;
				esac
				;;
			esac
		done
    ;;
    [nN])
	#No submodule
	;;
esac
echo 
git status
echo 
read -r -p "${ITALIC_BLUE}# Did you make any changes? [y/n] ${NC}" changes2
case "$changes2" in
    	[yY][eE][sS]|[yY]) 
	echo "${ITALIC_BLUE}# Enter the message of the commit: ${NC}"
	read commitMessage
	echo
	echo "This is the message:"
	echo "###########################################"
	echo $commitMessage
	echo "###########################################"
	#git commit -m "$commitMessage"
	#git pull
	#git push
	;;
	[nN])
	#Changes not done
	;;
esac
echo "${YELLOW}[-] ${GREEN}Have a nice day!"