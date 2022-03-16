require("dotenv").config
const Bot = require('node-telegram-bot-api');
const {
    INPUT_STATUS: ipstatus,
    INPUT_TOKEN: tgtoken,//Telegram api token
    INPUT_CHAT: chatid,// Telegram Chat ID
    INPUT_IU_TITLE: ititle,// Issue title
    INPUT_IU_NUM: inum,// Issue Number
    INPUT_IU_ACTOR: iactor,// Issue made by
    INPUT_IU_BODY: ibody,// Issue Body
    INPUT_PR_NUM: pnum,// PR Number
    INPUT_PR_STATE: prstate,// PR Opened, reponed or closed
    INPUT_PR_TITLE: ptitle,// PR Title
    INPUT_PR_BODY: pbody,// Body of the PR
    GITHUB_EVENT_NAME: ghevent,// Name of the trigger event
    GITHUB_REPOSITORY: repo,// Repository the trigger was made from
    GITHUB_ACTOR: ghactor,// User who triggered the action
    GITHUB_SHA: sha,// Commit ID
    GITHUB_WORKFLOW: ghwrkflw// Workflow Name
} = process.env;

const bot = new Bot(tgtoken)

const evresp = (gevent) => {
    switch (gevent) {

        case "issues":
            return `
❗️❗️❗️❗️❗️❗️

Issue ${prstate}

Issue Title and Number  : ${ititle} | #${inum}

Commented or Created By : \`${iactor}\`

Issue Body : *${ibody}*

[Link to Issue](https://github.com/${repo}/issues/${inum})
[Link to Repo ](https://github.com/${repo}/)
[Build log here](https://github.com/${repo}/commit/${sha}/checks)`
        case "pull_request":
            return `
🔃🔀🔃🔀🔃🔀
PR ${prstate} 

PR Number:      ${pnum}

PR Title:       ${ptitle}

PR Body:        *${pbody}*

PR By:          ${ghactor}

[Link to Issue](https://github.com/${repo}/pull/${pnum})
[Link to Repo ](https://github.com/${repo}/)
[Build log here](https://github.com/${repo}/commit/${sha}/checks)`
        default:
            return `
⬆️⇅⬆️⇅

ID: ${ghwrkflw}

Action was a *${ipstatus}!*

\`Repository:  ${repo}\` 

On:          *${ghevent}*

By:            *${ghactor}* 

Tag:        ${process.env.GITHUB_REF}

[Link to Repo ](https://github.com/${repo}/)
            `
    }
}

const output = evresp(ghevent)
bot.sendMessage(chatid,output,{parse_mode : "Markdown"})

