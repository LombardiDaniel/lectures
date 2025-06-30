# R&D with IaC

Daniel Lombardi | 2025-06-09 | [slides](/R&D%20with%20iac/keynote.pdf)

Check out [patos.dev](https://patos.dev)!

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

https://developer.hashicorp.com/terraform/tutorials

https://https://docs.magalu.cloud/docs/devops-tools/cli-mgc/how-to/download-and-install/

## Intro

The main idea of this lecture is to allow users to develop experimetns with IaC and Docker (in MagaluCloud). This means that all their experiments (and data) are easily repeatable.

So what is IaC?

IaC means Infrastructure as Code, so instead of provisioning infrastrutcure (like creating VMs, Storage Buckets etc.) via the Cloud's CLI or UI, we can write it as code where we can easily lock all dependency versions. This means our infra setup is **repeatable**. We can easily reprovision it in case something goes wrong.

By using Terraform (or OpenTofu) we can also destroy everything we create, so in case of needing to change our infra, it's extremely easy and there are no breadcrums left behind. We provision everything and destroy everything.

Terraform is **DECLARATIVE**, this means that we define what we want, not the steps to create it. Instead of saying `print("Hello World!")`, we just say `text: "Hello World!"`, and terraform figures out the steps to make it print. So if we run the same provisioning statements twice, we still get just one copy of our requested infrastructure.
