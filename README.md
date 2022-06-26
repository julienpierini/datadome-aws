# datadome-aws
Deploy a simple stack with aws app runner
## How to deploy

1. Change the `$ACCOUNT_ID` value with your in the file or export your account id [account.hcl](https://github.com/julienpierini/datadome-aws/blob/main/aws/live/account.hcl)
```
$ export TF_VAR_aws_account_id="000000000"
```
2. Go into the [dev](https://github.com/julienpierini/datadome-aws/tree/main/aws/live/eu-west-1/dev) folder
3. init and deploy the kms stack
```
$ cd ../kms
$ terragrunt init
$ terragrunt apply
```
4. init and deploy the iam stack
```
$ cd ../iam
$ terragrunt init
$ terragrunt apply
```
5. init and deploy the ecr stack
```
$ cd ../ecr
$ terragrunt init
$ terragrunt apply
```
6. Push your image into ecr, follow [How to push an image to the ecr repository](https://github.com/julienpierini/datadome-aws#how-to-push-an-image-to-the-ecr-repository)
7. init and deploy the app-runner stack (edit the [app-runner vars](https://github.com/julienpierini/datadome-aws/blob/main/aws/live/eu-west-1/dev/vars/app-runner.hcl) if needed)
```
$ vim ../vars/app-runner.hcl
$ cd ../app-runner
$ terragrunt init
$ terragrunt apply
```

## How to push an image to the ecr repository

Follow the documentation on [datadome-app](https://github.com/julienpierini/datadome-app)

## How to clean
1. Go into the [dev](https://github.com/julienpierini/datadome-aws/tree/main/aws/live/eu-west-1/dev) folder
2. Run the destroy command
```
$ terragrunt destroy-all
```
