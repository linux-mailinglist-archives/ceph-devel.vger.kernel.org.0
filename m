Return-Path: <ceph-devel+bounces-3512-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FF0B428E7
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 20:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A2D65675AE
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 18:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7025D368099;
	Wed,  3 Sep 2025 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tjKudUk0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B873368098;
	Wed,  3 Sep 2025 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756924895; cv=fail; b=n/cdDX7seNe//kFdIZuwPDtTNesHT7SUqNwYG1xsp85EXL7wvX06T8S5SD2Xw7tDTKBFFBMaA/8ZM/C9SasYligyQ9eT74qMQK0mBuie+Bz7aOflIvIIFZ+XySfgdnlCKgFdOzfqMGKauUwa+VN3KkE6SctD+xU9JeUwfvgpPJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756924895; c=relaxed/simple;
	bh=lawlvUGpNPkLgZ+bmqnz720hTUbXLd2OJlPgOz+V9l8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=qyGWmekiSFGveI4WuzPIVo0INSiqM6SMGzOP4Z3LnLuXyhQS5XWBxKg/Y5H31IEjwJ2EUIOzgGJUiHurSJBedb/RurQfQZnaMKukE5eSVJGq8jzHvP81Mt8eyn0aIQW3WlbWrQPCt0fFTY7FedjJoUHmLN927+Z/qObXHx22M78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tjKudUk0; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583EYphA014432;
	Wed, 3 Sep 2025 18:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=lawlvUGpNPkLgZ+bmqnz720hTUbXLd2OJlPgOz+V9l8=; b=tjKudUk0
	QXPTsnd02gG0ZVlJodMy2y/AgtNHScKo07faK791h/7MZqrKQzkwYYEuLC6jF12Y
	DIymi+Pk3N1GQMmzI5qLjY3GOts+/Z/nS6DwqulM3EhPGrRdOmEOE/AvCyHLWQt7
	VFB8zKxj4T56QEettwgNrlFPFoIYNjLh08sDl3JqGZptY4pfOTb68HVJoFRAmAwc
	4QDHOFDOzrHxL+DIOel1auKLg7r+OLoY9Hf7xtDeaWL6ryPG7S1pJLhw5s66OpHr
	ekox1KZZuYH/N8XabaFct8aXn744DSOQsCah2zN/c5COelNNkPeR9HfQBuEHK0Qk
	oT5l4BeJOZLBQw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usvfwqvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Sep 2025 18:41:30 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 583Ie1gC000443;
	Wed, 3 Sep 2025 18:41:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usvfwqvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Sep 2025 18:41:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6lvn0jn3mv9EO0txsZJ66G6ZU83QkuTRB6lX/B0bdatBGQjqdNlGvCy6lPcjA8JGe+X4DmYvOrX8GPLWKROs7kxXCBhDPD9GTWHaeKeuC4srN3uVyiYklblK/qgxVogcWjjXdeSsicAJB5W93kTV/yC1X3zZaAKZt5Abfd7HwabS9Ffk27soPvd3+ssUMzZy2lShfhlWCmdx+IRTbrMsTvcf4Gk+h9E3dwgRuiQrequEz3TLf9UUhBdiOZsqq0cIAXKaqmHhsXEv02wD9Y1fG4EvXUrhfO+KIcCSTtmUw7dq8Fz0vypw1sMZe6AO6mSEZFY4dUZ8G8VQzPVAJMWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lawlvUGpNPkLgZ+bmqnz720hTUbXLd2OJlPgOz+V9l8=;
 b=nGT+AIlTWxoEkiXZVjsvlwvOgyFdqb8fbb0bvt8gmW6BEOQhymPi2XduQnvr8YbUWpkkJpdrT1Vmf4MdZCobl+f9yX8wWue1eupbf0mGJvfSzBGAa2iDNkD4kQMn0ZcPMyAq2kojvdLweBAN8aOiynEjwdRRwzTyy7wgp/hItYUM3rpy8LTvw0xFTq5qAuKSho8vtTYjC3criFFZYxZuTxxS+1LbgP3TEq8qk4UN7meo36FD8doE18s+m8IF1k4Cv9h6sFoUuIm1fzL7dn4uxv1IMisJ/2VqMrvNkOm+b+PSFrNGGWsVTbQKVKhNAkclKNV1njoXNItHHZHTdLqLaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4686.namprd15.prod.outlook.com (2603:10b6:510:8b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 18:41:26 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 18:41:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH 1/2] ceph/mds_client: transfer
 CEPH_CAP_PIN when updating r_parent on mismatch
