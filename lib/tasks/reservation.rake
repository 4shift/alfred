namespace :ggihub do
  desc "task for clebee course status check"
  task reservation: :environment do
    ROOM_LIST = [
      {
        room_name: "R24",
        seat_code: "2"
      }
      # },
      # {
      #   room_name: "R25",
      #   seat_code: "3"
      # },
      # {
      #   room_name: "R27",
      #   seat_code: "5"
      # }
    ]

    ROOM_LIST.each do |list|
      req = "http://www.ggihub.or.kr:8081/library/putReserve_Sql.php?RoomName=#{list[:room_name]}&RoomClass=project&SeatCode=#{list[:seat_code]}&RoomCode=9&UserSNO=wecanooo&HourStart=20&DurationHour=1&PersonCnt=2"

      uri = URI(req)
      res = Net::HTTP.get_response(uri)
      puts res.body
    end
  end

end
