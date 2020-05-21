FROM alpine:latest
    # The provider is aws in provider.tf file
    # For multiple regions you can do TF_VAR_region='[us-east-1,us-east-2]' 
    # Installing and making cashed aws terraform plugin in one place.
ENV TF_PLUGIN_CACHE_DIR="/.terraform.d/plugin-cache" \
    TF_VAR_region=us-west-1
COPY provider.tf ./
RUN apk add --no-cache wget curl jq \
    && wget "https://releases.hashicorp.com/terraform/$(curl "https://checkpoint-api.hashicorp.com/v1/check/terraform" 2>/dev/null \
    | jq -r '.current_version')/terraform_$(curl "https://checkpoint-api.hashicorp.com/v1/check/terraform" 2>/dev/null \
    | jq -r '.current_version')_linux_amd64.zip" \
    && unzip terraform_0.12.25_linux_amd64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/terraform \
    && rm -f terraform*.zip \
    && apk del wget jq \
    && terraform init \
    && rm -rf .terraform
CMD ["sh"]
