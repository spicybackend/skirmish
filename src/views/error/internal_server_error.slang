h1 500 - Internal Server Error
- if Amber.env.development?
  pre = @ex.inspect_with_backtrace
- else
  p Something didn't quite go right, we're taking a look into it!
