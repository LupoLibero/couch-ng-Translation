var fields = require('modules/ITS/types');

exports.registerTranslation = function (doc, form, type, element, lang) {
  if(lang == undefined) {
    throw({forbidden: 'No language code'});
  }
  // If the is translatable
  if (!fields[type].fields[element].translatable) {
    return false
  }

  var value = null;
  if(form.hasOwnProperty(element)){
    value = form[element];
  } else {
    value = form.value;
  }

  // If field is not an object store the value an put
  // it into the init_lang or 'default' language
  if(typeof doc[element] != 'object') {
    var saved = doc[element];
    doc[element] = {}

    if(doc.hasOwnProperty('init_lang')){
      doc[element][doc.init_lang] = {
        content: saved,
      }
    } else {
      doc[element]['default'] = {
        content: saved,
      }
    }
  }
  doc[element][lang] = {
    content: value,
  }
  if(doc.hasOwnProperty('_rev')){
    doc[element][lang]._rev = doc._rev
  }
}
