angular.module("userRepository", [])
.factory "UserRepository", [
  "$q"
  ($q) ->

    class UserRepository

      lookupUser: (vendorClientAccountId) ->
        clientData = {vendorAccount: {vendorClientAccountId: null}}

        if vendorClientAccountId == 'bmiTest1'
          clientData = @createUser('KATIE', 'BATEMAN', 'KBATEMAN@EXAMPLE.COM', 1341, 'female', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest2'
          clientData = @createUser('JOHN', 'DOE', 'JDOE@EXAMPLE.COM', 2342, 'male', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest3'
          clientData = @createUser('JANE', 'BROWN', 'JBROWN@EXAMPLE.COM', 2343, 'female', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest4'
          clientData = @createUser('MARK', 'WHITE', 'MWHITE@EXAMPLE.COM', 2344, 'male', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest5'
          clientData = @createUser('SALLY', 'JONES', 'SJONES@EXAMPLE.COM', 2345, 'female', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest6'
          clientData = @createUser('BOB', 'SMITH', 'BSMITH@EXAMPLE.COM', 2346, 'male', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest7'
          clientData = @createUser('RUTH', 'WALTON', 'RWALTON@EXAMPLE.COM', 2347, 'female', vendorClientAccountId)
        else if vendorClientAccountId == 'bmiTest8'
          clientData = @createUser('JEREMY', 'MADDEN', 'JMADDEN@EXAMPLE.COM', 2348, 'male', vendorClientAccountId)
        return clientData

      createUser: (firstName, lastName, email, unique4Digits, gender, vendorClientAccountId) ->
        return {
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
          }
 

    return new UserRepository()
]
