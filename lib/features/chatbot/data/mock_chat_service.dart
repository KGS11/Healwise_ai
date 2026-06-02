class MockChatService {
  const MockChatService();

  String getMockResponse(String userMessage) {
    final cleanMessage = userMessage.trim().toLowerCase();

    if (cleanMessage == 'sleep' || cleanMessage == 'improve sleep') {
      return "For better sleep, try these naturopathy tips:\n"
          "   • Drink warm turmeric milk before bed\n"
          "   • Practice Shavasana for 10 minutes\n"
          "   • Avoid screens 1 hour before sleeping\n"
          "   • Keep a consistent sleep schedule\n"
          "   Would you like a guided sleep meditation routine?";
    }

    if (cleanMessage == 'diet' || cleanMessage == 'healthy diet' || cleanMessage == 'food') {
      return "Here are natural diet recommendations:\n"
          "   • Start your day with warm lemon water\n"
          "   • Include seasonal fruits and vegetables\n"
          "   • Avoid processed and packaged foods\n"
          "   • Eat mindfully and chew slowly\n"
          "   • Try intermittent fasting if suitable\n"
          "   Shall I create a personalized diet plan for you?";
    }

    if (cleanMessage == 'stress' || cleanMessage == 'anxiety' || cleanMessage == 'stress reduction') {
      return "Natural stress relief techniques:\n"
          "   • Practice 4-7-8 breathing exercise\n"
          "   • Try Anulom Vilom pranayama daily\n"
          "   • Walk barefoot on grass for grounding\n"
          "   • Ashwagandha herb tea can help\n"
          "   • Journaling for 5 minutes each evening\n"
          "   Want me to guide you through a breathing exercise?";
    }

    if (cleanMessage == 'yoga' || cleanMessage == 'yoga recommendations') {
      return "Recommended yoga poses for overall wellness:\n"
          "   • Surya Namaskar — morning energizer\n"
          "   • Balasana — stress relief\n"
          "   • Viparita Karani — sleep improvement\n"
          "   • Bhujangasana — back strength\n"
          "   • Shavasana — deep relaxation\n"
          "   Would you like to start a guided yoga session?";
    }

    if (cleanMessage == 'headache' || cleanMessage == 'head pain') {
      return "Natural headache remedies:\n"
          "   • Apply peppermint oil on temples\n"
          "   • Try cold or warm compress\n"
          "   • Practice neck stretches gently\n"
          "   • Stay hydrated — drink water slowly\n"
          "   • Avoid bright screens and loud sounds\n"
          "   If headache persists, please consult a doctor.";
    }

    if (cleanMessage == 'digestion' || cleanMessage == 'stomach' || cleanMessage == 'gut') {
      return "Natural digestion improvement tips:\n"
          "   • Drink warm water with ginger and lemon\n"
          "   • Try Vajrasana after meals\n"
          "   • Include fiber-rich foods daily\n"
          "   • Avoid eating late at night\n"
          "   • Triphala herbal supplement can help\n"
          "   Shall I suggest a digestive wellness routine?";
    }

    if (cleanMessage == 'bp' || cleanMessage == 'blood pressure') {
      return "Natural blood pressure management:\n"
          "   • Practice deep breathing daily\n"
          "   • Reduce salt and processed food intake\n"
          "   • Try Shavasana and meditation\n"
          "   • Drink hibiscus tea regularly\n"
          "   • Walk for 30 minutes every morning\n"
          "   Always monitor your BP and consult your doctor.";
    }

    return "I understand you're looking for wellness guidance.\n"
        "   As a naturopathy assistant, I can help with:\n"
        "   • Sleep improvement\n"
        "   • Stress and anxiety relief\n"
        "   • Diet and nutrition\n"
        "   • Yoga and breathing exercises\n"
        "   • Natural remedies for common issues\n"
        "   Please describe your health concern and I will\n"
        "   suggest natural wellness solutions.";
  }
}
