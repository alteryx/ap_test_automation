module Tests exposing (..)

import ElmTest.Extra exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, classes)
import UserStory exposing (..)
import Expect


-- import Fuzz exposing (list, int, tuple, string)

import Portal exposing (add)
import Update exposing (..)
import Msg exposing (..)
import Init exposing (..)
import Navigation exposing (navigation)
import Paginate exposing (..)


all : Test
all =
    describe "Portal"
        [ test "should have correct number of list items" <|
            \() ->
                navigation model
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 6)
        , test "first list item should have correct text" <|
            \() ->
                navigation model
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.first
                    |> Query.has [ text "Dashboard" ]
        , test "should have a class of alteryx-hover-link" <|
            \() ->
                navigation model
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.first
                    |> Query.has [ tag "li", classes [ "hover-green" ] ]
        , test "should update selected to the active tab" <|
            \() ->
                model
                    |> update (SetActive "Merged to ITB")
                    |> Tuple.first
                    |> Expect.equal
                        { selected = "Merged to ITB"
                        , tabs = [ "Ready to Merge", "Merged to ITB", "ITB Defects", "Feature Status" ]
                        , cards = [ "Defect Status", "Automated Test Results", "Release Status" ]
                        , listOfLinks = [ "Dashboard", "Defects", "Automated Tests", "Release Status", "Benchmarking", "QA Corner" ]
                        , sortCategory = ""
                        , userStory = UserStory "0" "0" 0 0 0 []
                        , listOfTeams =
                            [ "All Teams"
                            , "Advanced Analytics"
                            , "Analytics Products"
                            , "Content Engineering"
                            , "Core Engine Team"
                            , "Creative Services"
                            , "Designer Team"
                            , "Galileo Team"
                            , "Integration Test Team"
                            , "Internationalization"
                            , "Licensing 2.0"
                            , "Prague Team"
                            , "Reporting"
                            , "Rogue Squadron"
                            , "Tool Experience"
                            , "Web Team"
                            ]
                        , selectedTeam = ""
                        , paginated = (Paginate.fromList 5 <| List.map (\s -> s) <| userStory.results)
                        , reversed = False
                        , query = ""
                        , pageSize = 5
                        , releases = ""
                        , csvString = [ "STORY/DEFECT" ]
                        }
        , test "should have correct number of teams" <|
            \() ->
                Expect.equal (List.length model.listOfTeams) 16
        , test "should add numbers together" <|
            \() ->
                Expect.equal (add 1 1) 2
        , test "should format a string with spaces and capital letters to all lowercase" <|
            \() ->
                Expect.equal
                    (formatString "Say Toasty")
                    "ws://localhost:1234/qaportal/saytoasty"
        ]



-- [ describe "Unit test examples!"
--     [ test "Addition" <|
--         \() ->
--             Expect.equal (3 + 7) 10
--     , test "String.left" <|
--         \() ->
--             Expect.equal "a" (String.left 1 "abcdefg")
--     , test "This test should fail - you should remove it" <|
--         \() ->
--             Expect.fail "Failed as expected!"
--     ]
-- , describe "Fuzz test examples, using randomly generated input"
--     [ fuzz (list int) "Lists always have positive length" <|
--         \aList ->
--             List.length aList |> Expect.atLeast 0
--     , fuzz (list int) "Sorting a list does not change its length" <|
--         \aList ->
--             List.sort aList |> List.length |> Expect.equal (List.length aList)
--     , fuzzWith { runs = 1000 } int "List.member will find an integer in a list containing it" <|
--         \i ->
--             List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
--     , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
--         \s1 s2 ->
--             s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
--     ]
-- ]
