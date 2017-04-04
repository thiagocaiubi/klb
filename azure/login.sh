# Login, should be called before executing any functions
# Login info will be loaded from:
# AZURE_TENANT_ID
# AZURE_CLIENT_ID
# AZURE_CLIENT_SECRET
# no support using -q

fn azure_login() {
        azure config mode arm

        tenantID = $AZURE_TENANT_ID
        clientID = $AZURE_CLIENT_ID
        secretID = $AZURE_CLIENT_SECRET

        az login -u $clientID --service-principal --tenant $tenantID -p $secretID
}
