declare option output:method "csv";

declare variable $query as xs:string external;

let $ts := /lfm/recenttracks/track
let $epoch := xs:dateTime('1970-01-01T00:00:00')
let $oneSecond := xs:dayTimeDuration('PT1S')

return <csv>{
  for $t in $ts
    let $artist := $t/artist/text()
    let $title := $t/name/text()
    let $stamp := number($t/date/@uts)
    let $dateTime := $epoch + $stamp * $oneSecond
    let $date := xs:date($dateTime)
    let $name := concat($artist, ' - ', $title)
    where contains(lower-case($t/artist/text()), lower-case($query))
      or contains(lower-case($t/name/text()), lower-case($query))
    order by $dateTime
    group by $name
    return
      <record>
        <dateTime>{$dateTime[1]}</dateTime>
        <artist>{$artist[1]}</artist>
        <title>{$title[1]}</title>
      </record>
}</csv>