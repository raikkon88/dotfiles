cexec() {
    echo ""
    echo -e " 🟢 \e[32m $@ \e[0m "
    echo ""
    "$@"
}

fexec() {
    echo ""
    echo -e " 🔴 \e[31m $@ \e[0m "
    echo ""
}

tfinit() {
    ENV=${1}
    REGION=${2:-'eu-west-1'}

    # Find Terraform configuration files
    L_VARS=$(find "." -type f -name "${ENV}.tfvars")
    L_BACKEND=$(find "." -type f -name "${ENV}.tfbackend")
    TF_VARS=$(echo ${L_VARS} | grep -i ${REGION} || echo ${L_VARS})
    TF_BACKEND=$(echo ${L_BACKEND} | grep -i ${REGION} || echo ${L_BACKEND})

    # Check if Terraform configuration exists
    if [[ ! -e "terraform.tf" ]]; then
        fexec "ERROR: Terraform configuration NOT found!"
        return 1
    elif [[ -z "${ENV}" ]] && [[ -d "environment" ]]; then
        fexec "ERROR: Environment NOT specified!"
        return 1
    elif [[ -n ${ENV} ]] && [[ -z ${TF_VARS} ]]; then
        fexec "ERROR: ${ENV}.tfvars NOT found!"
        return 1
    else
        # Remove Terraform Cache
        cexec rm -fR .terraform
        cexec rm -f .terraform.lock.hcl
        cexec tfswitch # Init Tfswitch
    fi

    # Terraform Init
    if [[ "${TF_BACKEND}" == *"tfbackend"* ]]; then
        TF_VARS=${TF_BACKEND//tfbackend/tfvars}
        cexec terraform init -upgrade -reconfigure -backend-config="${TF_BACKEND}" -var-file="${TF_VARS}"
    elif [[ "${TF_VARS}" == *"tfvars"* ]]; then
        cexec terraform init -upgrade -reconfigure -var-file="${TF_VARS}"
    else
        cexec terraform init -upgrade -reconfigure
    fi

    # Terraform Workspace List
    cexec terraform workspace list

    # Terraform Workspace Select
    if [[ "$(pwd)" == *"base"* ]]; then
        cexec terraform workspace select default
    else
        cexec terraform workspace select ${ENV}
    fi
}

tfplan() {
    tfchanges plan ${1} ${2}
}

tfapply() {
    tfchanges apply ${1} ${2}
}

tfchanges() {
    METHOD=${1:-'plan'}
    ENV=${2}
    REGION=${3:-'eu-west-1'}

    # Find Terraform configuration files
    L_VARS=$(find "." -type f -name "${ENV}.tfvars")
    TF_VARS=$(echo ${L_VARS} | grep -i ${REGION} || echo ${L_VARS})

    # Terraform Plan/Apply
    if [[ "${TF_VARS}" == *"tfvars"* ]]; then
        cexec terraform ${METHOD} -var-file="${TF_VARS}"
    else
        cexec terraform ${METHOD}
    fi
}

ssm() {
    ID=${1}
    REGION=${2:-'eu-west-1'}
    PROFILE=${3:-'default'}

    if [[ ${ID} =~ "10.0." ]]; then
        PROFILE='augure'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi
    if [[ ${ID} =~ "10.8." ]]; then
        PROFILE='augure'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi

    if [[ ${ID} =~ "10.3." ]]; then
        PROFILE='fashiongps'
        REGION='us-east-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.4." ]]; then
        PROFILE='fashiongps'
        REGION='us-east-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi
    if [[ ${ID} =~ "10.5." ]]; then
        PROFILE='fashiongps'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.6." ]]; then
        PROFILE='fashiongps'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.14." ]]; then
        PROFILE='dataintelligence-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.15." ]]; then
        PROFILE='dataintelligence-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.16." ]]; then
        PROFILE='analytics'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.17." ]]; then
        PROFILE='analytics'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    #if [[ ${ID} =~ "10.20." ]]; then PROFILE='scx'; REGION='eu-west-1' ; echo "PROFILE ---> $PROFILE $REGION - STAGING"; fi
    #if [[ ${ID} =~ "10.21." ]]; then PROFILE='scx'; REGION='eu-west-1' ; echo "PROFILE ---> $PROFILE $REGION - PROD"; fi

    #if [[ ${ID} =~ "10.25." ]]; then PROFILE='mis'; REGION='eu-west-1' ; echo "PROFILE ---> $PROFILE $REGION - STAGING"; fi
    #if [[ ${ID} =~ "10.26." ]]; then PROFILE='mis'; REGION='eu-west-1' ; echo "PROFILE ---> $PROFILE $REGION - PROD"; fi

    if [[ ${ID} =~ "10.35." ]]; then
        PROFILE='visualcontent-staging'
        REGION='us-east-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.36." ]]; then
        PROFILE='visualcontent-prod'
        REGION='us-east-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.46." ]]; then
        PROFILE='contenthub-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.47." ]]; then
        PROFILE='contenthub-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.50." ]]; then
        PROFILE='discover-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.51." ]]; then
        PROFILE='discover-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi
    if [[ ${ID} =~ "10.55." ]]; then
        PROFILE='discover-china-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    #if [[ ${ID} =~ "10.60." ]]; then PROFILE='globalirm-staging'; REGION='ap-east-1' ;      echo "PROFILE ---> $PROFILE $REGION - STAGING"; fi
    #if [[ ${ID} =~ "10.61." ]]; then PROFILE='globalirm-prod'; REGION='ap-southeast-1' ;    echo "PROFILE ---> $PROFILE $REGION - PROD"; fi

    if [[ ${ID} =~ "10.65." ]]; then
        PROFILE='security'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi

    if [[ ${ID} =~ "10.70." ]]; then
        PROFILE='insightsandmetrics-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.71." ]]; then
        PROFILE='insightsandmetrics-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi
    if [[ ${ID} =~ "10.72." ]]; then
        PROFILE='insightsandmetrics-preprod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROPROD"
    fi

    if [[ ${ID} =~ "10.75." ]]; then
        PROFILE='auth-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.76." ]]; then
        PROFILE='auth-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.82." ]]; then
        PROFILE='dmr-staging'
        REGION='eu-south-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.83." ]]; then
        PROFILE='dmr-prod'
        REGION='eu-south-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.85." ]]; then
        PROFILE='bpc-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.86." ]]; then
        PROFILE='bpc-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    #if [[ ${ID} =~ "10.90." ]]; then PROFILE='marketplace-staging'; REGION='eu-west-1' ;   echo "PROFILE ---> $PROFILE $REGION - STAGING"; fi
    if [[ ${ID} =~ "10.91." ]]; then
        PROFILE='marketplace-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi

    if [[ ${ID} =~ "10.95." ]]; then
        PROFILE='atlas-staging'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - STAGING"
    fi
    if [[ ${ID} =~ "10.96." ]]; then
        PROFILE='atlas-prod'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - PROD"
    fi

    if [[ ${ID} =~ "10.100." ]]; then
        PROFILE='sre-ops'
        REGION='eu-west-1'
        echo "PROFILE ---> $PROFILE $REGION - OPS"
    fi

    IPV4_PATTERN="([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})"
    if [[ ${ID} =~ ${IPV4_PATTERN} ]]; then
        ID=$(aws ec2 describe-instances \
            --filters "Name=private-ip-address,Values=$1" \
            --query 'Reservations[0].Instances[0].InstanceId' \
            --output text \
            --region ${REGION} \
            --profile ${PROFILE})
    fi

    aws ssm start-session --target ${ID} --region ${REGION} --profile ${PROFILE}
}

alias tis='tfinit staging'
alias tas='tfapply staging'
alias ts='tfinit staging && tfapply staging'

alias tip='tfinit prod'
alias tap='tfapply prod'
alias tp='tfinit prod && tfapply prod'
alias tipus='tfinit prod us-east-1'
alias tapus='tfapply prod us-east-1'
alias tpus='tfinit prod us-east-1 && tfapply prod us-east-1'

alias tid='tfinit dev'
alias tad='tfapply dev'
alias td='tfinit dev && tfapply dev'
