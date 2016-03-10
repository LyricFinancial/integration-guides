angular.module("userRepository", [])
.factory "UserRepository", [
  "$q"
  ($q) ->

    class UserRepository

      setUser: (vendorClientAccountId) ->
        clientData = {account: {vendorAccount: {vendorClientAccountId: null}}}

        if vendorClientAccountId == 'eliSonyTest'
          clientData = @createUser('Eli', 'Ball', 'eric@lyricfinancial.com', 7341, 'male', vendorClientAccountId, 'Ball Jar Tunes')
        else if vendorClientAccountId == 'ericSonyTest'
          clientData = @createUser('Eric', 'Reuthe', 'eric@lyricfinancial.com', 7342, 'male', vendorClientAccountId, 'ER Tunes')
        else if vendorClientAccountId == 'chuckSonyTest'
          clientData = @createUser('Chuck', 'Swanberg', 'eric@lyricfinancial.com', 7343, 'male', vendorClientAccountId, 'Chuckles Tunes')
        else if vendorClientAccountId == 'amySonyTest'
          clientData = @createUser('Amy', 'Madden', 'eric@lyricfinancial.com', 7343, 'female', vendorClientAccountId, 'Madden Tunes')

        else if vendorClientAccountId == 'sonyTest7'
          clientData = @createUser('RUTH', 'WALTON', 'RWALTON@EMAIL.COM', 5347, 'female', vendorClientAccountId, 'XYZ Tunes')
        else if vendorClientAccountId == 'sonyTest8'
          clientData = @createUser('JEREMY', 'MADDEN', 'JMADDEN@EMAIL.COM', 5348, 'male', vendorClientAccountId, 'LMN Tunes')
        @clientData = clientData

      createUser: (firstName, lastName, email, unique4Digits, gender, vendorClientAccountId, clientName) ->
        return {
          account: {
            user: {
              firstName: firstName,
              lastName: lastName,
              address1: unique4Digits + ' MAIN ST',
              city: 'NASHVILE',
              state: 'TN',
              zipCode: '37212',
              phone: '615-736-' + unique4Digits,
              mobilePhone: '615-711-' + unique4Digits,
              email: email,
              dob: '1978-01-10',
              gender: gender,
              maritalStatus: 'single'
            },
            bankInfo: {
              bankName: "Bank of America",
              bankAccountNumber: "1234" + unique4Digits,
              bankRoutingNumber: "211274450",
              bankAccountType: "checking"
            },
            taxInfo: {
              taxEinTinSsn: "222-11-" + unique4Digits,
              tinType: "ssn",
              memberBusinessType: "individual"
            },
            vendorAccount: {
              vendorClientAccountId: vendorClientAccountId
            }
          },
          clientName: clientName
        }
 

    return new UserRepository()
]
