FROM alpine:latest
    # The provider is aws in provider.tf file
    # Installing and making cashed aws terraform plugin in one place.
ENV TF_PLUGIN_CACHE_DIR="/.terraform.d/plugin-cache"
RUN apk add --no-cache wget curl jq \
    && wget "https://releases.hashicorp.com/terraform/$(curl "https://checkpoint-api.hashicorp.com/v1/check/terraform" 2>/dev/null \
    | jq -r '.current_version')/terraform_$(curl "https://checkpoint-api.hashicorp.com/v1/check/terraform" 2>/dev/null \
    | jq -r '.current_version')_linux_amd64.zip" \
    && unzip terraform*.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/terraform \
    && rm -f terraform*.zip \
    && apk del wget jq
COPY provider.tf ./
RUN terraform init \
    && rm -rf .terraform
CMD ["sh"]
