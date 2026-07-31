# Terraform / AWS DevOps development shell
#
# Enter manually:   nix-shell
# Or auto-load:     direnv allow   (with .envrc -> use nix)
#
# Uses OpenTofu (open-source Terraform fork) as the IaC engine.
# The `terraform` command is aliased to `tofu` — fully drop-in compatible.
#
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # -- Terraform / IaC ---------------------------------------------------
    opentofu           # Open-source Terraform fork (drop-in, `tofu` cmd)
    terraform-ls       # HashiCorp Language Server (LSP for editors)
    terraform-docs     # Generate docs from .tf modules
    tfsec              # Security scanner for Terraform code

    # -- AWS ----------------------------------------------------------------
    awscli2            # AWS CLI v2
    ssm-session-manager-plugin  # AWS SSM session manager (EKS/node access)

    # -- Kubernetes / Helm --------------------------------------------------
    kubectl            # Kubernetes CLI
    kubernetes-helm    # Helm 3 package manager

    # -- Utilities ----------------------------------------------------------
    jq                 # JSON processing (terraform outputs, AWS responses)
    yq-go              # YAML processing (Helm values, k8s manifests)
    git                # Version control
    unzip              # Terraform providers sometimes ship as zip
  ];

  shellHook = ''
    # Alias `terraform` -> `tofu` so existing muscle memory and scripts work
    alias terraform='tofu'

    echo "terraform dev shell ready"
    echo ""
    echo "  IaC:        tofu (aliased as 'terraform')"
    echo "  LSP:        terraform-ls"
    echo "  Scanner:    tfsec"
    echo "  Docs:       terraform-docs"
    echo "  AWS:        aws --version"
    echo "  K8s:        kubectl version --client"
    echo "  Helm:       helm version --short"
    echo ""
    echo "  Quick start:"
    echo "    cd <section>/terraform-manifests"
    echo "    terraform init && terraform plan"
    echo ""
    echo "  Format:     terraform fmt -recursive"
    echo "  Validate:   terraform validate"
    echo "  Scan:       tfsec ."
    echo "  Docs:       terraform-docs markdown table ."
  '';
}
