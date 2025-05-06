

~~~powershell
cd simple.avnm # changfe to this directory if not already there
az login --use-device-code
$subscriptionId = az account show --query "id" -o tsv
$env:TF_VAR_subscription_id = $subscriptionId
tf init
tf fmt
tf validate
tf destroy --auto-approve
tf plan --out=01.tfplan
terraform apply --auto-approve 01.tfplan
~~~



~~~powershell
$subscriptions = az account list --query "[].id" -o tsv
foreach ($subscription in $subscriptions) {
    az account set --subscription $subscription
    az provider register -n Microsoft.AzureTerraform
}
~~~
