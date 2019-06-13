declare option output:method "csv";

let $ts := /lfm/recenttracks/track
let $epoch := xs:dateTime('1970-01-01T00:00:00')
let $oneSecond := xs:dayTimeDuration('PT1S')

return <csv>{
  for $t in $ts
    let $artist := $t/artist/text()
    let $title := $t/name/text()
    let $stamp := number($t/date/@uts)
    let $dateTime := $epoch + $stamp * $oneSecond
    order by $dateTime
    return
      <record>
        <dateTime>{$dateTime}</dateTime>
        <artist>{$artist}</artist>
        <title>{$title}</title>
      </record>
}</csv>