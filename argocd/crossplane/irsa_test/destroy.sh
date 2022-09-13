#!/bin/bash


jsonnet claim.jsonnet | kubectl delete -f -
jsonnet comp.jsonnet | kubectl delete -f -
jsonnet xrd.jsonnet | kubectl delete -f -
