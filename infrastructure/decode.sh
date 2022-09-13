#!/bin/bash

# grab decoded error message
error=`aws sts decode-authorization-message --encoded-message $@ | jq .DecodedMessage`
# trim the start and end double quotes
json_err=${error:1: -1}
# remove escaped quoted strings and pretty print with jq
echo $json_err | sed 's|\\"|"|g' | jq .

