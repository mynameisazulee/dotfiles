#compdef cf

typeset -A opt_args

_arguments -C \
  '1:operations:->operation_lists' \
  '*:: :->args' \
&& ret=0

case "$state" in
    (operation_lists)
        local operations; operations=(
            'list: list active cf stacks'
            'lista: list all cf stacks'
            'status: status of cf stack X'
        )
        _describe -t operations 'operations' operations && ret=0
    ;;
esac

# aws cloudformation describe-stack-events --stack-name MiraiTheiaImageGenerationService-EcsService-Beta-us-west-2 --max-items 10 | jq '.StackEvents[] | .ResourceStatus, .ResourceStatusReason'

cf() {
    if [[ $1 == "list" ]]; then
        if [[ -z $2 ]]; then
            local result=$(aws cloudformation list-stacks | jq '.StackSummaries[] | select(.StackStatus | contains("COMPLETE") | not)')
            if [[ -z $result ]]; then
                echo ">> No stacks currently updating"
            else
                echo $result | jq .
            fi
        fi
    elif [[ $2 == "lista" ]]; then
        aws cloudformation list-stacks | jq '.StackSummaries[].StackName'
    elif [[ $1 == "status" ]]; then
        if [[ -z $2 ]]; then
            echo ">> No stack name provided"
        else
            if [[ -z $3 ]]; then
                aws cloudformation describe-stack-events --stack-name $2 --max-items 3 | jq .StackEvents
            else
                aws cloudformation describe-stack-events --stack-name $2 --max-items $3 | jq .StackEvents
            fi
        fi
    elif [[ $1 == "open" ]]; then
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

return 1;

