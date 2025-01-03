# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/rails-nested-form", to: "@stimulus-components--rails-nested-form.js" # @5.0.0
pin "flatpickr" # @4.6.13
pin "stimulus-flatpickr" # @3.0.0
pin "slim-select" # @1.27.1
pin "stimulus-slimselect" # @0.2.0
# pin "gat-logo", to: "gat-logo.png"
