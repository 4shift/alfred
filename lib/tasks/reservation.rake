namespace :ggihub do
  desc "task for clebee course status check"
  task reservation: :environment do
    request_url = "http://www.ggihub.or.kr/front/doLogin"

    params = {
      'user_id' => 'wecanooo',
      'user_pw' => 'TRECjTbTR3u5iQZu4O3H9g=='
    }

    uri = URI.parse(request_url)
    http = Net::HTTP.new(uri.host, uri.port)

    uri = URI(request_url)
    res = Net::HTTP.post_form(uri, 'user_id' => 'wecanooo', 'user_pw' => 'TRECjTbTR3u5iQZu4O3H9g==')

    ROOM_LIST = [
      {
        room_name: "R24",
        seat_code: "2"
      },
      {
        room_name: "R25",
        seat_code: "3"
      },
      {
        room_name: "R27",
        seat_code: "5"
      }
    ]

    if (res.body == "1")
      ROOM_LIST.each do |list|
        req = "http://www.ggihub.or.kr:8081/library/putReserve_Sql.php?RoomName=#{list[:room_name]}&RoomClass=project&SeatCode=#{list[:seat_code]}&RoomCode=9&UserSNO=wecanooo&HourStart=10&DurationHour=8&PersonCnt=2"
        puts req
        # uri = URI(req)
        # res = Net::HTTP.get_response(uri)
        # if (res.result == "1")
        #   puts "error"
        #   puts response.body
        # end
      end
    end
  end

end
