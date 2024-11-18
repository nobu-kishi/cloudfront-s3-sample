# CloudFrontWithS3-Terraform

## 使用技術
- Terraform v1.9.8

## ディレクトリ構成
```
.
├── README.md
├── content
│   └── index.html
├── index.html
├── main.tf
├── module
│   ├── cloudfront
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── origin_s3
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── terraform.tfvars
```

## 構築方法
1. 初期化 & モジュール読み込み
```
terraform init
```

2. リソース作成
```
terraform apply
```

3. S3へ静的コンテンツを配置
```sh
aws s3 cp content/ s3://dev-cloudfrontWithS3 --recursive
```
