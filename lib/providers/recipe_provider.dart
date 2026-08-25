import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/gemini_service.dart';

class RecipeProvider with ChangeNotifier {
  final List<Recipe> _allRecipes = [
    Recipe(
      id: 'rec_kolhapuri_misal',
      title: 'झणझणीत कोल्हापुरी मिसळ पाव (Kolhapuri Misal Pav)',
      category: 'महाराष्ट्रीयन खास',
      imageUrl:
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=900&q=80',
      time: '३० मिनिटे',
      calories: '४८० कॅलरी',
      servings: '४ व्यक्तींसाठी',
      rating: '4.9',
      reviews: '2.8k',
      difficulty: 'Medium',
      description:
          'अस्सल कोल्हापुरी तिखट कट (रस्सा), मोड आलेली मटकीची उसळ, कुरकुरीत फरसाण, बारीक चिरलेला कांदा आणि मऊ लादी पाव!',
      ingredients: [
        IngredientItem(
            name: 'मोड आलेली मटकी (Sprouted Matki)',
            amount: '२ वाट्या (उकडलेली)'),
        IngredientItem(
            name: 'कांदा (बारीक चिरलेला व भाजलेला)', amount: '३ मध्यम'),
        IngredientItem(
            name: 'सुके खोबरे (कीस)', amount: '१/२ वाटी (भाजून वाटलेले)'),
        IngredientItem(name: 'लसूण-आले पेस्ट', amount: '२ चमचे'),
        IngredientItem(
            name: 'कोल्हापुरी कांदा-लसूण मसाला / गोडा मसाला',
            amount: '२.५ मोठे चमचे'),
        IngredientItem(name: 'हळद व लाल तिखट', amount: '१-१ चमचा'),
        IngredientItem(name: 'मिसळ फरसाण / शेव', amount: '१.५ वाटी'),
        IngredientItem(
            name: 'लादी पाव, लिंबू व ताजी कोथिंबीर', amount: 'सर्व्हिंगसाठी'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'मटकी उकडणे व मसाला वाटण',
          instruction:
              'मोड आलेली मटकी थोडी हळद व मीठ घालून मऊ उकडवून घ्या. भाजलेला कांदा, लसूण, आले आणि भाजलेले खोबरे एकत्र बारीक वाटून अस्सल वाटण तयार करा.',
          timerSeconds: 300,
        ),
        CookingStep(
          number: 2,
          title: 'खमंग फोडणी व तरी (कट) तयार करणे',
          instruction:
              'कढईत ३-४ मोठे चमचे तेल गरम करा. तयार वाटण तेलात तेल सुटेपर्यंत खमंग परता. कांदा-लसूण मसाला, लाल तिखट आणि गरम पाणी घालून उकळी आणा. वर लालबुंद तवंग (तरी) येईल.',
          timerSeconds: 420,
        ),
        CookingStep(
          number: 3,
          title: 'मटकी उसळ व कट एकत्र करणे',
          instruction:
              'उकडलेली मटकी या रश्श्यात घालून मंद आचेवर ५-७ मिनिटे चांगली उकळा जेणेकरून मसाल्याची चव मटकीत उतरेल.',
          timerSeconds: 360,
        ),
        CookingStep(
          number: 4,
          title: 'मिसळ सर्व्ह करणे (Plating)',
          instruction:
              'प्लेटमध्ये प्रथम मटकीची उसळ घाला, त्यावर कुरकुरीत फरसाण, बारीक चिरलेला कांदा आणि वरून गरमागरम झणझणीत कट (रस्सा) ओता. वर कोथिंबीर, लिंबू आणि लादी पावासोबत सर्व्ह करा.',
          timerSeconds: 60,
        ),
      ],
    ),
    Recipe(
      id: 'rec_kande_pohe',
      title: 'खमंग महाराष्ट्रीयन कांदे पोहे (Authentic Kande Pohe)',
      category: 'खमंग नाश्ता',
      imageUrl:
          'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=900&q=80',
      time: '१५ मिनिटे',
      calories: '२८० कॅलरी',
      servings: '३ व्यक्तींसाठी',
      rating: '4.9',
      reviews: '3.4k',
      difficulty: 'Easy',
      description:
          'सकाळच्या नाश्त्याची शान! जाड पोहे, खमंग तळलेले शेंगदाणे, मऊ परतेला कांदा, हिरवी मिरची आणि ओले खोबरे-लिंबाची चव.',
      ingredients: [
        IngredientItem(name: 'जाड पोहे (Thick Poha)', amount: '२ वाट्या'),
        IngredientItem(name: 'कांदा (उभा चिरलेला)', amount: '२ मोठे'),
        IngredientItem(name: 'हिरवी मिरची (तुकडे)', amount: '३-४ मिरच्या'),
        IngredientItem(name: 'कच्चे शेंगदाणे', amount: '१/४ वाटी'),
        IngredientItem(name: 'मोहरी, जिरे व हिंग', amount: '१-१ चमचा'),
        IngredientItem(
            name: 'हळद, मीठ व साखर', amount: '१/२ चमचा हळद, चवीनुसार मीठ-साखर'),
        IngredientItem(name: 'कढीपत्ता व ताजी कोथिंबीर', amount: '१० पाने'),
        IngredientItem(name: 'ओले खोबरे कीस व लिंबू', amount: 'सजावटीसाठी'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'पोहे भिजवून मोकळे करणे',
          instruction:
              'पोहे चाळणीत घेऊन पाण्याखाली २ वेळा स्वच्छ धुवा व पाणी पूर्ण निथळू द्या. त्यावर चवीनुसार मीठ व थोडी साखर टाकून हलक्या हाताने मोकळे करा.',
          timerSeconds: 120,
        ),
        CookingStep(
          number: 2,
          title: 'शेंगदाणे तळणे व फोडणी',
          instruction:
              'कढईत २ मोठे चमचे तेल गरम करा. प्रथम शेंगदाणे कुरकुरीत तळून घ्या. नंतर त्याच तेलात मोहरी, जिरे, हिंग, कढीपत्ता आणि हिरवी मिरची घालून खमंग फोडणी द्या.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 3,
          title: 'कांदा परतून पोहे मिक्स करणे',
          instruction:
              'चिरलेला कांदा घालून हलका गुलाबी होईपर्यंत परता. हळद घालून भिजवलेले पोहे व तळलेले शेंगदाणे एकत्र करा. मंद आचेवर २-३ मिनिटे एकजीव करा.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 4,
          title: 'वाफ काढणे व सर्व्ह करणे',
          instruction:
              'कढईवर झाकण ठेवून मंद आचेवर २ मिनिटे छान वाफ काढा. गॅस बंद करून वर भरपूर कोथिंबीर, ओले खोबरे आणि लिंबाचा रस पिळून गरमागरम चहासोबत वाढा!',
          timerSeconds: 120,
        ),
      ],
    ),
    Recipe(
      id: 'rec_pithla_bhakri',
      title: 'झणझणीत पिठलं आणि गरम भाकरी (Pithla Bhakri & Thecha)',
      category: 'पारंपरिक जेवण',
      imageUrl:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=900&q=80',
      time: '२० मिनिटे',
      calories: '३९० कॅलरी',
      servings: '२ व्यक्तींसाठी',
      rating: '4.9',
      reviews: '1.9k',
      difficulty: 'Easy',
      description:
          'गावरान चवीचे खमंग लसूण-मिरची फोडणीचे डाळीचे पिठलं (झुणका), गरमागरम ज्वारीची/बाजरीची भाकरी आणि झणझणीत हिरवा ठेचा!',
      ingredients: [
        IngredientItem(name: 'बेसन (चना डाळ पीठ)', amount: '१ वाटी'),
        IngredientItem(name: 'बारीक चिरलेला कांदा', amount: '१ मोठा'),
        IngredientItem(name: 'लसूण-हिरवी मिरची ठेचून', amount: '२ चमचे'),
        IngredientItem(name: 'मोहरी, जिरे, हिंग व हळद', amount: '१-१ चमचा'),
        IngredientItem(name: 'कढीपत्ता व ताजी कोथिंबीर', amount: 'भरपूर'),
        IngredientItem(name: 'पाणी व चवीनुसार मीठ', amount: '२.५ वाट्या'),
        IngredientItem(name: 'ज्वारीचे पीठ (भाकरीसाठी)', amount: '२ वाट्या'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'बेसन पेस्ट तयार करणे',
          instruction:
              '१ वाटी बेसनामध्ये १.५ वाटी पाणी घालून गाठी न राहता गुळगुळीत पातळ पेस्ट तयार करा.',
          timerSeconds: 120,
        ),
        CookingStep(
          number: 2,
          title: 'लसूण-कांदा खमंग फोडणी',
          instruction:
              'कढईत तेल गरम करून मोहरी, जिरे, हिंग, कढीपत्ता आणि ठेचलेला लसूण-मिरची परता. कांदा घालून तांबूस होईपर्यंत भाजा. हळद व मीठ घाला.',
          timerSeconds: 240,
        ),
        CookingStep(
          number: 3,
          title: 'पिठलं शिजवणे व वाफ काढणे',
          instruction:
              'कढईत १ वाटी गरम पाणी घाला. उकळी आल्यावर बेसनाची पेस्ट हळूहळू घालत सतत ढवळा जेणेकरून गाठी होणार नाहीत. झाकण ठेवून मंद आचेवर ५ मिनिटे वाफ काढा.',
          timerSeconds: 300,
        ),
        CookingStep(
          number: 4,
          title: 'गरम भाकरीसोबत आस्वाद',
          instruction:
              'पिठल्यावर ताजी कोथिंबीर आणि वरून कच्च्या शेंगदाणा तेलाची धार सोडून गरमागरम ज्वारीची भाकरी, कांदा व ठेच्यासोबत वाढा.',
          timerSeconds: 60,
        ),
      ],
    ),
    Recipe(
      id: 'rec_bharli_vangi',
      title: 'मसालेदार महाराष्ट्रीयन भरली वांगी (Bharli Vangi Gravy)',
      category: 'महाराष्ट्रीयन खास',
      imageUrl:
          'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=900&q=80',
      time: '३५ मिनिटे',
      calories: '३६० कॅलरी',
      servings: '४ व्यक्तींसाठी',
      rating: '4.8',
      reviews: '1.5k',
      difficulty: 'Medium',
      description:
          'लहान जांभळी काटेरी वांगी, भाजलेले शेंगदाणे, तीळ, सुके खोबरे आणि अस्सल गोडा मसाल्याचे चवदार भरलेले सारण.',
      ingredients: [
        IngredientItem(
            name: 'लहान काटेरी वांगी (Brinjals)',
            amount: '८-१० नग (४ चिरा पाडलेली)'),
        IngredientItem(name: 'भाजलेल्या शेंगदाण्याचा कूट', amount: '१/२ वाटी'),
        IngredientItem(name: 'भाजलेले सुके खोबरे व तीळ', amount: '२-२ चमचे'),
        IngredientItem(
            name: 'महाराष्ट्रीयन गोडा मसाला / कांदा लसूण मसाला',
            amount: '२ मोठे चमचे'),
        IngredientItem(
            name: 'आले-लसूण पेस्ट व गूळ-चिंच कोळ', amount: '१-१ चमचा'),
        IngredientItem(name: 'हळद, धने पूड व मीठ', amount: 'चवीनुसार'),
        IngredientItem(name: 'फोडणीसाठी तेल व कोथिंबीर', amount: '३ मोठे चमचे'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'वांगी कापणे व पाण्यात ठेवणे',
          instruction:
              'वांग्याचे देठ थोडे कापून देठाकडून ४ चिरा पाडा (वांगे वेगळे होणार नाही याची काळजी घ्या). मिठाच्या पाण्यात १० मिनिटे ठेवा जेणेकरून काळे पडणार नाही.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 2,
          title: 'खमंग मसाला सारण बनवणे',
          instruction:
              'शेंगदाणा कूट, खोबरे, तीळ, गोडा मसाला, हळद, धने पूड, आले-लसूण पेस्ट, चिंच-गूळ आणि मीठ एकत्र करून थोडे तेल घालून खमंग सारण बनवा.',
          timerSeconds: 240,
        ),
        CookingStep(
          number: 3,
          title: 'वांग्यात मसाला भरणे व परतणे',
          instruction:
              'प्रत्येक वांग्यात तयार मसाला चांगला दाबून भरा. कढईत तेल गरम करून भरलेली वांगी तेलात ४-५ मिनिटे मंद आचेवर सर्व बाजूंनी परतून घ्या.',
          timerSeconds: 300,
        ),
        CookingStep(
          number: 4,
          title: 'ग्रेव्ही शिजवणे (दम देणे)',
          instruction:
              'उरलेला मसाला व १.५ वाटी गरम पाणी घाला. कढईवर ताट ठेवून ताटात पाणी ठेवा. मंद आचेवर १५ मिनिटे वांगी मऊ होईपर्यंत व तेल सुटेपर्यंत शिजवा.',
          timerSeconds: 600,
        ),
      ],
    ),
    Recipe(
      id: 'rec_thalipeeth',
      title: 'खमंग भाजणीचे थालीपीठ (Traditional Thalipeeth & Loni)',
      category: 'खमंग नाश्ता',
      imageUrl:
          'https://images.unsplash.com/photo-1505253758473-96b7015fcd40?auto=format&fit=crop&w=900&q=80',
      time: '२० मिनिटे',
      calories: '३१० कॅलरी',
      servings: '३ व्यक्तींसाठी',
      rating: '4.9',
      reviews: '2.1k',
      difficulty: 'Easy',
      description:
          'पारंपरिक भाजणीचे पीठ, भरपूर कांदा, कोथिंबीर, तीळ आणि पांढऱ्या लोण्यासोबत गरमागरम कुरकुरीत थालीपीठ!',
      ingredients: [
        IngredientItem(name: 'थालीपीठ भाजणी पीठ', amount: '२ वाट्या'),
        IngredientItem(name: 'बारीक चिरलेला कांदा', amount: '२ मध्यम'),
        IngredientItem(name: 'हिरवी मिरची व लसूण पेस्ट', amount: '१.५ चमचा'),
        IngredientItem(name: 'पांढरे तीळ व ओवा', amount: '१-१ चमचा'),
        IngredientItem(name: 'हळद, लाल तिखट व मीठ', amount: '१-१ चमचा'),
        IngredientItem(name: 'भरपूर ताजी कोथिंबीर', amount: '१/२ वाटी'),
        IngredientItem(name: 'तूप / पांढरे लोणी व तेल', amount: 'भाजण्यासाठी'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'मऊ पीठ मळणे',
          instruction:
              'भाजणी पिठात कांदा, हिरवी मिरची-लसूण, कोथिंबीर, तीळ, ओवा, हळद, तिखट व मीठ घालून कोमट पाण्याने मऊ पीठ मळून घ्या.',
          timerSeconds: 240,
        ),
        CookingStep(
          number: 2,
          title: 'थालीपीठ थापणे',
          instruction:
              'ओल्या सुती कापडावर किंवा बटर पेपरवर तेलाचा हात लावून पिठाचा गोळा गोल थापा. मध्यभागी आणि कडेने ३-४ छोटी छिद्रे पाडा.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 3,
          title: 'तव्यावर खमंग भाजणे',
          instruction:
              'गरम तव्यावर तेल सोडून थालीपीठ अलगद टाका. छिद्रांमध्ये व कडेने थोडे तेल सोडून झाकण ठेवून मध्यम आचेवर ३ मिनिटे भाजा. पलटून दुसरी बाजूही कुरकुरीत भाजा.',
          timerSeconds: 360,
        ),
        CookingStep(
          number: 4,
          title: 'लोणी व दह्यासोबत सर्व्ह करा',
          instruction:
              'गरमागरम कुरकुरीत थालीपीठावर ताजे घरगुती पांढरे लोणी किंवा दही आणि लिंबाच्या लोणच्यासोबत वाढा.',
          timerSeconds: 60,
        ),
      ],
    ),
    Recipe(
      id: 'rec_ukadiche_modak',
      title: 'पारंपरिक उकडीचे मोदक (Authentic Ukadiche Modak)',
      category: 'गोडधोड',
      imageUrl:
          'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=900&q=80',
      time: '४० मिनिटे',
      calories: '२४० कॅलरी',
      servings: '४ व्यक्तींसाठी',
      rating: '5.0',
      reviews: '4.5k',
      difficulty: 'Hard',
      description:
          'सुवासिक तांदळाच्या मऊ उकडीत भरलेले ओले खोबरे, गूळ, जायफळ-वेलचीचे रसाळ सारण आणि वर साजूक तुपाची धार!',
      ingredients: [
        IngredientItem(
            name: 'सुवासिक तांदळाचे पीठ (बासमती/आंबेमोहोर)',
            amount: '२ वाट्या'),
        IngredientItem(name: 'ओले खोबरे (खवलेले)', amount: '२ वाट्या'),
        IngredientItem(name: 'सेंद्रिय गूळ (किसलेला)', amount: '१ वाटी'),
        IngredientItem(name: 'वेलची पूड व जायफळ', amount: '१/२ चमचा'),
        IngredientItem(name: 'साजूक तूप व किंचित मीठ', amount: '२ चमचे'),
        IngredientItem(
            name: 'पाणी व दूध (उकडीसाठी)',
            amount: '२ वाट्या पाणी + २ चमचे दूध'),
        IngredientItem(name: 'केशर काड्या', amount: 'सजावटीसाठी'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'गूळ-खोबऱ्याचे सारण बनवणे',
          instruction:
              'पॅनमध्ये १ चमचा तूप गरम करून खवलेले ओले खोबरे व गूळ मंद आचेवर परता. गूळ विरघळून मिश्रण एकजीव झाल्यावर वेलची-जायफळ पूड घालून थंड होऊ द्या.',
          timerSeconds: 360,
        ),
        CookingStep(
          number: 2,
          title: 'तांदळाची मऊ उकड काढणे',
          instruction:
              'पातेल्यात पाणी, दूध, १ चमचा तूप व चिमूटभर मीठ घालून उकळी आणा. गॅस बारीक करून तांदळाचे पीठ घालून भराभर ढवळा. झाकण ठेवून मंद आचेवर ३ मिनिटे वाफ काढा.',
          timerSeconds: 300,
        ),
        CookingStep(
          number: 3,
          title: 'उकड मळून मोदक वळणे',
          instruction:
              'गरम उकड परातीत काढून पाण्याचा हात लावून मऊ मळून घ्या. पिठाची पातळ पारी करून त्यात खोबऱ्याचे सारण भरा आणि सुंदर कळ्या पाडून मोदकाचा आकार द्या.',
          timerSeconds: 600,
        ),
        CookingStep(
          number: 4,
          title: 'मोदक वाफवणे व तूप सोडणे',
          instruction:
              'चाळणीला केळीचे पान किंवा तूप लावून मोदक ठेवा. स्टीमरमध्ये १०-१२ मिनिटे वाफवून घ्या. गरमागरम मोदकावर साजूक तूप सोडून नैवेद्य दाखवा!',
          timerSeconds: 660,
        ),
      ],
    ),
    Recipe(
      id: 'rec_sabudana_khichdi',
      title: 'उपवास साबुदाणा खिचडी (Fasting Sabudana Khichdi)',
      category: 'उपवास स्पेशल',
      imageUrl:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=900&q=80',
      time: '१५ मिनिटे',
      calories: '३४० कॅलरी',
      servings: '२ व्यक्तींसाठी',
      rating: '4.9',
      reviews: '2.5k',
      difficulty: 'Easy',
      description:
          'मोकळी-सळसळीत उपवासाची साबुदाणा खिचडी, खमंग भाजलेल्या शेंगदाण्याचा कूट, बटाटा आणि तिखट हिरवी मिरची.',
      ingredients: [
        IngredientItem(name: 'साबुदाणा (५-६ तास भिजवलेला)', amount: '२ वाट्या'),
        IngredientItem(name: 'भाजलेल्या शेंगदाण्याचा कूट', amount: '१ वाटी'),
        IngredientItem(name: 'उकडलेला बटाटा (तुकडे)', amount: '१ मोठा'),
        IngredientItem(
            name: 'हिरवी मिरची (बारीक चिरलेली)', amount: '३-४ मिरच्या'),
        IngredientItem(
            name: 'जिरे व साजूक तूप / शेंगदाणा तेल', amount: '२ मोठे चमचे'),
        IngredientItem(name: 'सेंधव मीठ व साखर', amount: 'चवीनुसार'),
        IngredientItem(name: 'लिंबू व ताजी कोथिंबीर', amount: 'सजावटीसाठी'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'साबुदाणा व शेंगदाणा मिक्स करणे',
          instruction:
              'भिजवलेला मोकळा साबुदाणा एका बाऊलमध्ये घ्या. त्यात शेंगदाणा कूट, मीठ आणि साखर एकत्र करून हलक्या हाताने मिक्स करा.',
          timerSeconds: 120,
        ),
        CookingStep(
          number: 2,
          title: 'जिरे-मिरची व बटाटा फोडणी',
          instruction:
              'कढईत तूप किंवा तेल गरम करून जिरे आणि हिरवी मिरची परता. उकडलेल्या बटाट्याचे तुकडे घालून २ मिनिटे हलके तांबूस होईपर्यंत भाजा.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 3,
          title: 'खिचडी परतून वाफ काढणे',
          instruction:
              'साबुदाणा मिश्रण कढईत घालून मध्यम आचेवर ३-४ मिनिटे सतत ढवळा. साबुदाणा पांढऱ्याचा हलका पारदर्शक झाला की झाकण ठेवून मंद आचेवर २ मिनिटे वाफ काढा.',
          timerSeconds: 300,
        ),
        CookingStep(
          number: 4,
          title: 'लिंबू पिळून सर्व्ह करणे',
          instruction:
              'गॅस बंद करा, वरून लिंबाचा रस पिळा आणि उपवासाच्या दह्यासोबत गरमागरम सर्व्ह करा.',
          timerSeconds: 60,
        ),
      ],
    ),
    Recipe(
      id: 'rec_mumbai_pav_bhaji',
      title: 'मुंबई स्पेशल चमचमीत पावभाजी (Mumbai Pav Bhaji)',
      category: 'स्ट्रीट फूड',
      imageUrl:
          'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=900&q=80',
      time: '२५ मिनिटे',
      calories: '४६० कॅलरी',
      servings: '४ व्यक्तींसाठी',
      rating: '4.9',
      reviews: '5.1k',
      difficulty: 'Medium',
      description:
          'भरपूर बटर, मॅश केलेल्या भाज्या, सुवासिक पावभाजी मसाला आणि बटरमध्ये भाजलेला गरमागरम मऊ पाव!',
      ingredients: [
        IngredientItem(
            name: 'उकडलेले बटाटे व फ्लॉवर, मटार',
            amount: '३ वाट्या (मॅश केलेले)'),
        IngredientItem(
            name: 'बारीक चिरलेला कांदा व टोमॅटो', amount: '२-२ मोठे'),
        IngredientItem(
            name: 'शिमला मिरची (Capsicum)', amount: '१/२ वाटी बारीक चिरून'),
        IngredientItem(name: 'आले-लसूण पेस्ट', amount: '१.५ चमचा'),
        IngredientItem(name: 'अमूल बटर (Butter)', amount: '३-४ मोठे चमचे'),
        IngredientItem(
            name: 'स्पेशल पावभाजी मसाला व कसुरी मेथी', amount: '२ मोठे चमचे'),
        IngredientItem(name: 'काश्मिरी लाल तिखट व मीठ', amount: 'चवीनुसार'),
        IngredientItem(
            name: 'लादी पाव, कांदा व लिंबू', amount: 'सर्व्हिंगसाठी'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'भाज्या उकडणे व मॅश करणे',
          instruction:
              'बटाटे, मटार आणि फ्लॉवर कुकरमध्ये शिजवून पोटॅटो मॅशरने मऊ मॅश करून घ्या.',
          timerSeconds: 240,
        ),
        CookingStep(
          number: 2,
          title: 'बटरमध्ये मसाला परतणे',
          instruction:
              'तव्यावर किंवा कढईत भरपूर बटर व थोडे तेल गरम करा. कांदा व शिमला मिरची मऊ होईपर्यंत परता. आले-लसूण पेस्ट आणि टोमॅटो घालून तेल सुटेपर्यंत भाजा.',
          timerSeconds: 360,
        ),
        CookingStep(
          number: 3,
          title: 'पावभाजी मसाला व भाजी शिजवणे',
          instruction:
              'पावभाजी मसाला, लाल तिखट, मीठ आणि मॅश केलेल्या भाज्या घाला. थोडे गरम पाणी घालून पोटॅटो मॅशरने पुन्हा तव्यावर चांगले मॅश करा व ५-७ मिनिटे उकळा.',
          timerSeconds: 420,
        ),
        CookingStep(
          number: 4,
          title: 'बटर पाव भाजणे व सर्व्ह करणे',
          instruction:
              'भाजीवर कसुरी मेथी व भरपूर कोथिंबीर टाका. तव्यावर बटर व पावभाजी मसाला टाकून लादी पाव दोन्ही बाजूंनी कुरकुरीत भाजून गरमागरम वाढा!',
          timerSeconds: 180,
        ),
      ],
    ),
  ];

