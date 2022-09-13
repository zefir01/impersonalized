local claim = import "libs/claim.libsonnet";

claim("irsa", "irsa", "blablabla.org", 
    params={
        region: "eu-central-1",
        awsProviderConfig: "aws-provider",
        saNamespace: "default",
        saName: "test1",
        policyLabels: {
            app: "test1"
        },
    }
)