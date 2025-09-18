region="asia-northeast1"
host_name="asia-northeast1-docker.pkg.dev"
project_id="dws-test-environment"
repo_name="taktak-static-app-repo"
image_name="taktak-static-app"


# 認証設定
gcloud auth configure-docker ${host_name}

tag_name="${host_name}/${project_id}/${repo_name}/${image_name}:latest"

echo "tag_name: ${tag_name}"

# イメージビルド
docker build -t ${tag_name} .


# プッシュ
docker push ${tag_name}

