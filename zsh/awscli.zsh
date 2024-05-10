export PATH=/usr/local/bin/:$PATH
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws



cf() {
    local operation=$1
    if [[ $operation == "list" ]]; then
        if [[ -z $2 ]]; then
            local result=$(aws cloudformation list-stacks | jq '.StackSummaries[] | select(.StackStatus | contains("COMPLETE") | not)')
            if [[ -z $result ]]; then
                echo ">> No stacks currently updating"
            else
                echo $result | jq .
            fi
        elif [[ $2 == "all" ]]; then
            aws cloudformation list-stacks | jq '.StackSummaries[].StackName'
        fi
    elif [[ $operation == "status" ]]; then
        if [[ -z $2 ]]; then
            echo ">> No stack name provided"
        else
            if [[ -z $3 ]]; then
                aws cloudformation describe-stack-events --stack-name $2 --max-items 3 | jq .StackEvents
            else
                aws cloudformation describe-stack-events --stack-name $2 --max-items $3 | jq .StackEvents
            fi
        fi
    elif [[ $operation == "open" ]]; then
        if [[ -z $ADA_REGION ]]; then
            echo ">> No region set, please run ada_export command"
        else
            if [[ -z $2 ]]; then
                open -n -a "Google Chrome" "https://$ADA_REGION.console.aws.amazon.com/cloudformation/home?region=$ADA_REGION"
            else    
                local stackId=$(aws cloudformation list-stacks | jq -r '.StackSummaries[] | select(.StackName | contains("'$2'")) | .StackId')
                local encodedStackId=$(echo $stackId | jq -sRr @uri)
                encodedStackId=$(echo "${encodedStackId::-3}")
                open -n -a "Google Chrome" "https://$ADA_REGION.console.aws.amazon.com/cloudformation/home?region=$ADA_REGION#/stacks/stackinfo?stackId=$encodedStackId"
            fi
        fi
    fi
}

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

ecs() {

}

_test() {
    local state

    _arguments \
    '1: :->aws_profile'\
    '*: :->eb_name'

    case $state in
        (aws_profile) _arguments '1:profiles:(cuonglm test)';;
        (*) compadd "$@" prod staging dev
    esac
}

_test() "$@"

fpath=(~/.zsh/completion $fpath)