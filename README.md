# slack.clje

![Test](https://github.com/ne-sachirou/slack.clje/workflows/Test/badge.svg)

A Slack client for [Clojerl][clojerl].

We are using Slack RTM (Real Time Messageing) API.

## LICENSE

GPL-3.0-or-later

## Installation

`rebar.config`.

```erlang
{deps, […,
        {slack, {git, "git@github.com:ne-sachirou/slack.clje.git", {branch, "master"}}}]}
```

## Usage

Create `gen_event` modules to handle Slack incoming messages.

```clojure
(ns example-bot.handler1
  (:require slack))

(erlang.core/behaviours gen_event)

(defn init [{:keys [name] :as args}] #erl[:ok args])

(defn handle_call [_ state] #erl[:ok :ok state])

(def handle_event
  (fn * ([#erl[:receive-msg #as(msg #erl{})] #as(state #erl{:name name})]
          ; Handle msg here.
          #erl[:ok state])
        ([_ state]
          #erl[:ok state])))
```

The `msg` is a decoded JSON received from Slack RTM API.

Then start a `slack.sup` to give `api-token`, `handlers` & unique `name`.

```clojure
(ns example-bot.sup
  (:require [slack.sup]))

(erlang.core/behaviours supervisor)

(def sup-flags #erl{:strategy  :one_for_one
                    :intensity 1
                    :period    5})

(def child-specs #erl((clj->erl (slack.sup/child-spec {:api-token "Slack API Token"
                                                       :handlers '([:example-bot.handler1 {}])
                                                       :name "example-bot"}))))

(defn start-link []
  (supervisor/start_link #erl[:local :example-bot.sup]
                         :example-bot.sup
                         #erl()))

(defn init [_]
  #erl[:ok #erl[sup-flags child-specs]])
```

To send a message to Slack, call `slack/send-msg.2`.

```clojure
(slack/send-msg name
                #erl{:id id
                     :type "message"
                     :channel channel
                     :text text})
```

[clojerl]: https://github.com/clojerl/clojerl
