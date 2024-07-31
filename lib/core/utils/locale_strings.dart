import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          // Common
          "general": "General",
          "close": "Close",
          "add_expense": "Add Expense",
          "delete_expense": "Delete Expense",
          "today": "Today",
          "are_you_sure_delete1": "Are you sure you want to delete",
          "are_you_sure_delete2": "expense?",
          "cancel": "Cancel",
          "delete": "Delete",
          "deleted_expense_success": "Deleted expense successfully!!",
          "edited_expense_success": "Edited expense successfully!!",

          // Landing Screen
          "landing_subtitle": "Your Personal Expense Tracker",
          "get_started": "Get Started",

          // Onboarding Screen
          "login_and_continue": "Login and Continue",
          "next": "Next",
          "manage_expenses": "Manage Expenses",
          "manage_expenses_desc": "Keep track of all your expenses effortlessly. Our tool helps you organize your spending and stay on top of your finances.",
          "analyze_expenses": "Analyze Expenses",
          "analyze_expenses_desc": "Gain insights into your spending patterns. Analyze your expenses to make better financial decisions.",
          "ai_assistance": "AI Assistance",
          "ai_assistance_desc": "Leverage AI to get smart recommendations on managing your finances more effectively and efficiently.",

          // Auth Screen
          "sign_in": "Sign In",
          "sign_up": "Sign Up",
          "email": "Email",
          "name": "Name",
          "password": "Password",
          "dont_have_acc": "Don't have account?",  
          "already_have_acc": "Already have account?",  
          "acc_created_successfully": "Account created! Please log in.",  

          // Dashboard Screen
          "hello": "Hello\n",
          "the_weeks_total1": "This week\'s total expense is ",
          "the_weeks_total2": "₹. The new week starts tomorrow!",
          "in_the_last1": "In the last ",
          "in_the_last2": " days, you have spent ",
          "in_the_last3": " ₹. You have ",
          "in_the_last4": " days left in this week.",
          "in_this_month1": "This month\'s total expense is ",
          "in_this_month2": " ₹. A new month starts tomorrow!",
          "in_this_month_faar1": "So far this month, you have spent ",
          "in_this_month_faar2": " ₹. You have ",
          "in_this_month_faar3": " days left in this month.",
          "todays_expenses": "Today's Expenses\n",
          "weekly_expenses": "Weekly Expenses\n",
          "weekly_expenses_analysis": "Weekly Expenses Analysis",
          "monthly_expenses": "Monthly Expenses\n",
          "monthly_expenses_analysis": "Monthly Expenses Analysis",
          "no_expenses_today": "No expenses today!",
        },
        "mar_IN": {
          // Common
          "general": "सामान्य",
          "close": "बंद करा",
          "add_expense": "खर्च जोडा",
          "delete_expense": "खर्च हटवा",
          "today": "आज",
          "are_you_sure_delete1": "तुम्ही खात्रीने हटवू इच्छिता",
          "are_you_sure_delete2": "खर्च?",
          "cancel": "रद्द करा",
          "delete": "हटवा",
          "deleted_expense_success": "खर्च यशस्वीरित्या हटवला!!",
          "edited_expense_success": "खर्च यशस्वीरित्या संपादित केला!!",

          // Landing Screen
          "landing_subtitle": "तुमचा वैयक्तिक खर्च ट्रॅकर",
          "get_started": "सुरू करा",

          // Onboarding Screen
          "login_and_continue": "लॉगिन करा आणि पुढे चालू ठेवा",
          "next": "पुढे",
          "manage_expenses": "खर्च व्यवस्थापित करा",
          "manage_expenses_desc": "तुमच्या सर्व खर्चांचे सहजपणे ट्रॅक ठेवा. आमचे साधन तुम्हाला तुमच्या खर्चाचे आयोजन करण्यास आणि तुमच्या वित्तीय स्थितीवर नियंत्रण ठेवण्यास मदत करते.",
          "analyze_expenses": "खर्च विश्लेषण करा",
          "analyze_expenses_desc": "तुमच्या खर्चाच्या नमुन्यांची अंतर्दृष्टी मिळवा. चांगले आर्थिक निर्णय घेण्यासाठी तुमच्या खर्चाचे विश्लेषण करा.",
          "ai_assistance": "AI सहाय्य",
          "ai_assistance_desc": "तुमच्या वित्तीय व्यवस्थापनासाठी अधिक प्रभावी आणि कार्यक्षम शिफारसी मिळवण्यासाठी AI चा वापर करा.",

          // Auth Screen
          "sign_in": "साइन इन",
          "sign_up": "साइन अप",
          "email": "ईमेल",
          "name": "नाव",
          "password": "पासवर्ड",
          "dont_have_acc": "खाते नाहीये?",  
          "already_have_acc": "खाते आहे?",  
          "acc_created_successfully": "खाते तयार झाले! कृपया लॉगिन करा.",  

          // Dashboard Screen
          "hello": "नमस्कार\n",
          "the_weeks_total1": "या आठवड्याचा एकूण खर्च आहे ",
          "the_weeks_total2": "₹. उद्या नवीन आठवडा सुरू होतो!",
          "in_the_last1": "गेल्या ",
          "in_the_last2": " दिवसांमध्ये, तुम्ही खर्च केले आहेत ",
          "in_the_last3": " ₹. तुम्हाला अजून ",
          "in_the_last4": " दिवस उरले आहेत.",
          "in_this_month1": "या महिन्याचा एकूण खर्च आहे ",
          "in_this_month2": " ₹. उद्या नवीन महिना सुरू होतो!",
          "in_this_month_faar1": "आजपर्यंत या महिन्यात, तुम्ही खर्च केले आहेत ",
          "in_this_month_faar2": " ₹. तुम्हाला अजून ",
          "in_this_month_faar3": " दिवस उरले आहेत.",
          "todays_expenses": "आजचा खर्च\n",
          "weekly_expenses": "आठवड्याचा खर्च\n",
          "weekly_expenses_analysis": "आठवड्याचा खर्च विश्लेषण",
          "monthly_expenses": "मासिक खर्च\n",
          "monthly_expenses_analysis": "मासिक खर्च विश्लेषण",
          "no_expenses_today": "आज खर्च नाही!",
        },
        "hin_IN": {
          // Common
          "general": "सामान्य",
          "close": "बंद करें",
          "add_expense": "खर्च जोड़ें",
          "delete_expense": "खर्च हटाएं",
          "today": "आज",
          "are_you_sure_delete1": "क्या आप वाकई हटाना चाहते हैं",
          "are_you_sure_delete2": "खर्च?",
          "cancel": "रद्द करें",
          "delete": "हटाएं",
          "deleted_expense_success": "खर्च सफलतापूर्वक हटाया गया!!",
          "edited_expense_success": "खर्च सफलतापूर्वक संपादित किया गया!!",

          // Landing Screen
          "landing_subtitle": "आपका व्यक्तिगत खर्च ट्रैकर",
          "get_started": "शुरू करें",

          // Onboarding Screen
          "login_and_continue": "लॉगिन करें और जारी रखें",
          "next": "अगला",
          "manage_expenses": "खर्च प्रबंधित करें",
          "manage_expenses_desc": "अपने सभी खर्चों को आसानी से ट्रैक करें। हमारा टूल आपको अपने खर्च को व्यवस्थित करने और अपने वित्तीय स्थिति पर नियंत्रण रखने में मदद करता है।",
          "analyze_expenses": "खर्चों का विश्लेषण करें",
          "analyze_expenses_desc": "अपने खर्च पैटर्न की अंतर्दृष्टि प्राप्त करें। बेहतर वित्तीय निर्णय लेने के लिए अपने खर्चों का विश्लेषण करें।",
          "ai_assistance": "AI सहायता",
          "ai_assistance_desc": "अधिक प्रभावी और कुशलता से अपने वित्तीय प्रबंधन के लिए स्मार्ट सिफारिशें प्राप्त करने के लिए AI का लाभ उठाएं।",

          // Auth Screen
          "sign_in": "साइन इन",
          "sign_up": "साइन अप",
          "email": "ईमेल",
          "name": "नाम",
          "password": "पासवर्ड",
          "dont_have_acc": "खाता नहीं है?",  
          "already_have_acc": "खाता है?",  
          "acc_created_successfully": "खाता बनाया गया! कृपया लॉगिन करें।",  

          // Dashboard Screen
          "hello": "नमस्ते\n",
          "the_weeks_total1": "इस सप्ताह का कुल खर्च है ",
          "the_weeks_total2": "₹. नया सप्ताह कल से शुरू होता है!",
          "in_the_last1": "पिछले ",
          "in_the_last2": " दिनों में, आपने खर्च किया है ",
          "in_the_last3": " ₹. आपके पास ",
          "in_the_last4": " दिन शेष हैं।",
          "in_this_month1": "इस महीने का कुल खर्च है ",
          "in_this_month2": " ₹. नया महीना कल से शुरू होता है!",
          "in_this_month_faar1": "अब तक इस महीने में, आपने खर्च किया है ",
          "in_this_month_faar2": " ₹. आपके पास ",
          "in_this_month_faar3": " दिन शेष हैं।",
          "todays_expenses": "आज का खर्च\n",
          "weekly_expenses": "साप्ताहिक खर्च\n",
          "weekly_expenses_analysis": "साप्ताहिक खर्च विश्लेषण",
          "monthly_expenses": "मासिक खर्च\n",
          "monthly_expenses_analysis": "मासिक खर्च विश्लेषण",
          "no_expenses_today": "आज कोई खर्च नहीं!",
        }
      };
}
