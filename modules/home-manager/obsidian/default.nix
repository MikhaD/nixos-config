{...}: {
  programs.obsidian = {
    enable = true;
    vaults.notes = {
      target = "Documents/notes";
    };
    defaultSettings = {
      app = {
        promptDelete = false;
        alwaysUpdateLinks = true;
        newFileLocation = "current";
        attachmentFolderPath = ".attachments";
        userIgnoreFilters = [".attachments/"];
      };
      appearance = {
        theme = "obsidian";
        accentColor = "#008080";
        translucency = false;
        enabledCssSnippets = [
          "admonitions"
          "code-blocks"
          "editor-preview-parity"
          "hr"
          "interface"
          "readable-line-length"
          "tables"
          "tabs"
          "theme"
        ];
      };
      communityPlugins = [
        "table-editor-obsidian"
        "obsidian-checklist-plugin"
        "obsidian-html-tags-autocomplete"
        "url-into-selection"
        "hotkeysplus-obsidian"
        "obsidian-excalidraw-plugin"
        "obsidian-kanban"
        "obsidian-jupyter"
        "table-inserter"
        "obsidian-table-generator"
        "hot-reload"
      ];
      hotkeys = {
        "command-palette:open" = [
          {
            modifiers = [];
            key = "F1";
          }
        ];
        "app:open-help" = []; # was F1
        "editor:cycle-list-checklist" = [
          {
            modifiers = ["Mod"];
            key = "]";
          }
        ];
        "editor:swap-line-down" = [
          {
            modifiers = ["Alt"];
            key = "ArrowDown";
          }
        ];
        "editor:swap-line-up" = [
          {
            modifiers = ["Alt"];
            key = "ArrowUp";
          }
        ];
        "app:go-forward" = [
          {
            modifiers = ["Alt"];
            key = "ArrowRight";
          }
        ];
        "app:go-back" = [
          {
            modifiers = ["Alt"];
            key = "ArrowLeft";
          }
        ];
        "switcher:open" = [
          {
            modifiers = ["Mod"];
            key = "P";
          }
        ];
        "editor:open-link-in-new-leaf" = []; # was Ctrl + Enter
        "open-with-default-app:show" = [
          {
            modifiers = ["Alt" "Meta"];
            key = "E";
          }
        ];
        "editor:toggle-bullet-list" = [
          {
            modifiers = ["Mod"];
            key = "[";
          }
        ];
        "editor:toggle-checklist-status" = []; # was Ctrl + L
        "editor:toggle-highlight" = [
          {
            modifiers = ["Mod"];
            key = "U";
          }
        ];
        "editor:toggle-source" = [
          {
            modifiers = ["Mod"];
            key = "\\";
          }
        ];
        # Hotkeys++ plugin hotkeys
        "hotkeysplus-obsidian:duplicate-lines-up" = [
          {
            modifiers = ["Alt" "Shift"];
            key = "ArrowUp";
          }
        ];
        "hotkeysplus-obsidian:duplicate-lines-down" = [
          {
            modifiers = ["Alt" "Shift"];
            key = "ArrowDown";
          }
        ];
        "hotkeysplus-obsidian:insert-line-above" = [
          {
            modifiers = ["Mod" "Shift"];
            key = "Enter";
          }
        ];
        "hotkeysplus-obsidian:insert-line-below" = [
          {
            modifiers = ["Mod"];
            key = "Enter";
          }
        ];
        "hotkeysplus-obsidian:toggle-block-quote" = [
          {
            modifiers = ["Mod"];
            key = ".";
          }
        ];
        "hotkeysplus-obsidian:better-toggle-todo" = []; # Was Ctrl + M
        "hotkeysplus-obsidian:toggle-bullet-number" = []; # Was Ctrl + Shift + M
        "hotkeysplus-obsidian:toggle-embed" = []; # Was Ctrl + Shift + 1
      };
      cssSnippets = [
        ./css/admonitions.css
        ./css/code-blocks.css
        ./css/editor-preview-parity.css
        ./css/hr.css
        ./css/interface.css
        ./css/readable-line-length.css
        ./css/tables.css
        ./css/tabs.css
        ./css/theme.css
      ];
    };
  };
}
