#include <ruby.h>

static VALUE hola_bonjour(VALUE self) {
  return rb_str_new2("bonjour!");
}

void Init_hare(void) {
}
