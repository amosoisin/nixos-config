# my-config - Custom zsh configuration plugin
# This is the main entry point for the plugin

# Get the directory where this plugin is located
PLUGIN_DIR="${0:A:h}"

# Load environment variables and PATH settings
[[ -f "${PLUGIN_DIR}/env.zsh" ]] && source "${PLUGIN_DIR}/env.zsh"

# Load custom functions
[[ -f "${PLUGIN_DIR}/functions.zsh" ]] && source "${PLUGIN_DIR}/functions.zsh"

# Load aliases
[[ -f "${PLUGIN_DIR}/aliases.zsh" ]] && source "${PLUGIN_DIR}/aliases.zsh"

# Load Powerlevel10k configuration
[[ -f "${PLUGIN_DIR}/p10k.zsh" ]] && source "${PLUGIN_DIR}/p10k.zsh"
