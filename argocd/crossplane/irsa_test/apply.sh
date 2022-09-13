#!/bin/bash


jsonnet xrd.jsonnet | kubectl apply -f -
jsonnet comp.jsonnet | kubectl apply -f -
jsonnet claim.jsonnet | kubectl apply -f -