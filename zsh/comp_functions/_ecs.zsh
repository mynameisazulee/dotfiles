#compdef ecs

typeset -A opt_args

_arguments -C \
  '1:operations:->operation_lists' \
  '*:: :->args' \
&& ret=0

case "$state" in
    (operation_lists)
        local operations; operations=(
            'list: list all clusters'
            'describe: describes the cluster that contains X'
        )
        _describe -t operations 'operations' operations && ret=0
    ;;
esac

# aws cloudformation describe-stack-events --stack-name MiraiTheiaImageGenerationService-EcsService-Beta-us-west-2 --max-items 10 | jq '.StackEvents[] | .ResourceStatus, .ResourceStatusReason'

ecs() {
    if [[ $1 == "list" ]]; then
        aws ecs list-clusters | jq '.clusterArns[] | select(. | contains("CODETEST") | not)'
    elif [[ $1 == "describe" ]]; then
        local cluster_arn=$(aws ecs list-clusters | jq '.clusterArns[] | select(. | contains("CODETEST") | not)' | grep Image | jq -r .)
        aws ecs describe-clusters --clusters $cluster_arn | jq .
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

