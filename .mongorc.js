// change the prompt
host = db.serverStatus().host;
prompt = function() { return db + '@' + host + '$'; };

// slave ok
rs.slaveOk()

function pretty() { DBQuery.prototype._prettyShell = true; }
function ugly() { DBQuery.prototype._prettyShell = false; }

// DBQuery is the mongo shell's cursor object, so you can chain these
// methods of off any cursor.
Object.assign( DBQuery.prototype, {
  // Pretty-print by default, ugly by command
  _prettyShell : true,
  ugly() { this._prettyShell = false; return this; },
} );

// DBCollection is what you get from `db.whatever`.  Things added here
// get added in the same way as things like `find` and `insert`.
Object.assign( DBCollection.prototype, {
} );

// control batch size (how many are shown before you have to type `it`)
DBQuery.shellBatchSize = 50;

function stringy( val ) {
  if ( typeof val === 'undefined' ) return '';
  if ( typeof val === 'string' ) return val;
  if ( Array.isArray( val ) ) return val.map( stringy ).join( ',' );
  return String( val );
}
function csvrow( arr ) {
  return JSON.stringify( arr.map( stringy ) ).slice( 1, -1 );
}
function printcsv( arr ) { print( csvrow( arr ) ); }

DBQuery.prototype.toCSV = DBCommandCursor.prototype.toCSV = toCSV;
function toCSV( opts={} ) {
  const { columns = [], headers = true } = opts;

  this.forEach( ( rec, idx ) => {
    if ( ! idx ) {
      if ( ! columns.length ) columns.push( ...Object.keys( rec ) );
      if ( headers === true ) printcsv( columns );
      if ( Array.isArray( headers ) ) printcsv( headers );
    }
    printcsv( columns.map( c => rec[ c ] ) );
  } );
}
