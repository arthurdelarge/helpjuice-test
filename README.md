# Simple Search Engine with Analytics

This project is a simple search engine that logs user searches and provides analytics on trending and recent searches.

## Main Dependencies

- Ruby 3.3.0
- Rails 7
- PostgreSQL

## Getting Started

### Setup

1. **Clone the repository:**

    ```bash
    git clone https://github.com/arthurdelarge/helpjuice-test.git
    cd helpjuice-test
    ```

2. **Install the dependencies:**

    ```bash
    bundle install
    ```

3. **Set up the database:**

    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Start the server:**

    ```bash
    rails s
    ```

5. **Navigate to the application in your browser:**

    ```
    http://localhost:3000
    ```

### Testing

Run the test suite to ensure everything is working correctly:

```bash
bundle exec rspec -fd
