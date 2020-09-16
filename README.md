# MS_Tooltip
Displays which specs should roll for MS on raid epics.

## Usage with a World of Warcraft 1.13 client:
* Copy the contents `src` to `<wow>/_classic_/Interface/AddOns`
* Start the client and enable the addon as usual

Extracted from Google Sheets with this JS:
```js
var title = document.location.href.split('/')[document.location.href.split('/').length-1].split('.')[0]
var table = document.querySelectorAll("tbody tr");
var cols = table[0].querySelectorAll("td")
var headers = [];
for(var i = 0;i<cols.length;i++)
{
  headers.push(cols[i].innerText)
}


var data = [];

for(var i = 2;i<table.length;i++)
{
  var row = table[i].querySelectorAll("td")
  if (row[0].firstChild.nodeName != "A"){
    if (row[0].firstChild.firstChild != null) {
      if (row[0].firstChild.firstChild.nodeName != "A"){
        console.log(row[0]);
        continue;
      }
    } else {
      continue;
    }
  }
  var url = row[0].querySelector("a").href
  var id = url.match(/(?:item=)(\d+)/)[1]
  var name = row[0].innerText

  var ms = []
  var os = []
  var prio = []
  var notes = null

  for(var j = 0;j<row.length;j++)
  {
    if (headers[j] == 'Notes')
    {
      notes = row[j].innerText
    } else {
      if (row[j].innerText.indexOf("Prio") > -1)
      {
        prio.push(headers[j])
      }
      if (row[j].innerText == "MS")
      {
        ms.push(headers[j])
      }
      if (row[j].innerText == "OS")
      {
        os.push(headers[j])
      }
    }
  }
  data.push({id:id,name:name,prio:prio,ms:ms,os:os,notes:notes})
}

var out = `MS_Items[\"${title}\"] = {\n`

for(var i = 0;i<data.length;i++)
{
  out += "    ["+data[i].id+"] = { -- "+data[i].name+"\n"
  if(data[i].prio.length) {
    out += "        [\"PRIO\"] = {"
    for(var j = 0;j<data[i].prio.length;j++)
    {
      out += '"'+data[i].prio[j]+'", '
    }
    out += "},\n"
  }
  out += "        [\"MS\"] = {"
  for(var j = 0;j<data[i].ms.length;j++)
  {
    out += '"'+data[i].ms[j]+'", '
  }
  if(data[i].os.length){
    out += "},\n"
    out += "        [\"OS\"] = {"
    for(var j = 0;j<data[i].os.length;j++)
    {
      out += '"'+data[i].os[j]+'", '
    }
  }
  out += "}"
  if(data[i].notes) out += `,\n        ["Notes"] = "${data[i].notes}"`
  out += "\n    },\n"
}
out += "}"
console.log(out)
```
