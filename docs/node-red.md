# Node-RED: filtering alerts from MQTT

A base node bridges the mesh to MQTT. With JSON output enabled on the base node, text
messages arrive as JSON with `type: "text"` and `payload.text`. The alert and acknowledgement
texts start with the bell character `\u0007`.

Flow: `mqtt in` (topic `msh/<region>/2/json/<channel>/#`) -> `json` -> function node below -> notification node of your choice.

```js
// Function node: pass only help/ack texts, tag them by kind.
const text = msg.payload && msg.payload.payload && msg.payload.payload.text;
if (msg.payload.type !== "text" || typeof text !== "string" || text[0] !== "\u0007") {
    return null;
}
const body = text.slice(1);
msg.kind = body === "OK" ? "ack" : "alert";
msg.topic = `${msg.kind}: ${body}`;
msg.payload = { from: msg.payload.from, sender: msg.payload.sender, text: body, kind: msg.kind };
return msg;
```

Adjust the JSON field names to your Meshtastic version if they differ (inspect a message with a `debug` node).
The same filter can drive a "come home" sender: publish a text starting with `\u0007` to the downlink topic.
