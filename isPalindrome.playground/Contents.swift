import Foundation

func isPalindrome(text: String) {
    if text.lowercased() == String(text.lowercased().reversed()) {
        print("\(text) is a palindrome")
    } else {
        print("\(text) isn’t a palindrome")
    }
}

isPalindrome(text: "aka")
isPalindrome(text: "Level")
isPalindrome(text: "Hello")
