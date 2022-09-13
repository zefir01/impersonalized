function(name, kind, plural, spec){
    "apiVersion": "apiextensions.crossplane.io/v1",
    "kind": "CompositeResourceDefinition",
    "metadata": {
        "name": name+".blablabla.org"
    },
    "spec": {
        "group": "blablabla.org",
        "names": {
            "kind": kind,
            "plural": plural
        },
        "versions": [
            {
                "name": "v1",
                "served": true,
                "referenceable": true,
                "schema": {
                    "openAPIV3Schema": {
                        "type": "object",
                        "properties": {
                            "spec": spec,
                            "status": {
                                "type": "object",
                                "ready": {
                                    "type": "boolean"
                                }
                            }
                        }
                    }
                }
            }
        ]
    }
}