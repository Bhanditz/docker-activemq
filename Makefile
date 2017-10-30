+NAME = m3hran/activemq
 +VERSION = 0.1.1
 +C_NAME = sidora-activemq
 +
 +.PHONY: all build test tag_latest release install clean
 +
 +all: clean build install
 +
 +# Build the container's image and tag it with the provided $NAME and $VERSION
 +build: 
 +	docker build -t $(NAME):$(VERSION) .
 +
 +# Remove the running container 
 +clean: 
 +	docker rm -vf $(C_NAME)| true && docker rmi -f $(NAME):$(VERSION)
 +
 +# Spin up and run the container	
 +install:
 +	docker run -d --name $(C_NAME) $(NAME):$(VERSION)
 +
 +# Tag the container's image as "lastest".
 +tag_latest:
 +	docker tag $(NAME):$(VERSION) $(NAME):latest
 +
 +# Push the container's image to Dockerhub.com repository and tag it as "latest"
 +release: tag_latest
 +	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
 +	docker push $(NAME)
 +	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
