const request = require('request')
const util = require('util')
const fs = require("fs")
const xml2js = require('xml2js')

const url_template = `http://ws.audioscrobbler.com/2.0/?method=user.getRecentTracks&username=${process.env.USERNAME}&api_key=${process.env.API_KEY}&limit=200&extended=0&format=${process.env.FORMAT}&page=%s`

function getTotalPages(cb) {
  request.get(util.format(url_template, 1), (err, res, body) => {
    if (err) {
      cb(err)
    } else {
      if (process.env.FORMAT == 'xml') {
        xml2js.parseString(body, function (err, res) {
          cb(err, res.lfm.recenttracks[0].$.totalPages)
        })
      } else if (process.env.FORMAT == 'json') {
        cb(null, JSON.parse(body).recenttracks['@attr'].totalPages)
      } else {
        cb(`Unsupported format: ${process.env.FORMAT}`, null)
      }
    }
  })
}

function getPage(page, cb) {
  request.get(util.format(url_template, page), (err, res, body) => {
    if (err) {
      cb(err)
    } else {
      cb(null, body)
    }
  })
}

getTotalPages((err, totalPages) => {
  console.log('Total number of pages:', totalPages)
  for (let page = 1; page < totalPages; page++) {
    const file = `${process.env.DIRECTORY}/page-${page}.${process.env.FORMAT}`
    fs.access(file, fs.F_OK, (err) => {
      if (err) {
        getPage(page, (err, data) => {
          if (err) {
            console.log(`Problem while getting page ${page}:`, err)
          } else {
            fs.writeFile(file, data, (err) => {
              if (err) {
                console.log(`Problem while writing file (${file}):`, err)
              } else {
                console.log('Created file:', file)
              }
            })
          }
        })
      } else {
        console.log('Already exists:', file)
      }
    })
  }
})
