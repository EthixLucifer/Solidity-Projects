//SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract decentralizedInvoicing {

    mapping(uint256 => paymentStatus) invoiceStat; // takes invoice ID as input to display the payment status
    mapping(string => invoiceData[]) invoiceDatas; // takes Buyers PAN address as input and is used to display invoice details

    enum paymentStatus { // enum for payment status
        Paid, //Invoice has been paid by the customer
        Overdue, //Invoice has past the payment date and the customer hasn’t paid yet
        Void, //You will void an invoice if it has been raised incorrectly. Customers cannot pay for a voided invoice.
        Writeoff,
        Draft
    }

    struct invoiceData {
        string buyerPAN;
        string sellerPAN;
        uint256 invoiceAmount;
        uint256 invoiceDate;
        uint256 invoiceID;
        paymentStatus invoiceStatus;
    }

    function createInvoice(
        string memory _buyersPAN,
        string memory _sellersPAN,
        uint256 _invoiceAmount,
        uint256 _invoiceID,
        uint256 _invoiceStatusNo
    ) public {
        invoiceDatas[_buyersPAN].push(
            invoiceData(
                _buyersPAN,
                _sellersPAN,
                _invoiceAmount * (1 ether),
                block.timestamp,
                _invoiceID,
                setInvoiceStatus(_invoiceStatusNo)
            )
        );
    }

    function viewInvoice(string memory _buyersPAN, uint256 _invoiceno) // function to view invoice details
        public
        view
        returns (invoiceData memory ivd)
    {
        return invoiceDatas[_buyersPAN][_invoiceno];
    }
    
    function setInvoiceStatus(uint256 _invoiceStatusNo) // function to set invoice status in the Enum paymentStatus
        private
        pure
        returns (paymentStatus _paymentStatus)
    {
        require(
            _invoiceStatusNo <= 4 && _invoiceStatusNo >= 0,
            "Invalid invoice status"
        );
        if (_invoiceStatusNo == 0) return paymentStatus.Paid;
        else if (_invoiceStatusNo == 1) return paymentStatus.Overdue;
        else if (_invoiceStatusNo == 2) return paymentStatus.Void;
        else if (_invoiceStatusNo == 3) return paymentStatus.Writeoff;
        else if (_invoiceStatusNo == 4) return paymentStatus.Draft;
    }
}
