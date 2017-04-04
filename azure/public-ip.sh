# Public IP related functions

fn azure_public_ip_create(name, group, location, allocation) {
	(
		az network public-ip create --name $name --resource-group $group --location $location --allocation-method $allocation
	)
}

fn azure_public_ip_delete(name, group) {
	(
		az network public-ip delete --name $name --resource-group $group
	)
}
