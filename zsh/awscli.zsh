export PATH=/usr/local/bin/:$PATH
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws





logs() {
    local operation=$1
    if [[ $operation == "list" ]]; then
        aws logs describe-log-groups | jq '.logGroups[] | select(.logGroupName | contains("CODETEST") | not)' | jq '.logGroupName'
    elif [[ $operation == "query" ]]; then
        local queryId=$(aws logs start-query --log-group-name $2 --start-time $(date -v-1d +%s) --end-time $(date +%s) --query-string $3 | jq -r .queryId)
        echo ">> Query ID: $queryId"
        local resultStatus="Running"
        while [[ $resultStatus == "Running" ]]; do
            echo ">> Result status: $resultStatus"
            local result=$(aws logs get-query-results --query-id $queryId)
            local resultStatus=$(echo $result | jq -r .status)
        done
        echo ">> Result status: $resultStatus"
        echo $result | jq '.results[] | .[] | select(.field=="@message")' | jq -r .value
    fi
}

fpath=(~/.zsh/completion $fpath)