class Specification < ActiveRecord::Base
  validates :version, presence: true, uniqueness: { scope: :title}
  validates :title, presence: true
  has_many :definitions, dependent: :destroy
  has_many :paths, dependent: :destroy

  def display_name
    "#{title} #{version}"
  end

  # load RingCentral data
  # how to copy the following data?
  # https://docs.google.com/spreadsheets/d/1Lne2Jz34J9mJ7shlVqglEy12JlmXtweeqHsHXTXHzaM/edit?ts=570c4d57#gid=1204854372
  # make a copy
  # remove empty columns
  # copy all rows
  # paste
  def load_rc_data!
    data = %{
      GET	/restapi	Get Server Info		Light	n/a		5.x	Regular	Public Basic		Misc	Server/Version Info	restapi		P0
      GET	/restapi/{version}	Get API Version Info		Light	n/a		5.x	Regular	Public Basic		Misc	Server/Version Info	restapi/version		P0
      POST	/restapi/{version}/account	Create New Account		Medium	Accounts (+EditAccounts)		6.3 TELUS	Regular	Public Internal		Account/Extension Info	Account Info	account	Account Configuration Service	P0
      DELETE	/restapi/{version}/account/{id}	Delete Account by ID		Medium	Accounts (+EditAccounts)		6.3 TELUS	Regular	Public Internal		Account/Extension Info	Account Info	account	Account Configuration Service
      GET	/restapi/{version}/account/{id}	Get Account Info by ID		Light	ReadAccounts	ReadCompanyInfo	5.x	Regular	Public Basic		Account/Extension Info	Account Info	account	Account Configuration Service	P0
      PUT	/restapi/{version}/account/{id}	Update Account by ID		Medium	EditAccounts (+ReadAccounts)	EditCompanyInfo	6.3 TELUS	Regular	Public Internal		Account/Extension Info	Account Info	account	Account Configuration Service	P0
      GET	/restapi/{version}/account/{id}/service-info	Get Account Service Info		Light	ReadAccounts	ReadServicePlanInfo	5.x	Regular	Public Advanced		Account/Extension Info	Account Info	account/service-info	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/active-calls	Get Account Active (Recent) Calls		Heavy	ReadCallLog	FullCompanyCallLog	6.5	Regular	Public Basic		Call Logs	Account Active Calls	account/active-calls	Call Logs Service
      GET	/restapi/{version}/account/~/business-address	Get Company Business Address		Light	ReadAccounts	ReadCompanyInfo	6.3 TELUS	Regular	Public Basic		Account/Extension Info	Company Address	account/business-address	Account Configuration Service	P0
      PUT	/restapi/{version}/account/~/business-address	Update Company Business Address		Medium	EditAccounts (+ReadAccounts)	EditCompanyInfo	6.3 TELUS	Regular	Public Advanced		Account/Extension Info	Company Address	account/business-address	Account Configuration Service	P0
      DELETE	/restapi/{version}/account/~/call-log	Delete Account Call Log		Heavy	EditCallLog (+ReadCallLog)	FullCompanyCallLog	5.x	Regular	Public Advanced	Disabled	Call Logs	Account Call Log	account/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/call-log	Get Account Call Log		Heavy	ReadCallLog	FullCompanyCallLog	5.x	Regular	Public Basic		Call Logs	Account Call Log	account/call-log	Call Logs Service
      DELETE	/restapi/{version}/account/~/call-log/{id}	Delete Account Call Log Record by ID	Yes	Heavy	EditCallLog (+ReadCallLog)	FullCompanyCallLog	5.x	Regular	Public Advanced	Disabled	Call Logs	Account Call Log	account/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/call-log/{id}	Get Account Call Log Record by ID	Yes	Heavy	ReadCallLog	FullCompanyCallLog	5.x	Regular	Public Basic		Call Logs	Account Call Log	account/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/department/{id}/members	Get Department Members		Light	ReadAccounts	ReadExtensions	5.x	Regular	Public Advanced		Account/Extension Info	Extension Info	account/department/members	Account Configuration Service
      GET	/restapi/{version}/account/~/device	Get Account Device List		Medium	ReadAccounts	ReadCompanyDevices	6.4	Regular	Public Advanced		Provisioning	Devices	account/device	Account Configuration Service
      GET	/restapi/{version}/account/~/device/{id}	Get Device by ID		Light	ReadAccounts	ReadCompanyDevices	6.1	Regular	Public Advanced		Provisioning	Devices	account/device	Account Configuration Service	P0
      PUT	/restapi/{version}/account/~/device/{id}	Update  Device by ID		Medium	EditAccounts (+ReadAccounts)	EditCompanyDevices	6.1	Regular	Public Advanced		Provisioning	Devices	account/device	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/device/sip-info	Get sip provisioning info for manual provisioning		Light	ReadAccounts	ReadCompanyDevices	7.4	Regular	Public Advanced		Provisioning	Devices	account/device	Account Configuration Service
      GET	/restapi/{version}/account/~/dialing-plan	Get IBO Dialing Plans		Heavy	ReadAccounts	ReadUserInfo	7.3	Regular	Public Internal		IBO	Dialing Plans	account/dialing-plan	Account Configuration Service
      GET	/restapi/{version}/account/~/extension	Get Extension List		Medium	ReadAccounts	ReadExtensions	5.x	Regular	Public Basic		Account/Extension Info	Extension Info	extension	Account Configuration Service	P0
      POST	/restapi/{version}/account/~/extension	Create New Extension		Medium	EditAccounts (+ReadAccounts)	AddRemoveUsers	6.3 TELUS	Regular	Public Internal		Account/Extension Info	Extension Info	extension	Account Configuration Service	P0
      DELETE	/restapi/{version}/account/~/extension/{id}	Delete Extension by ID		Medium	EditAccounts (+ReadAccounts)	AddRemoveUsers	6.3 TELUS	Regular	Public Internal		Account/Extension Info	Extension Info	extension	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/extension/{id}	Get Extension Info by ID		Light	ReadAccounts	ReadExtensions	5.x	Regular	Public Basic		Account/Extension Info	Extension Info	extension	Account Configuration Service	P0
      PUT	/restapi/{version}/account/~/extension/{id}	Update Extension by ID		Medium	EditExtensions	EditUserInfo OR EditUserCredentials	6.3 TELUS	Regular	Public Advanced		Account/Extension Info	Extension Info	extension	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/extension/{id}/permissions	Get Extension Permissions		Light	ReadAccounts	ReadUserInfo	6.3 TELUS	Regular	Public Advanced	Deprecated	Account/Extension Info	Extension Info	extension/permissions	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/active-calls	Get Extension Active (Recent) Calls		Heavy	ReadCallLog	ReadCallLog	6.5	Regular	Public Basic		Call Logs	Extension Active Calls	extension/active-calls	Call Logs Service
      GET	/restapi/{version}/account/~/extension/~/address-book-sync	Contacts Synchronization		Heavy	ReadContacts	ReadPersonalContacts	5.x	Sync	Public Advanced		Address Book	Address Book Sync	extension/address-book-sync	Address Book Service	P0
      GET	/restapi/{version}/account/~/extension/~/address-book/contact	Get Contact List		Heavy	ReadContacts	ReadPersonalContacts	5.x	Regular	Public Advanced		Address Book	Contacts	extension/address-book/contact	Address Book Service	P0
      POST	/restapi/{version}/account/~/extension/~/address-book/contact	Create New Contact		Heavy	Contacts (+ReadContacts)	EditPersonalContacts	5.x	Regular	Public Advanced		Address Book	Contacts	extension/address-book/contact	Address Book Service	P0
      DELETE	/restapi/{version}/account/~/extension/~/address-book/contact/{id}	Delete Contact by ID		Heavy	Contacts (+ReadContacts)	EditPersonalContacts	5.x	Regular	Public Advanced		Address Book	Contacts	extension/address-book/contact	Address Book Service	P0
      GET	/restapi/{version}/account/~/extension/~/address-book/contact/{id}	Get Contact by ID		Heavy	ReadContacts	ReadPersonalContacts	5.x	Regular	Public Advanced		Address Book	Contacts	extension/address-book/contact	Address Book Service	P0
      PUT	/restapi/{version}/account/~/extension/~/address-book/contact/{id}	Update Contact by ID		Heavy	Contacts (+ReadContacts)	EditPersonalContacts	5.x	Regular	Public Advanced		Address Book	Contacts	extension/address-book/contact	Address Book Service	P0
      GET	/restapi/{version}/account/~/extension/~/address-book/group	Get Contact Group List		Heavy	ReadContacts	ReadPersonalContacts	5.x	Regular	Public Advanced		Address Book	Contacts	extension/address-book/group	Address Book Service
      POST	/restapi/{version}/account/~/extension/~/address-book/group	Create New Contact Group		Heavy	Contacts (+ReadContacts)	EditPersonalContacts	5.x	Regular	Public Advanced	Deprecated	Address Book	Contact Groups	extension/address-book/group	Address Book Service
      DELETE	/restapi/{version}/account/~/extension/~/address-book/group/{id}	Delete Contact Group by ID		Heavy	Contacts (+ReadContacts)	EditPersonalContacts	5.x	Regular	Public Advanced	Deprecated	Address Book	Contact Groups	extension/address-book/group	Address Book Service
      GET	/restapi/{version}/account/~/extension/~/address-book/group/{id}	Get Contact Group by ID		Heavy	ReadContacts	ReadPersonalContacts	5.x	Regular	Public Advanced	Deprecated	Address Book	Contact Groups	extension/address-book/group	Address Book Service
      PUT	/restapi/{version}/account/~/extension/~/address-book/group/{id}	Update Contact Group by ID		Heavy	Contacts (+ReadContacts)	EditPersonalContacts	5.x	Regular	Public Advanced	Deprecated	Address Book	Contact Groups	extension/address-book/group	Address Book Service
      GET	/restapi/{version}/account/~/extension/~/answering-rule/{id}	Get Custom Answering Rule by ID		Light	ReadAccounts	ReadUserAnsweringRules	7.0	Regular	Public Advanced		Account/Extension Info	Answering Rules	extension/answering-rule	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/answering-rule/after-hours-rule	Get After Hours Answering Rule		Light	ReadAccounts	ReadUserAnsweringRules	7.0	Regular	Public Advanced		Account/Extension Info	Answering Rules	extension/answering-rule	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/answering-rule/business-hours-rule	Get User Hours Answering Rule		Light	ReadAccounts	ReadUserAnsweringRules	7.0	Regular	Public Advanced		Account/Extension Info	Answering Rules	extension/answering-rule	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/assigned-role	Get Extension Assigned Roles		Light	ReadAccounts	ReadExtensions	7.5	Regular	Public Advanced		Roles and Permissions	Extension Roles	extension/assigned-role
      PUT	/restapi/{version}/account/~/extension/~/assigned-role	Update Extension Assigned Roles		Medium	RoleManagement		7.5	Regular	Public Internal		Roles and Permissions	Extension Roles	extension/assigned-role
      GET	/restapi/{version}/account/~/extension/~/authz-profile	Get Authorization Profile		Medium	n/a		7.5	Regular	Public Advanced		Roles and Permissions	Extension Permissions	extension/authz-profile
      GET	/restapi/{version}/account/~/extension/~/authz-profile/check	Check Operation Availability		Light	n/a		7.5	RPC	Public Advanced		Roles and Permissions	Extension Permissions	extension/authz-profile/check
      GET	/restapi/{version}/account/~/extension/~/blocked-number	Get Blocked Number List		Light	ReadAccounts	ReadBlockedNumbers	5.x	Regular	Public Advanced		Account/Extension Info	Blocked Numbers	extension/blocked-number	Account Configuration Service	P0
      POST	/restapi/{version}/account/~/extension/~/blocked-number	Add New Blocked Number		Medium	EditExtensions	EditBlockedNumbers	5.x	Regular	Public Advanced		Account/Extension Info	Blocked Numbers	extension/blocked-number	Account Configuration Service	P0
      DELETE	/restapi/{version}/account/~/extension/~/blocked-number/{id}	Delete Blocked Number by ID		Medium	EditExtensions	EditBlockedNumbers	5.x	Regular	Public Advanced		Account/Extension Info	Blocked Numbers	extension/blocked-number	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/extension/~/blocked-number/{id}	Get Blocked Number by ID		Light	ReadAccounts	ReadBlockedNumbers	5.x	Regular	Public Advanced		Account/Extension Info	Blocked Numbers	extension/blocked-number	Account Configuration Service
      PUT	/restapi/{version}/account/~/extension/~/blocked-number/{id}	Update Blocked Number Label		Medium	EditExtensions	EditBlockedNumbers	5.x	Regular	Public Advanced		Account/Extension Info	Blocked Numbers	extension/blocked-number	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/business-hours	Get User Hours Setting		Light	ReadAccounts	ReadExtensions	7.0	Regular	Public Advanced		Account/Extension Info	Answering Rules	extension/business-hours	Account Configuration Service
      DELETE	/restapi/{version}/account/~/extension/~/call-log	Delete Extension Call Log		Heavy	EditCallLog (+ReadCallLog)	EditCallLog	5.x	Regular	Public Advanced		Call Logs	Extension Call Log	extension/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/extension/~/call-log	Get Extension Call Log		Heavy	ReadCallLog	ReadCallLog	5.x	Regular	Public Basic		Call Logs	Extension Call Log	extension/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/extension/~/call-log-sync	Call Log Synchronization		Heavy	ReadCallLog	ReadCallLog	5.x	Sync	Public Advanced		Call Logs	Extension Call Log Sync	extension/call-log-sync	Call Logs Service	P0
      DELETE	/restapi/{version}/account/~/extension/~/call-log/{id}	Delete Extension Call Log Record by ID	Yes	Heavy	EditCallLog (+ReadCallLog)	EditCallLog	5.x	Regular	Public Advanced	Disabled	Call Logs	Extension Call Log	extension/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/extension/~/call-log/{id}	Get Extension Call Log Record by ID	Yes	Heavy	ReadCallLog	ReadCallLog	5.x	Regular	Public Basic		Call Logs	Extension Call Log	extension/call-log	Call Logs Service
      GET	/restapi/{version}/account/~/extension/~/company-pager	Get Pager Message List		Light	ReadMessages	ReadMessages	5.x	Regular Alias	Public Advanced		Messaging	SMS	extension/company-pager	Messaging Service
      POST	/restapi/{version}/account/~/extension/~/company-pager	Create and Send Pager Message		Medium	InternalMessages (+ReadMessages)	InternalSMS	5.x	Regular	Public Basic		Messaging	Pager (ext-to-ext SMS)	extension/company-pager	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/company-pager/{id}	Get Pager Message by ID	Yes	Light	ReadMessages	ReadMessages	5.x	Regular Alias	Public Advanced		Messaging	SMS	extension/company-pager	Messaging Service
      GET	/restapi/{version}/account/~/extension/~/conferencing	Get Conferencing info		Light	ReadAccounts	OrganizeConference	5.x	Regular	Public Advanced		Account/Extension Info	Conferencing Info	extension/conferencing	Account Configuration Service	P0
      PUT	/restapi/{version}/account/~/extension/~/conferencing	Update Conferencing info		Medium	EditExtensions	OrganizeConference	6.4	Regular	Public Advanced		Account/Extension Info	Conferencing Info	extension/conferencing	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/device	Get Extension Device List		Light	ReadAccounts	ReadUserDevices	6.1	Regular	Public Advanced		Provisioning	Devices	extension/device	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/extension/~/fax	Get Fax Message List		Light	ReadMessages	ReadMessages	5.x	Regular Alias	Public Advanced		Messaging	Fax	extension/fax	Messaging Service
      POST	/restapi/{version}/account/~/extension/~/fax	Create and Send Fax Message		High	Faxes (+ReadMessages)	OutboundFaxes	5.x	Regular	Public Basic		Messaging	Fax	extension/fax	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/fax/{id}	Get Fax Message by ID	Yes	Light	ReadMessages	ReadMessages	5.x	Regular Alias	Public Advanced		Messaging	Fax	extension/fax	Messaging Service
      GET	/restapi/{version}/account/~/extension/~/forwarding-number	Get Forwarding Numbers		Light	ReadAccounts	ReadUserForwardingFlipNumbers	5.x	Regular	Public Basic		Account/Extension Info	Forwarding Numbers	extension/forwarding-number	Account Configuration Service	P0
      POST	/restapi/{version}/account/~/extension/~/forwarding-number	Add New Forwarding Number		Medium	EditExtensions	EditUserForwardingFlipNumbers	6.4	Regular	Public Advanced		Account/Extension Info	Forwarding Numbers	extension/forwarding-number	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/extension/~/grant	Get Extension Grants		Light	ReadAccounts	ReadExtensions	7.2	Regular	Public Advanced		Grants	Extension Grants	extension/grant	Account Configuration Service
      GET	/restapi/{version}/account/~/extension/~/message-store	Get Message List		Light	ReadMessages	ReadMessages	5.x	Regular	Public Basic		Messaging	Message Store	extension/message-store	Messaging Service	P0
      DELETE	/restapi/{version}/account/~/extension/~/message-store/{id}	Delete Message by ID	Yes	Medium	EditMessages (+ReadMessages)	EditMessages	5.x	Regular	Public Basic		Messaging	Message Store	extension/message-store	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/message-store/{id}	Get Message by ID	Yes	Light	ReadMessages	ReadMessages	5.x	Regular	Public Basic		Messaging	Message Store	extension/message-store	Messaging Service	P0
      PUT	/restapi/{version}/account/~/extension/~/message-store/{id}	Update Message by ID	Yes	Medium	EditMessages (+ReadMessages)	EditMessages	5.x	Regular	Public Basic		Messaging	Message Store	extension/message-store	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/message-store/{id}/content/{id}	Get Message Content		Medium	ReadMessages	ReadMessageContent	5.x	Data Stream	Public Basic		Messaging	Message Store	extension/message-store/content	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/message-sync	Message Synchronization		Light	ReadMessages	ReadMessages	5.x	Sync	Public Advanced		Messaging	Message Sync	extension/message-sync	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/phone-number	Get Extension Phone Numbers		Light	ReadAccounts	ReadUserPhoneNumbers	5.x	Regular	Public Basic		Account/Extension Info	Phone Numbers	extension/phone-number	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/extension/~/presence	Get Extension Presence	Yes	Light	ReadPresence	ReadPresenceStatus	5.x	Regular	Public Basic		Presence	Extension Presence	extension/presence	Presence Service	P0
      PUT	/restapi/{version}/account/~/extension/~/presence	Update Extension Presence		Medium	EditPresence (+ReadPresence)	EditPresenceStatus	5.x	Regular	Public Advanced		Presence	Extension Presence	extension/presence	Presence Service	P0
      GET	/restapi/{version}/account/~/extension/~/presence/line	Get List of Monitored Lines		Light	ReadPresence	ReadPresenceSettings	6.5	Regular	Public Internal		Presence	BLF	extension/presence/line	Presence Service
      PUT	/restapi/{version}/account/~/extension/~/presence/line	Update List of Monitored Lines		Medium	EditPresence (+ReadPresence)	EditPresenceSettings	7.0	Regular	Public Internal		Presence	BLF	extension/presence/line	Presence Service
      GET	/restapi/{version}/account/~/extension/~/presence/line/{id}	Get Monitored Line		Light	ReadPresence	ReadPresenceSettings	6.5	Regular	Public Internal		Presence	BLF	extension/presence/line	Presence Service
      GET	/restapi/{version}/account/~/extension/~/presence/permission	Get List of Extensions Allowed to Pick-up Calls		Light	ReadPresence	ReadPresenceSettings	6.5	Regular	Public Internal		Presence	BLF	extension/presence/permission	Presence Service
      PUT	/restapi/{version}/account/~/extension/~/profile-image	Update Profile Image 		High	EditExtensions	EditUserInfo	7.5	Regular	Public Advanced		Account/Extension Info	Profile Images	extension/profile-image
      POST	/restapi/{version}/account/~/extension/~/profile-image	Update Profile Image (same as PUT)		High	EditExtensions	EditUserInfo	7.5	Regular	Public Advanced		Account/Extension Info	Profile Images	extension/profile-image
      GET	/restapi/{version}/account/~/extension/~/profile-image	Get Profile Image		Medium	ReadAccounts	ReadExtensions	7.5	Regular	Public Advanced		Account/Extension Info	Profile Images	extension/profile-image
      GET	/restapi/{version}/account/~/extension/~/profile-image/195x195	Get Scaled Profile Image (Medium)		Light	ReadAccounts	ReadExtensions	7.5	Regular	Public Advanced		Account/Extension Info	Profile Images	extension/profile-image
      GET	/restapi/{version}/account/~/extension/~/profile-image/584x584	Get Scaled Profile Image (Large)		Light	ReadAccounts	ReadExtensions	7.5	Regular	Public Advanced		Account/Extension Info	Profile Images	extension/profile-image
      GET	/restapi/{version}/account/~/extension/~/profile-image/90x90	Get Scaled Profile Image (Small)		Light	ReadAccounts	ReadExtensions	7.5	Regular	Public Advanced		Account/Extension Info	Profile Images	extension/profile-image
      GET	/restapi/{version}/account/~/extension/~/reporting/settings	Get Customer Facing Analytics Settings		Light	EditReportingSettings	ReadReports	7.2	Regular	Public Internal		Reporting	Reporting Setting	extension/reporting	Account Configuration Service
      PUT	/restapi/{version}/account/~/extension/~/reporting/settings	Update Customer Facing Analytics Settings		Medium	EditReportingSettings	EditReportSettings	7.2	Regular	Public Internal		Reporting	Reporting Setting	extension/reporting	Account Configuration Service
      POST	/restapi/{version}/account/~/extension/~/ringout	Initiate RingOut Call		Heavy	RingOut	?	5.x	Regular	Public Basic		Calls	RingOut	extension/ringout	Telco Service
      DELETE	/restapi/{version}/account/~/extension/~/ringout/{id}	Cancel RingOut Call		Heavy	RingOut	?	5.x	Regular	Public Basic		Calls	RingOut	extension/ringout	Telco Service
      GET	/restapi/{version}/account/~/extension/~/ringout/{id}	Get RingOut Call Status		Light	RingOut	?	5.x	Regular	Public Basic		Calls	RingOut	extension/ringout	Telco Service
      POST	/restapi/{version}/account/~/extension/~/ringout/direct	Initiate Direct RingOut Call		Heavy	DirectRingOut	?	5.x	RPC	Public Internal		Calls	RingOut	extension/ringout	Telco Service
      GET	/restapi/{version}/account/~/extension/~/sms	Get SMS Message List		Light	ReadMessages	ReadMessages	5.x	Regular Alias	Public Advanced		Messaging	SMS	extension/sms	Messaging Service	P0
      POST	/restapi/{version}/account/~/extension/~/sms	Create and Send SMS Message		Medium	SMS (+ReadMessages)	OutboundSMS	5.x	Regular	Public Basic		Messaging	SMS	extension/sms	Messaging Service	P0
      GET	/restapi/{version}/account/~/extension/~/sms/{id}	Get SMS Message by ID	Yes	Light	ReadMessages	ReadMessages	5.x	Regular Alias	Public Advanced		Messaging	SMS	extension/sms	Messaging Service
      POST	/restapi/{version}/account/~/extension/bulk-assign	Provision unassigned users		Heavy	EditExtensions	AddRemoveUsers	7.4	RPC	Public Internal		Account/Extension Info	Extension Info	extension	Account Configuration Service
      POST	/restapi/{version}/account/~/extension/validate	Validate Extension Creation Request		Light	EditExtensions	AddRemoveUsers	6.6	RPC	Public Internal		Account/Extension Info	Validation	extension/validate
      POST	/restapi/{version}/account/~/order	Create New Order		Heavy	EditAccounts (+ReadAccounts)	EditCompanyDevices	6.3 TELUS	Regular	Public Advanced		Provisioning	Device Orders	account/order	Ordering Service	P0
      GET	/restapi/{version}/account/~/order/{id}	Get Order by ID		Light	ReadAccounts	EditCompanyDevices	6.3 TELUS	Regular	Public Advanced		Provisioning	Device Orders	account/order	Ordering Service	P0
      GET	/restapi/{version}/account/~/payment-info	Get Payment Method Info		Light	EditPaymentInfo	ReadPaymentMethod	6.0	Regular	Public Advanced		Provisioning	Payment Info	account/payment-info	Account Configuration Service
      PUT	/restapi/{version}/account/~/payment-info	Update Payment Method Info		Medium	EditPaymentInfo	EditPaymentMethod	6.0	Regular	Public Advanced		Provisioning	Payment Info	account/payment-info	Account Configuration Service
      GET	/restapi/{version}/account/~/phone-number	Get Account Phone Numbers		Heavy	ReadAccounts	ReadCompanyPhoneNumbers	5.x	Regular	Public Basic		Account/Extension Info	Phone Numbers	account/phone-number	Account Configuration Service
      POST	/restapi/{version}/account/~/phone-number	Create New Phone Number		Medium	EditAccounts (+ReadAccounts)	EditCompanyPhoneNumbers	6.3 TELUS	Regular	Public Internal		Account/Extension Info	Phone Numbers	account/phone-number	Account Configuration Service	P0
      DELETE	/restapi/{version}/account/~/phone-number/{id}	Delete  Phone Number by ID		Medium	EditAccounts (+ReadAccounts)	EditCompanyPhoneNumbers	6.3 TELUS	Regular	Public Internal		Account/Extension Info	Phone Numbers	account/phone-number	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/phone-number/{id}	Get Phone Number by ID		Light	ReadAccounts	ReadCompanyPhoneNumbers	5.x	Regular	Public Basic		Account/Extension Info	Phone Numbers	account/phone-number	Account Configuration Service
      PUT	/restapi/{version}/account/~/phone-number/{id}	Update Phone Number by ID		Medium	EditAccounts (+ReadAccounts)	ReassignPhoneNumbers	6.3 TELUS	Regular	Public Internal		Account/Extension Info	Phone Numbers	account/phone-number	Account Configuration Service	P0
      GET	/restapi/{version}/account/~/presence	Get Account Presence		High	ReadPresence	ReadPresenceStatus	5.x	Regular	Public Internal	Deprecated	Presence	Account Presence	account/presence	Presence Service
      GET	/restapi/{version}/account/~/recording/{id}	Get Call Recording Metadata		Medium	ReadCallRecording	ReadCallRecordings	7.2.1	Regular	Public Basic		Call Logs	Call Recordings	account/recording	Call Logs Service
      GET	/restapi/{version}/account/~/recording/{id}/content	Get Call Recording Content		Heavy	ReadCallRecording	ReadCallRecordings	7.2.1	Data Stream	Public Basic		Call Logs	Call Recordings	account/recording/content	Call Logs Service
      GET	/restapi/{version}/account/~/user-group	Get User Group List		Light			8.1	Regular	Public Internal		Roles and Permissions	User Groups	account/user-group
      POST	/restapi/{version}/account/~/user-group	Create User Group		Medium	EditAccounts (+ReadAccounts)	UserGroups	8.1	Regular	Public Internal		Roles and Permissions	User Groups	account/user-group
      GET	/restapi/{version}/account/~/user-group/{id}	Get User Group by ID		Light			8.1	Regular	Public Internal		Roles and Permissions	User Groups	account/user-group
      DELETE	/restapi/{version}/account/~/user-group/{id}	Delete User Group by ID		Medium	EditAccounts (+ReadAccounts)	UserGroups	8.1	Regular	Public Internal		Roles and Permissions	User Groups	account/user-group
      PUT	/restapi/{version}/account/~/user-group/{id}	Update User Group by ID		Medium	EditAccounts (+ReadAccounts)	UserGroups	8.1	Regular	Public Internal		Roles and Permissions	User Groups	account/user-group
      GET	/restapi/{version}/account/~/user-group/{id}/members	Get User Group Members		Light			8.1	Regular	Public Internal		Roles and Permissions	User Groups	account/user-group
      POST	/restapi/{version}/account/~/user-group/bulk-assign	Bulk Assignment of User Group Members		Heavy	EditAccounts (+ReadAccounts)	UserGroups	8.1	RPC	Public Internal		Roles and Permissions	User Groups	account/user-group/bulk-assignment
      GET	/restapi/{version}/account/~/user-role	Get Account User Roles		Light	ReadAccounts		7.5	Regular	Public Internal		Roles and Permissions	Account Roles	account/user-role
      POST	/restapi/{version}/account/~/verification-call	Initiate Verification Call		Medium	Accounts (+EditAccounts)		6.6	Regular	Public Internal		Account/Extension Info	Verification Calls	account/verification-call	Account Configuration Service
      DELETE	/restapi/{version}/account/~/verification-call/{id}	Cancel Verification Call		Medium	Accounts (+EditAccounts)		6.6	Regular	Public Internal		Account/Extension Info	Verification Calls	account/verification-call	Account Configuration Service
      GET	/restapi/{version}/account/~/verification-call/{id}	Get Verification Call Status		Medium	Accounts (+EditAccounts)		6.6	Regular	Public Internal		Account/Extension Info	Verification Calls	account/verification-call	Account Configuration Service
      PUT	/restapi/{version}/account/~/verification-call/{id}	Validate Verification Code		Medium	Accounts (+EditAccounts)		6.6	Regular	Public Internal		Account/Extension Info	Verification Calls	account/verification-call	Account Configuration Service
      POST	/restapi/{version}/account/validate	Validate Account Creation Request		Light	Accounts (+EditAccounts)		6.6	RPC	Public Internal		Account/Extension Info	Validation	account/validate
      GET	/restapi/{version}/client-info	Get Client Info		Light	ReadClientInfo		6.3	Regular	Public Internal		Misc	Client Info / Provisioning	client-info	Client Provisioning Service	P0
      GET	/restapi/{version}/client-info/custom-data/{key}	Get Custom Data by Key		Light	EditCustomData		6.6	Regular	Public Advanced		Misc	Custom Data	client-info/custom-data	Client Provisioning Service	P0
      PUT	/restapi/{version}/client-info/custom-data/{key}	Update Custom Data by Key		Medium	EditCustomData		6.6	Regular	Public Advanced		Misc	Custom Data	client-info/custom-data	Client Provisioning Service	P0
      POST	/restapi/{version}/client-info/sip-provision	Provision SIP Client		High	n/a		7.1	RPC	Public Internal		Misc	SIP Provisioning	client-info/sip-provision	Client Provisioning Service
      GET	/restapi/{version}/client-info/special-number-rule	Get Special Number Rules		Light	ReadClientInfo		6.4	Regular	Public Internal		Misc	Client Info / Provisioning	client-info/special-number-rule	Client Provisioning Service
      GET	/restapi/{version}/dictionary/brand/{id}	Get Brand by ID		Light	n/a		6.5	Regular	Public Advanced		Dictionary	Brands	dictionary/brand	Dictionary Service
      GET	/restapi/{version}/dictionary/country	Get Country List		Light	n/a		6.3	Regular	Public Basic		Dictionary	Countries	dictionary/country	Dictionary Service	P0
      GET	/restapi/{version}/dictionary/country/{id}	Get Country by ID		Light	n/a		6.3	Regular	Public Basic		Dictionary	Countries	dictionary/country	Dictionary Service
      GET	/restapi/{version}/dictionary/device	Get Devices Dictionary		Light	n/a		7.1	Regular	Public Internal		Dictionary	Devices	dictionary/device	Dictionary Service
      GET	/restapi/{version}/dictionary/forms/address	Get Emergency Address Form Parameters		Light	n/a		7.5	Regular	Public Internal		Dictionary	Forms	dictionary/forms/address
      GET	/restapi/{version}/dictionary/language	Get Supported Language List		Light	n/a		6.6	Regular	Public Basic		Dictionary	Languages	dictionary/language	Dictionary Service	P0
      GET	/restapi/{version}/dictionary/language/{id}	Get Language by ID		Light	n/a		6.6	Regular	Public Basic		Dictionary	Languages	dictionary/language	Dictionary Service	P0
      GET	/restapi/{version}/dictionary/location	Get Location List		Light	n/a		6.3	Regular	Public Basic		Dictionary	Locations	dictionary/location	Dictionary Service	P0
      GET	/restapi/{version}/dictionary/permission	Get Permission List		Light	n/a		7.5	Regular	Public Internal		Dictionary	Permissions	dictionary/permission
      GET	/restapi/{version}/dictionary/permission-category	Get Permission Category List		Light	n/a		7.5	Regular	Public Internal		Dictionary	Permissions	dictionary/permission-category
      GET	/restapi/{version}/dictionary/secret-question	Get Secret Question List		Light	n/a		7.4	Regular	Public Internal		Dictionary	Secret Questions	dictionary/secret-question	Dictionary Service
      GET	/restapi/{version}/dictionary/secret-question/{id}	Get Secret Question by ID		Light	n/a		7.4	Regular	Public Internal		Dictionary	Secret Questions	dictionary/secret-question	Dictionary Service
      GET	/restapi/{version}/dictionary/service-plan/{id}	Get Service Plan by ID		Light	n/a		6.5	Regular	Public Advanced		Dictionary	Service Plans	dictionary/service-plan	Dictionary Service
      GET	/restapi/{version}/dictionary/shipping-options	Get Shipping Options		Light	n/a		7.1	Regular	Public Internal		Dictionary	Shipping Options	dictionary/shipping-options	Dictionary Service
      GET	/restapi/{version}/dictionary/state	Get State/Province List		Light	n/a		6.3	Regular	Public Basic		Dictionary	States/Provinces	dictionary/state	Dictionary Service	P0
      GET	/restapi/{version}/dictionary/state/{id}	Get State/Province by ID		Light	n/a		6.3	Regular	Public Basic		Dictionary	States/Provinces	dictionary/state	Dictionary Service
      GET	/restapi/{version}/dictionary/timezone	Get Time Zone List		Light	n/a		6.3	Regular	Public Basic		Dictionary	Timezones	dictionary/timezone	Dictionary Service	P0
      GET	/restapi/{version}/dictionary/timezone/{id}	Get Time Zone by ID		Light	n/a		6.3	Regular	Public Basic		Dictionary	Timezones	dictionary/timezone	Dictionary Service
      GET	/restapi/{version}/dictionary/user-role	Get Role List		Light	n/a		7.5	Regular	Public Internal		Dictionary	Roles	dictionary/user-role
      GET	/restapi/{version}/internal/address-book	Corporate directory for hardphones		n/a	n/a		7.2	Regular	Internal		RC Internal	Corporate Directory	internal/address-book
      POST	/restapi/{version}/internal/device-order/update	Update Device Order		n/a	n/a		6.4	RPC	Internal		RC Internal	DOS Device Orders	internal/device-order/update
      POST	/restapi/{version}/internal/message-notification/transcription-result	VMT Transcription Callback		n/a	n/a		6.5	Callback	Integration		VMT Callback	Mutare API	internal/message-notification/transcription-result
      POST	/restapi/{version}/internal/number-porting/update-order	Update LNP Order		n/a	n/a		5.x	RPC	Internal		RC Internal	LNP Orders	internal/number-porting/update-order
      GET	/restapi/{version}/internal/oauth/app-info	Get Application Info		n/a	n/a		7.4	Regular	Internal		RC Internal	OAuth 	internal/oauth/app-info
      GET	/restapi/{version}/internal/oauth/app-session	Get Application Sessions		n/a	n/a		7.4	Regular	Internal		RC Internal	OAuth 	internal/oauth/app-session
      POST	/restapi/{version}/internal/oauth/generate-code	Generate Authorization Code		n/a	n/a		7.1	RPC	Internal		RC Internal	OAuth 	internal/oauth/generate-code
      GET	/restapi/{version}/internal/presence	Get Internal Presence		n/a	n/a		7.4	Regular	Internal		RC Internal	Presence	internal/presence
      PUT	/restapi/{version}/internal/presence	Update Internal Presence		n/a	n/a		7.4	Regular	Internal		RC Internal	Presence	internal/presence
      POST	/restapi/{version}/internal/rendering-queue/poll	Poll Rendering Queue		n/a	n/a		7.5	RPC	Internal		RC Internal	Rendering	internal/rendering-queue/poll
      POST	/restapi/{version}/internal/rendering-queue/save	Save Rendering Result		n/a	n/a		7.5	RPC	Internal		RC Internal	Rendering	internal/rendering-queue/save
      POST	/restapi/{version}/internal/rendering-queue/touch	Touch Rendering Queue (Keep-Alive)		n/a	n/a		7.5	RPC	Internal		RC Internal	Rendering	internal/rendering-queue/touch
      POST	/restapi/{version}/internal/send-email	Internal Email Sending		n/a	n/a		7.3	RPC	Internal		RC Internal	Email	internal/email
      POST	/restapi/{version}/internal/send-sms	Send internal SMS		n/a	n/a		6.4	RPC	Internal		RC Internal	Internal SMS	internal/send-sms
      GET	/restapi/{version}/internal/service-parameter	Get Service Parameter Value		n/a	n/a		7.1	Regular	Internal		RC Internal	AGS	internal/service-parameter
      PUT	/restapi/{version}/internal/service-parameter	Update Service Parameter Value		n/a	n/a		7.1	Regular	Internal		RC Internal	AGS	internal/service-parameter
      POST	/restapi/{version}/interop/generate-code	Generate Authorization Code		Heavy	Interoperability		7.1	RPC	Public Internal		Misc	Interop	interop/generate-code
      POST	/restapi/{version}/number-parser/parse	Parse Phone Number		Light	n/a		6.5	RPC	Public Advanced		Phone Numbers	Phone Number Parser	number-parser/parse	Phone Parser Service
      GET	/restapi/{version}/number-parser/phonedata.xml	Get Number Parser Configuration		Medium	n/a		6.4	Data Stream	Public Internal		Phone Numbers	Phone Number Parser	number-parser/phonedata.xml	Phone Parser Service	P0
      POST	/restapi/{version}/number-pool/lookup	Look up Phone Number		Medium	NumberLookup	AddRemovePhoneNumbers	6.3	RPC	Public Advanced		Phone Numbers	Phone Number Lookup	number-pool/lookup	Phone Number Pool Service	P0
      POST	/restapi/{version}/number-pool/reserve	Reserve Phone Number		Medium	NumberLookup	AddRemovePhoneNumbers	6.3	RPC	Public Advanced		Phone Numbers	Phone Number Lookup	number-pool/reserve	Phone Number Pool Service	P0
      POST	/restapi/{version}/subscription	Create New Subscription		Medium	n/a		5.x	Regular	Public Basic		Misc	Subscriptions	subscription	Subscription Service	P0
      DELETE	/restapi/{version}/subscription/{id}	Cancel Subscription by ID		Medium	n/a		5.x	Regular	Public Basic		Misc	Subscriptions	subscription	Subscription Service	P0
      GET	/restapi/{version}/subscription/{id}	Get Subscription by ID		Light	n/a		5.x	Regular	Public Basic		Misc	Subscriptions	subscription	Subscription Service
      PUT	/restapi/{version}/subscription/{id}	Update/Renew Subscription by ID		Medium	n/a		5.x	Regular	Public Basic		Misc	Subscriptions	subscription	Subscription Service	P0
      POST	/restapi/auth	LoginHash Authorization		n/a	n/a		5.x	RPC 	Public Internal	Deprecated	Authentication	LoginHash Auth	?	Authentication & Authorization Service
      POST	/restapi/oauth/authorize	OAuth2 Authorize		Auth	n/a		7.1	RPC 	Public Basic		Authentication	OAuth 	oauth/authorize	Authentication & Authorization Service
      POST	/restapi/oauth/revoke	OAuth2 Revoke Token		Auth	n/a		5.x	RPC 	Public Basic		Authentication	OAuth 	oauth/revoke	Authentication & Authorization Service	P0
      POST	/restapi/oauth/token	OAuth2 Get Token		Auth	n/a		5.x	RPC	Public Basic		Authentication	OAuth 	oauth/token	Authentication & Authorization Service	P0
      GET	/sms-inbound/message	Inbound SMS Notification		n/a	n/a		5.x	Callback	Integration		SMS Callback	Nexmo API			P0
      GET	/sms-inbound/receipt	SMS Delivery Receipt		n/a	n/a		5.x	Callback	Integration		SMS Callback	Nexmo API			P0
    }.gsub('/{version}', '/v1.0')
     .gsub(%r</([^/]+)/(?:~|\{id\})>){ |m| "/#{$1}/{#{$1.gsub('-', '_').camelize(:lower)}Id}" }
     .gsub(%r</([^/]+)/\{key\}>){ |m| "/#{$1}/{#{$1.gsub('-', '_').camelize(:lower)}Key}" }
    lines = data.split(/[\r\n]+/).collect(&:strip).reject{ |line| line == '' }
    lines.uniq.each do |line|
      method, uri, name, batch, user_plan_group, app_permission, user_permission, since, style, visibility, status, api_group, api_subgroup, name_for_reports, service_name, priority = line.split("\t").collect(&:strip)
      # create paths
      if self.paths.find_by_uri(uri).nil?
        path = self.paths.build(uri: uri)
        path.save!
        # todo: create requests
      end
    end
  end
end
