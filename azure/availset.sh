# Availset related functions

# azure_availset_create creates a new `availability set`.
# `name` is the availability set name
# `group` is the resource group name
# `location` is the azure region
fn azure_availset_create(name, group, location) {
	az vm availability-set create --name $name --resource-group $group --location $location
}

# azure_availset_delete deletes a exit `availability set`.
# `name` is the availability set name
# `group` is the resource group name
fn azure_availset_delete(name, group) {
	az vm availability-set delete --name $name --resource-group $group
}
