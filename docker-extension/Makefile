#IMAGE?=teamgosh/docker-extension
IMAGE?=teamgosh-docker-extension
TAG?=0.0.1-alpha
LOCAL_TEMP_DIR=./.tmp/

.DEFAULT_GOAL := debug

build: ## Build service image to be deployed as a desktop extension
	-rm -rf $(LOCAL_TEMP_DIR)
	-mkdir $(LOCAL_TEMP_DIR)
	-cp -r ../content-signature $(LOCAL_TEMP_DIR)
	docker build \
	  --tag=$(IMAGE):$(TAG) \
	  --build-arg content_signature_local_dir="$(LOCAL_TEMP_DIR)" \
	  .
	-rm -rf $(LOCAL_TEMP_DIR)

install: build ## Install the extension
	docker extension install $(IMAGE):$(TAG)

update: build ## Update the extension
	docker extension update $(IMAGE):$(TAG)

debug: update ## Debug the extension
	docker extension dev debug $(IMAGE):$(TAG)

publish: build ## Publish the extension
	docker pull $(IMAGE):$(TAG) && echo "Failed: image version already published" || docker push $(IMAGE):$(TAG)

.PHONY: build install update debug publish
