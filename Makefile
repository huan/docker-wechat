# Author: Huan LI <zixia@zixia.net> git.io/zixia
#
.PHONY: version
version:
	@newVersion=$$(awk -F. '{print $$1"."$$2"."$$3+1}' < VERSION) \
		&& echo $${newVersion} > VERSION \
		&& git add VERSION \
		&& git commit -m "$${newVersion}" \
		&& git tag "v$${newVersion}" \
		&& echo "Bumped version to $${newVersion}"
