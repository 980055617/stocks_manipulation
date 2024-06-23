FROM ruby:3.3

WORKDIR /frontend

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 8501

CMD ["bundle", "exec", "ruby", "app.rb", "-o", "0.0.0.0","-p","8501"]