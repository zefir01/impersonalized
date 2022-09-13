local y = std.parseYaml(importstr '../env.yaml');

function(env, project, image)
  std.manifestYamlDoc(std.mergePatch(
    y,
    {
      [env]: {
        [project]: {
          image: image,
        },
      },
    }
  ), indent_array_in_object=true, quote_keys=false)
