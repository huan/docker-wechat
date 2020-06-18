#
# DoChat: https://github.com/huan/docker-wechat
# Author: Huan LI <zixia@zixia.net> github.com/huan
#
.PHONY: install
install:
	./scripts/install.sh

.PHONY: test
test:
	./scripts/test.sh

.PHONY: version
version:
	@newVersion=$$(awk -F. '{print $$1"."$$2"."$$3+1}' < VERSION) \
		&& echo $${newVersion} > VERSION \
		&& git add VERSION \
		&& git commit -m "$${newVersion}" \
		&& git tag "v$${newVersion}" \
		&& echo "Bumped version to $${newVersion}"
