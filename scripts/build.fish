#!/usr/bin/env fish
function main
	set baseDir (status dirname)/..
	set dpFile "$baseDir/dietpi.txt"
	source $baseDir/secrets.env.fish

	# Check we have the right env variables in place
	set placeholders (envsubst --variables "$(cat $dpFile)")
	set envNames (set -lx --names)

	for ph in $placeholders
		if not contains $ph $envNames
			echo "$ph is not in the env file. Build cancelling."	
			exit
		end
	end

	for ev in $envNames
		if not contains $ev $placeholders
			echo "$ev does not have a placeholder in dietpi.txt. Build cancelling."
			exit
		end
	end

	mkdir -p out
	envsubst <$dpFile >$baseDir/out/dietpi.txt

end
main

