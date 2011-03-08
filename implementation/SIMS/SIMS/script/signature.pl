use strict;
use warnings;
use SDL;
use SDLx::App;
use SDL::Video;
use JSON;

my $json_sign = '
[{"lx":7,"ly":27,"mx":7,"my":27},{"lx":9,"ly":27,"mx":7,"my":27},{"lx":10,"ly":27,"mx":9,"my":27},{"lx":11,"ly":27,"mx":10,"my":27},{"lx":13,"ly":27,"mx":11,"my":27},{"lx":13,"ly":26,"mx":13,"my":27},{"lx":14,"ly":26,"mx":13,"my":26},{"lx":14,"ly":25,"mx":14,"my":26},{"lx":16,"ly":25,"mx":14,"my":25},{"lx":16,"ly":24,"mx":16,"my":25},{"lx":18,"ly":24,"mx":16,"my":24},{"lx":19,"ly":23,"mx":18,"my":24},{"lx":20,"ly":22,"mx":19,"my":23},{"lx":23,"ly":22,"mx":20,"my":22},{"lx":24,"ly":19,"mx":23,"my":22},{"lx":27,"ly":19,"mx":24,"my":19},{"lx":30,"ly":17,"mx":27,"my":19},{"lx":30,"ly":15,"mx":30,"my":17},{"lx":31,"ly":14,"mx":30,"my":15},{"lx":34,"ly":14,"mx":31,"my":14},{"lx":38,"ly":14,"mx":34,"my":14},{"lx":39,"ly":12,"mx":38,"my":14},{"lx":40,"ly":11,"mx":39,"my":12},{"lx":42,"ly":11,"mx":40,"my":11},{"lx":42,"ly":10,"mx":42,"my":11},{"lx":43,"ly":10,"mx":42,"my":10},{"lx":43,"ly":9,"mx":43,"my":10},{"lx":44,"ly":9,"mx":43,"my":9},{"lx":46,"ly":9,"mx":44,"my":9},{"lx":47,"ly":8,"mx":46,"my":9},{"lx":47,"ly":7,"mx":47,"my":8},{"lx":48,"ly":6,"mx":47,"my":7},{"lx":48,"ly":7,"mx":48,"my":6},{"lx":48,"ly":8,"mx":48,"my":7},{"lx":48,"ly":9,"mx":48,"my":8},{"lx":48,"ly":11,"mx":48,"my":9},{"lx":48,"ly":12,"mx":48,"my":11},{"lx":47,"ly":14,"mx":48,"my":12},{"lx":45,"ly":14,"mx":47,"my":14},{"lx":45,"ly":16,"mx":45,"my":14},{"lx":45,"ly":18,"mx":45,"my":16},{"lx":44,"ly":19,"mx":45,"my":18},{"lx":44,"ly":22,"mx":44,"my":19},{"lx":44,"ly":24,"mx":44,"my":22},{"lx":43,"ly":24,"mx":44,"my":24},{"lx":43,"ly":25,"mx":43,"my":24},{"lx":42,"ly":25,"mx":43,"my":25},{"lx":42,"ly":27,"mx":42,"my":25},{"lx":41,"ly":28,"mx":42,"my":27},{"lx":41,"ly":29,"mx":41,"my":28},{"lx":40,"ly":29,"mx":41,"my":29},{"lx":40,"ly":30,"mx":40,"my":29},{"lx":40,"ly":31,"mx":40,"my":30},{"lx":40,"ly":32,"mx":40,"my":31},{"lx":39,"ly":33,"mx":40,"my":32},{"lx":67,"ly":9,"mx":67,"my":9},{"lx":66,"ly":9,"mx":67,"my":9},{"lx":66,"ly":10,"mx":66,"my":9},{"lx":63,"ly":10,"mx":66,"my":10},{"lx":62,"ly":11,"mx":63,"my":10},{"lx":61,"ly":13,"mx":62,"my":11},{"lx":58,"ly":15,"mx":61,"my":13},{"lx":57,"ly":16,"mx":58,"my":15},{"lx":55,"ly":16,"mx":57,"my":16},{"lx":53,"ly":17,"mx":55,"my":16},{"lx":52,"ly":17,"mx":53,"my":17},{"lx":52,"ly":19,"mx":52,"my":17},{"lx":50,"ly":19,"mx":52,"my":19},{"lx":49,"ly":19,"mx":50,"my":19},{"lx":49,"ly":20,"mx":49,"my":19},{"lx":47,"ly":20,"mx":49,"my":20},{"lx":46,"ly":20,"mx":47,"my":20},{"lx":45,"ly":20,"mx":46,"my":20},{"lx":46,"ly":20,"mx":45,"my":20},{"lx":47,"ly":20,"mx":46,"my":20},{"lx":48,"ly":20,"mx":47,"my":20},{"lx":49,"ly":20,"mx":48,"my":20},{"lx":50,"ly":20,"mx":49,"my":20},{"lx":50,"ly":21,"mx":50,"my":20},{"lx":52,"ly":21,"mx":50,"my":21},{"lx":53,"ly":21,"mx":52,"my":21},{"lx":53,"ly":22,"mx":53,"my":21},{"lx":54,"ly":22,"mx":53,"my":22},{"lx":55,"ly":23,"mx":54,"my":22},{"lx":56,"ly":23,"mx":55,"my":23},{"lx":56,"ly":25,"mx":56,"my":23},{"lx":57,"ly":26,"mx":56,"my":25},{"lx":58,"ly":26,"mx":57,"my":26},{"lx":59,"ly":26,"mx":58,"my":26},{"lx":60,"ly":27,"mx":59,"my":26},{"lx":61,"ly":28,"mx":60,"my":27},{"lx":61,"ly":29,"mx":61,"my":28},{"lx":62,"ly":29,"mx":61,"my":29},{"lx":63,"ly":30,"mx":62,"my":29},{"lx":64,"ly":30,"mx":63,"my":30},{"lx":65,"ly":30,"mx":64,"my":30},{"lx":65,"ly":31,"mx":65,"my":30},{"lx":66,"ly":31,"mx":65,"my":31},{"lx":67,"ly":31,"mx":66,"my":31},{"lx":68,"ly":31,"mx":67,"my":31},{"lx":68,"ly":32,"mx":68,"my":31},{"lx":69,"ly":32,"mx":68,"my":32},{"lx":71,"ly":32,"mx":69,"my":32},{"lx":72,"ly":32,"mx":71,"my":32},{"lx":73,"ly":32,"mx":72,"my":32},{"lx":74,"ly":32,"mx":73,"my":32},{"lx":75,"ly":32,"mx":74,"my":32},{"lx":75,"ly":31,"mx":75,"my":32},{"lx":76,"ly":31,"mx":75,"my":31},{"lx":76,"ly":30,"mx":76,"my":31},{"lx":77,"ly":29,"mx":76,"my":30},{"lx":77,"ly":28,"mx":77,"my":29},{"lx":77,"ly":27,"mx":77,"my":28},{"lx":78,"ly":27,"mx":77,"my":27},{"lx":79,"ly":26,"mx":78,"my":27},{"lx":80,"ly":26,"mx":79,"my":26},{"lx":81,"ly":26,"mx":80,"my":26},{"lx":81,"ly":25,"mx":81,"my":26},{"lx":81,"ly":24,"mx":81,"my":25},{"lx":80,"ly":24,"mx":81,"my":24},{"lx":82,"ly":21,"mx":80,"my":24},{"lx":82,"ly":20,"mx":82,"my":21},{"lx":80,"ly":19,"mx":82,"my":20},{"lx":79,"ly":18,"mx":80,"my":19},{"lx":78,"ly":18,"mx":79,"my":18},{"lx":76,"ly":17,"mx":78,"my":18},{"lx":75,"ly":17,"mx":76,"my":17},{"lx":73,"ly":16,"mx":75,"my":17},{"lx":73,"ly":15,"mx":73,"my":16},{"lx":72,"ly":15,"mx":73,"my":15},{"lx":71,"ly":15,"mx":72,"my":15},{"lx":71,"ly":16,"mx":71,"my":15},{"lx":70,"ly":16,"mx":71,"my":16},{"lx":70,"ly":18,"mx":70,"my":16},{"lx":70,"ly":19,"mx":70,"my":18},{"lx":70,"ly":20,"mx":70,"my":19},{"lx":70,"ly":21,"mx":70,"my":20},{"lx":71,"ly":21,"mx":70,"my":21},{"lx":71,"ly":22,"mx":71,"my":21},{"lx":71,"ly":23,"mx":71,"my":22},{"lx":72,"ly":24,"mx":71,"my":23},{"lx":73,"ly":24,"mx":72,"my":24},{"lx":74,"ly":25,"mx":73,"my":24},{"lx":76,"ly":25,"mx":74,"my":25},{"lx":77,"ly":25,"mx":76,"my":25},{"lx":77,"ly":24,"mx":77,"my":25},{"lx":78,"ly":24,"mx":77,"my":24},{"lx":78,"ly":22,"mx":78,"my":24},{"lx":79,"ly":22,"mx":78,"my":22},{"lx":79,"ly":21,"mx":79,"my":22},{"lx":79,"ly":20,"mx":79,"my":21},{"lx":79,"ly":19,"mx":79,"my":20},{"lx":79,"ly":18,"mx":79,"my":19},{"lx":79,"ly":19,"mx":79,"my":18},{"lx":79,"ly":20,"mx":79,"my":19},{"lx":80,"ly":20,"mx":79,"my":20},{"lx":80,"ly":21,"mx":80,"my":20},{"lx":80,"ly":22,"mx":80,"my":21},{"lx":80,"ly":23,"mx":80,"my":22},{"lx":80,"ly":24,"mx":80,"my":23},{"lx":80,"ly":25,"mx":80,"my":24},{"lx":81,"ly":26,"mx":80,"my":25},{"lx":81,"ly":27,"mx":81,"my":26},{"lx":81,"ly":28,"mx":81,"my":27},{"lx":81,"ly":29,"mx":81,"my":28},{"lx":83,"ly":30,"mx":81,"my":29},{"lx":84,"ly":30,"mx":83,"my":30},{"lx":85,"ly":30,"mx":84,"my":30},{"lx":86,"ly":30,"mx":85,"my":30},{"lx":87,"ly":30,"mx":86,"my":30},{"lx":87,"ly":29,"mx":87,"my":30},{"lx":87,"ly":28,"mx":87,"my":29},{"lx":88,"ly":27,"mx":87,"my":28},{"lx":89,"ly":26,"mx":88,"my":27},{"lx":89,"ly":25,"mx":89,"my":26},{"lx":89,"ly":24,"mx":89,"my":25},{"lx":89,"ly":23,"mx":89,"my":24},{"lx":87,"ly":23,"mx":89,"my":23},{"lx":87,"ly":22,"mx":87,"my":23},{"lx":85,"ly":20,"mx":87,"my":22},{"lx":84,"ly":20,"mx":85,"my":20},{"lx":84,"ly":19,"mx":84,"my":20},{"lx":84,"ly":18,"mx":84,"my":19},{"lx":84,"ly":17,"mx":84,"my":18},{"lx":83,"ly":17,"mx":84,"my":17},{"lx":83,"ly":16,"mx":83,"my":17},{"lx":82,"ly":16,"mx":83,"my":16},{"lx":83,"ly":16,"mx":82,"my":16},{"lx":84,"ly":16,"mx":83,"my":16},{"lx":85,"ly":16,"mx":84,"my":16},{"lx":86,"ly":16,"mx":85,"my":16},{"lx":87,"ly":16,"mx":86,"my":16},{"lx":88,"ly":17,"mx":87,"my":16},{"lx":88,"ly":18,"mx":88,"my":17},{"lx":89,"ly":18,"mx":88,"my":18},{"lx":89,"ly":21,"mx":89,"my":18},{"lx":90,"ly":21,"mx":89,"my":21},{"lx":90,"ly":23,"mx":90,"my":21},{"lx":90,"ly":24,"mx":90,"my":23},{"lx":91,"ly":24,"mx":90,"my":24},{"lx":93,"ly":26,"mx":91,"my":24},{"lx":93,"ly":27,"mx":93,"my":26},{"lx":93,"ly":28,"mx":93,"my":27},{"lx":94,"ly":28,"mx":93,"my":28},{"lx":94,"ly":30,"mx":94,"my":28},{"lx":95,"ly":31,"mx":94,"my":30},{"lx":95,"ly":32,"mx":95,"my":31},{"lx":95,"ly":33,"mx":95,"my":32},{"lx":95,"ly":34,"mx":95,"my":33},{"lx":96,"ly":34,"mx":95,"my":34},{"lx":97,"ly":34,"mx":96,"my":34},{"lx":98,"ly":34,"mx":97,"my":34},{"lx":99,"ly":34,"mx":98,"my":34},{"lx":100,"ly":34,"mx":99,"my":34},{"lx":101,"ly":34,"mx":100,"my":34},{"lx":101,"ly":33,"mx":101,"my":34},{"lx":102,"ly":33,"mx":101,"my":33},{"lx":103,"ly":33,"mx":102,"my":33},{"lx":104,"ly":33,"mx":103,"my":33},{"lx":105,"ly":32,"mx":104,"my":33},{"lx":106,"ly":32,"mx":105,"my":32},{"lx":107,"ly":31,"mx":106,"my":32},{"lx":108,"ly":30,"mx":107,"my":31},{"lx":109,"ly":30,"mx":108,"my":30},{"lx":110,"ly":29,"mx":109,"my":30},{"lx":111,"ly":28,"mx":110,"my":29},{"lx":113,"ly":28,"mx":111,"my":28},{"lx":113,"ly":27,"mx":113,"my":28},{"lx":114,"ly":27,"mx":113,"my":27},{"lx":115,"ly":27,"mx":114,"my":27},{"lx":115,"ly":26,"mx":115,"my":27},{"lx":116,"ly":26,"mx":115,"my":26},{"lx":116,"ly":25,"mx":116,"my":26},{"lx":117,"ly":24,"mx":116,"my":25},{"lx":117,"ly":23,"mx":117,"my":24},{"lx":117,"ly":22,"mx":117,"my":23},{"lx":117,"ly":21,"mx":117,"my":22},{"lx":117,"ly":20,"mx":117,"my":21},{"lx":117,"ly":19,"mx":117,"my":20},{"lx":117,"ly":18,"mx":117,"my":19},{"lx":117,"ly":17,"mx":117,"my":18},{"lx":116,"ly":16,"mx":117,"my":17},{"lx":116,"ly":15,"mx":116,"my":16},{"lx":115,"ly":14,"mx":116,"my":15},{"lx":115,"ly":13,"mx":115,"my":14},{"lx":115,"ly":12,"mx":115,"my":13},{"lx":114,"ly":12,"mx":115,"my":12},{"lx":114,"ly":10,"mx":114,"my":12},{"lx":113,"ly":9,"mx":114,"my":10},{"lx":113,"ly":8,"mx":113,"my":9},{"lx":113,"ly":7,"mx":113,"my":8},{"lx":112,"ly":7,"mx":113,"my":7},{"lx":111,"ly":7,"mx":112,"my":7},{"lx":111,"ly":5,"mx":111,"my":7},{"lx":111,"ly":6,"mx":111,"my":5},{"lx":111,"ly":7,"mx":111,"my":6},{"lx":111,"ly":9,"mx":111,"my":7},{"lx":111,"ly":11,"mx":111,"my":9},{"lx":111,"ly":12,"mx":111,"my":11},{"lx":111,"ly":13,"mx":111,"my":12},{"lx":112,"ly":14,"mx":111,"my":13},{"lx":112,"ly":16,"mx":112,"my":14},{"lx":112,"ly":17,"mx":112,"my":16},{"lx":112,"ly":19,"mx":112,"my":17},{"lx":112,"ly":21,"mx":112,"my":19},{"lx":112,"ly":22,"mx":112,"my":21},{"lx":112,"ly":23,"mx":112,"my":22},{"lx":112,"ly":24,"mx":112,"my":23},{"lx":112,"ly":25,"mx":112,"my":24},{"lx":113,"ly":26,"mx":112,"my":25},{"lx":113,"ly":27,"mx":113,"my":26},{"lx":113,"ly":28,"mx":113,"my":27},{"lx":113,"ly":29,"mx":113,"my":28},{"lx":112,"ly":30,"mx":113,"my":29},{"lx":112,"ly":31,"mx":112,"my":30},{"lx":112,"ly":32,"mx":112,"my":31},{"lx":112,"ly":33,"mx":112,"my":32},{"lx":112,"ly":34,"mx":112,"my":33},{"lx":113,"ly":34,"mx":112,"my":34},{"lx":114,"ly":34,"mx":113,"my":34},{"lx":115,"ly":34,"mx":114,"my":34},{"lx":116,"ly":34,"mx":115,"my":34},{"lx":116,"ly":33,"mx":116,"my":34},{"lx":117,"ly":32,"mx":116,"my":33},{"lx":118,"ly":31,"mx":117,"my":32},{"lx":119,"ly":31,"mx":118,"my":31},{"lx":119,"ly":29,"mx":119,"my":31},{"lx":120,"ly":28,"mx":119,"my":29},{"lx":121,"ly":28,"mx":120,"my":28},{"lx":121,"ly":27,"mx":121,"my":28},{"lx":122,"ly":26,"mx":121,"my":27},{"lx":122,"ly":25,"mx":122,"my":26},{"lx":122,"ly":24,"mx":122,"my":25},{"lx":122,"ly":23,"mx":122,"my":24},{"lx":123,"ly":23,"mx":122,"my":23},{"lx":123,"ly":24,"mx":123,"my":23},{"lx":123,"ly":25,"mx":123,"my":24},{"lx":124,"ly":26,"mx":123,"my":25},{"lx":125,"ly":27,"mx":124,"my":26},{"lx":125,"ly":28,"mx":125,"my":27},{"lx":125,"ly":29,"mx":125,"my":28},{"lx":125,"ly":30,"mx":125,"my":29},{"lx":126,"ly":31,"mx":125,"my":30},{"lx":127,"ly":32,"mx":126,"my":31},{"lx":127,"ly":33,"mx":127,"my":32},{"lx":128,"ly":34,"mx":127,"my":33},{"lx":129,"ly":34,"mx":128,"my":34},{"lx":129,"ly":35,"mx":129,"my":34},{"lx":131,"ly":36,"mx":129,"my":35},{"lx":132,"ly":36,"mx":131,"my":36},{"lx":133,"ly":36,"mx":132,"my":36},{"lx":134,"ly":36,"mx":133,"my":36},{"lx":135,"ly":36,"mx":134,"my":36},{"lx":136,"ly":36,"mx":135,"my":36},{"lx":137,"ly":36,"mx":136,"my":36},{"lx":138,"ly":35,"mx":137,"my":36},{"lx":139,"ly":35,"mx":138,"my":35},{"lx":140,"ly":34,"mx":139,"my":35},{"lx":140,"ly":32,"mx":140,"my":34},{"lx":142,"ly":30,"mx":140,"my":32},{"lx":143,"ly":27,"mx":142,"my":30},{"lx":143,"ly":26,"mx":143,"my":27},{"lx":144,"ly":26,"mx":143,"my":26},{"lx":144,"ly":25,"mx":144,"my":26},{"lx":144,"ly":24,"mx":144,"my":25},{"lx":144,"ly":23,"mx":144,"my":24},{"lx":144,"ly":22,"mx":144,"my":23},{"lx":144,"ly":21,"mx":144,"my":22},{"lx":144,"ly":19,"mx":144,"my":21},{"lx":145,"ly":18,"mx":144,"my":19},{"lx":145,"ly":17,"mx":145,"my":18},{"lx":145,"ly":16,"mx":145,"my":17},{"lx":145,"ly":15,"mx":145,"my":16},{"lx":145,"ly":13,"mx":145,"my":15},{"lx":145,"ly":12,"mx":145,"my":13},{"lx":145,"ly":11,"mx":145,"my":12},{"lx":145,"ly":9,"mx":145,"my":11},{"lx":145,"ly":8,"mx":145,"my":9},{"lx":145,"ly":7,"mx":145,"my":8},{"lx":145,"ly":6,"mx":145,"my":7},{"lx":145,"ly":7,"mx":145,"my":6},{"lx":145,"ly":9,"mx":145,"my":7},{"lx":146,"ly":11,"mx":145,"my":9},{"lx":146,"ly":12,"mx":146,"my":11},{"lx":146,"ly":14,"mx":146,"my":12},{"lx":146,"ly":16,"mx":146,"my":14},{"lx":146,"ly":18,"mx":146,"my":16},{"lx":146,"ly":19,"mx":146,"my":18},{"lx":146,"ly":21,"mx":146,"my":19},{"lx":146,"ly":22,"mx":146,"my":21},{"lx":146,"ly":24,"mx":146,"my":22},{"lx":146,"ly":25,"mx":146,"my":24},{"lx":144,"ly":27,"mx":146,"my":25},{"lx":144,"ly":28,"mx":144,"my":27},{"lx":143,"ly":29,"mx":144,"my":28},{"lx":143,"ly":31,"mx":143,"my":29},{"lx":142,"ly":31,"mx":143,"my":31},{"lx":142,"ly":33,"mx":142,"my":31},{"lx":142,"ly":34,"mx":142,"my":33},{"lx":142,"ly":35,"mx":142,"my":34},{"lx":139,"ly":36,"mx":142,"my":35},{"lx":139,"ly":38,"mx":139,"my":36},{"lx":139,"ly":39,"mx":139,"my":38},{"lx":138,"ly":39,"mx":139,"my":39},{"lx":137,"ly":39,"mx":138,"my":39},{"lx":137,"ly":38,"mx":137,"my":39},{"lx":137,"ly":37,"mx":137,"my":38},{"lx":137,"ly":36,"mx":137,"my":37},{"lx":135,"ly":33,"mx":137,"my":36},{"lx":135,"ly":29,"mx":135,"my":33},{"lx":135,"ly":27,"mx":135,"my":29},{"lx":135,"ly":23,"mx":135,"my":27},{"lx":135,"ly":21,"mx":135,"my":23},{"lx":135,"ly":18,"mx":135,"my":21},{"lx":135,"ly":17,"mx":135,"my":18},{"lx":135,"ly":16,"mx":135,"my":17},{"lx":135,"ly":15,"mx":135,"my":16},{"lx":135,"ly":14,"mx":135,"my":15},{"lx":136,"ly":13,"mx":135,"my":14},{"lx":136,"ly":12,"mx":136,"my":13},{"lx":137,"ly":11,"mx":136,"my":12},{"lx":138,"ly":11,"mx":137,"my":11},{"lx":138,"ly":10,"mx":138,"my":11},{"lx":139,"ly":10,"mx":138,"my":10},{"lx":141,"ly":9,"mx":139,"my":10},{"lx":142,"ly":9,"mx":141,"my":9},{"lx":143,"ly":9,"mx":142,"my":9},{"lx":144,"ly":9,"mx":143,"my":9},{"lx":145,"ly":8,"mx":144,"my":9},{"lx":146,"ly":8,"mx":145,"my":8},{"lx":147,"ly":8,"mx":146,"my":8},{"lx":149,"ly":10,"mx":147,"my":8},{"lx":150,"ly":11,"mx":149,"my":10},{"lx":150,"ly":12,"mx":150,"my":11},{"lx":151,"ly":12,"mx":150,"my":12},{"lx":152,"ly":13,"mx":151,"my":12},{"lx":153,"ly":14,"mx":152,"my":13},{"lx":153,"ly":15,"mx":153,"my":14},{"lx":153,"ly":16,"mx":153,"my":15},{"lx":153,"ly":18,"mx":153,"my":16},{"lx":153,"ly":19,"mx":153,"my":18},{"lx":153,"ly":20,"mx":153,"my":19},{"lx":152,"ly":20,"mx":153,"my":20},{"lx":151,"ly":22,"mx":152,"my":20},{"lx":151,"ly":23,"mx":151,"my":22},{"lx":150,"ly":23,"mx":151,"my":23},{"lx":150,"ly":24,"mx":150,"my":23},{"lx":150,"ly":25,"mx":150,"my":24},{"lx":149,"ly":26,"mx":150,"my":25},{"lx":147,"ly":26,"mx":149,"my":26},{"lx":146,"ly":27,"mx":147,"my":26},{"lx":146,"ly":28,"mx":146,"my":27},{"lx":145,"ly":28,"mx":146,"my":28},{"lx":145,"ly":29,"mx":145,"my":28},{"lx":146,"ly":29,"mx":145,"my":29},{"lx":148,"ly":29,"mx":146,"my":29},{"lx":149,"ly":29,"mx":148,"my":29},{"lx":151,"ly":29,"mx":149,"my":29},{"lx":152,"ly":29,"mx":151,"my":29},{"lx":153,"ly":29,"mx":152,"my":29},{"lx":154,"ly":29,"mx":153,"my":29},{"lx":158,"ly":29,"mx":154,"my":29},{"lx":159,"ly":29,"mx":158,"my":29},{"lx":160,"ly":29,"mx":159,"my":29},{"lx":162,"ly":29,"mx":160,"my":29},{"lx":163,"ly":29,"mx":162,"my":29},{"lx":164,"ly":29,"mx":163,"my":29},{"lx":167,"ly":29,"mx":164,"my":29},{"lx":169,"ly":29,"mx":167,"my":29},{"lx":170,"ly":30,"mx":169,"my":29},{"lx":174,"ly":30,"mx":170,"my":30},{"lx":175,"ly":30,"mx":174,"my":30},{"lx":176,"ly":30,"mx":175,"my":30},{"lx":177,"ly":30,"mx":176,"my":30},{"lx":178,"ly":30,"mx":177,"my":30},{"lx":179,"ly":30,"mx":178,"my":30},{"lx":180,"ly":30,"mx":179,"my":30},{"lx":180,"ly":31,"mx":180,"my":30},{"lx":178,"ly":31,"mx":180,"my":31},{"lx":177,"ly":31,"mx":178,"my":31},{"lx":109,"ly":10,"mx":109,"my":10},{"lx":110,"ly":10,"mx":109,"my":10},{"lx":111,"ly":10,"mx":110,"my":10},{"lx":112,"ly":10,"mx":111,"my":10},{"lx":113,"ly":10,"mx":112,"my":10},{"lx":114,"ly":10,"mx":113,"my":10},{"lx":115,"ly":10,"mx":114,"my":10},{"lx":116,"ly":10,"mx":115,"my":10},{"lx":117,"ly":10,"mx":116,"my":10},{"lx":118,"ly":10,"mx":117,"my":10},{"lx":119,"ly":10,"mx":118,"my":10},{"lx":120,"ly":10,"mx":119,"my":10},{"lx":121,"ly":10,"mx":120,"my":10},{"lx":122,"ly":10,"mx":121,"my":10},{"lx":123,"ly":10,"mx":122,"my":10},{"lx":124,"ly":10,"mx":123,"my":10}]
';

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

my $app = SDLx::App->new( width => 200, height => 50);
$app->draw_rect([0,0,$app->w, $app->h], 0xFFFFFFFF);
my $sign = decode_json( $json_sign );

foreach( @$sign )
{
	$app->draw_line([$_->{lx},$_->{ly}],[$_->{mx},$_->{my}], 0x0000DDFF);
}

$app->update();
my $rand;
map { $rand .= ("a".."z")[rand 26] } 1..8;
my $rand_pic = 'sign'.$rand;

SDL::Video::save_BMP( $app, 'tmp_sign/'.$rand_pic.'.bmp');

`mogrify -format jpg tmp_sign/$rand_pic.bmp `;

#reset the old video driver
if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

