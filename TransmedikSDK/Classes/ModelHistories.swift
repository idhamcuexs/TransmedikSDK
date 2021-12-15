//
//  ModelHistories.swift
//  Pasien
//
//  Created by Idham on 27/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation




class ModelHistories{
    
    
    var type_history,label,name,transaction_date,status : String
    var total,rating : Int
    var  detail_consultation : detailconsul?
    var detail_medicine : [resdetailobat]
    init(type_history: String,label: String,name: String,transaction_date: String,status : String,total : Int,detail_medicine : [resdetailobat], detail_consultation : detailconsul?,rating : Int) {
        self.type_history = type_history
        self.label = label
        self.name = name
        self.transaction_date = transaction_date
        self.status = status
        self.total = total
        self.detail_medicine = detail_medicine
        self.detail_consultation = detail_consultation
        self.rating = rating
    }
}

class detailconsul {
    var modelhistoryclinic : modelhistoryclinic
    var doctor :Detaildokter
    var patient :ModelProfile
    var consultation_id : String
    var doctor_note:doctor_note
    var spa : Bool
    var prescription : prescription
    init(
        doctor :Detaildokter,
        patient :ModelProfile,
        consultation_id:String,
         doctor_note:doctor_note,
         spa : Bool,
         prescription : prescription,
        modelhistoryclinic : modelhistoryclinic
    ) {
        self.doctor = doctor
        self.patient = patient
        self.consultation_id = consultation_id
        self.doctor_note = doctor_note
        self.spa = spa
        self.prescription = prescription
        self.modelhistoryclinic = modelhistoryclinic
    }
    
    
}

struct modelhistoryclinic {
    var address,image,name : String
}


class prescription {
    
    
    var id,consultation_id,prescription_number,order_status,administration_fee,discount_percent,discount,total,note,status,created_at,updated_at,expires :String
    
    init(id:String,consultation_id:String,prescription_number:String,order_status:String,administration_fee:String,discount_percent:String,discount:String,total:String,note:String,status:String,created_at:String,updated_at:String,expires :String) {
        self.id = id
        self.consultation_id = consultation_id
        self.prescription_number = prescription_number
        self.order_status = order_status
        self.administration_fee = administration_fee
        self.discount_percent = discount_percent
        self.discount = discount
        self.total = total
        self.note = note
        self.status = status
        self.created_at = created_at
        self.updated_at = updated_at
        self.expires = expires
    }
}
class doctor_note {
    var note,next_schedule : String
    init(note:String,next_schedule:String) {
        self.note = note
        self.next_schedule = next_schedule
    }
}


struct ResponseDetailTracking : Codable {
    var code : Int?
    var messages : String?
    var data : ordertrackingtransaksimodel?
    
    
}

struct detailobattraking :Codable {
    var slug,name,unit : String?
    var qty,prescription_id,price : Int?
}

struct ordertrackingtransaksimodel : Codable{
    
    
    var medicines: [detailobattraking]?
    var order_id_partner,order_date,order_status,total_order,shipping_fee,service_fee,courier_amount,subtotal,total,consignee,phone_number,address,note,payment_name,payment_gateway,payment_channel,payment_status,courier,invoice : String?
    
    var voucher_amount : Int?
    
    var couriers : DetailCour?
    
  
}

struct DetailCour : Codable {
    var name,vehicle_number,photo,tracking_url : String?

}

struct keluhanorderobat {
    var desc,image_complain,reason_solved,order_status,order_date:String
    var images,complain_type_name : [String]
    var detail :[detailobattraking]
    var total,voucher_amount : String
    var namaapotek,alamatapotek,gambarapotek : String
}



struct ResponseDataKonsultasi : Codable {
    var data : DataHiostoryKonsultasi?
    var messages : String?
    var code : Int?
}

struct DataHiostoryKonsultasi :Codable {
    var current_page,last_page : Int?
    var data : [DetailDataHiostoryKonsultasi]?
}
struct  DetailDataHiostoryKonsultasi : Codable {
    var total : Int?
    var label,name,status,transaction_date : String?
    var detail_consultation : NewsHistorykonsultasi?
}

struct NewsHistorykonsultasi :Codable{
    var doctor : Newdoctors?
    var patient : Newpatient?
    var consultation_id : Int?
    var doctor_note : DoctorNote?
    var prescription : Newprescription?
    var spa : Bool?
    var clinic : Newclinic?
}

struct Newclinic : Codable {
    var id : Int?
    var name,address,image :String?
    var medical_form,is_nik : Bool?
}

struct Newprescription : Codable {
    var id ,consultation_id,status : Int?
    var prescription_number,expires : String?
}

struct DoctorNote : Codable{
    var note,next_schedule : String?
}

struct Newref : Codable {
    var medical_record_number,nik,dob,relationship : String?
}
struct Newpatient : Codable {
    var uuid,full_name,email,phone_number,gender : String?
//    var ref : Newref?
}

struct Newdoctors : Codable {
    var uuid,full_name,email,phone_number,profile_picture,gender,status,specialist_slug,specialist,status_docter : String?
}


//==========================================================================================================


struct Newmedicines : Codable {
    var slug,name,unit : String?
    var price,qty,prescription_id : Int?
}
struct  Newdetail_order : Codable {
    var medicines : [Newmedicines]?
    var order_id : Int?
}

struct DetailDataHiostoryObat: Codable  {

    var type_history,total : Int?
    var label,name,transaction_date,status: String?
    var detail_order: Newdetail_order?
}


struct ResponseDataObat: Codable {
    var data : DataHiostoryObat?
    var messages : String?
    var code : Int?
}

struct DataHiostoryObat :Codable {
    var current_page,last_page : Int?
    var data : [DetailDataHiostoryObat]?
}
