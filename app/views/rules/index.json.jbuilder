json.array!(@rules) do |rule|
  json.extract! rule, :id, :field, :operator, :value, :triggered
  json.url rule_url(rule, format: :json)
end
