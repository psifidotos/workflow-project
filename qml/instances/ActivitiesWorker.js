WorkerScript.onMessage = function(message) {
    WorkerScript.sendMessage({ ntype: message.type ,ncode:message.code })
 }
