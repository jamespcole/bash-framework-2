#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'pathing'
import.require 'textprint'
import.require 'provision.motd'
import.require 'provision.figlet'
import.extension 'login_message.help'
resource.relative 'templates/template.bml'

login_message.init() {
    BF2_CAP=0

    login_message.__init() {
        import.useExtension 'login_message.help'
        login_message.args
    }
    login_message.args() {
        args.add --key 'login_message_update' \
            --name 'Update Message' \
            --alias '-u' \
            --alias '--update' \
            --desc 'Update motd with the latest changes you have made to your template' \
            --required-unless 'login_message_create' \
            --required-unless 'login_message_install' \
            --has-value 'n' \
            --type 'switch'

        args.add --key 'login_message_create' \
            --name 'Create Message' \
            --alias '-c' \
            --alias '--create' \
            --desc 'Create a new login message' \
            --required-unless 'login_message_update' \
            --required-unless 'login_message_install' \
            --has-value 'n' \
            --type 'switch'

        args.add --key 'login_force_create' \
            --name 'Create Message' \
            --alias '-f' \
            --alias '--force' \
            --desc 'Overwrite any existing message files' \
            --required '0' \
            --default '0' \
            --has-value 'n' \
            --type 'switch'

        args.add --key 'login_message_name' \
            --name 'Message Name' \
            --alias '-n' \
            --alias '--name' \
            --desc 'Create a new login message' \
            --has-value 'y'

        args.add --key 'login_message_save_project' \
            --name 'Save for Project' \
            --alias '-p' \
            --alias '--project' \
            --desc 'If passed the command will look for a .project_root file and attempt to create the login message in the configs directory.  This is useful when creating messages that you wish to keep in source control.' \
            --required '0' \
            --type 'switch' \
            --default '0' \
            --includes 'login_message_name' \
            --has-value 'n'

        args.add --key 'login_message_install' \
            --name 'Install for Project' \
            --alias '-i' \
            --alias '--install' \
            --desc 'If passed the command will look for an existing rendered version of the message and install it, otherwise it will run re-render and update the message.' \
            --required '0' \
            --type 'switch' \
            --default '0' \
            --includes 'login_message_name' \
            --has-value 'n'
    }
    login_message.main() {

        provision.require 'figlet' || {
            script.exitWithError 'Could not install figlet dependency.'
        }

        local __save_to_proj="${__args_VALS[login_message_save_project]}"
        local __update="${__args_VALS[login_message_update]}"
        local __install="${__args_VALS[login_message_install]}"

        local __msg_path="/home/${USER}/.login-message"

        local __update_command='login_message -u'
        local __msg_env='local'

        if [ "$__save_to_proj" == '1' ]; then
            local __app_root_path
            pathing.closestParentFile --filename '.project_root' \
                --return __app_root_path || {
                    script.exitWithError \
                        "Could not find a .project_root file in a parent directoy of this command"
                }
            local __conf_name="${__args_VALS['login_message_name']}"
            __msg_env="$__conf_name"
            local __config_dir="${__app_root_path}/configs/motd/${__conf_name}"
            __msg_path="$__config_dir"
            __update_command="login_message -u -p -n ${__conf_name}"
        fi

        if [ "${__args_VALS['login_message_create']}" == '1' ]; then
            login_message.createSimple
        elif [ "$__update" == '1' ]; then

            login_message.updateSimple \
                "${__msg_path}/motd.template.bml" \
                '/etc/motd'

        elif [ "$__install" == '1' ]; then
            login_message.installSimple
        fi

        script.exitSuccess "Your script has exited successfully!"
    }
    login_message.createSimple() {
        local __motd_path='/etc/motd'
        mkdir -p "$__msg_path"
        echo "motd.orig.bak" > "${__msg_path}/.gitignore"
        if [ ! -f "${__msg_path}/motd.orig.bak" ]; then
            if [ -f "${__motd_path}" ]; then
                cp "${__motd_path}" "${__msg_path}/motd.orig.bak"
            else
                logger.warning --message \
                    "Could not find an existing motd at \"${__motd_path}\""
            fi
        fi
        local __template_path="${__msg_path}/motd.template.bml"
        resource.get 'templates/template.bml' > "${__template_path}"
        login_message.updateSimple "$__template_path" "$__motd_path"
    }
    login_message.updateSimple() {
        local __template_path="$1"
        local __of_path="$2"

        local __bml
        __bml=$(cat "${__template_path}")
        textprint.printLine --text "${__bml}" > "${__msg_path}/.motd.rendered.txt"
        sudo cp "${__msg_path}/.motd.rendered.txt" "$__of_path"
        cat "${__msg_path}/.motd.rendered.txt"
    }
    login_message.installSimple() {
        local __motd_path='/etc/motd'

        if [ -f "${__msg_path}/.motd.rendered.txt" ]; then
            sudo cp "${__msg_path}/.motd.rendered.txt" "$__motd_path"
            return 0
        elif [ -f "${__msg_path}/motd.template.bml" ]; then
            login_message.updateSimple "${__msg_path}/motd.template.bml" "$__motd_path"
        else
            login_message.createSimple
        fi
    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'login_message' "$@"
fi
