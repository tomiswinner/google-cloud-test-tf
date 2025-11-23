# Variables
DIR ?= helloWorld
APP_NAME ?= az-di-dev-jpe-func-taktest-002-single-get
RESOURCE_GROUP ?= az-di-rg-if-catalog-test
ZIP_NAME = $(DIR).zip
PUBLISH_DIR = $(DIR)/publish

.PHONY: help build publish deploy clean

help:
	@echo "Usage: make [DIR=<directory>] [APP_NAME=<function-app-name>] [RESOURCE_GROUP=<resource-group>] <target>"
	@echo ""
	@echo "Targets:"
	@echo "  build    - Build the project in Release mode"
	@echo "  publish  - Publish the project and create ZIP file"
	@echo "  deploy   - Deploy to Azure Function App"
	@echo "  clean    - Clean build artifacts"
	@echo ""
	@echo "Examples:"
	@echo "  make deploy DIR=helloWorld APP_NAME=my-function-app"
	@echo "  make publish DIR=helloWorld"

build:
	@echo "Building $(DIR)..."
	cd $(DIR) && dotnet build -c Release

publish: build
	@echo "Publishing $(DIR)..."
	cd $(DIR) && dotnet publish -c Release -o ./publish
	@echo "Creating ZIP file..."
	cd $(DIR)/publish && zip -r ../../$(ZIP_NAME) . > /dev/null
	@echo "ZIP file created: $(ZIP_NAME)"

deploy: publish
	@echo "Deploying $(DIR) to $(APP_NAME)..."
	az functionapp deployment source config-zip \
		--resource-group $(RESOURCE_GROUP) \
		--name $(APP_NAME) \
		--src $(ZIP_NAME)
	@echo "Deployment completed!"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(DIR)/bin $(DIR)/obj $(DIR)/publish $(ZIP_NAME)
	@echo "Clean completed!"

