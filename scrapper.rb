# encoding: utf-8
# https://www.freelancer.com/jobs/Graphic-Design/Create-two-scrappers-website
require 'open-uri'
require 'net/http'
require 'pp'
require 'nokogiri'
require 'digest'
require 'csv'

# open and parse the url
puts "Downloading list"
url = "http://www.supersociedades.gov.co/Paginas/ConsultaGeneralSociedades.aspx"
uri = URI(url)
req = Net::HTTP::Post.new(uri)
req.body = "MSOWebPartPage_PostbackSource=&MSOTlPn_SelectedWpId=&MSOTlPn_View=0&MSOTlPn_ShowSettings=False&MSOGallery_SelectedLibrary=&MSOGallery_FilterString=&MSOTlPn_Button=none&__EVENTTARGET=&__EVENTARGUMENT=&__REQUESTDIGEST=0xFCAAF06B67BDDA718BE00362B2B83CA67328326928676E763C996E0B5BA63F16482F33ED20F1387BD73C47E5DE5A70230E3BE8B455072243A6EF44161DAB1C3A%2C28+Apr+2015+01%3A13%3A02+-0000&MSOSPWebPartManager_DisplayModeName=Browse&MSOSPWebPartManager_ExitingDesignMode=false&MSOWebPartPage_Shared=&MSOLayout_LayoutChanges=&MSOLayout_InDesignMode=&_wpSelected=&_wzSelected=&MSOSPWebPartManager_OldDisplayModeName=Browse&MSOSPWebPartManager_StartWebPartEditingName=false&MSOSPWebPartManager_EndWebPartEditing=false&__VIEWSTATE=%2FwEPDwUBMA9kFgJmD2QWAgIBD2QWBAIBD2QWAgIGD2QWAmYPZBYCAgEPFgIeE1ByZXZpb3VzQ29udHJvbE1vZGULKYgBTWljcm9zb2Z0LlNoYXJlUG9pbnQuV2ViQ29udHJvbHMuU1BDb250cm9sTW9kZSwgTWljcm9zb2Z0LlNoYXJlUG9pbnQsIFZlcnNpb249MTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49NzFlOWJjZTExMWU5NDI5YwFkAgMPZBYMAgMPZBYCBSZnXzc3MzQyYzJiXzdiZWVfNDZmYl84ZTUwXzkwNjZmMDU3MGE0ZQ9kFgJmD2QWAgICD2QWAgIDDzwrAA0AZAIRD2QWAgIBD2QWBGYPZBYCAgEPFgIeB1Zpc2libGVoFgJmD2QWBAICD2QWBgIBDxYCHwFoZAIDDxYIHhNDbGllbnRPbkNsaWNrU2NyaXB0BXVqYXZhU2NyaXB0OkNvcmVJbnZva2UoJ1Rha2VPZmZsaW5lVG9DbGllbnRSZWFsJywxLCA1MywgJ2h0dHA6XHUwMDJmXHUwMDJmd3d3LnN1cGVyc29jaWVkYWRlcy5nb3YuY28nLCAtMSwgLTEsICcnLCAnJykeGENsaWVudE9uQ2xpY2tOYXZpZ2F0ZVVybGQeKENsaWVudE9uQ2xpY2tTY3JpcHRDb250YWluaW5nUHJlZml4ZWRVcmxkHgxIaWRkZW5TY3JpcHQFIlRha2VPZmZsaW5lRGlzYWJsZWQoMSwgNTMsIC0xLCAtMSlkAgUPFgIfAWhkAgMPDxYKHglBY2Nlc3NLZXkFAS8eD0Fycm93SW1hZ2VXaWR0aAIFHhBBcnJvd0ltYWdlSGVpZ2h0AgMeEUFycm93SW1hZ2VPZmZzZXRYZh4RQXJyb3dJbWFnZU9mZnNldFkC6wNkZAIBD2QWBAIDD2QWAgIBDxAWAh8BaGQUKwEAZAIFD2QWAmYPZBYCZg8UKwADZGRkZAITD2QWAmYPZBYCAgIPZBYCAgMPEGRkFgBkAhUPZBYCAgEPZBYCZg9kFgICAQ8PZBYGHgVjbGFzcwUibXMtc2J0YWJsZSBtcy1zYnRhYmxlLWV4IHM0LXNlYXJjaB4LY2VsbHBhZGRpbmcFATAeC2NlbGxzcGFjaW5nBQEwZAI5D2QWBAIKD2QWAgIJD2QWAgIBDw8WAh8BaGQWAgICD2QWAmYPZBYCAgMPZBYCAgUPDxYEHgZIZWlnaHQbAAAAAAAAeUABAAAAHgRfIVNCAoABZBYCAgEPPCsACQEADxYEHg1QYXRoU2VwYXJhdG9yBAgeDU5ldmVyRXhwYW5kZWRnZGQCDA9kFgICBw8WAh8ACysEAWQCOw9kFgJmD2QWAmYPDxYCHgRUZXh0BRQyNy8wNC8yMDE1IDA4OjEyOjQ3IGRkGAIFQGN0bDAwJG0kZ183NzM0MmMyYl83YmVlXzQ2ZmJfOGU1MF85MDY2ZjA1NzBhNGUkY3RsMDAkZ3ZSZXN1bHRhZG8PZ2QFR2N0bDAwJFBsYWNlSG9sZGVyVG9wTmF2QmFyJFBsYWNlSG9sZGVySG9yaXpvbnRhbE5hdiRUb3BOYXZpZ2F0aW9uTWVudVY0Dw9kBR5TdXBlcmludGVuZGVuY2lhIGRlIFNvY2llZGFkZXNkHLmJENK6q4DYBhdkejCBno48l4o%3D&__EVENTVALIDATION=%2FwEWPALVh%2FLBAQKpn5bCCwLNrvW5AwK9%2Bp7tAgLv2%2BWrDgLc27edDQKRgcvuCwK07a2PBgL2r87ICAL%2Fr4LLCAL%2Br4LLCAL9r7LLCAL08KrVDwL98KrVDwL88KrVDwL%2F8KrVDwL%2B8KrVDwL58KrVDwL98NbWDwL88ObWDwL88OLWDwLV7%2B24CALE76G7CALY7%2B24CALL76G7CALL7%2B24CALc76G7CALc75m7CALc75G7CALc74m7CALc7824CALL75G7CALc78G4CALd7627CALd74m7CALd75m7CALd75G7CALE7527CALE75G7CALf76G7CALf7527CALf74m7CALY7627CALY76W7CALY7527CALL75W7CALZ75m7CALZ75W7CALL7824CALZ7824CAKnzZ9zAqfNn3MC2u%2BtuwgC2u%2BZuwgC2u%2BVuwgCxO%2BJuwgCxO%2FBuAgC78f15wwCx5m82gcC2fu8%2FweQG3MIvTrVRv5kuuemItKa6ceiIg%3D%3D&ctl00%24PlaceHolderSearchArea%24ctl01%24ctl00=http%3A%2F%2Fwww.supersociedades.gov.co&InputKeywords=Buscar+en+este+sitio...&ctl00%24PlaceHolderSearchArea%24ctl01%24ctl04=0&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24txtNit=&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24txtRazonSocial=&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24ddlEstado=*&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24ddlSituacion=*&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24ddlDepartamento=*&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24ddlOrdenarPor=ms001nitso&ctl00%24m%24g_77342c2b_7bee_46fb_8e50_9066f0570a4e%24ctl00%24btnConsultarPorEstadoSituacion=Consultar&servicios-electronicos=---+Seleccione+-----&__spText1=&__spText2=&_wpcmWpid=&wpcmVal="
req.content_type = 'application/x-www-form-urlencoded'
res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req) do |response|
    open 'supersociedades.html', 'w' do |io|
      response.read_body do |chunk|
        io.write chunk
      end
    end
  end
