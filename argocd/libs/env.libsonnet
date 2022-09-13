local env = std.parseYaml(importstr '../env.yaml');
local envName = std.extVar('env');

{
  local _getEnv = function() env[envName],
  getEnv:: _getEnv,

  local _toDev = function(value) if envName == 'dev' then [value] else [],
  toDev:: _toDev,

  local _toProd = function(value) if envName == 'prod' then [value] else [],
  toProd:: _toProd,

  local _envVar = function() {
    name: 'env',
    value: envName,
  },
  envVar:: _envVar,
}
