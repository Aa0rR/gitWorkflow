#!/bin/bash

###########################################
#---------------) Colors (----------------#
###########################################

C = $ (printf '\033') 
RED = "${C}[1;31m" 
SED_RED = "${C}[1;31m&${C}[0m" 
GREEN = "${C}[1;32m" 
SED_GREEN = "${C}[1;32m&${C}[0m" 
YELLOW = "${C}[1;33m" 
SED_YELLOW = "${C}[1;33m&${C}[0m" 
SED_RED_YELLOW = "${C}[1;31;103m&${C}[0m" 
BLUE = "${C}[1;34m" 
SED_BLUE = "${C}[1;34m&${C}[0m" 
ITALIC_BLUE = "${C}[1;34m${C}[3m" 
LIGHT_MAGENTA = "${C}[1;95m" 
SED_LIGHT_MAGENTA = "${C}[1;95m&${C}[0m" 
LIGHT_CYAN = "${C}[1;96m" 
SED_LIGHT_CYAN = "${C}[1;96m&${C}[0m" 
LG = "${C}[1;37m" #LightGray
SED_LG = "${C}[1;37m&${C}[0m" 
DG = "${C}[1;90m" #DarkGray
SED_DG = "${C}[1;90m&${C}[0m" 
NC = "${C}[0m" 
UNDERLINED = "${C}[5m" 
ITALIC = "${C}[3m" 
  
###########################################


function box () {
	local s = ("$@") b w 
	for l in "${s[@]}"; do
		((w < $ {#l})) && { b="$l"; w="${#l}"; }
	done 
 	tput setaf 3 
 	echo "${GREEN}" 
 	echo " -${b//?/-}-
	| ${b//?/ } |" 
 	for l in "${s[@]}"; do
		echo "${GREEN}" 
		printf '| %s%*s%s |\n' "$(tput setaf 4)" "-$w" "$l" "$(tput setaf 3)" 
	done
 	echo "${GREEN}" 
	echo "| ${b//?/ } |
	-${b//?/-}-" 
	tput sgr 0 
} 

echo
box "${YELLOW}[-] ${GREEN}Hi, welcome to the git workflow script"
echo
echo "${NC}Current path:${RED}"
pwd
echo "${NC}" 
ls
echo
echo "${ITALIC_BLUE}# Type the path of the project: ${NC}"
echo
while true; do #Path while (string)
	read PROJECT_PATH 
	echo 
 	echo "${NC}The entered path is ${RED}$PROJECT_PATH" 
	while true; do #You sure while (y/n)
		read - r -p "${ITALIC_BLUE}# Are you sure? [y/N] ${NC}" response 
 		case "$response" in 
			[yY] *) #Sure
			break 
			;; 
			[nN] *) #Not sure
				echo 
				echo "${ITALIC_BLUE}# Retype the path: ${NC}" 
 				ls 
 				break 
			;;
			*) #Default
				echo "${RED}! Please type only Yy or Nn${NC}" 
	 			echo 
			;;
		esac 
	done #End sure while (y/n)
	if[[$response = "y" || $response = "Y"]]; then 
		break 
	fi 
done #End path while (string)
echo 
if[-d "$PROJECT_PATH"]; then 
	cd $PROJECT_PATH 
else
	box "Sorry this path does not exist in the system, restart the script"
	exit 
fi 
ls 
echo 
git status 
echo 
while true; do #Changes while (y/n)
	read - r -p "${ITALIC_BLUE}# Did you make any changes? [y/n] ${NC}" changes 
 	case "$changes" in 
		[yY][eE][sS] |[yY]) #Changes done
			echo 
		  	while true; do #Add all files while (y/n)
				read - r -p "${ITALIC_BLUE}# Do you have to add all the files? [y/n] ${NC}" add 
 				case "$add" in 
					[yY][eE][sS] |[yY]) #Add all the files
		  				git add * 
						break 
					;;
					[nN]) #Add only the entered files
						echo 
						git status 
						echo 
						read - r -p "${ITALIC_BLUE}# Enter the files with their above path in the same line separated by space:  ${NC}" -a arr 
 						for file in "${arr[@]}"; do
							echo "${GREEN}$file" 
		  					git add $file 
 						done 
 						git status 
 						break 
					;;
					*) #Default
						echo "${RED}! Please type only Yy or Nn${NC}" 
 						echo 
					;;
				esac 
 			done #End add all files while (y/n)
			echo 
			while true; do #Detached HEAD while (y/n)
				read - r -p "${ITALIC_BLUE}# Are you on the wrong branch or in a Detached HEAD? [y/n] ${NC}" wrong_branch
 				case "$wrong_branch" in 
				[yY][eE][sS] |[yY])  #Currently on the wrong branch
		  			git stash 
		 			git pull 
		 			echo "${ITALIC_BLUE}# Enter the name of the branch (${RED}if it doesn't exist create it${NC}) "
					read branch 
 					git checkout $branch 
 					git stash pop 
 					git	add * 
					echo 
 					git status 
 					break 
				;;
				[nN]) #In the right branch
					break 
				;;
				*) #Default
					echo "${RED}! Please type only Yy or Nn${NC}" 
 					echo 
				;;
				esac 
 				break 
			done #End Detached HEAD while (y/n)
		;;
		[nN]) #Changes not done
			echo 
			while true; do #Wrong branch or detached HEAD while (y/n)
				read - r - p "${ITALIC_BLUE}# Are you on the wrong branch or in a Detached HEAD? [y/n] ${NC}" wrong_branch 
 				case "$wrong_branch" in 
					[yY][eE][sS] |[yY]) #Currently on the wrong branch
		  				git pull 
		  				echo "${ITALIC_BLUE}# Enter the name of the branch (${RED}if it doesn't exist create it${NC}) "
		  				read branch 
 						git checkout $branch 
 						echo 
 						git status 
		 				 break 
					;;
					[nN]) #In the right branch
						break 
					;;
	      			* ) #Default
						echo "${RED}! Please type only Yy or Nn${NC}" 
						echo 
					;;
	      		esac 
 			done #End wrong branch while (y/n) 
			break 
		;;
		* ) #Default
			echo "${RED}! Please type only Yy or Nn${NC}" 
 			echo 
		;;
	esac 
