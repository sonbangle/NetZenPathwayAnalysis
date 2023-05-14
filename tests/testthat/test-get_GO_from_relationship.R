test_that("get_GO_from_part_of_relationship works", {
  GO =get_GO_from_relationship(rel = "part_of GO:0002397 ! MHC class I protein complex assembly")
  print(GO)
  expect_equal(GO, "GO:0002397")
  rel ="positively_regulates GO:0019882 ! antigen processing and presentation"
  GO =get_GO_from_relationship(rel)
  print(GO)
  expect_equal(GO, "GO:0019882")
})
