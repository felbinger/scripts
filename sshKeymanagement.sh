#!/bin/bash
keyFile="/home/$USER/.ssh/authorized_keys"
function sshKeyManagement {
	# Add all keys from the key file to the key list
	IFS=$'\r\n' GLOBIGNORE='*' command eval 'keyList=($(cat $keyFile))'
	count=0
	echo -e "\e[32mChoose an option\e[39m"
	for description in "${keyList[@]}"; do
		description=${description#* }
		description=${description#* }
		echo -e "\e[32m[$count] Delete $description\e[39m"
		count=$((count+1))
	done
	echo -e "\e[32m[97] add a new key\e[39m"
	echo -e "\e[32m[98] load backup file\e[39m"
	echo -e "\e[32m[99] exit\e[39m"
	printf "Number: "
	read number
	if [[ "$number" -eq "97" ]]; then
		echo -e "\e[32mWhich key typ you want to add?\e[39m"
		echo -e "\e[32m[0] RSA\e[39m"
		echo -e "\e[32m[1] DSA\e[39m"
		echo -e "\e[32m[2] ECDSA 256bit\e[39m"
		echo -e "\e[32m[3] ECDSA 384bit\e[39m"
		echo -e "\e[32m[4] ECDSA 512bit\e[39m"
		printf "Number: "
		read keyTypNumber
		if [[ $keyTypNumber == "0" ]]; then
			keyTyp="ssh-rsa"
		elif [[ $keyTypNumber == "1" ]]; then
			keyTyp="ssh-dss"
		elif [[ $keyTypNumber == "2" ]]; then
      keyTyp="ecdsa-sha2-nistp256"
		elif [[ $keyTypNumber == "3" ]]; then
    	keyTyp="ecdsa-sha2-nistp384"
		elif [[ $keyTypNumber == "4" ]]; then
    	keyTyp="ecdsa-sha2-nistp512"
		fi
		# Add Key
		printf "Public key: "
		read publicKey
		printf "Description: "
		read description
		cp $keyFile $keyFile.bak
		echo "$keyTyp $publicKey $description" >> $keyFile
		chown $username:$username $keyFile
		echo -e "\e[32mKey has been added successfully!\e[39m"
		echo -e "\e[0mPress enter to continue"
		read $val
		main
	elif [[ "$number" -eq "98" ]]; then
		if [[ -e $keyFile.bak ]]; then
		  mv $keyFile.bak $keyFile
			if [[ $? -eq 0 ]]; then
				echo -e "\e[32mBackup successfully loaded!\e[39m"
			else
				echo -e "\e[91mUnable to load backup!\e[39m"
			fi
		else
		  echo -e "\e[91mUnable to find backup!\e[39m"
		fi
	elif [[ "$number" -eq "99" ]]; then
		exit 0
	elif [[ "$number" -eq "" ]]; then
		sshKeyManagement
	else
	  showKey=${keyList[$number]}
		showKey=${showKey#* }
		showKey=${showKey#* }
		echo -e "\e[32mAre you sure that you want to remove the key with the description: $showKey ?\e[39m"
		printf "Type uppercase YES: "
		read areYouSure
		echo -e "\e[39m"
		if [[ $areYouSure == "YES" ]]; then
			keyToRemove=${keyList[$number]}
			mv $keyFile $keyFile.bak
			content=$(cat $keyFile.bak)
			content=${content//"$keyToRemove"/ }
			content=${content//"ssh-rsa"/"\nssh-rsa"} #Send \n for new line befor starting ssh-rsa # Not working
			echo -e $content > $keyFile
			chown $username:$username $keyFile
			echo -e "\e[32mKey has been removed successfully!\e[39m"
			echo -e "\e[0mPress enter to continue"
			read $val
		else
			echo -e "\e[39mFailed to remove key, confirmation failed!\e[39m"
			echo -e "\e[0mPress enter to continue"
			read $val
		fi
	fi
}
sshKeyManagement

