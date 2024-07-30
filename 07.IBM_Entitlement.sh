export ENTITLEDKEY="$(<ibm-entitlement-key)"
export NAMESPACE="oms"
kubectl create secret docker-registry ibm-entitlement-key  --docker-server=cp.icr.io --docker-username=cp --docker-password=${ENTITLEDKEY} --namespace=${NAMESPACE}