end
res = nil # GC

# extract tr's (read one byte at time to not consume too much memory)
needle = "td_consulta_general_sociedades_gridview"
needle_level = 0
recording = false
File.open("supersociedades.html") do |file|
  while (buffer = file.read(1024)) do
    if buffer.include? needle
      needle_level += 1
      if needle_level == 1
        needle = "<tr>"
      elsif needle_level == 2
        needle = "</table>"
        recording = true
        tr_file = File.open("trs.html", "w")
        tr_file.write(buffer[buffer.index("<tr>")..-1])
      elsif needle_level == 3
        tr_file.write(buffer[0..buffer.index("</table>")-1])
        tr_file.close
        break
      end
    else
      if recording
        tr_file.write(buffer)
      end
    end
  end
end

def extract_data(block)
  csv = []
  doc = Nokogiri::HTML(block)
  doc.css('table tr').each do |tr|
    nit = tr.css('td:nth-child(1) a').text
    razon_social = tr.css('td:nth-child(2)').text.strip
    estado = tr.css('td:nth-child(3)').text.strip
    etapa_situacion = tr.css('td:nth-child(4)').text.strip
    dependencia = tr.css('td:nth-child(5)').text.strip
    csv << [nit, razon_social, estado, etapa_situacion, dependencia].to_csv
  end
  @sociedades_file.write(csv.join)
end

# read a block of 100 tr's at time, and process it
def read_trs
  buffer = ""
  File.open("trs.html") do |file|
    block = ""
    count = 0
    while (buffer = file.read(1024)) do
      count += buffer.scan("</tr>").length
      if count >= 100
        pos = buffer.rindex("</tr>")
        block = block + buffer[0..pos-1] + "</tr>"
        extract_data("<table>" + block + "</table>")
        count = 0
        block = buffer[pos+5..-1]
      else
        block = block + buffer
      end
    end

    # residual
    extract_data("<table>" + block + "</table>")
  end
end

@sociedades_file = File.open("sociedades.csv", "w")
@sociedades_file.write (["NIT", "Razon Social", "Estado", "Etapa Situacion", "Dependencia"]).to_csv # header
read_trs
@sociedades_file.close

# doc = Nokogiri::HTML(res.body)
# trs = doc.css('table.td_consulta_general_sociedades_gridview tr')