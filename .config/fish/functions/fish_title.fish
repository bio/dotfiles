function fish_title
    # emacs' "term" is basically the only term that can't handle it.
    if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
        set currCommand (status current-command)

        set titleParts
        if set --query argv[1]
            set titleParts $argv[1]
        else if test $currCommand != "fish"
            set titleParts $currCommand
        end
    
        set --append titleParts (fish_prompt_pwd_dir_length=1 prompt_pwd)

        echo (string join ' ' $titleParts);
    end
end