  late final List<Recipe> _savedRecipes = [
    _allRecipes[0],
    _allRecipes[1],
  ];

  late Recipe _currentRecipe = _allRecipes[0];

  final List<String> _selectedIngredients = [
    'कांदा (Onion)',
    'बटाटा (Potato)',
    'लसूण-आले (Garlic-Ginger)',
    'हिरवी मिरची (Green Chillies)',
  ];

  final List<String> _selectedPreferences = [];
  String _homeCategoryFilter = 'सर्व रेसिपी';
  String _savedCategoryFilter = 'All';
  String _homeSearchQuery = '';
  String _savedSearchQuery = '';
  String _currentLanguage = 'mr';
  bool _isAiGenerating = false;

  // Getters
  List<Recipe> get allRecipes => _allRecipes;
  List<Recipe> get savedRecipes => _savedRecipes;
  Recipe get currentRecipe => _currentRecipe;
  List<String> get selectedIngredients => _selectedIngredients;
  List<String> get selectedPreferences => _selectedPreferences;
  String get homeCategoryFilter => _homeCategoryFilter;
  String get savedCategoryFilter => _savedCategoryFilter;
  String get homeSearchQuery => _homeSearchQuery;
  String get savedSearchQuery => _savedSearchQuery;
  String get currentLanguage => _currentLanguage;
  bool get isAiGenerating => _isAiGenerating;

