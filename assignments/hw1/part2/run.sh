terraform apply terraform --auto-approve

psql "host=${DATABASE_NAME}.postgres.database.azure.com port=5432 dbname=postgres user=${DATABASE_ADMIN}@${DATABASE_NAME} password=${DATABASE_ADMIN_PWD} sslmode=require" -f db.sql -o db.out

docker buildx build --platform=linux/amd64  -t webimage cna-next/Dockerfile
docker buildx build --platform=linux/amd64  -t expressimage cna-node-express/Dockerfile
docker tag webimage  ${REGISTRYNAME}.azurecr.io/webimage
docker tag expressimage ${REGISTRYNAME}.azurecr.io/expressimage
docker push ${REGISTRYNAME}.azurecr.io/webimage
docker push ${REGISTRYNAME}.azurecr.io/expressimage

terraform output -raw kube_config > ~/.kube/config-aks
export "KUBECONFIG=$HOME/.kube/config-aks:$KUBECONFIG"
az aks get-credentials --resource-group $RESOURCEGROUP --name $CLUSTERNAME
sed -e 's|DATABASE_URL_REPLACE|'"${DATABASE_URL}"'|g' manifest/web-deployment.yaml | kubectl apply -f -
kubectl apply -f manifest/

az aks enable-addons --resource-group $RESOURCEGROUP  --name $CLUSTERNAME --addons http_application_routing
az aks show --resource-group $RESOURCEGROUP --name $CLUSTERNAME -o tsv  --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName