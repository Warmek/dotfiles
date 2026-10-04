import type { Plugin } from "@opencode-ai/plugin"
import { spawn } from "node:child_process"

const MAX_LEN = 120

const truncate = (s: string) => (s.length > MAX_LEN ? s.slice(0, MAX_LEN - 1) + "…" : s)
const clean = (s: string) => s.replace(/\s+/g, " ").trim()

function notify(title: string, body: string) {
  const command = process.env.OPENCODE_NOTIFY_COMMAND ?? "notify-send"
  try {
    const child = spawn(command, ["--app-name", "opencode", title, body], {
      stdio: "ignore",
      detached: true,
    })
    child.unref()
    child.on("error", () => {})
  } catch {
    // never break the agent over a notification
  }
}

export default async (input: Parameters<Plugin>[0]) => {
  const { client } = input
  const sessions = new Map<string, { root: boolean; title: string }>()
  const asked = new Set<string>()

  const remember = (id: string) => {
    asked.add(id)
    if (asked.size > 500) {
      const first = asked.values().next().value
      if (first) asked.delete(first)
    }
  }

  const sessionInfo = async (id: string) => {
    const hit = sessions.get(id)
    if (hit) return hit
    let info = { root: true, title: "" }
    try {
      const { data } = await client.session.get({ path: { id } })
      if (data) info = { root: !data.parentID, title: data.title ?? "" }
    } catch {
      // session gone or API hiccup: assume root so we still notify
    }
    sessions.set(id, info)
    return info
  }

  return {
    event: async (e: any) => {
      const event = e?.event
      const type: string = event?.type
      const p: any = event?.properties
      if (!type) return
      try {
        if (type === "session.created") {
          if (p?.info?.id && p?.info?.parentID) sessions.set(p.info.id, { root: false, title: p.info.title ?? "" })
          return
        }
        if (type === "session.idle") {
          const id: string = p?.sessionID
          if (!id) return
          const info = await sessionInfo(id)
          if (!info.root) return
          notify("opencode: agent done", info.title ? truncate(clean(info.title)) : "The agent is done and waiting for you")
          return
        }
        if (type === "question.asked") {
          const id: string = p?.id
          if (!id || asked.has(id)) return
          remember(id)
          const q: any = Array.isArray(p?.questions) ? p.questions[0] : undefined
          if (q?.question) {
            const more = Array.isArray(p?.questions) && p.questions.length > 1 ? ` (+${p.questions.length - 1} more)` : ""
            notify("opencode: needs your answer", truncate(clean(q.question)) + more)
          } else {
            notify("opencode: needs your answer", "The agent has a question for you")
          }
          return
        }
        if (type === "permission.asked") {
          const id: string = p?.id
          if (!id || asked.has(id)) return
          remember(id)
          const patterns = Array.isArray(p?.patterns) ? p.patterns.join(" ") : typeof p?.patterns === "string" ? p.patterns : ""
          notify("opencode: needs your answer", truncate(clean(`Permission request: ${p?.permission ?? "tool access"} ${patterns}`)))
        }
      } catch {
        // never break the agent over a notification
      }
    },
  }
}