Thread-Index: AQHcHKrXQi/eEN0pJU2oMr6rxlGHerSBy16A
Date: Wed, 3 Sep 2025 18:41:26 +0000
Message-ID: <df87678853084b0f976943e6fd852327dcc7cd04.camel@ibm.com>
References: <20250901151448.726098-1-amarkuze@redhat.com>
		 <ae2a652559e30aaea925fc2dfe28602f7216f5b0.camel@ibm.com>
	 <CAO8a2ShM3yar0g83z=aC9VLuPz5bEpBAN8FxRqEqQfSnkgZGUw@mail.gmail.com>
In-Reply-To:
 <CAO8a2ShM3yar0g83z=aC9VLuPz5bEpBAN8FxRqEqQfSnkgZGUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4686:EE_
x-ms-office365-filtering-correlation-id: 13632a93-e4cc-410d-085b-08ddeb197d1b
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MjZPZFdMeHdnTCtoTVZhNWZ5WWFJdHRtMk9jWmcyNDhnNGdKWGRtSmhtNVha?=
 =?utf-8?B?Wit5OXpJTThnSjFac3p4Unl0UlRnSjZoWGV1UVYyLzZWSGcrTmRMZEpSUi9S?=
 =?utf-8?B?cUFFcThqb1NMbjB5UG9yUkNnOGh0SnI5K1c1eUZVV21WUkl6QXdwK3hsZzVn?=
 =?utf-8?B?VzhMZFpJTU1xbFNMQ0l1R1grRjdBdjFUTVE4Zk51WnozaDhZaTBpZkJSUnli?=
 =?utf-8?B?QnJ4UEdOYnlQdk1FSE1GWjFsOWdHMUluSUt2OWlZaHA5ZUZreFNDZnZrSVJt?=
 =?utf-8?B?eGhERkxKVUFINVM5SlpMd0VZWTlUWDJjZmxCYXV3bWs3MWhuTHNhV2pCczFh?=
 =?utf-8?B?aUhtUEpqNjlqcmdwdFordTFGd3lBUmJJRVZsNDhyZFUxbUtSY2FkRGpHNkk3?=
 =?utf-8?B?S1VMTmFUaE5LWTJJc0RlODdUUi9Pc0JoaVllcDBYQ214czR2NDRwcU1ham5j?=
 =?utf-8?B?Y0V1ZnA2MUVwaGVnSnhGY1QrWjJsZThoa2pvWk15N1VlRDBwS1hmWXg0VlBh?=
 =?utf-8?B?V0hpUzNzV1o3amdxZWxEU2NLb1F4NnRsS0hSWHJudWxnQzV4WkxydUo4VDBx?=
 =?utf-8?B?RE1vTEVPeGlhTEZtb1pJYlJ6ekNCbFVoNnBweml0WWhyM1V3SjB3cnZoakFi?=
 =?utf-8?B?YUsyc2tyYTFMNUxGdHBRMTc1QkFCM2l2M3Zxdk40Z2pkSDV2QnArVUhNS1or?=
 =?utf-8?B?WEVoZkt2bEhUei95b1JUWThtRnFzZkpWZW5RSFk1WHJ1SUxHZ3BlT2JQbXcy?=
 =?utf-8?B?T2graWVTaVAvUm5CRDZ2MGt5TURHdit4OFlCcEk5SzV2V3B0R1l0S1VHUkRD?=
 =?utf-8?B?cytscXJNM3I2aC84YlV4RUl4dHRvVXhZR1Z5N0RCWXlBVGlzaURJMHZpMnFY?=
 =?utf-8?B?a1FZWlV2MUxaT2dEdUtqWDV5VEVLamVRYnFyUVkxcFV1dW9FRGZwWmM5TUdN?=
 =?utf-8?B?WWsyQ3kzL3FQT3lGNnpiNlFZM3ZDd3k1dERYTHhTUlYvdkRkK3R1ay9BRE4w?=
 =?utf-8?B?NXI2QmI2cjlmUEplWllRYkFTdXozMUVrZGFMQ2R1bG1yU05JMi9xb0lPTXcw?=
 =?utf-8?B?R3RuZ2VVdGt1TVk5SzRQcGFtcEMzRFJCMVQ2Y1J3SXczRERvOHl3bGFIS3k4?=
 =?utf-8?B?M1krVUlCbGZtRWlOQ2RJcDI0RmRzd0l1UWk4bDRBV05PbEt3YnVGVVFJWS9o?=
 =?utf-8?B?WTg0bDFYeU9waFZKY3hpdFhwcFlxZFJ0bmV4NUJNZjgyaExsUXZnbU53RzRG?=
 =?utf-8?B?SEUxVG13ZUlYYUNwS3o0NmRGU1BxRnlxWW8ycXNwazRjU3pqRDkzQkhyNEs1?=
 =?utf-8?B?OXoxOGthY1dhWWM4UjhzRGQveXNYMnNzTHV3L2R1NHBDRTdSem1UdElvQ2sw?=
 =?utf-8?B?V0RTSDJyaHJ1Q3lhcjdndU8rcG4wY1RyeDNaeGViRFpsVi9Ec2s4ci9UZnNy?=
 =?utf-8?B?SWZ1NFVaL2RQMzdBR3Y4d295LzlmZXh5eVA4MUY3emkya1R1NXVScVJ3blRw?=
 =?utf-8?B?TTVWSjZVc3lrK2xyZTBMQ250NUZwenFLemdNMWVVS1BuWUFLUVR2OFpwNHc4?=
 =?utf-8?B?Rnl2M3dyODBYWS9SaVJKSnFWYUhzTklpWnlFbWV3NWZIQ0NFNXRrSFE0c2xY?=
 =?utf-8?B?WktoV1ZTODBoV0J3bTBSZXl5endPVVZ1REFRYlR0SWNsdWxzZWNjKzQwMWJF?=
 =?utf-8?B?OFdxeGNKUXVmZXZMMVdXcU5FZUJseXczOUNwNDFCZ3h2VGIxVGU3YTJQbmtY?=
 =?utf-8?B?VmZXSE5TUUVaWStBaG9NTi82N1dNcWFkc3lPNTJvYjljSlVVQmptcHRjejVO?=
 =?utf-8?B?RDcxZGQ4cm9XTkgwU2NFK3RqVmNjQ3RjeG1hb1psWk0reER1eWdpRWg2ckFI?=
 =?utf-8?B?ZGIrWFNwQWlpenk3REpnemltUjg4dFlydFptMkdqN3hxR25ROHBVU25ObDR5?=
 =?utf-8?B?TWR4TmNzUTNYNDN4cmFhSkZEbjBLRmg2YnRGdDRoWStNOWQzd0FXRHJzYVk2?=
 =?utf-8?B?bFEvNldWUVdnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dDEzSExaZEhYdUN3NzNZMTBGNlZPUEpzNUl0SzlDa2Jsc09nV0JaR2NSTTVp?=
 =?utf-8?B?bjRmSkpBVVhxQWF1QXJxYjRGM0FnVUJIeXBaMXF0SWJINCtGNm1KS2x5YThC?=
 =?utf-8?B?OHZOMDRMMTNEZFMzTkFnT05SWUVuMFArODRsbGkvV3B2YThLWkxMb2p3RFBx?=
 =?utf-8?B?dmE0ZFJJcTZPbjNSM2lRRDE5ZDhDeVFPYytuSlRxWXRETWlDNXExbkZvZ3M0?=
 =?utf-8?B?KzZhQVdFV0Qwc1pOVDBPTUdsZmRaYVo5THhVS2h4eGpwSjZQdVJLNk5SV1N1?=
 =?utf-8?B?SG9nUU56T3poaXRYYUtFcVBTN2N3VytYamNZREpVbVQ0Zjlab3B2REoyT2VS?=
 =?utf-8?B?QWQrRUJuWVZOcEZ0OE5XY3BzRlIyTVVjOCttSzVFSUZkVlpWR053a3ZObGVD?=
 =?utf-8?B?Y2dYcFNnWDV6N2ZFektVM04vOStITUhNV3F2ZzBONDA0VS9NdlBwL2lVUWVW?=
 =?utf-8?B?dm5NcDVTTzNhenJSMXNtOC9tTWZGQ04rQStRQVpPenhJWWZPUXB6SW5SemhC?=
 =?utf-8?B?UXNWdXdOSExKd3p4dGxBZkRGQldySHBNV0pWMnJqTzI0ekJ6dU41RGlqLzVZ?=
 =?utf-8?B?ZHZHUlA4aG1OZ3g1b0NnZUJsaU9ydlJDOFVVWUlSMmJTUmU2bDUwWlNvYWp6?=
 =?utf-8?B?Uk5oRmM0YlRBME5vbHVUbDJaVE1OUUQvdkkzODRSblR5V01mK20wQzY5WEpn?=
 =?utf-8?B?eVJWbHU5LzQ1QkpKdTNjcHBQR29GUWpBYWEvV0pyZkJQRitkWXlwa09vWHVn?=
 =?utf-8?B?blpmbEkyeEE0RUQ5VUlxYWp4V0FhcFFyWGVCWnhZZTBDY3JuSlZseHJQY3RW?=
 =?utf-8?B?MStqTDhHbkNqdFMwa0c2enVzaFducllXMUdBaHkwaWJGeXhKR1RLTEJGc29s?=
 =?utf-8?B?VCtEc0JmQTRxSFd6aGpxOXdTMXUrRzBYTDJpMkg0Uy9wWGtLWDhyRGcvb2hH?=
 =?utf-8?B?MEJRMy9FVTMwRm1LZnRCOE51bjNIeEhGbXVRZTR1RjM4U3E4UGx0SGtpai85?=
 =?utf-8?B?MWlsTWd6VDY1OEZKdmYvMFBoK2pSSW13L2Y1TngrN3A1SElMakdRVXk2b25S?=
 =?utf-8?B?OXQ4SnFCTHpraVJQTVdEV2o1NExjRmJRMlZ4a0w5SmIvSkJFVlFyK1oveTh2?=
 =?utf-8?B?QmtwRitsY2RLcGRGengrdWErRE1lTGlFaGdZcUVtZU8wbnM4b0tNcFJROTZq?=
 =?utf-8?B?MzNqa1Q2ZEUwSDloRFJoVXR6Y2FWaU5aam9tOEFuNkltR01XQ0dtK2ZiMjNH?=
 =?utf-8?B?ckdvVEVBTEpLVFJ6dXNwRGpVY2hGNDZZT0kwZWRDazU2YnJPR2I5K09lcUJn?=
 =?utf-8?B?WXNRTG5rN0RFaUNDa1NhRDZkSEdyK0tVcjNLWjNwclUyY3c0UHRYYXYvaUVB?=
 =?utf-8?B?aFN5NkZZNkZEdjcxeWVnSTM3Q20vOXAwQ0x5Y244STFEUTlqYkRFRnU1Vlhr?=
 =?utf-8?B?N3lUMjFRcTFOVWZOUkZCQUVqeUhjd0JBS3lhWGlhNS8wNW5Wamt3cGpXckI4?=
 =?utf-8?B?cGxyVGdRQkZsVWpwd0Z4ZkJUSHVMaUYydkU2cXYvQjVzSG9kRy9KaEljcVJF?=
 =?utf-8?B?bCs0amthSHV0dk9ZbVcwL1F4RW1UZzMzS0xkMUdzbkR2K2tCbW5ETGdBNVZm?=
 =?utf-8?B?V3R1eS9SZWRISzIzY1VlYXNvWmJraWJsSzlaWFROdDFlMkVBeE93OHRhcUVr?=
 =?utf-8?B?L1dXay95d3BtN1BNTGxDbmZPK3ZDZ283VU0vUCtXZGNSTzVSSG9EMFdyS3lw?=
 =?utf-8?B?NmpXaStLK1lrdWtSUDZ5WTlKeUJBMkFsV0RzRWF5QkZ4V3VkeVdWTThRcWFF?=
 =?utf-8?B?YlpUTG8wUmNmMHRXTWtrLy9Ub2xuZGhnT2VXQjVBakZZUGFLSUU4dHc3MTEv?=
 =?utf-8?B?UmpzWTVEcnE4VnFYSGo4ejRKVXZpQnFjY2lORFh3ZW9xNVpJa2VSdlJvUEll?=
 =?utf-8?B?b3NlUzBPcHBpVmc1RkR5Sk52c1hsUDBrVzIzVnM2MWh1NlBDbExtNFFLd0Fw?=
 =?utf-8?B?WC9rYmFOVEdMUlhLK3RZblk5UVV3eklMNmQzYlV3SHhhYnQxNmowWWc1Rm82?=
 =?utf-8?B?UkE1MWZJbU1xbHFGeUxzRUdORElRQWFGQUZIb0F4dDh3L08vaVVhUjBvcGJn?=
 =?utf-8?B?Z1BSUDZ5bXZjWkVIUDFiRFhpMWlXeXpncFVibFM5cHF4OTNVTTlBSTJuaXBq?=
 =?utf-8?Q?XIAIMdH9izCcDr0SOgtjwKE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17653DA17264324E9A99C117E694FA20@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13632a93-e4cc-410d-085b-08ddeb197d1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2025 18:41:26.1761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8vhwITRGNl3A2ljWmxPUrizOYJYAVjcj5w4EMSsIAIaAGeks08f+0dGzoJphw72fzLzo/uZ3SI44EgCVGSkpuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4686
