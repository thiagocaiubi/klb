# Subnet related functions
# parameter -network-security-group could be name or id
fn azure_subnet_create(name, group, vnet, address, securitygroup) {
	(
		az network vnet subnet create
						--name $name
						--resource-group $group
						--vnet-name $vnet
						--address-prefix $address
						--network-security-group $securitygroup
	)
}

fn azure_subnet_get_id(name, group, vnet) {
        resp <= (
                az network vnet subnet show $group $vnet $name --json
        )
        id <= echo $resp | jq -r ".id"
        return $id
}

fn azure_subnet_delete(name, group, vnet) {
	(
		az network vnet subnet delete
						--resource-group $group
						--vnet-name $vnet
						--name $name
	)
}
