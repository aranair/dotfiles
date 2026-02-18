#!/bin/bash

# Searches Jira issues using JQL search (replaces deprecated GET /rest/api/3/search)
# Usage: ./jira-search-full.sh "search terms"
#
# If query ends with a number (likely a ticket key), also searches by key.
# Requires: domain, username, apitoken environment variables

query="$1"
escaped_query=$(printf '%s' "$query" | sed 's/"/\\"/g')

if [[ "$1" =~ ^.*[0-9]+$ ]]; then
  jql="description ~ \"${escaped_query}\" OR summary ~ \"${escaped_query}\" OR key = \"${escaped_query}\" ORDER BY updated DESC"
else
  jql="description ~ \"${escaped_query}\" OR summary ~ \"${escaped_query}\" ORDER BY updated DESC"
fi

curl --silent --request POST \
  --url "https://${domain}.atlassian.net/rest/api/3/search/jql" \
  --user "${username}:${apitoken}" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data "$(jq -n --arg jql "$jql" '{jql: $jql, maxResults: 15, fields: ["summary", "assignee"]}')" \
  | /usr/local/bin/jq '{items: [.issues[] | {uid: .id, title: .key, subtitle: ((.fields.summary // "") + " (" + (.fields.assignee.displayName // "Unassigned") + ")"), arg: .key}]}'