X-Authority-Analysis: v=2.4 cv=behrUPPB c=1 sm=1 tr=0 ts=68b88bda cx=c_pps
 a=6o6yH+ztO9YTVe8NWKRCvg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=uu4kMVUoGKXNm7DU1c0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0uGjyQSSMz5qLInTPPkICz9QLgvMbk5E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX6BQLMmot6eOK
 Af7OdeVCv5YY3cuIjQ63nbgETt3Nql8qaEXhYrlpYVW+7v4g8mTQ3YcSmzWztiDuPSPhilY5+PT
 8YHlzwHYIcRBUECzbHxVSE+bwFDJcoM/4nbNU4XH5V6fdRE2EYTDPptvpdILY0Wrz2bH6lOXZ5Y
 cUVs+omS5zNQmrQW3y1gWbJVN4WVfrjzDTKgG8HozwYUoSTUefRCBBlQrva0caqn9Tur62nKHpq
 jpdpNKetTRB/TTwFBLgd+N9IyVjO/iS8d/2xVEFG7sWe9lp8N+JhhSIUZsJFg1qPU3+gEZUulTj
 2HEalB/NTdnOod6s3ewjWMhSI53ikY544fyzowFS1ariv3xq9wMR4sdVhQhJLjCKpjArMH0XZMy
 teq7zl+6
