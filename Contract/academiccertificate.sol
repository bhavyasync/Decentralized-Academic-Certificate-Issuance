// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AcademicCertificateIssuer {

    address public owner;
    uint public certificateCount;

    // Structure to store certificate information
    struct Certificate {
        uint id;
        string studentName;
        string degree;
        string university;
        uint256 issuanceDate;
        bool isValid;
    }

    // Mapping from certificate ID to Certificate data
    mapping(uint => Certificate) public certificates;

    // Event that is emitted when a certificate is issued
    event CertificateIssued(
        uint indexed certificateId,
        string studentName,
        string degree,
        string university,
        uint256 issuanceDate
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        certificateCount = 0;
    }

    // Function to issue a new certificate
    function issueCertificate(
        string memory _studentName,
        string memory _degree,
        string memory _university
    ) public onlyOwner {
        certificateCount++;
        certificates[certificateCount] = Certificate({
            id: certificateCount,
            studentName: _studentName,
            degree: _degree,
            university: _university,
            issuanceDate: block.timestamp,
            isValid: true
        });

        emit CertificateIssued(certificateCount, _studentName, _degree, _university, block.timestamp);
    }

    // Function to invalidate a certificate (in case of fraud or error)
    function invalidateCertificate(uint _certificateId) public onlyOwner {
        require(certificates[_certificateId].isValid, "Certificate already invalidated.");
        certificates[_certificateId].isValid = false;
    }

    // Function to check the validity of a certificate
    function checkCertificateValidity(uint _certificateId) public view returns (bool) {
        return certificates[_certificateId].isValid;
    }

    // Function to fetch certificate details
    function getCertificateDetails(uint _certificateId) public view returns (
        string memory studentName,
        string memory degree,
        string memory university,
        uint256 issuanceDate,
        bool isValid
    ) {
        Certificate memory cert = certificates[_certificateId];
        return (cert.studentName, cert.degree, cert.university, cert.issuanceDate, cert.isValid);
    }
}

