#!/bin/bash
# Uses bash extensions.  Not portable as written.

usage() {
    echo "Usage:"
    echo " $0 [ --loglevel=<value> | --loglevel <value> | -l <value> ] [ --range <beginning> <end> ] [--] [non-option-argument]..."
    echo " $0 [ --help | -h ]"
    echo
    echo "Default loglevel is 0. Default range is 0 to 0"
}

# set defaults
loglevel=0
r1=0 # beginning of range
r2=0 # end of range

i=$(($# + 1)) # index of the first non-existing argument
declare -A longoptspec
# Use associative array to declare how many arguments a long option
# expects. In this case we declare that loglevel expects/has one
# argument and range has two. Long options that aren't listed in this
# way will have zero arguments by default.
longoptspec=( [loglevel]=1 [range]=2 )
optspec=":l:h-:"
while getopts "$optspec" opt; do
while true; do
    case "${opt}" in
        -) #OPTARG is name-of-long-option or name-of-long-option=value
            if [[ ${OPTARG} =~ .*=.* ]] # with this --key=value format only one argument is possible
            then
                opt=${OPTARG/=*/}
                ((${#opt} <= 1)) && {
                    echo "Syntax error: Invalid long option '$opt'" >&2
                    exit 2
                }
                if (($((longoptspec[$opt])) != 1))
                then
                    echo "Syntax error: Option '$opt' does not support this syntax." >&2
                    exit 2
                fi
                OPTARG=${OPTARG#*=}
            else #with this --key value1 value2 format multiple arguments are possible
                opt="$OPTARG"
                ((${#opt} <= 1)) && {
                    echo "Syntax error: Invalid long option '$opt'" >&2
                    exit 2
                }
                OPTARG=(${@:OPTIND:$((longoptspec[$opt]))})
                ((OPTIND+=longoptspec[$opt]))
                #echo $OPTIND
                ((OPTIND > i)) && {
                    echo "Syntax error: Not all required arguments for option '$opt' are given." >&2
                    exit 3
                }
            fi

            continue #now that opt/OPTARG are set we can process them as
            # if getopts would've given us long options
            ;;
        l|loglevel)
            loglevel=$OPTARG
            ;;
        range)
            r1=${OPTARG[0]}
            r2=${OPTARG[1]}
            ;;
        h|help)
            usage
            exit 0
            ;;
        ?)
            echo "Syntax error: Unknown short option '$OPTARG'" >&2
            exit 2
            ;;
        *)
            echo "Syntax error: Unknown long option '$opt'" >&2
            exit 2
            ;;
    esac
break; done
done

echo "Loglevel: $loglevel"
echo "Range: $r1 to $r2"
echo "First non-option-argument (if exists): ${!OPTIND-}"
#echo "Second non-option-argument (if exists): ${!OPTIND-}"

shift "$((OPTIND-1))"   # Discard the options and sentinel --
printf '<%s>\n' "$@"


# End of file
