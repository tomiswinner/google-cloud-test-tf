# 設定
PROJECT_NAME = frontend
AWS_REGION = ap-northeast-1
AWS_ACCOUNT_ID = $(shell aws sts get-caller-identity --query Account --output text)
ECR_URI = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT_NAME)

.PHONY: build push deploy clean

# ビルドのみ
build:
	@echo "yaBuilding Docker image..."
	docker build -t $(PROJECT_NAME):latest .

# ECRにプッシュ
push: build
	@echo "Logging into ECR..."
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_URI)
	@echo "Tagging image..."
	docker tag $(PROJECT_NAME):latest $(ECR_URI):latest
	@echo "Pushing to ECR..."
	docker push $(ECR_URI):latest

# デプロイ
deploy: push
	@echo "Updating ECS service..."
	aws ecs update-service --cluster main --service main --force-new-deployment --region $(AWS_REGION)

# ローカルで実行
run:
	@echo "Running locally..."
	docker run -p 3000:3000 $(PROJECT_NAME):latest

# クリーンアップ
clean:
	@echo "Cleaning up..."
	docker rmi $(PROJECT_NAME):latest || true
	docker rmi $(ECR_URI):latest || true
