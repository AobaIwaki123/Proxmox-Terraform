prune-br:
	@git remote prune origin
	@git branch | xargs git branch -d
