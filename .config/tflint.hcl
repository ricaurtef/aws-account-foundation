plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Wrapper modules declare providers for passthrough to child modules.
# TFLint flags this as unused, but it's required for provider inheritance.
rule "terraform_unused_required_providers" {
  enabled = false
}

plugin "aws" {
  enabled = true
  version = "0.45.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
