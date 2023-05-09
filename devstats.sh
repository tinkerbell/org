#!/bin/bash

# example execution for the last 8 months (range:2020-05-05,2022-01-04) of contributions to tinkerbell/boots:
# API_URL="https://devstats.cncf.io/api/v1" bash ./devstats.sh tinkerbell 'range:2020-05-05,2022-01-04' 'Contributions' 'tinkerbell/boots'

if [ -z "$1" ]
then
  echo "$0: please specify project name as a 1st arg"
  exit 2
fi
if [ -z "$API_URL" ]
then
  API_URL="http://127.0.0.1:8080/api/v1"
fi
project="${1}"
range="${2}"
metric="${3}"
repository="${4}"
country="${5}"
github_id="${6}"
if [ -z "$range" ]
then
  range='Last decade'
fi
if [ -z "$metric" ]
then
  metric='Contributions'
fi
if [ -z "$repository" ]
then
  echo "$0: you must specify repository"
  exit 3
fi
if [ -z "$country" ]
then
  country='All'
fi
if [ -z "$github_id" ]
then
  github_id=''
fi

echo $repository
curl -H "Content-Type: application/json" \
    "${API_URL}" \
    -d '{
    "api":"DevActCnt",
    "payload":{
        "project":'\"${project}\"',
        "range":'\"${range}\"',
        "metric":'\"${metric}\"',
        "repository_group":'\"${repository}\"',
        "country":'\"${country}\"',
        "github_id":'\"${github_id}\"',
        "bg":'\"${BG}\"'
    }
}' 2>/dev/null | jq -r '["rank","name","num"], ["----","----","---"], ([.rank, .login, .number] | transpose | .[]) | @tsv' | column -t -s $'\t'