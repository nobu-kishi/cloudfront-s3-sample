# cloudfront-s3-sample

## 使用技術
- Terraform v1.9.8

## ディレクトリ構成
```
.
├── README.md
├── content
│   └── index.html
├── envs
│   └── dev
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variable.tf
└── module
    ├── cloudfront
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── origin_s3
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
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
aws s3 cp content/ s3://dev-cloudfront-s3-sample --recursive
```
