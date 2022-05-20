# RSpec::Psychologist - True healing comes from the code itself

💆💆  A hackweek project in celebration of mental health awareness month 💆💆 

Rigid and maladaptive expectations of reality can be a great source of frustration in life and in codebases. By replacing these rigid "musts" with more flexible "preferences" we can be adaptive to inevitable change for things we once thought would never change. 

RSpec::Psychologist is a gem to help you replace incorrect test expectations with more flexible preferences that can be replaced as wants and needs change. 

It is intended for a specific kind of testing, where you have strict inputs and output of values. These kinds of tests are often rigid by design, but they are also subject to entropy and thus change, which can mean situations where the test suit is broken but the codebase is fine. 

By using RSpec::Psychologist for these kinds of tests, tests can be automatically updated in the future when the underlying data has changed. Simply run rspec like `OPEN_TO_SUGGESTIONS=true rspec ...` 

## Installation (TODO)

Add this line to your application's Gemfile:

```ruby
gem 'rspec_psychologist'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec_psychologist

In your `rails_helper.rb`
```ruby
require "rspec_psychologist"

RSpec.configure do |config|
    config.include RSpec::Psychologist
end

```



## Usage

RSpec::Psychologist makes a new helper method available called `prefer_it_be` that returns a `RSpec::PsychologistHelper` instance, from which the `expected` (what we passed to the method) and the `result` (what we actually saw). We must pass `self` to the method in order to pass along the context used to make changesto failed tests. 

Take the following example:

```ruby
preference = prefer_it_be(self, user.calculated_age) do
    29
end 

expect(preference.expected).to eq(preference.result)

```

Lets say the above works fine for 364 days. But then they encounter an unexpected birthday and suddenly they're in their 30's. That means our tests will fail!
But don't wory! when this happens to tests using `prefer_it_be` they can be automatically adjusted. 

```
🙋 It doesn't have to be this way! run again with OPEN_TO_SUGGESTIONS=true to correct

```
This tells RSpec::Psycholgist to make those changes for you. 
```
💁 Setting a more realistic expectation...Rerun your test to verify

```
And now you'll see your test looks like 
```ruby

preference = prefer_it_be(self, user.calculated_age) do
    %Q(--- 30\n)
end 

expect(preference.expected).to eq(preference.result)
```

When you call `preference.result` it will parse the YAML value if it's YAML, otherwise it will return whatever was provided to the block. This means it's easy to refactor tests to use RSpec::Psychologist without a ton of changes. 

## Limitations

the `prefer_it_be` block can contain any ruby object like a Hash, String, Array, Etc. But it cannot contain other `do/end` blocks due to parsing limitations. 

Additionally, it should be possible to replace ruby with ruby (instead of YAML) but that is still unexplored. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meesterdude/rspec_psychologist.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
