# See: https://github.com/gitpod-io/template-ruby-on-rails-postgres/blob/main/.gitpod.Dockerfile
FROM gitpod/workspace-postgres
# FROM gitpod/workspace-full
USER gitpod

ARG RUBY_VERSION=3.1.2


RUN printf "rvm_gems_path=/home/gitpod/.rvm\n" > ~/.rvmrc \
    && bash -lc "rvm reinstall ruby-${RUBY_VERSION} && rvm use ruby-${RUBY_VERSION} --default && gem install rails" \
    && printf "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc \
    && printf '{ rvm use $(rvm current); } \n' >> "$HOME/.bashrc.d/70-ruby"