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
			return 1
		end
	end

	for ev in $envNames
		if not contains $ev $placeholders
			echo "$ev does not have a placeholder in dietpi.txt. Build cancelling."
			return 1
		end
	end

	umask 077
	mkdir -p out
	envsubst <dietpi.txt >out/dietpi.txt.out
	or begin
		rm out/dietpi.txt.out
		return 1
	end
	mv out/dietpi.txt.out out/dietpi.txt
end
main

