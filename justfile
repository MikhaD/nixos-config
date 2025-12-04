set quiet

update *INPUT="":
	nix flake update {{INPUT}}

check:
	nix flake check

search QUERY LIMIT="5":
	nh search --limit {{LIMIT}} {{QUERY}}

keygen COMMENT="":
	CMNT="{{COMMENT}}"
	echo ssh-keygen -t ed25519 -a 100 -C ${CMNT:-$(hostname)}

add-key PATH="~/.ssh/id_ed25519":
	ssh-add {{PATH}}
