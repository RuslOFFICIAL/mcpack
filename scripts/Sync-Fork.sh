#!/bin/bash
[ -n "$BASH_VERSION" ] && set +H && set -e
cd "$(dirname "$0")" || exit

# Variables.
VARIABLES_FILE_NAME="Variables.conf"
VARIABLES_FILE="../configs/$VARIABLES_FILE_NAME"

# Configs.
if [ -f "$VARIABLES_FILE" ]; then
	while IFS='=' read -r key value; do
		[[ "$key" =~ ^#.* ]] || [[ -z "$key" ]] && continue
		clean_value="${value%$'\r'}"
		export "$key=$clean_value"
	done < "$VARIABLES_FILE"
else
	echo "Warning: File not found at '$VARIABLES_FILE'!" && echo -e "Check if there is that file or download it from the repository!\n"
fi

echo -e "Sync-Fork $Sync_Fork_Version\n"

# Confirmation.
while true; do
	read -r -e -p "Run this script? (Y/N) " confirmation
	case "$confirmation" in
		[Yy]* ) echo; break ;;
		[Nn]* ) echo -e "\nOperation cancelled by user.\n"; read -s -p "Press [Enter] to continue..."; exit 0 ;;
		* ) echo -e "Please answer Y or n.\n" ;;
	esac
done

# Save the name of the currently active branch.
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
echo "Current branch detected: $CURRENT_BRANCH"

echo -e "\nFetching latest updates from all remotes..."
git fetch --all

echo -e "\nEnsuring local 'main' tracks origin/main..."
git checkout -B main origin/main

echo -e "\nMerging upstream changes (allowing unrelated histories)..."
if ! git merge upstream/main --allow-unrelated-histories --no-edit; then
	echo "[INFO] Conflicts detected! Automatically resolving in favor of upstream (--theirs)..."
	git checkout --theirs .
	git add .
	
	commit_message="Merge 'upstream/main' and resolve conflicts automatically"
	commit_flags=()
	if [ -n "$(git config --get user.signingkey)" ]; then
		commit_flags+=("-s" "-S")
		echo "[INFO] It may ask now for the keyphrase of a GPG key if there is one."
		echo "[INFO] GPG key detected. Adding signed commit ('-s -S')..."
	else
		echo "[INFO] No GPG key detected. Making standard commit..."
	fi
	git commit "${commit_flags[@]}" -m "$commit_message"
fi

echo -e "\nPushing updated main branch to the fork (origin)..."
git push origin main

echo -e "\nReturning back to the original branch: $CURRENT_BRANCH..."
git checkout "$CURRENT_BRANCH"

echo -e "\nSuccess! Fork synced!\n"
read -s -p "Press [Enter] to continue..." && exit 0
