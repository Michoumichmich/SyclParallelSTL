#include <sycl/sycl.hpp>
#include <experimental/algorithm>
#include <sycl/execution_policy>
#include <vector>
#include <list>

namespace parallel = std::experimental::parallel;


int main (){
  std::list<float> v;
  int n_elems = 128;
  float search_val = 10.0f;
  int val_idx = std::rand() % n_elems;

  for (int i = 0; i < n_elems / 2; i++) {
    float x = ((float)std::rand()) / RAND_MAX;
    if (i == val_idx) {
      v.push_back(x);
    } else {
      v.push_back(
          search_val);  // make sure the searched for value is actually there
    }
  }
  v.push_back(0);  // add a value that we're not searching for

  auto res_std = std::find(begin(v), end(v), search_val);

  cl::sycl::queue q;
  sycl::sycl_execution_policy<class FindAlgorithm2> snp(q);
  auto res_sycl = parallel::find(snp, begin(v), end(v), search_val);
  return res_std==res_sycl;
}