X-Proofpoint-GUID: Sc9LoOqo_545N0rM3zxrHV-d1pF4qsq7
Subject: RE: [PATCH 1/2] ceph/mds_client: transfer CEPH_CAP_PIN when updating
 r_parent on mismatch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_09,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034

T24gV2VkLCAyMDI1LTA5LTAzIGF0IDExOjE0ICswMzAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFRoZXNlIHBhdGNoZXMgYXBwbHkgdG8gdGhlIHRlc3RpbmcgYnJhbmNoLiBUaGV5IHVwZGF0ZSB0
aGUgcl9wYXJlbnQgcmFjZSBmaXguDQo+IA0KPiBjb21taXQgYTY5YWM1NDkyOGE0NWFkNjZiNmJh
ODRmOWJkNGJlMmZkMGY5NTE4ZQ0KPiBBdXRob3I6IEFsZXggTWFya3V6ZSA8YW1hcmt1emVAcmVk
aGF0LmNvbT4NCj4gRGF0ZTogICBUdWUgQXVnIDEyIDA5OjU3OjM5IDIwMjUgKzAwMDANCj4gDQo+
ICAgICBjZXBoOiBmaXggcmFjZSBjb25kaXRpb24gd2hlcmUgcl9wYXJlbnQgYmVjb21lcyBzdGFs
ZSBiZWZvcmUgc2VuZGluZyBtZXNzYWdlDQo+IA0KPiAgICAgV2hlbiB0aGUgcGFyZW50IGRpcmVj
dG9yeSdzIGlfcndzZW0gaXMgbm90IGxvY2tlZCwgcmVxLT5yX3BhcmVudCBtYXkgYmVjb21lDQo+
ICAgICBzdGFsZSBkdWUgdG8gY29uY3VycmVudCBvcGVyYXRpb25zIChlLmcuIHJlbmFtZSkgYmV0
d2VlbiBkZW50cnkgbG9va3VwIGFuZA0KPiAgICAgbWVzc2FnZSBjcmVhdGlvbi4gVmFsaWRhdGUg
dGhhdCByX3BhcmVudCBtYXRjaGVzIHRoZSBlbmNvZGVkIHBhcmVudCBpbm9kZQ0KPiAgICAgYW5k
IHVwZGF0ZSB0byB0aGUgY29ycmVjdCBpbm9kZSBpZiBhIG1pc21hdGNoIGlzIGRldGVjdGVkLg0K
PiANCj4gICAgIFNpZ25lZC1vZmYtYnk6IEFsZXggTWFya3V6ZSA8YW1hcmt1emVAcmVkaGF0LmNv
bT4NCj4gICAgIFJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29A
aWJtLmNvbT4NCj4gICAgIFNpZ25lZC1vZmYtYnk6IElseWEgRHJ5b21vdiA8aWRyeW9tb3ZAZ21h
aWwuY29tPg0KPiANCj4gY29tbWl0IDcxMjhlNDFhNDkwNzA5Yzc1OWZkZTMyODk4ZWFkZTE5N2Fj
ZDA5NzgNCj4gQXV0aG9yOiBBbGV4IE1hcmt1emUgPGFtYXJrdXplQHJlZGhhdC5jb20+DQo+IERh
dGU6ICAgVHVlIEF1ZyAxMiAwOTo1NzozOCAyMDI1ICswMDAwDQo+IA0KPiAgICAgY2VwaDogZml4
IHJhY2UgY29uZGl0aW9uIHZhbGlkYXRpbmcgcl9wYXJlbnQgYmVmb3JlIGFwcGx5aW5nIHN0YXRl
DQo+IA0KPiAgICAgQWRkIHZhbGlkYXRpb24gdG8gZW5zdXJlIHRoZSBjYWNoZWQgcGFyZW50IGRp
cmVjdG9yeSBpbm9kZSBtYXRjaGVzIHRoZQ0KPiAgICAgZGlyZWN0b3J5IGluZm8gaW4gTURTIHJl
cGxpZXMuIFRoaXMgcHJldmVudHMgY2xpZW50LXNpZGUgcmFjZSBjb25kaXRpb25zDQo+ICAgICB3
aGVyZSBjb25jdXJyZW50IG9wZXJhdGlvbnMgKGUuZy4gcmVuYW1lKSBjYXVzZSByX3BhcmVudCB0
byBiZWNvbWUgc3RhbGUNCj4gICAgIGJldHdlZW4gcmVxdWVzdCBpbml0aWF0aW9uIGFuZCByZXBs
eSBwcm9jZXNzaW5nLCB3aGljaCBjb3VsZCBsZWFkIHRvDQo+ICAgICBhcHBseWluZyBzdGF0ZSBj
aGFuZ2VzIHRvIGluY29ycmVjdCBkaXJlY3RvcnkgaW5vZGVzLg0KPiANCj4gICAgIFNpZ25lZC1v
ZmYtYnk6IEFsZXggTWFya3V6ZSA8YW1hcmt1emVAcmVkaGF0LmNvbT4NCj4gICAgIFJldmlld2Vk
LWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCj4gICAgIFNp
Z25lZC1vZmYtYnk6IElseWEgRHJ5b21vdiA8aWRyeW9tb3ZAZ21haWwuY29tPg0KPiANCg0KT0su
IFRoYW5rcyBmb3IgZXhwbGFpbmluZyB0aGlzLg0KDQo+IE9uIFR1ZSwgU2VwIDIsIDIwMjUgYXQg
OTo0MuKAr1BNIFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90
ZToNCj4gPiANCj4gPiBPbiBNb24sIDIwMjUtMDktMDEgYXQgMTU6MTQgKzAwMDAsIEFsZXggTWFy
a3V6ZSB3cm90ZToNCj4gPiA+IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkgbG9jayBpcyBub3Qg
aGVsZCwgcmVxLT5yX3BhcmVudCBjYW4gYmVjb21lIHN0YWxlIGJldHdlZW4gZGVudHJ5IGxvb2t1
cCBhbmQgcmVxdWVzdCBlbmNvZGluZy4NCj4gPiA+IFRoZSBjbGllbnQgdXBkYXRlcyByX3BhcmVu
dCB0byB0aGUgY29ycmVjdCBpbm9kZSBiYXNlZCBvbiB0aGUgZW5jb2RlZCBwYXRoLCBidXQgcHJl
dmlvdXNseSBkaWQgbm90IGFkanVzdCBDRVBIX0NBUF9QSU4gcmVmZXJlbmNlcy4NCj4gPiA+IA0K
PiA+ID4gUmVsZWFzZSB0aGUgcGluIGZyb20gdGhlIG9sZCBwYXJlbnQgYW5kIGFjcXVpcmUgaXQg
Zm9yIHRoZSBuZXcgcGFyZW50IHdoZW4gc3dpdGNoaW5nIHJfcGFyZW50LCBlbnN1cmluZyByZWZl
cmVuY2UgYWNjb3VudGluZyBzdGF5cyBiYWxhbmNlZCBhbmQgYXZvaWRpbmcgbGVha3Mgb3IgdW5k
ZXJmbG93cyBsYXRlciBpbiBjZXBoX21kc2NfcmVsZWFzZV9yZXF1ZXN0KCkuDQo+ID4gPiANCj4g
PiANCg0KSSB0aGluayB0aGF0IGl0IG1ha2VzIHNlbnNlIHRvIGV4cGxhaW4gaW4gYnJpZWYgd2hh
dCBpcyB0aGUNCnJlc3BvbnNpYmlsaXR5IG9mIENFUEhfQ0FQX1BJTiBhbmQgd2h5IGl0IGlzIGlt
cG9ydGFudCB0byBtb3ZlDQp0aGUgQ0VQSF9DQVBfUElOIGZyb20gdGhlIG9sZCBwYXJlbnQgdG8g
dGhlIG5ldyBvbmUuDQoNCj4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggTWFya3V6ZSA8
YW1hcmt1emVAcmVkaGF0LmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGZzL2NlcGgvbWRzX2NsaWVu
dC5jIHwgMTEgKysrKysrKysrLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9t
ZHNfY2xpZW50LmMgYi9mcy9jZXBoL21kc19jbGllbnQuYw0KPiA+ID4gaW5kZXggY2UwYzEyOWY0
NjUxLi40ZTU5MjZmMzZlOGQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9mcy9jZXBoL21kc19jbGllbnQu
Yw0KPiA+ID4gKysrIGIvZnMvY2VwaC9tZHNfY2xpZW50LmMNCj4gPiA+IEBAIC0zMDUzLDEyICsz
MDUzLDE5IEBAIHN0YXRpYyBzdHJ1Y3QgY2VwaF9tc2cgKmNyZWF0ZV9yZXF1ZXN0X21lc3NhZ2Uo
c3RydWN0IGNlcGhfbWRzX3Nlc3Npb24gKnNlc3Npb24sDQo+ID4gPiAgICAgICAgKi8NCj4gPiA+
ICAgICAgIGlmICghcGFyZW50X2xvY2tlZCAmJiByZXEtPnJfcGFyZW50ICYmIHBhdGhfaW5mbzEu
dmluby5pbm8gJiYNCj4gPiA+ICAgICAgICAgICBjZXBoX2lubyhyZXEtPnJfcGFyZW50KSAhPSBw
YXRoX2luZm8xLnZpbm8uaW5vKSB7DQo+ID4gPiArICAgICAgICAgICAgIHN0cnVjdCBpbm9kZSAq
b2xkX3BhcmVudCA9IHJlcS0+cl9wYXJlbnQ7DQo+ID4gPiAgICAgICAgICAgICAgIHN0cnVjdCBp
bm9kZSAqY29ycmVjdF9kaXIgPSBjZXBoX2dldF9pbm9kZShtZHNjLT5mc2MtPnNiLCBwYXRoX2lu
Zm8xLnZpbm8sIE5VTEwpOw0KPiA+ID4gICAgICAgICAgICAgICBpZiAoIUlTX0VSUihjb3JyZWN0
X2RpcikpIHsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBXQVJOX09OQ0UoMSwgImNlcGg6
IHJfcGFyZW50IG1pc21hdGNoIChoYWQgJWxseCB3YW50ZWQgJWxseCkgLSB1cGRhdGluZ1xuIiwN
Cj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2VwaF9pbm8ocmVxLT5yX3Bh
cmVudCksIHBhdGhfaW5mbzEudmluby5pbm8pOw0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAg
IGlwdXQocmVxLT5yX3BhcmVudCk7DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNlcGhfaW5vKG9sZF9wYXJlbnQpLCBwYXRoX2luZm8xLnZpbm8uaW5vKTsNCj4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAvKg0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAqIFRy
YW5zZmVyIENFUEhfQ0FQX1BJTiBmcm9tIHRoZSBvbGQgcGFyZW50IHRvIHRoZSBuZXcgb25lLg0K
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAqIFRoZSBwaW4gd2FzIHRha2VuIGVhcmxpZXIg
aW4gY2VwaF9tZHNjX3N1Ym1pdF9yZXF1ZXN0KCkuDQo+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICovDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgY2VwaF9wdXRfY2FwX3JlZnMoY2Vw
aF9pbm9kZShvbGRfcGFyZW50KSwgQ0VQSF9DQVBfUElOKTsNCj4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBpcHV0KG9sZF9wYXJlbnQpOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIHJl
cS0+cl9wYXJlbnQgPSBjb3JyZWN0X2RpcjsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBj
ZXBoX2dldF9jYXBfcmVmcyhjZXBoX2lub2RlKHJlcS0+cl9wYXJlbnQpLCBDRVBIX0NBUF9QSU4p
Ow0KPiA+ID4gICAgICAgICAgICAgICB9DQo+ID4gPiAgICAgICB9DQo+ID4gPiANCg0KVGhlIHBh
dGNoIGxvb2tzIGdvb2QuIEJ1dCB0aGUgY29tbWl0IG1lc3NhZ2UgY2FuIGJlIGltcHJvdmVkIHRv
IGJlIG1vcmUNCmluZm9ybWF0aXZlLCBmcm9tIG15IHBvaW50IG9mIHZpZXcuDQoNClJldmlld2Vk
LWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtz
LA0KU2xhdmEuDQo=

