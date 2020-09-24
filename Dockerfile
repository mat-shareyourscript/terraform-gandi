FROM golang:latest AS builder
WORKDIR /opt/
RUN mkdir -p terraform.d/plugins/linux_amd64/ \
  && git clone https://github.com/go-gandi/terraform-provider-gandi
RUN cd terraform-provider-gandi; CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make; cd ..
RUN cp terraform-provider-gandi/terraform-provider-gandi terraform.d/plugins/linux_amd64/terraform-provider-gandi_v1.0.0


FROM hashicorp/terraform:0.12.29
LABEL org.label-schema.name="terraform-gandi" \
      org.label-schema.url="https://hub.docker.com/r/matshareyourscript/terraform-gandi/" \
      org.label-schema.vcs-url="https://github.com/mat-shareyourscript/terraform-gandi"
ENV TERRAFORM_VERSION="v0.12.29"
RUN mkdir -p ./terraform.d/plugins/linux_amd64 || true
COPY --from=builder /opt/terraform.d/plugins/linux_amd64/terraform-provider-gandi_v1.0.0 ./terraform.d/plugins/linux_amd64/
ENTRYPOINT ["/bin/terraform"]
