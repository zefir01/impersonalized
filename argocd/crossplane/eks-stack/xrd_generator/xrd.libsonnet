function(name, kind, plural, spec, resources){

    local field=function(field){
        [field]: {
            type: "string"
        },
    },
    local res_props=function(res){
        [res.name]:{
            type: "object",
            properties: std.foldl(function(r, r1) (r+field(r1)), res.fields, {}),
        },
    },
    local fiter_res=std.filter(function(res) std.objectHas(res, "patches"), resources),

    local maped=std.map(function(res) {
        local patches= std.filter(function(patch) (std.objectHas(patch, "toFieldPath") &&
            (patch.type=="ToCompositeFieldPath" || patch.type=="CombineToComposite")),
            res.patches
        ),
        name: res.name,
        fields: [p.toFieldPath for p in patches],
    }, fiter_res),

    local prepared=std.filter(function(p) std.length(p.fields)>0, maped),

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
                            outputs: {
                                type: "object",
                                properties: std.foldl(function(r, r1) (r+res_props(r1)), prepared, {})
                            },
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