local typedefs = require "kong.db.schema.typedefs"

return {
  name = "biolerplate",
  fields = {
    {
      consumer = typedefs.no_consumer
    },
    {
      config = {
        type = "record",
        fields = {
          {
            say_hello = { 
              type = "boolean", 
              default = true 
            }
          }
        }
      }
    }
  }
}