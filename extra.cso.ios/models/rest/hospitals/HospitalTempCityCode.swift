
enum HospitalTempCityCode: String, Decodable, CaseIterable {
    case CODE_000000
    case CODE_110001
    case CODE_110002
    case CODE_110003
    case CODE_110004
    case CODE_110005
    case CODE_110006
    case CODE_110007
    case CODE_110008
    case CODE_110009
    case CODE_110010
    case CODE_110011
    case CODE_110012
    case CODE_110013
    case CODE_110014
    case CODE_110015
    case CODE_110016
    case CODE_110017
    case CODE_110018
    case CODE_110019
    case CODE_110020
    case CODE_110021
    case CODE_110022
    case CODE_110023
    case CODE_110024
    case CODE_110025
    case CODE_210001
    case CODE_210002
    case CODE_210003
    case CODE_210004
    case CODE_210005
    case CODE_210006
    case CODE_210007
    case CODE_210008
    case CODE_210009
    case CODE_210010
    case CODE_210011
    case CODE_210012
    case CODE_210013
    case CODE_210014
    case CODE_210015
    case CODE_210100
    case CODE_220001
    case CODE_220002
    case CODE_220003
    case CODE_220004
    case CODE_220005
    case CODE_220006
    case CODE_220007
    case CODE_220008
    case CODE_220100
    case CODE_220200
    case CODE_230001
    case CODE_230002
    case CODE_230003
    case CODE_230004
    case CODE_230005
    case CODE_230006
    case CODE_230007
    case CODE_230100
    case CODE_230200
    case CODE_240001
    case CODE_240002
    case CODE_240003
    case CODE_240004
    case CODE_240005
    case CODE_250001
    case CODE_250002
    case CODE_250003
    case CODE_250004
    case CODE_250005
    case CODE_260001
    case CODE_260002
    case CODE_260003
    case CODE_260004
    case CODE_260100
    case CODE_310001
    case CODE_310002
    case CODE_310006
    case CODE_310008
    case CODE_310009
    case CODE_310010
    case CODE_310011
    case CODE_310012
    case CODE_310016
    case CODE_310017
    case CODE_310100
    case CODE_310200
    case CODE_310300
    case CODE_310301
    case CODE_310302
    case CODE_310303
    case CODE_310401
    case CODE_310402
    case CODE_310403
    case CODE_310500
    case CODE_310600
    case CODE_310601
    case CODE_310602
    case CODE_310603
    case CODE_310604
    case CODE_310701
    case CODE_310702
    case CODE_310800
    case CODE_310900
    case CODE_311000
    case CODE_311100
    case CODE_311101
    case CODE_311102
    case CODE_311200
    case CODE_311300
    case CODE_311400
    case CODE_311500
    case CODE_311600
    case CODE_311700
    case CODE_311800
    case CODE_311901
    case CODE_311902
    case CODE_311903
    case CODE_312000
    case CODE_312001
    case CODE_312002
    case CODE_312003
    case CODE_312100
    case CODE_312200
    case CODE_312300
    case CODE_312400
    case CODE_312500
    case CODE_312600
    case CODE_312700
    case CODE_312800
    case CODE_312900
    case CODE_320001
    case CODE_320004
    case CODE_320005
    case CODE_320006
    case CODE_320008
    case CODE_320009
    case CODE_320010
    case CODE_320012
    case CODE_320013
    case CODE_320014
    case CODE_320015
    case CODE_320100
    case CODE_320200
    case CODE_320300
    case CODE_320400
    case CODE_320500
    case CODE_320600
    case CODE_320700
    case CODE_330001
    case CODE_330002
    case CODE_330003
    case CODE_330004
    case CODE_330005
    case CODE_330006
    case CODE_330007
    case CODE_330009
    case CODE_330010
    case CODE_330011
    case CODE_330100
    case CODE_330101
    case CODE_330102
    case CODE_330103
    case CODE_330104
    case CODE_330200
    case CODE_330300
    case CODE_340002
    case CODE_340004
    case CODE_340007
    case CODE_340009
    case CODE_340011
    case CODE_340012
    case CODE_340013
    case CODE_340014
    case CODE_340015
    case CODE_340016
    case CODE_340200
    case CODE_340201
    case CODE_340202
    case CODE_340300
    case CODE_340400
    case CODE_340500
    case CODE_340600
    case CODE_340700
    case CODE_340800
    case CODE_340900
    case CODE_350001
    case CODE_350004
    case CODE_350005
    case CODE_350006
    case CODE_350008
    case CODE_350009
    case CODE_350010
    case CODE_350011
    case CODE_350013
    case CODE_350100
    case CODE_350200
    case CODE_350300
    case CODE_350400
    case CODE_350401
    case CODE_350402
    case CODE_350500
    case CODE_350600
    case CODE_360001
    case CODE_360002
    case CODE_360003
    case CODE_360006
    case CODE_360008
    case CODE_360009
    case CODE_360010
    case CODE_360012
    case CODE_360014
    case CODE_360015
    case CODE_360016
    case CODE_360017
    case CODE_360018
    case CODE_360019
    case CODE_360020
    case CODE_360021
    case CODE_360022
    case CODE_360200
    case CODE_360300
    case CODE_360400
    case CODE_360500
    case CODE_360700
    case CODE_370002
    case CODE_370003
    case CODE_370005
    case CODE_370007
    case CODE_370010
    case CODE_370012
    case CODE_370013
    case CODE_370014
    case CODE_370017
    case CODE_370018
    case CODE_370019
    case CODE_370021
    case CODE_370022
    case CODE_370023
    case CODE_370024
    case CODE_370100
    case CODE_370200
    case CODE_370300
    case CODE_370400
    case CODE_370500
    case CODE_370600
    case CODE_370700
    case CODE_370701
    case CODE_370702
    case CODE_370800
    case CODE_370900
    case CODE_371000
    case CODE_380002
    case CODE_380003
    case CODE_380004
    case CODE_380005
    case CODE_380007
    case CODE_380008
    case CODE_380011
    case CODE_380012
    case CODE_380014
    case CODE_380016
    case CODE_380017
    case CODE_380018
    case CODE_380019
    case CODE_380100
    case CODE_380200
    case CODE_380300
    case CODE_380500
    case CODE_380600
    case CODE_380700
    case CODE_380701
    case CODE_380702
    case CODE_380703
    case CODE_380704
    case CODE_380705
    case CODE_380800
    case CODE_380900
    case CODE_381000
    case CODE_381100
    case CODE_390001
    case CODE_390002
    case CODE_390100
    case CODE_390200
    case CODE_410000
    
