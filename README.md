# 静的コンテンツ配信サンプル

## 構築方法

1. 初期化 & モジュール読み込み

```sh
terraform init
```

2. リソース作成

```sh
terraform apply
```

3. S3へ静的コンテンツを配置

```sh
aws s3 cp {アップロードファイル} s3://{s3バケット名}

# 例: static_site_listの[0]のs3に配置場合
cd env/dev
aws s3 cp ../../content/index.html s3://$(terraform output -json s3_bucket_list | jq -r '.[0]')
```

4. リソース削除

```SH
terraform destroy
```
