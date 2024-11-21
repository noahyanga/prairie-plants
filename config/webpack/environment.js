const { environment } = require('@rails/webpacker')
const sass = require('./loaders/sass')

environment.loaders.append('sass', sass)
module.exports = environment
