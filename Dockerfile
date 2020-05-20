FROM alpine:latest
    # The provider is aws in provider.tf file
    # For multiple regions you can do 
ENV TF_PLUGIN_CACHE_DIR="/.terraform.d/plugin-cache" \
    TF_VAR_region=us-west-1
RUN apk add --no-cache wget curl jq \
    && wget "https://releases.hashicorp.com/terraform/$(curl "https://checkpoint-api.hashicorp.com/v1/check/terraform" 2>/dev/null \
    | jq -r '.current_version')/terraform_$(curl "https://checkpoint-api.hashicorp.com/v1/check/terraform" 2>/dev/null \
    | jq -r '.current_version')_linux_amd64.zip" \
    && unzip terraform_0.12.25_linux_amd64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/terraform \
    && rm -f terraform*.zip \
    && apk del wget jq
# Installing and making cashed aws terraform plugin in one place.
COPY provider.tf ./
RUN  terraform init
ENTRYPOINT ["sh", "-c"]
