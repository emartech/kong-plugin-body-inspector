return {
  name = "body-inspector",
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            log_message = {
              type = "string",
              default = "body-inspector"
            }
          },
          {
            status_code_to_inspect = {
              type = "number",
              default = 502
            }
          }
        }
      }
    }
  }
}