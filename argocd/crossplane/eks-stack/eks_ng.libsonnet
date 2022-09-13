local role = import "iam_role.libsonnet";
local attach = import "iam_role_policy_attachement.libsonnet";
local lt = import "launch_template.libsonnet";

function(provider_config, name, stack, region, cluster, subnets){
    local r= role(provider_config, "eks-ng-role", "", stack, |||
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                }
            }
        ]
    }
|||
    ),

    local templ= lt(provider_config, "main-node", stack, cluster, region),

    local ng= {
        "apiVersion": "eks.aws.crossplane.io/v1alpha1",
        "kind": "NodeGroup",
        "metadata": {
            "name": name+"-"+stack
        },
        "spec": {
            forProvider: {
                clusterNameRef: {
                    name: cluster.metadata.name
                },
                instanceTypes: ["t3.small"],
                region: region,
                scalingConfig: {
                    maxSize: 1,
                    minSize: 1,
                    desiredSize: 1
                },
                subnetRefs: [
                    {
                        name: net.metadata.name
                    } for net in subnets
                ],
                nodeRoleRef:{
                    name: r.metadata.name
                },
                launchTemplate:{
                    nameRef: {
                        name: templ.metadata.name
                    }
                }
            },
            providerConfigRef: {
                name: provider_config
            }
        }
    },


    local attach1= attach(provider_config, "ng-attach1", stack, r, policyArn="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"),
    local attach2= attach(provider_config, "ng-attach2", stack, r, policyArn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"),
    local attach3= attach(provider_config, "ng-attach3", stack, r, policyArn="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"),

    "items": [r, attach1, attach2, attach3, templ, ng]

}