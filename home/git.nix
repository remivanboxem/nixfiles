{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    # Git settings
    settings = {
      user.name = "Rémi Van Boxem";
      user.email = "remi.vanboxem@uclouvain.be";
      color.ui = "auto";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "hx";
      init.defaultBranch = "main";

      # Stolen from Bartho's config
      alias = {
        cm = "commit -m";
        cma = "! git add . && git commit -m";
        a = "commit --amend";
        a-all = "! git add . && git commit --amend --no-edit";
        f-push = "! git add . && git commit --amend --no-edit && git push --force-with-lease";
        ch = "checkout";
        s = "status -sb";
        unstage = "reset HEAD --";
        uncommit = "reset --soft HEAD^";
        discard = "reset --hard HEAD";
        # graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        g = "! git graph";
        graph = "! git-graph";
        count-lines = "! git log --author=\"$1\" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }' #";
      };
    };

    # Git signing
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/git-signing";
      signByDefault = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };
}
