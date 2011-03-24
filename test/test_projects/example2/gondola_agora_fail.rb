@sel.open "/"
@sel.wait_for_page_to_load "30000"
@sel.type "q", "agora games"
@sel.click "btnG"
@sel.click "link=Careers"
@sel.wait_for_page_to_load "30000"
verify_equal "Agora Games", @sel.get_title
verify @sel.is_text_present("At Agora")
assert @sel.is_text_present("Platform Engineer")
@sel.click "link=Application Engineer"
assert @sel.is_text_present("Application Engineer")
@sel.click "link=Producer"
assert @sel.is_text_present("Producer FAIL")
@sel.click "link=work at Agora."
@sel.wait_for_page_to_load "30000"
@sel.click "link=Fun at Agora"
@sel.click "link=Hack-a-thon"
@sel.click "link=Our Town"
@sel.click "link=Communication at Agora"
