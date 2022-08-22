

## Testing
### Testing rodauth email

rodauth uses mail gem:
```ruby
Mail.deliver do
  from     'valid email address'
  to       'another valid address'
  subject  'TEST email from heroku'
  body     'TEST'
end
```