done #End changes while (y/n)
echo 
while true; do #Submodule while (y/n)
	read - r -p "${ITALIC_BLUE}# Do you have one or more submodules? [y/n] ${NC}" submodules 
 	case "$submodules" in
		[yY][eE][sS] |[yY]) #One or more submodule
			echo 
		  	cat.gitmodules 
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
		 		while true; do #Any changes while (y/n)
					read -r -p "${ITALIC_BLUE}# Did you make any changes? [y/n] ${NC}" changes 
 					case "$changes" in 
						[yY][eE][sS] |[yY]) #Changes done
		  					echo 
		 					while true; do #Add files while
								read -r -p "${ITALIC_BLUE}# Do you have to add all the files? [y/n] ${NC}" add 
 								case "$add" in 
									[yY][eE][sS] |[yY]) #Add all the files
		  								git add * 
										break 
									;;
									[nN]) #Add only the entered files
										echo 
										git status 
										echo 
										read -r -p "${ITALIC_BLUE}# Enter the files with their above path in the same line separated by space	:  ${NC}" -a arr 
 										for file in "${arr[@]}"; do
											echo "${GREEN}$file" 
 											git add $file 
 										done 
 									break 
									;;
	      							*) #Default
										echo "${RED}! Please type only Yy or Nn${NC}" 
 										echo 
									;;
								esac
 							done #End add files while
							echo 
 							while true; do
								read -r -p "${ITALIC_BLUE}# Are you on a Detached HEAD? [y/n] ${NC}" detached 
 								case "$detached" in 
									[yY][eE][sS] |[yY]) #Currently on a detached HEAD
		  								git stash 
		  								git pull 
		  								echo "${ITALIC_BLUE}# Enter the name of the branch (${RED}if it doesn't exist create it${NC}) "
		  								read branch 
										git checkout $branch
 										git stash pop 
										git add * 
										echo 
										git status 
										break 
									;;		
									[nN]) #Not in Detached HEAD
										git pull 
 										break 
									;;
									* ) #Default
								esac 
 							done 
 							break
						;;
						[nN]) #Changes not done
							echo 
							while true; do #Detached head while (y/n)
								read -r -p "${ITALIC_BLUE}# Are you on a Detached HEAD? [y/n] ${NC}" detached 
								case "$detached" in 
									[yY][eE][sS] |[yY]) #Currently on a detached HEAD
										git stash 
										git pull 
										echo "${ITALIC_BLUE}# Enter the name of the branch (${RED}if it doesn't exist create it${NC}) "
										read branch 
										git checkout $branch 
										echo 
										git status 
									break 
									;;
									[nN]) #Not in Detached HEAD
									git pull 
									break 
									;;
									* ) #Default
										echo "${RED}! Please type only Yy or Nn${NC}" 
										echo 
									;;
								esac 
							done #End detached head while (y/n)
							break 
						;;
					esac 
 				done #End while changes (y/n)
			done #End for every submodules
			break 
		;;
		[nN]) #No submodule
			break 
		;;
		* ) #Default
			echo "${RED}! Please type only Yy or Nn${NC}" 
 			echo 
		;;
	esac 
done #End submodules while (y/n)
echo 
git status 
echo
while true; do #Any changes while (y/n)
	read -r -p "${ITALIC_BLUE}# Did you make any changes? [y/n] ${NC}" changes2 
	case "$changes2" in 
		[yY][eE][sS] |[yY]) #Changes done
			echo "${ITALIC_BLUE}# Enter the message of the commit: ${NC}" 
			read commitMessage 
			echo 
			echo "This is the message:${BLUE}" 
			box $commitMessage 
			echo "${NC}" 
			commit - m "$commitMessage" 
				git pull 
			git push 
			break 
		;;
		[nN]) #Changes not doneg
			break 
		;;
		* ) #Default
			echo "${RED}! Please type only Yy or Nn${NC}" 
			echo 
		;;
	esac 
done #End any changes while (y/n)
echo 
echo "${BLUE}# All done!${NC}" 
echo 
box "${YELLOW}[-] ${GREEN}Have a nice day!" 
echo 