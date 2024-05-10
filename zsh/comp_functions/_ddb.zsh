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
            'scan: scans first X items in table Y'
        )
        _describe -t operations 'operations' operations && ret=0
    ;;
esac

_list() {
    aws dynamodb list-tables
}

return 1;