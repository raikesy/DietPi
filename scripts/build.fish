#!/usr/bin/env fish
function main
	cd (status dirname)/..
	source secrets.env.fish

	# Check we have the right env variables in place
	set placeholders (envsubst --variables "$(cat dietpi.txt)")
	set envNames (set -lx --names)

	for ph in $placeholders
		if not contains $ph $envNames
			echo "$ph is not in the env file. Build cancelling."	
			exit 1
		end
	end

	for ev in $envNames
		if not contains $ev $placeholders
			echo "$ev does not have a placeholder in dietpi.txt. Build cancelling."
			exit 1
		end
	end

	umask 077
	mkdir -p out
	envsubst <dietpi.txt >out/dietpi.txt.out
	mv out/dietpi.txt.out out/dietpi.txt
end
main

