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
    let $date := xs:date($dateTime)
    let $name := concat($artist, ' - ', $title)
    where $date >= xs:date('2006-06-01') and $date < xs:date('2006-07-01')
    group by $name
    order by count($t) descending
    return
      <record>
        <artist>{count($t)}</artist>
        <artist>{$artist[1]}</artist>
        <title>{$title[1]}</title>
      </record>
}</csv>