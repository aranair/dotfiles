import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("agent_end", async () => {
    pi.exec("afplay", ["/System/Library/Sounds/Pop.aiff"]).catch(() => {});
  });
}
