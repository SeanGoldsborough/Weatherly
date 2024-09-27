/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Base : Codable {
	let coord : Coord?
	let weather : [Weather]?
	let base : String?
	let main : Main?
	let visibility : Int?
	let wind : Wind?
	//let rain : Rain?
	let clouds : Clouds?
	let dt : Int?
	let sys : Sys?
	let timezone : Int?
	let id : Int?
	let name : String?
	let cod : Int?

	enum CodingKeys: String, CodingKey {

		case coord = "coord"
		case weather = "weather"
		case base = "base"
		case main = "main"
		case visibility = "visibility"
		case wind = "wind"
		//case rain = "rain"
		case clouds = "clouds"
		case dt = "dt"
		case sys = "sys"
		case timezone = "timezone"
		case id = "id"
		case name = "name"
		case cod = "cod"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
		weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
		base = try values.decodeIfPresent(String.self, forKey: .base)
		main = try values.decodeIfPresent(Main.self, forKey: .main)
		visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
		wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
		//rain = try values.decodeIfPresent(Rain.self, forKey: .rain)
		clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		sys = try values.decodeIfPresent(Sys.self, forKey: .sys)
		timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		cod = try values.decodeIfPresent(Int.self, forKey: .cod)
	}

}
