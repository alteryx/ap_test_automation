
// start eyeball
var button=document.getElementById('button');
var lid=document.querySelectorAll('.lid')[0];
var pupil=document.querySelectorAll('.pupil')[0];
var deleted_rows=document.querySelectorAll('.deleted-row,.nondefault-column');

function toggle_classes_on_elements(elements,add_class=null,remove_class=null){
  for (var i=0,l=elements.length;i<l;i++){
    var el = elements[i];
    if (add_class != null) {
      el.classList.add(add_class);
    }
    if (remove_class != null) {
      el.classList.remove(remove_class);
    }
  }
}

function init_eyeball(){
  lid.classList.remove('lid--open');
  pupil.classList.remove('pupil--open');
  lid.classList.add('lid--close');
  pupil.classList.add('pupil--close');
  toggle_classes_on_elements(elements=deleted_rows,add_class="hidden-data",remove_class=null);
}
if (lid && pupil){
  init_eyeball();
  button.addEventListener('click',function(){
    if (lid.classList.contains('lid--open')) {
      lid.classList.remove('lid--open');
      pupil.classList.remove('pupil--open');
      toggle_classes_on_elements(elements=deleted_rows,add_class="hidden-data",remove_class=null);
    }
    else {
      if (lid.classList.contains('lid--close')) {
        lid.classList.add('lid--open');
        pupil.classList.add('pupil--open');
        toggle_classes_on_elements(elements=deleted_rows,add_class=null,remove_class="hidden-data");
      } else {
        lid.classList.add('lid--close');
        pupil.classList.add('pupil--close');
        toggle_classes_on_elements(elements=deleted_rows,add_class="hidden-data",remove_class=null);
      }
    }
  });
}
// end eyeball
