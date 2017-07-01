import.require 'provision'
import.require 'params'
provision.ruby_base.init() {
    provision.ruby_base.__init() {
        import.useModule 'provision'
        import.useModule 'params'
    }
    provision.ruby_base.require() {
        local -A __params
        __params['method']='rbenv' # or ppa
        params.get "$@"
        if ! provision.isInstalled 'ruby'; then
            if [ "${__params['method']}" == 'ppa' ]; then
                sudo apt-get install -y ruby
                return $?
            elif [ "${__params['method']}" == 'rbenv' ]; then
                provision.ruby_base.installRbenv "$@"
            fi
        fi
        return 0
    }

    provision.ruby_base.installRbenv() {
        # sudo apt-get update
        sudo apt-get install -y \
            git-core \
            curl \
            zlib1g-dev \
            build-essential \
            libssl-dev \
            libreadline-dev \
            libyaml-dev \
            libsqlite3-dev \
            sqlite3 \
            libxml2-dev \
            libxslt1-dev \
            libcurl4-openssl-dev \
            python-software-properties \
            libffi-dev \
        || {
            return "$?"
        }
        git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
        git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
        git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
        source ~/.bashrc

        export PATH="$HOME/.rbenv/bin:$PATH"
        eval "$(rbenv init -)"

        rbenv install 2.3.0
        rbenv global 2.3.0
        rbenv rehash
    }
}
