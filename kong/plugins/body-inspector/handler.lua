local BasePlugin = require "kong.plugins.base_plugin"
local concat = table.concat
local kong = kong
local ngx = ngx

local BodyInspectorHandler = BasePlugin:extend()

BodyInspectorHandler.PRIORITY = 799

function BodyInspectorHandler:new()
  BodyInspectorHandler.super.new(self, "body-inspector")
end

function BodyInspectorHandler:body_filter(conf)
  local ctx = ngx.ctx
  local chunk, eof = ngx.arg[1], ngx.arg[2]

  ctx.rt_body_chunks = ctx.rt_body_chunks or {}
  ctx.rt_body_chunk_number = ctx.rt_body_chunk_number or 1

  if eof then
    local chunks = concat(ctx.rt_body_chunks)
    ngx.arg[1] = chunks
    if kong.response.get_status() == conf.status_code_to_inspect then
      kong.log.warn(conf.log_message, ": ", chunks)
    end
  else
    ctx.rt_body_chunks[ctx.rt_body_chunk_number] = chunk
    ctx.rt_body_chunk_number = ctx.rt_body_chunk_number + 1
    ngx.arg[1] = nil
  end
end

return BodyInspectorHandler