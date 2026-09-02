#!/usr/bin/env bash
# Install git hooks by symlinking from scripts/hooks/ into .git/hooks/
REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/.git/hooks"

ln -sf "$REPO_ROOT/scripts/hooks/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$REPO_ROOT/scripts/hooks/pre-commit"
echo "Installed pre-commit hook"

ln -sf "$REPO_ROOT/scripts/hooks/post-commit" "$HOOKS_DIR/post-commit"
chmod +x "$REPO_ROOT/scripts/hooks/post-commit"
echo "Installed post-commit hook"