    var code: Int {
        switch self {
        case HospitalTempCityCode.CODE_000000: return 0
        case HospitalTempCityCode.CODE_110001: return 110001
        case HospitalTempCityCode.CODE_110002: return 110002
        case HospitalTempCityCode.CODE_110003: return 110003
        case HospitalTempCityCode.CODE_110004: return 110004
        case HospitalTempCityCode.CODE_110005: return 110005
        case HospitalTempCityCode.CODE_110006: return 110006
        case HospitalTempCityCode.CODE_110007: return 110007
        case HospitalTempCityCode.CODE_110008: return 110008
        case HospitalTempCityCode.CODE_110009: return 110009
        case HospitalTempCityCode.CODE_110010: return 110010
        case HospitalTempCityCode.CODE_110011: return 110011
        case HospitalTempCityCode.CODE_110012: return 110012
        case HospitalTempCityCode.CODE_110013: return 110013
        case HospitalTempCityCode.CODE_110014: return 110014
        case HospitalTempCityCode.CODE_110015: return 110015
        case HospitalTempCityCode.CODE_110016: return 110016
        case HospitalTempCityCode.CODE_110017: return 110017
        case HospitalTempCityCode.CODE_110018: return 110018
        case HospitalTempCityCode.CODE_110019: return 110019
        case HospitalTempCityCode.CODE_110020: return 110020
        case HospitalTempCityCode.CODE_110021: return 110021
        case HospitalTempCityCode.CODE_110022: return 110022
        case HospitalTempCityCode.CODE_110023: return 110023
        case HospitalTempCityCode.CODE_110024: return 110024
        case HospitalTempCityCode.CODE_110025: return 110025
        case HospitalTempCityCode.CODE_210001: return 210001
        case HospitalTempCityCode.CODE_210002: return 210002
        case HospitalTempCityCode.CODE_210003: return 210003
        case HospitalTempCityCode.CODE_210004: return 210004
        case HospitalTempCityCode.CODE_210005: return 210005
        case HospitalTempCityCode.CODE_210006: return 210006
        case HospitalTempCityCode.CODE_210007: return 210007
        case HospitalTempCityCode.CODE_210008: return 210008
        case HospitalTempCityCode.CODE_210009: return 210009
        case HospitalTempCityCode.CODE_210010: return 210010
        case HospitalTempCityCode.CODE_210011: return 210011
        case HospitalTempCityCode.CODE_210012: return 210012
        case HospitalTempCityCode.CODE_210013: return 210013
        case HospitalTempCityCode.CODE_210014: return 210014
        case HospitalTempCityCode.CODE_210015: return 210015
        case HospitalTempCityCode.CODE_210100: return 210100
        case HospitalTempCityCode.CODE_220001: return 220001
        case HospitalTempCityCode.CODE_220002: return 220002
        case HospitalTempCityCode.CODE_220003: return 220003
        case HospitalTempCityCode.CODE_220004: return 220004
        case HospitalTempCityCode.CODE_220005: return 220005
        case HospitalTempCityCode.CODE_220006: return 220006
        case HospitalTempCityCode.CODE_220007: return 220007
        case HospitalTempCityCode.CODE_220008: return 220008
        case HospitalTempCityCode.CODE_220100: return 220100
        case HospitalTempCityCode.CODE_220200: return 220200
        case HospitalTempCityCode.CODE_230001: return 230001
        case HospitalTempCityCode.CODE_230002: return 230002
        case HospitalTempCityCode.CODE_230003: return 230003
        case HospitalTempCityCode.CODE_230004: return 230004
        case HospitalTempCityCode.CODE_230005: return 230005
        case HospitalTempCityCode.CODE_230006: return 230006
        case HospitalTempCityCode.CODE_230007: return 230007
        case HospitalTempCityCode.CODE_230100: return 230100
        case HospitalTempCityCode.CODE_230200: return 230200
        case HospitalTempCityCode.CODE_240001: return 240001
        case HospitalTempCityCode.CODE_240002: return 240002
        case HospitalTempCityCode.CODE_240003: return 240003
        case HospitalTempCityCode.CODE_240004: return 240004
        case HospitalTempCityCode.CODE_240005: return 240005
        case HospitalTempCityCode.CODE_250001: return 250001
        case HospitalTempCityCode.CODE_250002: return 250002
        case HospitalTempCityCode.CODE_250003: return 250003
        case HospitalTempCityCode.CODE_250004: return 250004
        case HospitalTempCityCode.CODE_250005: return 250005
        case HospitalTempCityCode.CODE_260001: return 260001
        case HospitalTempCityCode.CODE_260002: return 260002
        case HospitalTempCityCode.CODE_260003: return 260003
        case HospitalTempCityCode.CODE_260004: return 260004
        case HospitalTempCityCode.CODE_260100: return 260100
        case HospitalTempCityCode.CODE_310001: return 310001
        case HospitalTempCityCode.CODE_310002: return 310002
        case HospitalTempCityCode.CODE_310006: return 310006
        case HospitalTempCityCode.CODE_310008: return 310008
        case HospitalTempCityCode.CODE_310009: return 310009
        case HospitalTempCityCode.CODE_310010: return 310010
        case HospitalTempCityCode.CODE_310011: return 310011
        case HospitalTempCityCode.CODE_310012: return 310012
        case HospitalTempCityCode.CODE_310016: return 310016
        case HospitalTempCityCode.CODE_310017: return 310017
        case HospitalTempCityCode.CODE_310100: return 310100
        case HospitalTempCityCode.CODE_310200: return 310200
        case HospitalTempCityCode.CODE_310300: return 310300
        case HospitalTempCityCode.CODE_310301: return 310301
        case HospitalTempCityCode.CODE_310302: return 310302
        case HospitalTempCityCode.CODE_310303: return 310303
        case HospitalTempCityCode.CODE_310401: return 310401
        case HospitalTempCityCode.CODE_310402: return 310402
        case HospitalTempCityCode.CODE_310403: return 310403
        case HospitalTempCityCode.CODE_310500: return 310500
        case HospitalTempCityCode.CODE_310600: return 310600
        case HospitalTempCityCode.CODE_310601: return 310601
        case HospitalTempCityCode.CODE_310602: return 310602
        case HospitalTempCityCode.CODE_310603: return 310603
        case HospitalTempCityCode.CODE_310604: return 310604
        case HospitalTempCityCode.CODE_310701: return 310701
        case HospitalTempCityCode.CODE_310702: return 310702
        case HospitalTempCityCode.CODE_310800: return 310800
        case HospitalTempCityCode.CODE_310900: return 310900
        case HospitalTempCityCode.CODE_311000: return 311000
        case HospitalTempCityCode.CODE_311100: return 311100
        case HospitalTempCityCode.CODE_311101: return 311101
        case HospitalTempCityCode.CODE_311102: return 311102
        case HospitalTempCityCode.CODE_311200: return 311200
        case HospitalTempCityCode.CODE_311300: return 311300
        case HospitalTempCityCode.CODE_311400: return 311400
        case HospitalTempCityCode.CODE_311500: return 311500
        case HospitalTempCityCode.CODE_311600: return 311600
        case HospitalTempCityCode.CODE_311700: return 311700
        case HospitalTempCityCode.CODE_311800: return 311800
        case HospitalTempCityCode.CODE_311901: return 311901
        case HospitalTempCityCode.CODE_311902: return 311902
        case HospitalTempCityCode.CODE_311903: return 311903
        case HospitalTempCityCode.CODE_312000: return 312000
        case HospitalTempCityCode.CODE_312001: return 312001
        case HospitalTempCityCode.CODE_312002: return 312002
        case HospitalTempCityCode.CODE_312003: return 312003
        case HospitalTempCityCode.CODE_312100: return 312100
        case HospitalTempCityCode.CODE_312200: return 312200
        case HospitalTempCityCode.CODE_312300: return 312300
        case HospitalTempCityCode.CODE_312400: return 312400
        case HospitalTempCityCode.CODE_312500: return 312500
        case HospitalTempCityCode.CODE_312600: return 312600
        case HospitalTempCityCode.CODE_312700: return 312700
        case HospitalTempCityCode.CODE_312800: return 312800
        case HospitalTempCityCode.CODE_312900: return 312900
        case HospitalTempCityCode.CODE_320001: return 320001
        case HospitalTempCityCode.CODE_320004: return 320004
        case HospitalTempCityCode.CODE_320005: return 320005
        case HospitalTempCityCode.CODE_320006: return 320006
        case HospitalTempCityCode.CODE_320008: return 320008
        case HospitalTempCityCode.CODE_320009: return 320009
        case HospitalTempCityCode.CODE_320010: return 320010
        case HospitalTempCityCode.CODE_320012: return 320012
        case HospitalTempCityCode.CODE_320013: return 320013
        case HospitalTempCityCode.CODE_320014: return 320014
        case HospitalTempCityCode.CODE_320015: return 320015
        case HospitalTempCityCode.CODE_320100: return 320100
        case HospitalTempCityCode.CODE_320200: return 320200
        case HospitalTempCityCode.CODE_320300: return 320300
        case HospitalTempCityCode.CODE_320400: return 320400
        case HospitalTempCityCode.CODE_320500: return 320500
        case HospitalTempCityCode.CODE_320600: return 320600
        case HospitalTempCityCode.CODE_320700: return 320700
        case HospitalTempCityCode.CODE_330001: return 330001
        case HospitalTempCityCode.CODE_330002: return 330002
        case HospitalTempCityCode.CODE_330003: return 330003
        case HospitalTempCityCode.CODE_330004: return 330004
        case HospitalTempCityCode.CODE_330005: return 330005
        case HospitalTempCityCode.CODE_330006: return 330006
        case HospitalTempCityCode.CODE_330007: return 330007
        case HospitalTempCityCode.CODE_330009: return 330009
        case HospitalTempCityCode.CODE_330010: return 330010
        case HospitalTempCityCode.CODE_330011: return 330011
        case HospitalTempCityCode.CODE_330100: return 330100
        case HospitalTempCityCode.CODE_330101: return 330101
        case HospitalTempCityCode.CODE_330102: return 330102
        case HospitalTempCityCode.CODE_330103: return 330103
        case HospitalTempCityCode.CODE_330104: return 330104
        case HospitalTempCityCode.CODE_330200: return 330200
        case HospitalTempCityCode.CODE_330300: return 330300
        case HospitalTempCityCode.CODE_340002: return 340002
        case HospitalTempCityCode.CODE_340004: return 340004
        case HospitalTempCityCode.CODE_340007: return 340007
        case HospitalTempCityCode.CODE_340009: return 340009
        case HospitalTempCityCode.CODE_340011: return 340011
        case HospitalTempCityCode.CODE_340012: return 340012
        case HospitalTempCityCode.CODE_340013: return 340013
        case HospitalTempCityCode.CODE_340014: return 340014
        case HospitalTempCityCode.CODE_340015: return 340015
        case HospitalTempCityCode.CODE_340016: return 340016
        case HospitalTempCityCode.CODE_340200: return 340200
        case HospitalTempCityCode.CODE_340201: return 340201
        case HospitalTempCityCode.CODE_340202: return 340202
        case HospitalTempCityCode.CODE_340300: return 340300
        case HospitalTempCityCode.CODE_340400: return 340400
        case HospitalTempCityCode.CODE_340500: return 340500
        case HospitalTempCityCode.CODE_340600: return 340600
        case HospitalTempCityCode.CODE_340700: return 340700
        case HospitalTempCityCode.CODE_340800: return 340800
        case HospitalTempCityCode.CODE_340900: return 340900
        case HospitalTempCityCode.CODE_350001: return 350001
        case HospitalTempCityCode.CODE_350004: return 350004
        case HospitalTempCityCode.CODE_350005: return 350005
        case HospitalTempCityCode.CODE_350006: return 350006
        case HospitalTempCityCode.CODE_350008: return 350008
        case HospitalTempCityCode.CODE_350009: return 350009
        case HospitalTempCityCode.CODE_350010: return 350010
        case HospitalTempCityCode.CODE_350011: return 350011
        case HospitalTempCityCode.CODE_350013: return 350013
        case HospitalTempCityCode.CODE_350100: return 350100
        case HospitalTempCityCode.CODE_350200: return 350200
        case HospitalTempCityCode.CODE_350300: return 350300
        case HospitalTempCityCode.CODE_350400: return 350400
        case HospitalTempCityCode.CODE_350401: return 350401
        case HospitalTempCityCode.CODE_350402: return 350402
        case HospitalTempCityCode.CODE_350500: return 350500
        case HospitalTempCityCode.CODE_350600: return 350600
        case HospitalTempCityCode.CODE_360001: return 360001
        case HospitalTempCityCode.CODE_360002: return 360002
        case HospitalTempCityCode.CODE_360003: return 360003
        case HospitalTempCityCode.CODE_360006: return 360006
        case HospitalTempCityCode.CODE_360008: return 360008
        case HospitalTempCityCode.CODE_360009: return 360009
        case HospitalTempCityCode.CODE_360010: return 360010
        case HospitalTempCityCode.CODE_360012: return 360012
        case HospitalTempCityCode.CODE_360014: return 360014
        case HospitalTempCityCode.CODE_360015: return 360015
        case HospitalTempCityCode.CODE_360016: return 360016
        case HospitalTempCityCode.CODE_360017: return 360017
        case HospitalTempCityCode.CODE_360018: return 360018
        case HospitalTempCityCode.CODE_360019: return 360019
        case HospitalTempCityCode.CODE_360020: return 360020
        case HospitalTempCityCode.CODE_360021: return 360021
        case HospitalTempCityCode.CODE_360022: return 360022
        case HospitalTempCityCode.CODE_360200: return 360200
        case HospitalTempCityCode.CODE_360300: return 360300
        case HospitalTempCityCode.CODE_360400: return 360400
        case HospitalTempCityCode.CODE_360500: return 360500
        case HospitalTempCityCode.CODE_360700: return 360700
        case HospitalTempCityCode.CODE_370002: return 370002
        case HospitalTempCityCode.CODE_370003: return 370003
        case HospitalTempCityCode.CODE_370005: return 370005
        case HospitalTempCityCode.CODE_370007: return 370007
        case HospitalTempCityCode.CODE_370010: return 370010
        case HospitalTempCityCode.CODE_370012: return 370012
        case HospitalTempCityCode.CODE_370013: return 370013
        case HospitalTempCityCode.CODE_370014: return 370014
        case HospitalTempCityCode.CODE_370017: return 370017
        case HospitalTempCityCode.CODE_370018: return 370018
        case HospitalTempCityCode.CODE_370019: return 370019
        case HospitalTempCityCode.CODE_370021: return 370021
        case HospitalTempCityCode.CODE_370022: return 370022
        case HospitalTempCityCode.CODE_370023: return 370023
        case HospitalTempCityCode.CODE_370024: return 370024
        case HospitalTempCityCode.CODE_370100: return 370100
        case HospitalTempCityCode.CODE_370200: return 370200
        case HospitalTempCityCode.CODE_370300: return 370300
        case HospitalTempCityCode.CODE_370400: return 370400
        case HospitalTempCityCode.CODE_370500: return 370500
        case HospitalTempCityCode.CODE_370600: return 370600
        case HospitalTempCityCode.CODE_370700: return 370700
        case HospitalTempCityCode.CODE_370701: return 370701
        case HospitalTempCityCode.CODE_370702: return 370702
        case HospitalTempCityCode.CODE_370800: return 370800
        case HospitalTempCityCode.CODE_370900: return 370900
        case HospitalTempCityCode.CODE_371000: return 371000
        case HospitalTempCityCode.CODE_380002: return 380002
        case HospitalTempCityCode.CODE_380003: return 380003
        case HospitalTempCityCode.CODE_380004: return 380004
        case HospitalTempCityCode.CODE_380005: return 380005
        case HospitalTempCityCode.CODE_380007: return 380007
        case HospitalTempCityCode.CODE_380008: return 380008
        case HospitalTempCityCode.CODE_380011: return 380011
        case HospitalTempCityCode.CODE_380012: return 380012
        case HospitalTempCityCode.CODE_380014: return 380014
        case HospitalTempCityCode.CODE_380016: return 380016
        case HospitalTempCityCode.CODE_380017: return 380017
        case HospitalTempCityCode.CODE_380018: return 380018
        case HospitalTempCityCode.CODE_380019: return 380019
        case HospitalTempCityCode.CODE_380100: return 380100
        case HospitalTempCityCode.CODE_380200: return 380200
        case HospitalTempCityCode.CODE_380300: return 380300
        case HospitalTempCityCode.CODE_380500: return 380500
        case HospitalTempCityCode.CODE_380600: return 380600
        case HospitalTempCityCode.CODE_380700: return 380700
        case HospitalTempCityCode.CODE_380701: return 380701
        case HospitalTempCityCode.CODE_380702: return 380702
        case HospitalTempCityCode.CODE_380703: return 380703
        case HospitalTempCityCode.CODE_380704: return 380704
        case HospitalTempCityCode.CODE_380705: return 380705
        case HospitalTempCityCode.CODE_380800: return 380800
        case HospitalTempCityCode.CODE_380900: return 380900
        case HospitalTempCityCode.CODE_381000: return 381000
        case HospitalTempCityCode.CODE_381100: return 381100
        case HospitalTempCityCode.CODE_390001: return 390001
        case HospitalTempCityCode.CODE_390002: return 390002
        case HospitalTempCityCode.CODE_390100: return 390100
        case HospitalTempCityCode.CODE_390200: return 390200
        case HospitalTempCityCode.CODE_410000: return 410000
        }
    }
    var desc: String {
        switch self {
        case HospitalTempCityCode.CODE_000000: return "미지정"
        case HospitalTempCityCode.CODE_110001: return "강남구"
        case HospitalTempCityCode.CODE_110002: return "강동구"
        case HospitalTempCityCode.CODE_110003: return "강서구"
        case HospitalTempCityCode.CODE_110004: return "관악구"
        case HospitalTempCityCode.CODE_110005: return "구로구"
        case HospitalTempCityCode.CODE_110006: return "도봉구"
        case HospitalTempCityCode.CODE_110007: return "동대문구"
        case HospitalTempCityCode.CODE_110008: return "동작구"
        case HospitalTempCityCode.CODE_110009: return "마포구"
        case HospitalTempCityCode.CODE_110010: return "서대문구"
        case HospitalTempCityCode.CODE_110011: return "성동구"
        case HospitalTempCityCode.CODE_110012: return "성북구"
        case HospitalTempCityCode.CODE_110013: return "영등포구"
        case HospitalTempCityCode.CODE_110014: return "용산구"
        case HospitalTempCityCode.CODE_110015: return "은평구"
        case HospitalTempCityCode.CODE_110016: return "종로구"
        case HospitalTempCityCode.CODE_110017: return "중구"
        case HospitalTempCityCode.CODE_110018: return "송파구"
        case HospitalTempCityCode.CODE_110019: return "중랑구"
        case HospitalTempCityCode.CODE_110020: return "양천구"
        case HospitalTempCityCode.CODE_110021: return "서초구"
        case HospitalTempCityCode.CODE_110022: return "노원구"
        case HospitalTempCityCode.CODE_110023: return "광진구"
        case HospitalTempCityCode.CODE_110024: return "강북구"
        case HospitalTempCityCode.CODE_110025: return "금천구"
        case HospitalTempCityCode.CODE_210001: return "부산남구"
        case HospitalTempCityCode.CODE_210002: return "부산동구"
        case HospitalTempCityCode.CODE_210003: return "부산동래구"
        case HospitalTempCityCode.CODE_210004: return "부산진구"
        case HospitalTempCityCode.CODE_210005: return "부산북구"
        case HospitalTempCityCode.CODE_210006: return "부산서구"
        case HospitalTempCityCode.CODE_210007: return "부산영도구"
        case HospitalTempCityCode.CODE_210008: return "부산중구"
        case HospitalTempCityCode.CODE_210009: return "부산해운대구"
        case HospitalTempCityCode.CODE_210010: return "부산사하구"
        case HospitalTempCityCode.CODE_210011: return "부산금정구"
        case HospitalTempCityCode.CODE_210012: return "부산강서구"
        case HospitalTempCityCode.CODE_210013: return "부산연제구"
        case HospitalTempCityCode.CODE_210014: return "부산수영구"
        case HospitalTempCityCode.CODE_210015: return "부산사상구"
        case HospitalTempCityCode.CODE_210100: return "부산기장군"
        case HospitalTempCityCode.CODE_220001: return "인천미추홀구"
        case HospitalTempCityCode.CODE_220002: return "인천동구"
        case HospitalTempCityCode.CODE_220003: return "인천부평구"
        case HospitalTempCityCode.CODE_220004: return "인천중구"
        case HospitalTempCityCode.CODE_220005: return "인천서구"
        case HospitalTempCityCode.CODE_220006: return "인천남동구"
        case HospitalTempCityCode.CODE_220007: return "인천연수구"
        case HospitalTempCityCode.CODE_220008: return "인천계양구"
        case HospitalTempCityCode.CODE_220100: return "인천강화군"
        case HospitalTempCityCode.CODE_220200: return "인천옹진군"
        case HospitalTempCityCode.CODE_230001: return "대구남구"
        case HospitalTempCityCode.CODE_230002: return "대구동구"
        case HospitalTempCityCode.CODE_230003: return "대구북구"
        case HospitalTempCityCode.CODE_230004: return "대구서구"
        case HospitalTempCityCode.CODE_230005: return "대구수성구"
        case HospitalTempCityCode.CODE_230006: return "대구중구"
        case HospitalTempCityCode.CODE_230007: return "대구달서구"
        case HospitalTempCityCode.CODE_230100: return "대구달성군"
        case HospitalTempCityCode.CODE_230200: return "대구군위군"
        case HospitalTempCityCode.CODE_240001: return "광주동구"
        case HospitalTempCityCode.CODE_240002: return "광주북구"
        case HospitalTempCityCode.CODE_240003: return "광주서구"
        case HospitalTempCityCode.CODE_240004: return "광주광산구"
        case HospitalTempCityCode.CODE_240005: return "광주남구"
        case HospitalTempCityCode.CODE_250001: return "대전유성구"
        case HospitalTempCityCode.CODE_250002: return "대전대덕구"
        case HospitalTempCityCode.CODE_250003: return "대전서구"
        case HospitalTempCityCode.CODE_250004: return "대전동구"
        case HospitalTempCityCode.CODE_250005: return "대전중구"
        case HospitalTempCityCode.CODE_260001: return "울산남구"
        case HospitalTempCityCode.CODE_260002: return "울산동구"
        case HospitalTempCityCode.CODE_260003: return "울산중구"
        case HospitalTempCityCode.CODE_260004: return "울산북구"
        case HospitalTempCityCode.CODE_260100: return "울산울주군"
        case HospitalTempCityCode.CODE_310001: return "가평군"
        case HospitalTempCityCode.CODE_310002: return "강화군"
        case HospitalTempCityCode.CODE_310006: return "시흥시"
        case HospitalTempCityCode.CODE_310008: return "양주군"
        case HospitalTempCityCode.CODE_310009: return "양평군"
        case HospitalTempCityCode.CODE_310010: return "여주군"
        case HospitalTempCityCode.CODE_310011: return "연천군"
        case HospitalTempCityCode.CODE_310012: return "옹진군"
        case HospitalTempCityCode.CODE_310016: return "평택군"
        case HospitalTempCityCode.CODE_310017: return "포천군"
        case HospitalTempCityCode.CODE_310100: return "광명시"
        case HospitalTempCityCode.CODE_310200: return "동두천시"
        case HospitalTempCityCode.CODE_310300: return "부천시"
        case HospitalTempCityCode.CODE_310301: return "부천소사구"
        case HospitalTempCityCode.CODE_310302: return "부천오정구"
        case HospitalTempCityCode.CODE_310303: return "부천원미구"
        case HospitalTempCityCode.CODE_310401: return "성남수정구"
        case HospitalTempCityCode.CODE_310402: return "성남중원구"
        case HospitalTempCityCode.CODE_310403: return "성남분당구"
        case HospitalTempCityCode.CODE_310500: return "송탄시"
        case HospitalTempCityCode.CODE_310600: return "수원시"
        case HospitalTempCityCode.CODE_310601: return "수원권선구"
        case HospitalTempCityCode.CODE_310602: return "수원장안구"
        case HospitalTempCityCode.CODE_310603: return "수원팔달구"
        case HospitalTempCityCode.CODE_310604: return "수원영통구"
        case HospitalTempCityCode.CODE_310701: return "안양만안구"
        case HospitalTempCityCode.CODE_310702: return "안양동안구"
        case HospitalTempCityCode.CODE_310800: return "의정부시"
        case HospitalTempCityCode.CODE_310900: return "과천시"
        case HospitalTempCityCode.CODE_311000: return "구리시"
        case HospitalTempCityCode.CODE_311100: return "안산시"
        case HospitalTempCityCode.CODE_311101: return "안산단원구"
        case HospitalTempCityCode.CODE_311102: return "안산상록구"
        case HospitalTempCityCode.CODE_311200: return "평택시"
        case HospitalTempCityCode.CODE_311300: return "하남시"
        case HospitalTempCityCode.CODE_311400: return "군포시"
        case HospitalTempCityCode.CODE_311500: return "남양주시"
        case HospitalTempCityCode.CODE_311600: return "의왕시"
        case HospitalTempCityCode.CODE_311700: return "시흥시"
        case HospitalTempCityCode.CODE_311800: return "오산시"
        case HospitalTempCityCode.CODE_311901: return "고양덕양구"
        case HospitalTempCityCode.CODE_311902: return "고양일산서구"
        case HospitalTempCityCode.CODE_311903: return "고양일산동구"
        case HospitalTempCityCode.CODE_312000: return "용인시"
        case HospitalTempCityCode.CODE_312001: return "용인기흥구"
        case HospitalTempCityCode.CODE_312002: return "용인수지구"
        case HospitalTempCityCode.CODE_312003: return "용인처인구"
        case HospitalTempCityCode.CODE_312100: return "이천시"
        case HospitalTempCityCode.CODE_312200: return "파주시"
        case HospitalTempCityCode.CODE_312300: return "김포시"
        case HospitalTempCityCode.CODE_312400: return "안성시"
        case HospitalTempCityCode.CODE_312500: return "화성시"
        case HospitalTempCityCode.CODE_312600: return "광주시"
        case HospitalTempCityCode.CODE_312700: return "양주시"
        case HospitalTempCityCode.CODE_312800: return "포천시"
        case HospitalTempCityCode.CODE_312900: return "여주시"
        case HospitalTempCityCode.CODE_320001: return "고성군"
        case HospitalTempCityCode.CODE_320004: return "양구군"
        case HospitalTempCityCode.CODE_320005: return "양양군"
        case HospitalTempCityCode.CODE_320006: return "영월군"
        case HospitalTempCityCode.CODE_320008: return "인제군"
        case HospitalTempCityCode.CODE_320009: return "정선군"
        case HospitalTempCityCode.CODE_320010: return "철원군"
        case HospitalTempCityCode.CODE_320012: return "평창군"
        case HospitalTempCityCode.CODE_320013: return "홍천군"
        case HospitalTempCityCode.CODE_320014: return "화천군"
        case HospitalTempCityCode.CODE_320015: return "횡성군"
        case HospitalTempCityCode.CODE_320100: return "강릉시"
        case HospitalTempCityCode.CODE_320200: return "동해시"
        case HospitalTempCityCode.CODE_320300: return "속초시"
        case HospitalTempCityCode.CODE_320400: return "원주시"
        case HospitalTempCityCode.CODE_320500: return "춘천시"
        case HospitalTempCityCode.CODE_320600: return "태백시"
        case HospitalTempCityCode.CODE_320700: return "삼척시"
        case HospitalTempCityCode.CODE_330001: return "괴산군"
        case HospitalTempCityCode.CODE_330002: return "단양군"
        case HospitalTempCityCode.CODE_330003: return "보은군"
        case HospitalTempCityCode.CODE_330004: return "영동군"
        case HospitalTempCityCode.CODE_330005: return "옥천군"
        case HospitalTempCityCode.CODE_330006: return "음성군"
        case HospitalTempCityCode.CODE_330007: return "제천군"
        case HospitalTempCityCode.CODE_330009: return "진천군"
        case HospitalTempCityCode.CODE_330010: return "청원군"
        case HospitalTempCityCode.CODE_330011: return "증평군"
        case HospitalTempCityCode.CODE_330100: return "청주시"
        case HospitalTempCityCode.CODE_330101: return "청주상당구"
        case HospitalTempCityCode.CODE_330102: return "청주흥덕구"
        case HospitalTempCityCode.CODE_330103: return "청주청원구"
        case HospitalTempCityCode.CODE_330104: return "청주서원구"
        case HospitalTempCityCode.CODE_330200: return "충주시"
        case HospitalTempCityCode.CODE_330300: return "제천시"
        case HospitalTempCityCode.CODE_340002: return "금산군"
        case HospitalTempCityCode.CODE_340004: return "당진군"
        case HospitalTempCityCode.CODE_340007: return "부여군"
        case HospitalTempCityCode.CODE_340009: return "서천군"
        case HospitalTempCityCode.CODE_340011: return "연기군"
        case HospitalTempCityCode.CODE_340012: return "예산군"
        case HospitalTempCityCode.CODE_340013: return "천안군"
        case HospitalTempCityCode.CODE_340014: return "청양군"
        case HospitalTempCityCode.CODE_340015: return "홍성군"
        case HospitalTempCityCode.CODE_340016: return "태안군"
        case HospitalTempCityCode.CODE_340200: return "천안시"
        case HospitalTempCityCode.CODE_340201: return "천안서북구"
        case HospitalTempCityCode.CODE_340202: return "천안동남구"
        case HospitalTempCityCode.CODE_340300: return "공주시"
        case HospitalTempCityCode.CODE_340400: return "보령시"
        case HospitalTempCityCode.CODE_340500: return "아산시"
        case HospitalTempCityCode.CODE_340600: return "서산시"
        case HospitalTempCityCode.CODE_340700: return "논산시"
        case HospitalTempCityCode.CODE_340800: return "계룡시"
        case HospitalTempCityCode.CODE_340900: return "당진시"
        case HospitalTempCityCode.CODE_350001: return "고창군"
        case HospitalTempCityCode.CODE_350004: return "무주군"
        case HospitalTempCityCode.CODE_350005: return "부안군"
        case HospitalTempCityCode.CODE_350006: return "순창군"
        case HospitalTempCityCode.CODE_350008: return "완주군"
        case HospitalTempCityCode.CODE_350009: return "익산군"
        case HospitalTempCityCode.CODE_350010: return "임실군"
        case HospitalTempCityCode.CODE_350011: return "장수군"
        case HospitalTempCityCode.CODE_350013: return "진안군"
        case HospitalTempCityCode.CODE_350100: return "군산시"
        case HospitalTempCityCode.CODE_350200: return "남원시"
        case HospitalTempCityCode.CODE_350300: return "익산시"
        case HospitalTempCityCode.CODE_350400: return "전주시"
        case HospitalTempCityCode.CODE_350401: return "전주완산구"
        case HospitalTempCityCode.CODE_350402: return "전주덕진구"
        case HospitalTempCityCode.CODE_350500: return "정읍시"
        case HospitalTempCityCode.CODE_350600: return "김제시"
        case HospitalTempCityCode.CODE_360001: return "강진군"
        case HospitalTempCityCode.CODE_360002: return "고흥군"
        case HospitalTempCityCode.CODE_360003: return "곡성군"
        case HospitalTempCityCode.CODE_360006: return "구례군"
        case HospitalTempCityCode.CODE_360008: return "담양군"
        case HospitalTempCityCode.CODE_360009: return "무안군"
        case HospitalTempCityCode.CODE_360010: return "보성군"
        case HospitalTempCityCode.CODE_360012: return "신안군"
        case HospitalTempCityCode.CODE_360014: return "영광군"
        case HospitalTempCityCode.CODE_360015: return "영암군"
        case HospitalTempCityCode.CODE_360016: return "완도군"
        case HospitalTempCityCode.CODE_360017: return "장성군"
        case HospitalTempCityCode.CODE_360018: return "장흥군"
        case HospitalTempCityCode.CODE_360019: return "진도군"
        case HospitalTempCityCode.CODE_360020: return "함평군"
        case HospitalTempCityCode.CODE_360021: return "해남군"
        case HospitalTempCityCode.CODE_360022: return "화순군"
        case HospitalTempCityCode.CODE_360200: return "나주시"
        case HospitalTempCityCode.CODE_360300: return "목포시"
        case HospitalTempCityCode.CODE_360400: return "순천시"
        case HospitalTempCityCode.CODE_360500: return "여수시"
        case HospitalTempCityCode.CODE_360700: return "광양시"
        case HospitalTempCityCode.CODE_370002: return "고령군"
        case HospitalTempCityCode.CODE_370003: return "군위군"
        case HospitalTempCityCode.CODE_370005: return "달성군"
        case HospitalTempCityCode.CODE_370007: return "봉화군"
        case HospitalTempCityCode.CODE_370010: return "성주군"
        case HospitalTempCityCode.CODE_370012: return "영덕군"
        case HospitalTempCityCode.CODE_370013: return "영양군"
        case HospitalTempCityCode.CODE_370014: return "영일군"
        case HospitalTempCityCode.CODE_370017: return "예천군"
        case HospitalTempCityCode.CODE_370018: return "울릉군"
        case HospitalTempCityCode.CODE_370019: return "울진군"
        case HospitalTempCityCode.CODE_370021: return "의성군"
        case HospitalTempCityCode.CODE_370022: return "청도군"
        case HospitalTempCityCode.CODE_370023: return "청송군"
        case HospitalTempCityCode.CODE_370024: return "칠곡군"
        case HospitalTempCityCode.CODE_370100: return "경주시"
        case HospitalTempCityCode.CODE_370200: return "구미시"
        case HospitalTempCityCode.CODE_370300: return "김천시"
        case HospitalTempCityCode.CODE_370400: return "안동시"
        case HospitalTempCityCode.CODE_370500: return "영주시"
        case HospitalTempCityCode.CODE_370600: return "영천시"
        case HospitalTempCityCode.CODE_370700: return "포항시"
        case HospitalTempCityCode.CODE_370701: return "포항남구"
        case HospitalTempCityCode.CODE_370702: return "포항북구"
        case HospitalTempCityCode.CODE_370800: return "문경시"
        case HospitalTempCityCode.CODE_370900: return "상주시"
        case HospitalTempCityCode.CODE_371000: return "경산시"
        case HospitalTempCityCode.CODE_380002: return "거창군"
        case HospitalTempCityCode.CODE_380003: return "고성군"
        case HospitalTempCityCode.CODE_380004: return "김해군"
        case HospitalTempCityCode.CODE_380005: return "남해군"
        case HospitalTempCityCode.CODE_380007: return "사천군"
        case HospitalTempCityCode.CODE_380008: return "산청군"
        case HospitalTempCityCode.CODE_380011: return "의령군"
        case HospitalTempCityCode.CODE_380012: return "창원군"
        case HospitalTempCityCode.CODE_380014: return "창녕군"
        case HospitalTempCityCode.CODE_380016: return "하동군"
        case HospitalTempCityCode.CODE_380017: return "함안군"
        case HospitalTempCityCode.CODE_380018: return "함양군"
        case HospitalTempCityCode.CODE_380019: return "합천군"
        case HospitalTempCityCode.CODE_380100: return "김해시"
        case HospitalTempCityCode.CODE_380200: return "마산시"
        case HospitalTempCityCode.CODE_380300: return "사천시"
        case HospitalTempCityCode.CODE_380500: return "진주시"
        case HospitalTempCityCode.CODE_380600: return "진해시"
        case HospitalTempCityCode.CODE_380700: return "창원시"
        case HospitalTempCityCode.CODE_380701: return "창원마산회원구"
        case HospitalTempCityCode.CODE_380702: return "창원마산합포구"
        case HospitalTempCityCode.CODE_380703: return "창원진해구"
        case HospitalTempCityCode.CODE_380704: return "창원의창구"
        case HospitalTempCityCode.CODE_380705: return "창원성산구"
        case HospitalTempCityCode.CODE_380800: return "통영시"
        case HospitalTempCityCode.CODE_380900: return "밀양시"
        case HospitalTempCityCode.CODE_381000: return "거제시"
        case HospitalTempCityCode.CODE_381100: return "양산시"
        case HospitalTempCityCode.CODE_390001: return "남제주군"
        case HospitalTempCityCode.CODE_390002: return "북제주군"
        case HospitalTempCityCode.CODE_390100: return "서귀포시"
        case HospitalTempCityCode.CODE_390200: return "제주시"
        case HospitalTempCityCode.CODE_410000: return "세종시"
        }
    }
}

