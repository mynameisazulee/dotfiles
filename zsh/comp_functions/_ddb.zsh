#compdef ddb

typeset -A opt_args

_arguments -C \
  '1:operations:->operation_lists' \
  '*:: :->args' \
&& ret=0

case "$state" in
    (operation_lists)
        local operations; operations=(
            'list: lists all dynamodbs'
            'describe: describes table X'
            'scan: scans table X to get Y items'
        )
        _describe -t operations 'operations' operations && ret=0
    ;;
esac

ddb() {
    if [[ $1 == "list" ]]; then
        aws dynamodb list-tables | jq '.TableNames[] | select(. | contains("CODETEST") | not)'
    elif [[ $1 == "describe" ]]; then
        aws dynamodb describe-table --table-name $2 | jq .Table
    elif [[ $1 == "scan" ]]; then
        local scan=$(aws dynamodb scan --table-name $2 --max-items 50)
        local scannedCount=$(echo $scan | jq '.ScannedCount')
        if [[ -z $3 ]]; then
            echo $scan | jq '.Items[0]'
            echo ">> Scanned first item from table $2 - scannedCount: $scannedCount"
        else
            echo $scan | jq '.Items['$3']'
            echo ">> Scanned item i=$3 from table $2 - scannedCount: $scannedCount"
        fi
    elif [[ $1 == "query" ]]; then
        local table=$2
        local hk_v=$3
        local sk_v=$4

        local describe_table=$(aws dynamodb describe-table --table-name $table)
        local hash_key=$(echo $describe_table | jq -r '.Table.KeySchema[] | select(.KeyType | contains("HASH")) | .AttributeName')
        local sort_key=$(echo $describe_table | jq -r '.Table.KeySchema[] | select(.KeyType | contains("RANGE")) | .AttributeName')

        if [[ -z $sk_v ]]; then
            aws dynamodb query --table-name $table --key-condition-expression "$hash_key = :value"  --expression-attribute-values '{":value":{"S":"'$hk_v'"}}' | jq .Items
        else
            aws dynamodb query --table-name $table --key-condition-expression "$hash_key = :hkValue AND $sort_key = :skValue"  --expression-attribute-values '{":hkValue":{"S":"'$hk_v'"}, :skValue":{"S":"'$sk_v'"}}' | jq .Items
        fi
    elif [[ $1 == "open" ]]; then
        if [[ -z $ADA_REGION ]]; then
            echo ">> No region set, please run ada_export command"
        else
            if [[ -z $2 ]]; then
                open -n -a "Google Chrome" "https://$ADA_REGION.console.aws.amazon.com/dynamodbv2/home?region=$ADA_REGION#item-explorer"
            else
                open -n -a "Google Chrome" "https://$ADA_REGION.console.aws.amazon.com/dynamodbv2/home?region=$ADA_REGION#item-explorer?table=$2"
            fi
        fi
    fi
}

return 1;

