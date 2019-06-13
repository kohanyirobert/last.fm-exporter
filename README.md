# About

## Requirements

* [`node`](https://nodejs.org/) - `10.14.2`
* [`basex`](http://basex.org/) - `9.2.2`
* Last.fm API key.

## Running

```
git clone <url> <repository>
cd <repository>
npm install

API_KEY=<api-key> USERNAME=<username> FORMAT=xml DIRECTORY=xml node index.js

# not well-formed XML files need to fixed for this succeed
basex -c 'CREATE DATABASE scrobbles xml'

basex -c 'OPEN scrobbles' -bquery='Rank 1'  find-first-track.xq
```

* `API_KEY` - Last.fm API key.
* `FORMAT` - `xml` or `json`.
* `USERNAME` - Last.fm username.
* `DIRECTORY` - the directory name where files will be downloaded.

### Notes

* The example assumes that `FORMAT` and `DIRECTORY` are both set to `xml`.
This can be `json` as well, but it's not tested.
* The `CREATE DATABASE` command creates the `scrobble` database and imports XML files from the `xml` folder.
Again, JSON can be used somehow, I'm unsure.
