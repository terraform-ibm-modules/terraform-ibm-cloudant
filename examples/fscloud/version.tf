terraform {
  required_version = ">= 1.9.0"

  # Ensure that there is always 1 example locked into the lowest provider version of the range defined in the main
  # module's version.tf (basic example), and 1 example that will always use the latest provider version (dedicated + complete example).
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
<<<<<<< HEAD
      version = ">= 1.88.0, < 2.0.0"
=======
      version = ">= 1.88.0, < 3.0.0"
>>>>>>> 0b913e47cc5e1431e1e0d0902199c60b89663380
    }
  }
}
