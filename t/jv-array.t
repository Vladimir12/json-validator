use lib '.';
use Mojo::Base -strict;
use t::Helper;

my $simple = {type => 'array', items => {type => 'number'}};
my $length = {type => 'array', minItems => 2, maxItems => 2};
my $unique = {type => 'array', uniqueItems => 1, items => {type => 'integer'}};
my $tuple = {
  type  => 'array',
  items => [
    {type => 'number'},
    {type => 'string'},
    {type => 'string', enum => ['Street', 'Avenue', 'Boulevard']},
    {type => 'string', enum => ['NW', 'NE', 'SW', 'SE']}
  ]
};

validate_ok [1], $simple;
validate_ok [1, 'foo'], $simple, E('/1', 'Expected number - got string.');
validate_ok [1], $length, E('/', 'Not enough items: 1/2.');
validate_ok [1, 2], $length;
validate_ok [1, 2, 3], $length, E('/', 'Too many items: 3/2.');
validate_ok [123, 124], $unique;
validate_ok [1, 2, 1], $unique, E('/', 'Unique items required.');
validate_ok [1600, 'Pennsylvania', 'Avenue', 'NW'], $tuple;
validate_ok [24, 'Sussex',  'Drive'],  $tuple;
validate_ok [10, 'Downing', 'Street'], $tuple;
validate_ok [1600, 'Pennsylvania', 'Avenue', 'NW', 'Washington'], $tuple;

$tuple->{additionalItems} = Mojo::JSON->false;
validate_ok [1600, 'Pennsylvania', 'Avenue', 'NW', 'Washington'], $tuple,
  E('/', 'Invalid number of items: 5/4.');

done_testing;
