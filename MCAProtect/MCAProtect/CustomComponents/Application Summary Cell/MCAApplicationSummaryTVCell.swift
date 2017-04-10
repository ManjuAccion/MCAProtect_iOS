//
//  MCAApplicationSummaryTVCell.swift
//  MCAProtect
//
//  Created by Sarath NS on 2/14/17.
//  Copyright © 2017 Accionlabs. All rights reserved.
//

import UIKit

protocol MCAApplicationSummaryTVCellDelegate {
    
    func rightActionButtonTapped()
}


class MCAApplicationSummaryTVCell: UITableViewCell {
    
    
    @IBOutlet weak var dataTF: UITextField!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    var delegate:MCAApplicationSummaryTVCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSavedApplicationSummary(appSummary : MCASavedApplication, appSummaryKey : ApplicationSummaryKeys)
    {
        titleLabel.text = appSummaryKey.rawValue
        dataTF.text =  appSummary.getValueFromKey(key: appSummaryKey)
    }

    func setLoanDetail(programInformation : MCAProgramInformation, loanKey : LoanDetailKeys)
    {
        titleLabel.text = loanKey.rawValue
        dataTF.text = programInformation.getLoanDetailsFromProgramInformation(loanDetailKey: loanKey)
    }
    
    func setBusinessInformation(businessInformation : MCABusinessInformation, businessInfoKey : BusinessInformationKeys)
    {
        titleLabel.text = businessInfoKey.rawValue
        dataTF.text =  businessInformation.getValueFromKey(key: businessInfoKey)
    }
    
    func setBusinessAddress(businessAddress : MCAAddress, businessAddressKey : BusinessAddressKeys)
    {
        titleLabel.text = businessAddressKey.rawValue
        dataTF.text =  businessAddress.getValueFromKey(key: businessAddressKey)
    }
    
    func setFPSummaryDetails(FPSummary : MCAFundingProgramList, key : FPApplicationSummaryKeys)
    {
        titleLabel.text = key.rawValue
        dataTF.text = FPSummary.getValueFromKey(key: key) as? String
    }
    
    func setExistingMCALoan(existingLoan : MCALoanAccountsList, mcaLoanKey : MCALoanDetailKeys)
    {
        titleLabel.text = mcaLoanKey.rawValue
        dataTF.text =  existingLoan.getValueFromKey(key: mcaLoanKey)
    }
    
    func setOwnerInformationDetail(ownerInfoDetail : MCAOwnerInformation, ownerInfoDetailKey : OwnerInformationDetailKeys)
    {
        titleLabel.text = ownerInfoDetailKey.rawValue
        dataTF.text =  ownerInfoDetail.getValueFromKey(ownerInformationKey: ownerInfoDetailKey)
    }
    
    func setBusinessLocationDetail(businessLocationDetail : MCABusinessLocationList, businessLocationDetailKey : BusinessLocationDetailKeys)
    {
        titleLabel.text = businessLocationDetailKey.rawValue
        dataTF.text =  businessLocationDetail.getValueFromKey(businessLocationKey: businessLocationDetailKey)
    }
    
    func setMerchantDocumentation(merchantDocumentation : MCAMerchantDocumentation, merchantDocumentationKey : MerchantDocumentationKeys)
    {
        titleLabel.text = merchantDocumentationKey.rawValue
        dataTF.text =  merchantDocumentation.getValueFromKey(merchantDoumentationKey: merchantDocumentationKey)
    }
    
    func setMerchantApplicationSummary(merchantSummary : MCAMerchantApplicationDetail, merchantSummaryKey : MASummaryKeys)
    {
        titleLabel.text = merchantSummaryKey.rawValue
        dataTF.text =  merchantSummary.getValueFromKey(merchantSummaryKey: merchantSummaryKey)
    }
    
    func setApplicationSummaryDetails(_ : AnyObject)
    {
        
        
    }
    
    func setFPProgramInformation(programInfromation : MCAFPProgramInformation, programInformationKeys : FPProgramInformationKeys)
    {
        
        if programInformationKeys.rawValue == "Loan Agreement False" {
            titleLabel.text = programInformationKeys.rawValue
            dataTF.text = "Loan Agreement"

        }
        else
        {
        titleLabel.text = programInformationKeys.rawValue
        dataTF.text = programInfromation.getValueFromKey(key: programInformationKeys) as String
        }
        
    }
    func setFPMerchantRequirement(merchantRequirement : MCAFPMerchantRquirement, merchantRequirementKeys : FPMerchantRequirementkeys)
    {
        titleLabel.text = merchantRequirementKeys.rawValue
        dataTF.text = merchantRequirement.getValueFromKey(key: merchantRequirementKeys) as String
        
        
    }
    func setFPLiensBankruptcy(liensBankruptcyDetails : MCAFPLiensOrBankruptcy, liensBankruptcyKeys : FPLiensAndBankruptcyKeys)
    {
        
        titleLabel.text = liensBankruptcyKeys.rawValue
        dataTF.text = liensBankruptcyDetails.getValueFromKey(key: liensBankruptcyKeys) as String
        
        
    }
    @IBAction func viewDetailsButtonTapped(_ sender: Any) {
        delegate?.rightActionButtonTapped()
        
    }
}
