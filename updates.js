exports.local_update = function (doc, req) {
  var form = JSON.parse(req.body);
  if (doc !== null) {
    if (!form.hasOwnProperty('key')  ||
        !form.hasOwnProperty('text')
    ) {
      throw({forbidden: '111: Request incomplete'});
    }
    doc[form.key] = form.text;
    return [doc, 'ok'];
  }
}
