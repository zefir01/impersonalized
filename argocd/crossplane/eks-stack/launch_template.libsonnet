local data=importstr "user_data.txt";

function(provider_config, name, stack, cluster, region){
    "apiVersion": "ec2.aws.crossplane.io/v1alpha1",
    "kind": "LaunchTemplate",
    "metadata": {
        "name": name+"-"+stack
    },
    spec: {
        forProvider: {
            region: region,
            launchTemplateData: {
                userData: std.base64(std.format(data, cluster.metadata.name))
            },
            launchTemplateName: name+"-"+stack
        },
        providerConfigRef: {
            name: provider_config
        }
    }
}