# WeatherApp

### WIP
Rails 8 for fun app - WIP.

Roadmap:
- Integrate React & Bootstrap for frontend
- Show stimulus under different path
- Show more weather stats
- Integrate some diagram libraries


Super awesome app to check weather conditions for given localization.


## Prerequisites

- Ruby 3.4.1
- Rails 8.0.0

## Setup

2. Install dependencies:

```bash
bundle install
```

4. Start the server:

```bash
rails server
```

or for use with VSCode debug

```bash
bundle exec rdbg -O -n -c -- bin/rails server -p 3000
```

## Development

### Pre-commit Hooks

This project uses pre-commit hooks to ensure code quality. They run automatically before each commit.

To setup pre-commit hooks:

```bash
pre-commit install
```

### Running Tests

```bash
cp .env.sample .env.test
```

```bash
bundle exec rspec
```

### Code Style

- Ruby code follows the [Ruby Style Guide](https://rubystyle.guide)
- Run `rubocop` to check Ruby code style

## Environment Variables

Copy a `.env.sample` file in the root directory:

```bash
OPEN_WEATHER_API_KEY=YOUR_KEY
```
