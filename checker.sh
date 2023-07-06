#!/bin/bash
token="<telegram_token>" #CHANGE THIS!
chatid="<chatid>" #CHANGE THIS!
curh="zero"
node=127.0.0.1:26657 #CHANGE THIS!
for ((;;))
do
peer=`curl -s $node/net_info? | jq -r .result.n_peers`
if ((peer>0)); then
echo $peer
else
req="https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid&text='peernotfound'"
wget -qO- $req
fi
newh=$(curl -s $node/status |jq .result.sync_info.latest_block_height)
if [ "$curh" == "$newh" ]; then
req="https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid&text='heightdoesnotmove'"
wget -qO- $req
fi
curh="$newh"
sleep 40
done