  List<Recipe> get filteredHomeRecipes {
    return _allRecipes.where((r) {
      final matchesCategory = _homeCategoryFilter == 'All' ||
          _homeCategoryFilter == 'सर्व रेसिपी' ||
          _homeCategoryFilter == 'All Dishes' ||
          _homeCategoryFilter == 'सभी रेसिपी' ||
          r.category
              .toLowerCase()
              .contains(_homeCategoryFilter.toLowerCase()) ||
          _homeCategoryFilter.toLowerCase().contains(r.category.toLowerCase());

      final matchesSearch = _homeSearchQuery.isEmpty ||
          r.title.toLowerCase().contains(_homeSearchQuery.toLowerCase()) ||
          r.description
              .toLowerCase()
              .contains(_homeSearchQuery.toLowerCase()) ||
          r.ingredients.any((i) =>
              i.name.toLowerCase().contains(_homeSearchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Recipe> get filteredSavedRecipes {
    return _savedRecipes.where((r) {
      final matchesCategory = _savedCategoryFilter == 'All' ||
          _savedCategoryFilter == 'सर्व रेसिपी' ||
          r.category == _savedCategoryFilter;
      final matchesSearch = _savedSearchQuery.isEmpty ||
          r.title.toLowerCase().contains(_savedSearchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  bool isSaved(String recipeId) {
    return _savedRecipes.any((r) => r.id == recipeId);
  }

  void setLanguage(String langCode) {
    _currentLanguage = langCode;
    notifyListeners();
  }

  void toggleSave(Recipe recipe) {
    final index = _savedRecipes.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      _savedRecipes.removeAt(index);
    } else {
      _savedRecipes.add(recipe);
    }
    notifyListeners();
  }

  void setCurrentRecipe(Recipe recipe) {
    _currentRecipe = recipe;
    notifyListeners();
  }

  void setHomeCategoryFilter(String category) {
    _homeCategoryFilter = category;
    notifyListeners();
  }

  void setSavedCategoryFilter(String category) {
    _savedCategoryFilter = category;
    notifyListeners();
  }

  void setHomeSearchQuery(String query) {
    _homeSearchQuery = query;
    notifyListeners();
  }

  void setSavedSearchQuery(String query) {
    _savedSearchQuery = query;
    notifyListeners();
  }

  void toggleIngredient(String item) {
    if (_selectedIngredients.contains(item)) {
      _selectedIngredients.remove(item);
    } else {
      _selectedIngredients.add(item);
    }
    notifyListeners();
  }

  void addCustomIngredient(String item) {
    final clean = item.trim();
    if (clean.isNotEmpty && !_selectedIngredients.contains(clean)) {
      _selectedIngredients.add(clean);
      notifyListeners();
    }
  }

  void removeIngredient(String item) {
    _selectedIngredients.remove(item);
    notifyListeners();
  }

  void clearIngredients() {
    _selectedIngredients.clear();
    notifyListeners();
  }

  void togglePreference(String pref) {
    if (_selectedPreferences.contains(pref)) {
      _selectedPreferences.remove(pref);
    } else {
      _selectedPreferences.add(pref);
    }
    notifyListeners();
  }

  void toggleIngredientCheck(int idx) {
    if (idx >= 0 && idx < _currentRecipe.ingredients.length) {
      _currentRecipe.ingredients[idx].isChecked =
          !_currentRecipe.ingredients[idx].isChecked;
      notifyListeners();
    }
  }

  void toggleAllIngredientsCheck() {
    final allChecked = _currentRecipe.ingredients.every((i) => i.isChecked);
    for (var ing in _currentRecipe.ingredients) {
      ing.isChecked = !allChecked;
    }
    notifyListeners();
  }

  Future<Recipe> generateRecipeFromPantry() async {
    _isAiGenerating = true;
    notifyListeners();

    try {
      final generated = await GeminiService.generateRecipe(
        ingredients: _selectedIngredients,
        preferences: _selectedPreferences,
        language: _currentLanguage,
      );

      _currentRecipe = generated;
      // Prepend to all recipes feed so it shows at the top
      if (!_allRecipes.any((r) => r.id == generated.id)) {
        _allRecipes.insert(0, generated);
      }

      _isAiGenerating = false;
      notifyListeners();
      return generated;
    } catch (e) {
      _isAiGenerating = false;
      notifyListeners();
      rethrow;
    }
  }
}
