int other();

int test() { 
  int val = 5;
  int res = other() - val;
  return res;
}