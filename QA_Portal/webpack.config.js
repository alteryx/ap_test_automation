var CleanWebpackPlugin = require('clean-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = {
  entry: ['./src/index.js'],

  output: {
    path: __dirname,
    filename: 'main.js'
  },

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },

  module: {
    loaders: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file?name=[name].[ext]'
      },
      // {
      //   test: /main\.js$/,
      //   exclude: [/elm-stuff/, /node_modules/],
      //   loader: 'elm-hot'
      // },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot!elm-webpack?verbose=true&warn=true&debug=true'
      }
    // {
    //   loader: 'elm-webpack',
    //   test: /\.elm$/,
    //   exclude: /node_modules/
    // }
    ],

    noParse: /\.elm$/
  },

  plugins: [
    new CleanWebpackPlugin(['dist'], {
      root: __dirname,
      verbose: true,
      dry: false
    }),
    new CopyWebpackPlugin([
      { from: 'src/assets', to: 'assets'}
    ])
  ],

  devServer: {
    stats: 'errors-only'
  }
}
