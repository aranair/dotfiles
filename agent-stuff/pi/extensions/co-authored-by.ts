/**
 * Co-Authored-By Extension
 *
 * Automatically appends a Co-Authored-By git trailer to commit messages
 * when the agent runs `git commit -m`. Credits the model that helped
 * write the code.
 *
 * Example commit message:
 *   fix: resolve null pointer
 *
 *   Co-Authored-By: Claude Sonnet 4 <noreply@pi.dev>
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

/** Check if a command is a `git commit` with a -m message flag. */
function isGitCommit(cmd: string): boolean {
	const normalized = cmd.replace(/\\\n/g, " ");
	return /\bgit\s+commit\b/.test(normalized) && /\s-[^\s]*m\b/.test(normalized);
}

/** Build the rewritten command with a Co-Authored-By trailer. */
function appendTrailer(cmd: string, modelName: string): string {
	const trailer = `Co-Authored-By: ${modelName} <noreply@anthropic.com>`;
	return `${cmd.trimEnd()} -m "" -m $'${trailer}'`;
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		if (!isToolCallEventType("bash", event)) return;

		const cmd = event.input.command;
		if (!isGitCommit(cmd)) return;

		const model = ctx.model;
		const modelName = model ? (model.name || `${model.provider}/${model.id}`) : "unknown";

		event.input.command = appendTrailer(cmd, modelName);
	});
}
