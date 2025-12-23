Return-Path: <ceph-devel+bounces-4225-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 980B2CDAC5A
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 23:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 603C6300AC65
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 22:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2542514AD20;
	Tue, 23 Dec 2025 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iEAXPy4u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1379CD
	for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 22:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766530184; cv=fail; b=tsKCHHvVSg5q1OVbm1RY6JLCBTMzdGvEGbIpglQtpKQfBsboO67/r7nx+e+B6tdoEQ7b9W9bOyXHMx6mj4HKRM+tOiFXP2jp0kd9/p6Yp+9CQqXu6jo86qETHDoFeldJiXOJmygTsosB/A4+1RpZs80TNfo+hd2i7glFATbOmVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766530184; c=relaxed/simple;
	bh=kKzALuE+PMMOOMhozO3+pSjOKOR65rduWTXIfhPjlno=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Y9V2EWiKRMeROF5BBaQoT7tFD/Br8dC+lBXfUxYpR81F0IS7toHKeqSYPXKKhiHkXISQsZoHJebPwLcNOJPsMXQtfCwyKB0nGD7+eu+Bs8tT/0BLqhZIseMx+0/EQlvClc0FfWLlNvZ71DQIjfF0tmgqtJXLcfL5fj9Y0CQwudA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iEAXPy4u; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BNG1sQp017384
	for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 22:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=THZ8q22Zv5EiolHBwXRER0ZZYl8vS8eSXua4IN5QXbA=; b=iEAXPy4u
	b5Z6P4Z66nIT45x7WgSgVkdaNTcDOnb/8vW7uaStX03ZjbQxjxq69QcbdVW6uSbz
	JKoqznydwZVbwmfjhGEJrirSIIUZ3BxwH2zsOASRueHju4CC18HIcxo57GSvic20
	Zg3lA1cya8Hkknp7adQGEgVFZYekOUSp+xOP8DY2gY+uXFGQM88QyaNuqt9xLkxC
	q7czP8eD+8QWAiDxuWGqzxY8jbb7Kvht32IiQtJzlt8WfdPgqQ1EjTkCXl/fzVKk
	H7TOv36stBHIFt2EYX/qFX9LFat194vBcgiGr2pyHoPqyXmzxIVj3tzZWR7s0s8p
	zuuIRGkB2CM87w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5h7hxvhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 22:49:41 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BNMnfTK002300;
	Tue, 23 Dec 2025 22:49:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5h7hxvht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Dec 2025 22:49:40 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BNMneu0002288;
	Tue, 23 Dec 2025 22:49:40 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010055.outbound.protection.outlook.com [52.101.56.55])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5h7hxvhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Dec 2025 22:49:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqId3DKtrukrlDFlxfFF3vC+XtPNeTvs4II4gI03Skbg1pEGbVEoE7P5xfHAIX5/xfIdLRDr1tJlq0xVQVjbvMSBPDaKnAsd0DugpwYcBiuZ+ru7tI7fpU7hsVE77cBHIFbIRi8FhwIdBE0MUrsPpM6/sxtzeTmd0ouVddolciCumqh7K0gdmOVxSWBLv4K0sdv86LrGQcD0egzswGhURCui3ugD5cUY4ZftyrGI7n6l/ma3AQZHur6aVIEAZgmwNA1l3kO+SLMHQzct9MjInd8ffzEOLPgY7RLMF4zXNAag1tJLpJjaUAT0cP03GCjKwlKuRfFRYb8c7jMV+0Jw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YY7sECpcjgLS05/gH2NgOGSDBAzlWP5Zo6L5g06hxnE=;
 b=DL6pxij7GEtN3F8EUO1ngwWvPLeeGJ3MlL451SfMa1YgQW15AphlcikE2D8sqRR1J361HTaa6Y8xwBEb5/UfipnKIWDwA+sjOq3ZFp0b0NoyfROzxERwozTg9CEzQjZlfdLY28+cUUeXZF0P6pT4v4SK+J8fUhTVa7J5tP30ZJ+N5JmnrKUKv69/PRc8DwBW/mTp0M1G+lasnrzL6MIGYFBZWL7jDawlOrQpVDMRsFq8YVWsaho6oqgnQRgKEcSzpGx4CHiWJsvXMEDTh//aVvBJDfeKWBh1eJYZHZ8rsh/yjhtspzqaXrGzLKMauOhj0ZqftXc6N06nPZiVuDEaEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY3PR15MB4835.namprd15.prod.outlook.com (2603:10b6:a03:3b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 22:49:36 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9434.001; Tue, 23 Dec 2025
 22:49:36 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "daniel@chaospixel.com" <daniel@chaospixel.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph: Fix kernel oops due invalid
 pointer for kfree() in parse_longname()
Thread-Index: AQHcc4m7/8ZhY6GLjECGBMIwypwZdrUv1b6A
Date: Tue, 23 Dec 2025 22:49:36 +0000
Message-ID: <180a7f3f6965b69298fbfd90806aee3102c5abb8.camel@ibm.com>
References: <20251220140153.1523907-1-daniel@chaospixel.com>
	 <62924ea8997fb174034e6333db3a52b2f30f0e68.camel@ibm.com>
	 <95555273-fa9a-48fa-855e-ca1e71f4c903@chaospixel.com>
In-Reply-To: <95555273-fa9a-48fa-855e-ca1e71f4c903@chaospixel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY3PR15MB4835:EE_
x-ms-office365-filtering-correlation-id: 13738465-9431-4637-e756-08de42758c29
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?R003d2xka3VyVjBPM09WYWl4Y1dVK1BGQzJjakg0ei9LUVgzb0M3Z2pZdVh6?=
 =?utf-8?B?dHRXWi9Hd1I3UWk1MnJtOFNFaGdTMXNDaDNpeWozVzY5V1ZYU2dyU3pqRzln?=
 =?utf-8?B?dUo3c0p6UDlpSEhSVlRkelZ6Vnh1VnZWbzhmSCtqdkE3T0dpTWd0Zk55Y2RI?=
 =?utf-8?B?M08wN1BZSFJ1SC9BdG9Zc0g4K3gxWUNkdEE1Rm1DZWF5QlBlTzNFQTJkZTd6?=
 =?utf-8?B?N211YTh5K3BlNDg2SFJvSkpQS3lSNHc3MVpIR2hBeGhQS1ZqdlVUbDRpeC9v?=
 =?utf-8?B?TGxXRERHTDQ2VUY5cHZPcDNydWR2MkdMQXVrcFJONWlseGl6WUgzamhhWnVP?=
 =?utf-8?B?aE9Zc2UzVFJXSmpOVlB4OEt5MUREWjhuaVVOZDlsRVFoUEJNRFBzSnVhMVpQ?=
 =?utf-8?B?RzVSM29YWGVnelVacVJmR2NMdDFhVjJxWHdZNm53WnNpdEtYcW9hcldiekpT?=
 =?utf-8?B?NkZNbyt0OFZteDdHNEhKOE0wUW9vemtKdkZCZlowOGt2Y2lPV2I0Q0ovWVVs?=
 =?utf-8?B?N0hrWDQvUmZNWTRzcG9RNXh2RjRPci9JQnpWZCt4amhJcUtVQ3VJdjg4Z3Nx?=
 =?utf-8?B?LytXc09aMVY5eGw1WnNsZHVxaXg5c09tS1d0Q1hibGk5OGc4VGc4Q3pzMEdn?=
 =?utf-8?B?YWRiS2ZEdC9DTEJ1VGV0RlB6Z3greW40ZTNOTjh4Y0dralYrcGJxVG4ybU1D?=
 =?utf-8?B?WUVka1o2b1BxM2lLTnc3dVk0Yit1SDEwS2xZZ0VjRkRHaWk2a2s4RDVGZmVv?=
 =?utf-8?B?SjN5U09wcFpXZER1Qkt6MDN4djZIVGt2c2tac21YNkZTVUJuY3o5Mk5OTis0?=
 =?utf-8?B?Qk1paDdpTHlySjJKRU82RlFNektEOFlrODkrVlprNGhhL3llampQekg3R2t4?=
 =?utf-8?B?Qmh0aWlXek0weS9sU1NiRGYzNnpiZFFIY0pqcjlzTWVueS85UXJRS2hxK1li?=
 =?utf-8?B?aUFOWnBPY2FqWXIxK1NNclhrejZEYVlCcEUzMTErTFVJVU1ISzYxTmhObita?=
 =?utf-8?B?Q1RDblZrSlpNS2lKdnBBQzg5Z3Yra3Vra3I1VUFhMWV4NjNuZ01nS2I0TFNt?=
 =?utf-8?B?ckc4TllVQTc0TTQ0dmJvdkJZVGoxeDYvUzB5L3RYU2V3T2x0Um4wbHZVZkxu?=
 =?utf-8?B?K1NoS0d6UGhyeGVjY21zbFpTcE9oUE9FWCt5ekRrWUpuQkptU3VRSmV0V1Ir?=
 =?utf-8?B?R1E2N3JZRXVyQUtyOVhxV1h0cFlWeWxnaHJiY3g4Vnh2TUlZcWJ4cytWTWRx?=
 =?utf-8?B?WFhEOVZqbkVTRXdsSnI2YlprM3pBaE9qYU1SU2p5RjJySTk5R0EzVUYyZG0w?=
 =?utf-8?B?bHQxYzI2SHR2Z1hkQWpIZGUyYjZ5OGZjOGZuczZwYklEVURUOEpMcWcvZmJZ?=
 =?utf-8?B?QW5vOVhxUHZDbmJnRUJzSzlMV0NNVy9jUEN3NUdyQlJpUnlCWmxMMXZxN1Rm?=
 =?utf-8?B?VWcxcWRpTVEvNkZrS2NtNE03dHFUODZTQWptb1A5YkxrRkhkUjBRalRJbWsy?=
 =?utf-8?B?a2hLOWhGOTZTTjkzaUJwR2F0ZFNxN1lsWjZ1aGNtNzdWSmQvSkhGVG8xWWto?=
 =?utf-8?B?S0I4Ni8rTWpsWlNOQlBFTld0aWlSR1E3WklTOG5vMkY4OEZoazBFdjVsaTgz?=
 =?utf-8?B?TnY4S2NSdmVtS2ttSHR2TlVrTExKV2JyeFU5MkNOWHdLS3k5YzQ3Y0gzOUll?=
 =?utf-8?B?UnBVaXd5R3hNYStrSUVPQzN0YmhiZXNMWVpSRjlSUVNaWmFNaEQ3RzhPR2ZM?=
 =?utf-8?B?a2gwMXRISnVoVjdUMTFXK3RTSytRUTJiVlZyV2tDWWpXRm5hV2d6TXFYUlcr?=
 =?utf-8?B?WjJxNzlyU0p5VHE5VDFBWGFBczIxS3l5dkRPekRDK0ZubkJHeWs2aEZRYUxS?=
 =?utf-8?B?b2hQVmEwSXBCdzRmTmc5dWwzRFF5K2JpcUFHMXlMc2IzQnkrb21Hb2VOcEdC?=
 =?utf-8?B?cHFBdmNQKzgwenh2R3JsL0ZFc3hkU1dOLy9SMFRqY0JWNzA0NGg5NjhURlFL?=
 =?utf-8?B?U25GUEM3YjVBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NUxDejhsT1duZmdxVENybjh6Vll2YkVvem5GZjUwTTQyVDRJZUt4b21LNmFk?=
 =?utf-8?B?Vk9SQUx6dWFFRGNGdm5KcHAvQldEUHNRK1Zld0VueGN5RExVTFV4UEV3WkVB?=
 =?utf-8?B?TGlCUUpPRkw4dFFkQlJlU29DRUh3RUUvVFh5VnZpajlPWmxJOFBHaEFZZDB1?=
 =?utf-8?B?TS9MaUZJdU5JNFZzKysvcDBWYU5SSExiZnZrenpUSG1pVk04Zm5JZ3pGNXYz?=
 =?utf-8?B?cU5iOUsweit6VG4yazVyVEpWZFNYRkNXVFdiRWcxV1BIWlZ1dktzbTRhNUli?=
 =?utf-8?B?WHNmSkJxeXhHa1AxTXIxb2gxU04xU3NibSs5T2NCaHpJY3E4dFJLcWJlZDRD?=
 =?utf-8?B?RWwwSUZWZEVwMUpDWUZXVHlobmFxTXRyTW16Z3FkMi9IVzJaZ1hlNThwRm1y?=
 =?utf-8?B?WkVCQnVEQ1NuRjVLZ2pMMkRvbVdkZGpHNHZRVDFoSGppb0VvVGdRcHZvdGZ1?=
 =?utf-8?B?MlVFZlZGTmE2aUkyY3A0RUF6K3pURUpvdVdsWUp5UHpHY2F6WDIrYXJxMTlV?=
 =?utf-8?B?bkZETy9zdm5wSFRhNTdBUmsxWk9DdmdUQjU1RWVUQUhGaVV1ditaUGVHd3NL?=
 =?utf-8?B?cHRBQTYyQTdNLzl2OEV4UGpIUWdtaTNTNzJCSk0wT0xSZW9SdFl4eXdlRXZt?=
 =?utf-8?B?Z3p2cGxzNEJGd0Q5amNNckV6RWJZRngzN3oxUUwzNFh2cnJyYW9QK3J0ZjFN?=
 =?utf-8?B?VlB4TFltWWdXd2NES2pIL3RYWlk2MFhWMGt2TDdkb2RBc0pOWkhFdktGQVpD?=
 =?utf-8?B?VXRzcjJyallYaEFSdHZZaUg0YUdPUXg5NGV3M0w1aFRxSDJZTkhQN0hGQ0Fx?=
 =?utf-8?B?bTZTL2FkTGI2TnRZSFc0WEFxRGRyWnk4a3h0UktSOEhCbGh5MnUreVpodnZy?=
 =?utf-8?B?OTR4cnhFdU9pcDVIVHJVakV3WmVvbnRCcUg5YUs5Qm1Sc0xzSTg3a1Z4M0pC?=
 =?utf-8?B?Y2pqak9VS2NWMUxJaDdERFN6Z0VXTzROa05WcmVpR1ZDanpQdkFDOW82THhw?=
 =?utf-8?B?dDI1UFQ2VlJuWjcxbjJNaHJLL1RRU0Eyd09vSUdFKzBkL0RaQUJtL1pRVE51?=
 =?utf-8?B?V1BkcmhpYVY3K3lYL3p4dTl1WWloTE50cU10My9Ydkp1bDF6RU9DWUc2OTVk?=
 =?utf-8?B?eDV3Y1BBU1dpbjduajRkSDNsRUdFU3BzV0ZYYjNCTEIwRXlTTTFYM3pJYU43?=
 =?utf-8?B?VGhrTkxRdjBRM0draUxGVjFWWXcrdEU0ajB4dllOZVlYRFB2b2xUWXRIdUND?=
 =?utf-8?B?MHFuU1dkTVEvODJtTUNnYTJiSUl0Ym9XaU1hV0ZiRkdGV0ZjS1hhVEJIWXRk?=
 =?utf-8?B?TXEvSG51OGp5OE9ub1F2UENuM1pVaHl2NkhHTThWdGx4UFBPK09Jb1paWFpw?=
 =?utf-8?B?aXlXcTA0RFhqYSs0VnAyN2lzanNNVEVBZEQ2S1dpL1pOcWV5OUZnUXR1eGpu?=
 =?utf-8?B?ZGRuZlNGZTJlaGR0TktOem1Jbk5WTVQ2UE5VMGNCYVBrdFdVN2RtZmpzVk9x?=
 =?utf-8?B?cEFBbDVLdDc1VHRJTzJudjlxeE9odngzWEIrSU1yT25CazNtYlNzVFd3YzNE?=
 =?utf-8?B?UERvYzA1M1oyMkJEV0g3VFR5RnhyS0ducTVvb2JiMEZWRU01clYwMGswMjFG?=
 =?utf-8?B?em4zMkVXTmlpdUZvT3B6TWZ6TzcrckhHVUxDdVhmaWVuRUpaVkZ5N2ZGS1Yx?=
 =?utf-8?B?WHQ3Q0dOa1pLVEVNQlovSDVsVk9Ob2w1NGFIb25SL0dMTzFNbXhOY1FUUlpO?=
 =?utf-8?B?V2U1aS9MM1ZSd0tDSEpmemhXbCtWRFhWclZoUnhtNE1RYVFkeDVQZy9IRXhM?=
 =?utf-8?B?RzQ5akJJbHRQV0tEWTdmMURWWUx1ZkljWnNvQk5yOUpZNmNMWG5UcG40Z0VO?=
 =?utf-8?B?bFloa2tEUHpZRUlvWFMweGJxVmlxUmJHQ2hpcE1OSm9XSGxNOWE4ZlpRaW9h?=
 =?utf-8?B?Znd3bUhZOUI0UG9HOVhpaThsSkFVQUJlS0VMMVZyemlzRzk1Z0luR1o5eEph?=
 =?utf-8?B?VmwrNDF0NndQbDdpZlJFbXhLaDNDNTVMRVpEQ0E0cmdzQXlOT29iczNpZkRB?=
 =?utf-8?B?NXE4ak80ZE9ycW5wWmRQLzRRclJFMUJ6WHU3QzVlVFdjTllIaC9ZQzZLSnly?=
 =?utf-8?B?TkRMQWx5MUpJNlZWdjI0eG5TN0FnZnFuaUVDaURUaGlQR1hBS242b3JDNTJI?=
 =?utf-8?B?b293L2VQS3NqLzg2SVRzeHlEby9DZmRFcHBHQ2VqMTZVNFJnMmgvalRxTnRE?=
 =?utf-8?B?SXBJTERHcFB0WndyRU15K1lMZExZNkNzbHhZNks3dHJBMGxQbW9KNmJLSE1L?=
 =?utf-8?B?Zk5MSjh3aWxtK1BRQ0VkU0lja0xPVDNzbWtja1gxRDBLalZzR2Z4ZmJvVmp1?=
 =?utf-8?Q?0yn7a7qDFckKuc/40V4Qyx2rIneyH1n/E9izM?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13738465-9431-4637-e756-08de42758c29
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 22:49:36.3147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjLLNI6KwIzw2DCdq0+QKgksr7l1PMGlzXqexQ+XctSKqq1OJZMmC6k0GzPBG8Ef7esD+8/Ez8pPMFWCUvBhDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4835
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDE5MiBTYWx0ZWRfX3PMxdSRGofMn
 mmelJFBUBDJj6I2n62goM4ert1sXsMdKMPkXhVzmh6Sx+zj6SJ+3TTe9sBWQdAsmCo2fqJ9Qx80
 oPjJM6WOhpukJweSdBXgjS0b9bPezwhcvaWZANAxkpwmOV11Hkf1nbXLveOBSmxXp/SGXAkgjp4
 OypYHL0Kk4XywyU+QUPBZTNQ5DUL8fbaxSRfPTVDXCjmn0yy1oQHc++R2b3rA5IS/11Lm5GY9yi
 GX9vcz32644NpWqvHXgtsm1JOb79QL7dRdWJIQHn/nKU2bO8YULlVZh0DqsbfOAxri4i5AdbAet
 Rir4wfUMKUgtDBJj7nMiH/BW7mjwleDpgKTbXnxb4m7QN2CVtlAxD/MemwujeHRDvEjJ71rH8sb
 4XcbEiq57hy7/lbCWTHjlrgsEjKa5VMXgZqpkZ7kFMt0+qZlY8lGYgvTmmYhn409FPZknqowdeA
 NlKUPDjZV1RdYygKFFA==
X-Authority-Analysis: v=2.4 cv=Ba3VE7t2 c=1 sm=1 tr=0 ts=694b1c84 cx=c_pps
 a=Ess5LnjAiV6zB+80YbJDlg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=4u6H09k7AAAA:8
 a=Zv-iYU-hAAAA:8 a=_mRqrqfCb1mzlmI4aZYA:9 a=QEXdDO2ut3YA:10
 a=5yerskEF2kbSkDMynNst:22 a=7POGK4OykCGyYpN2cFti:22
X-Proofpoint-ORIG-GUID: rskM6uoiqS1zcDQJ9lsVaXlHtcvTSY0G
X-Proofpoint-GUID: fp_nP-WFBZ2eT-R5aQUe8LRcduB06wrL
Content-Type: text/plain; charset="utf-8"
Content-ID: <15829AD1961BF6489B4073F907FC23A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH] fs/ceph: Fix kernel oops due invalid pointer for kfree()
 in parse_longname()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_05,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2512120000 definitions=main-2512230192

On Mon, 2025-12-22 at 22:26 +0100, Daniel Vogelbacher wrote:
> On 12/22/25 21:08, Viacheslav Dubeyko wrote:
> > On Sat, 2025-12-20 at 15:01 +0100, Daniel Vogelbacher wrote:
> > > This fixes a kernel oops when reading ceph snapshot directories (.sna=
p),
> > > for example by simply run `ls /mnt/my_ceph/.snap`.
> > >=20
> >=20
> > Frankly speaking, it's completely not clear how this kernel oops can ha=
ppen.
> > Could you please explain in more details how it can happen and what is =
the
> > nature of the issue? How the issue can be reproduced?
>=20
> All I need to reproduce the issue is to run `ls .snap/` on any mounted=20
> cephfs mountpoint that contains scheduled snapshots. I've one prod VM=20
> (KVM) where I hit the issue after a Debian Trixie upgrade. To isolate=20
> it, I've created a fresh Trixie VM, dropped the distribution kernel and=20
> built a vanilla kernel to isolate the buggy commit by using git-bisect -=
=20
> and to ensure the bug was not introduced by any Debian patches. If that=20
> helps, it's a Squid 19.2.3 cluster.
>=20
> So basically the steps are:
>=20
>   * Setup a Ceph cluster with 19.2.3
>   * Create a pool and cephfs
>   * Create schedule snapshots for the fs
>   * Mount the fs and populate it with a few files on any kernel version=20
> that contains bb80f7618832, that is >=3D6.12.41
>   * Wait until there are scheduled snapshots created
>   * run `ls /mnt/my/cephfs/.snap`

It will be good to see the particular command that everyone can run to repr=
oduce
the issue. You don't need to share the command for setup Ceph cluster, crea=
ting
pool and CephFS instance. But the rest steps are really important because m=
ount
options and details of command that you run can change everything.

>=20
> This should result in a kernel oops like:

The commit message could include oops details.

>=20
> [   53.703013] Oops: general protection fault, probably for=20
> non-canonical address 0xd0c22857c0000000: 0000 [#1] SMP PTI
> [   53.703201] CPU: 11 UID: 0 PID: 360 Comm: kworker/11:2 Not tainted=20
> 6.18.0-rc7 #41 PREEMPT(voluntary)
> [   53.703281] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=20
> 1.16.2-debian-1.16.2-1 04/01/2014
> [   53.703317] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> [   53.703424] RIP: 0010:rb_insert_color=20
> (/usr/src/linux/lib/rbtree.c:185 (discriminator 1)=20
> /usr/src/linux/lib/rbtree.c:436 (discriminator 1))
> [   53.704503] Code: 76 17 48 83 e1 fc 48 3b 51 10 0f 84 b7 00 00 00 48=20
> 89 41 08 c3 cc cc cc cc 48 89 06 c3 cc cc cc cc 48 8b 4a 10 48 85 c9 74=20
> 05 <f6> 01 01 74 1b 48 8b 48 10 48 39 f9 74 68 48 89 c7 48 89 4a 08 48
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>     0:	76 17                	jbe    0x19
>     2:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
>     6:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
>     a:	0f 84 b7 00 00 00    	je     0xc7
>    10:	48 89 41 08          	mov    %rax,0x8(%rcx)
>    14:	c3                   	ret
>    15:	cc                   	int3
>    16:	cc                   	int3
>    17:	cc                   	int3
>    18:	cc                   	int3
>    19:	48 89 06             	mov    %rax,(%rsi)
>    1c:	c3                   	ret
>    1d:	cc                   	int3
>    1e:	cc                   	int3
>    1f:	cc                   	int3
>    20:	cc                   	int3
>    21:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
>    25:	48 85 c9             	test   %rcx,%rcx
>    28:	74 05                	je     0x2f
>    2a:*	f6 01 01             	testb  $0x1,(%rcx)		<-- trapping instruction
>    2d:	74 1b                	je     0x4a
>    2f:	48 8b 48 10          	mov    0x10(%rax),%rcx
>    33:	48 39 f9             	cmp    %rdi,%rcx
>    36:	74 68                	je     0xa0
>    38:	48 89 c7             	mov    %rax,%rdi
>    3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
>    3f:	48                   	rex.W
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     0:	f6 01 01             	testb  $0x1,(%rcx)
>     3:	74 1b                	je     0x20
>     5:	48 8b 48 10          	mov    0x10(%rax),%rcx
>     9:	48 39 f9             	cmp    %rdi,%rcx
>     c:	74 68                	je     0x76
>     e:	48 89 c7             	mov    %rax,%rdi
>    11:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
>    15:	48                   	rex.W
> [   53.704559] RSP: 0018:ffff9ab7c07579e0 EFLAGS: 00010286
> [   53.704591] RAX: ffff8bd0c2285b40 RBX: ffff8bd0c2285240 RCX:=20
> d0c22857c0000000
> [   53.704616] RDX: ffff8bd0c2285910 RSI: ffff8bd0c3e695c0 RDI:=20
> ffff8bd0c22855c0
> [   53.704645] RBP: 0000000000002139 R08: 0000000000000000 R09:=20
> 0000000000000000
> [   53.704668] R10: 0000000000000000 R11: ffff8bd0c16244e0 R12:=20
> ffff8bd0c3e695b8
> [   53.704691] R13: ffff8bd0c3b62000 R14: ffff8bd0c22857c0 R15:=20
> ffff8bd0c3e695c0
> [   53.704714] FS:  0000000000000000(0000) GS:ffff8bd1815ca000(0000)=20
> knlGS:0000000000000000
> [   53.704741] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   53.704762] CR2: 000055667ef28e10 CR3: 0000000106cc2005 CR4:=20
> 0000000000772ef0
> [   53.704790] PKRU: 55555554
> [   53.704803] Call Trace:
> [   53.704844]  <TASK>
> [   53.704862] ceph_get_snapid_map=20
> (/usr/src/linux/./include/linux/spinlock.h:391=20
> /usr/src/linux/fs/ceph/snap.c:1255) ceph
> [   53.704957] ceph_fill_inode (/usr/src/linux/fs/ceph/inode.c:1062=20
> (discriminator 2)) ceph
> [   53.705019]  ? __pfx_ceph_set_ino_cb=20
> (/usr/src/linux/fs/ceph/inode.c:46) ceph
> [   53.705074]  ? __pfx_ceph_ino_compare=20
> (/usr/src/linux/fs/ceph/super.h:595) ceph
> [   53.705132] ceph_readdir_prepopulate=20
> (/usr/src/linux/fs/ceph/inode.c:2113) ceph
> [   53.705191] mds_dispatch (/usr/src/linux/fs/ceph/mds_client.c:3993=20
> /usr/src/linux/fs/ceph/mds_client.c:6299) ceph
> [   53.705253]  ? sock_recvmsg (/usr/src/linux/net/socket.c:1078=20
> (discriminator 1) /usr/src/linux/net/socket.c:1100 (discriminator 1))
> [   53.705279] ceph_con_process_message=20
> (/usr/src/linux/net/ceph/messenger.c:1427) libceph
> [   53.705347] process_message=20
> (/usr/src/linux/net/ceph/messenger_v2.c:2879) libceph
> [   53.705406] ceph_con_v2_try_read=20
> (/usr/src/linux/net/ceph/messenger_v2.c:3043=20
> /usr/src/linux/net/ceph/messenger_v2.c:3099=20
> /usr/src/linux/net/ceph/messenger_v2.c:3148) libceph
> [   53.705467]  ? psi_group_change (/usr/src/linux/kernel/sched/psi.c:876)
> [   53.705488]  ? sched_balance_newidle=20
> (/usr/src/linux/kernel/sched/fair.c:12902 (discriminator 2))
> [   53.705512]  ? psi_task_switch (/usr/src/linux/kernel/sched/psi.c:984=
=20
> (discriminator 2))
> [   53.705532]  ? _raw_spin_unlock=20
> (/usr/src/linux/./arch/x86/include/asm/paravirt.h:562=20
> /usr/src/linux/./arch/x86/include/asm/qspinlock.h:57=20
> /usr/src/linux/./include/linux/spinlock.h:204=20
> /usr/src/linux/./include/linux/spinlock_api_smp.h:142=20
> /usr/src/linux/kernel/locking/spinlock.c:186)
> [   53.705550]  ? finish_task_switch.isra.0=20
> (/usr/src/linux/./arch/x86/include/asm/paravirt.h:671=20
> /usr/src/linux/kernel/sched/sched.h:1559=20
> /usr/src/linux/kernel/sched/core.c:5073=20
> /usr/src/linux/kernel/sched/core.c:5191)
> [   53.705575] ceph_con_workfn=20
> (/usr/src/linux/net/ceph/messenger.c:1578) libceph
> [   53.705627]  process_one_work=20
> (/usr/src/linux/./arch/x86/include/asm/jump_label.h:36=20
> /usr/src/linux/./include/trace/events/workqueue.h:110=20
> /usr/src/linux/kernel/workqueue.c:3268)
> [   53.705657]  worker_thread (/usr/src/linux/kernel/workqueue.c:3340=20
> (discriminator 2) /usr/src/linux/kernel/workqueue.c:3427 (discriminator 2=
))
> [   53.705679]  ? __pfx_worker_thread=20
> (/usr/src/linux/kernel/workqueue.c:3373)
> [   53.705700]  kthread (/usr/src/linux/kernel/kthread.c:463)
> [   53.705717]  ? __pfx_kthread (/usr/src/linux/kernel/kthread.c:412)
> [   53.705734]  ? __pfx_kthread (/usr/src/linux/kernel/kthread.c:412)
> [   53.705752]  ret_from_fork (/usr/src/linux/arch/x86/kernel/process.c:1=
64)
> [   53.705776]  ? __pfx_kthread (/usr/src/linux/kernel/kthread.c:412)
> [   53.705793]  ret_from_fork_asm=20
> (/usr/src/linux/arch/x86/entry/entry_64.S:255)
> [   53.705826]  </TASK>
> [   53.705842] Modules linked in: ceph netfs libceph cfg80211 rfkill=20
> 8021q garp stp mrp llc binfmt_misc intel_rapl_msr intel_rapl_common=20
> intel_uncore_frequency_common kvm_intel virtio_gpu joydev kvm=20
> drm_client_lib virtio_dma_buf evdev drm_shmem_helper sg drm_kms_helper=20
> virtio_balloon button irqbypass ghash_clmulni_intel aesni_intel rapl=20
> pcspkr drm configfs efi_pstore nfnetlink vsock_loopback=20
> vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vmw_vmci=20
> vsock qemu_fw_cfg virtio_rng autofs4 ext4 crc16 mbcache jbd2 hid_generic=
=20
> usbhid hid sr_mod cdrom dm_mod ahci libahci libata xhci_pci iTCO_wdt=20
> intel_pmc_bxt xhci_hcd iTCO_vendor_support scsi_mod psmouse virtio_net=20
> i2c_i801 watchdog serio_raw i2c_smbus lpc_ich scsi_common usbcore=20
> net_failover failover virtio_blk usb_common
> [   53.708740] ---[ end trace 0000000000000000 ]---
> [   53.709462] RIP: 0010:rb_insert_color=20
> (/usr/src/linux/lib/rbtree.c:185 (discriminator 1)=20
> /usr/src/linux/lib/rbtree.c:436 (discriminator 1))
> [   53.710118] Code: 76 17 48 83 e1 fc 48 3b 51 10 0f 84 b7 00 00 00 48=20
> 89 41 08 c3 cc cc cc cc 48 89 06 c3 cc cc cc cc 48 8b 4a 10 48 85 c9 74=20
> 05 <f6> 01 01 74 1b 48 8b 48 10 48 39 f9 74 68 48 89 c7 48 89 4a 08 48
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>     0:	76 17                	jbe    0x19
>     2:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
>     6:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
>     a:	0f 84 b7 00 00 00    	je     0xc7
>    10:	48 89 41 08          	mov    %rax,0x8(%rcx)
>    14:	c3                   	ret
>    15:	cc                   	int3
>    16:	cc                   	int3
>    17:	cc                   	int3
>    18:	cc                   	int3
>    19:	48 89 06             	mov    %rax,(%rsi)
>    1c:	c3                   	ret
>    1d:	cc                   	int3
>    1e:	cc                   	int3
>    1f:	cc                   	int3
>    20:	cc                   	int3
>    21:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
>    25:	48 85 c9             	test   %rcx,%rcx
>    28:	74 05                	je     0x2f
>    2a:*	f6 01 01             	testb  $0x1,(%rcx)		<-- trapping instruction
>    2d:	74 1b                	je     0x4a
>    2f:	48 8b 48 10          	mov    0x10(%rax),%rcx
>    33:	48 39 f9             	cmp    %rdi,%rcx
>    36:	74 68                	je     0xa0
>    38:	48 89 c7             	mov    %rax,%rdi
>    3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
>    3f:	48                   	rex.W
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     0:	f6 01 01             	testb  $0x1,(%rcx)
>     3:	74 1b                	je     0x20
>     5:	48 8b 48 10          	mov    0x10(%rax),%rcx
>     9:	48 39 f9             	cmp    %rdi,%rcx
>     c:	74 68                	je     0x76
>     e:	48 89 c7             	mov    %rax,%rdi
>    11:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
>    15:	48                   	rex.W
> [   53.711453] RSP: 0018:ffff9ab7c07579e0 EFLAGS: 00010286
> [   53.712112] RAX: ffff8bd0c2285b40 RBX: ffff8bd0c2285240 RCX:=20
> d0c22857c0000000
> [   53.712798] RDX: ffff8bd0c2285910 RSI: ffff8bd0c3e695c0 RDI:=20
> ffff8bd0c22855c0
> [   53.713423] RBP: 0000000000002139 R08: 0000000000000000 R09:=20
> 0000000000000000
> [   53.714061] R10: 0000000000000000 R11: ffff8bd0c16244e0 R12:=20
> ffff8bd0c3e695b8
> [   53.714696] R13: ffff8bd0c3b62000 R14: ffff8bd0c22857c0 R15:=20
> ffff8bd0c3e695c0
> [   53.715321] FS:  0000000000000000(0000) GS:ffff8bd1815ca000(0000)=20
> knlGS:0000000000000000
> [   53.715956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   53.716651] CR2: 000055667ef28e10 CR3: 0000000106cc2005 CR4:=20
> 0000000000772ef0
> [   53.717295] PKRU: 55555554
> [   53.717918] note: kworker/11:2[360] exited with preempt_count 1
>=20
>=20
> > > The bug was introduced in commit:
> > >=20
> > > bb80f7618832 - parse_longname(): strrchr() expects NUL-terminated str=
ing
> > >=20
> > > str is guarded by __free(kfree), but advanced later for skipping
> > > the initial '_' in snapshot names.
> > > This patch removes the need for advancing the pointer so kfree()
> > > could do proper memory cleanup.
> > >=20
> >=20
> > I cannot follow of this explanation. What is the wrong? Why should we f=
ix
> > something here?
>=20
> In bb80f7618832, the pointer in variable "str" is guarded by=20
> __free(kfree), which means the pointer returned by kmemdup_nul() is=20
> automatically freed. kfree() should receive the same pointer as returned=
=20
> by kmemdump_nul(), but this is not the case, as the pointer is advanced=20
> by one. kmemdup_nul() may return for example 0x1234000, but kfree() is=20
> called with 0x1234001. I don't know the exact behavior of kfree(), but I=
=20
> assume calling kfree() with random pointers leads to UB?

Please, see my comments below.

>=20
> > > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D220807 =20
> > >=20
> >=20
> > Why the issue had not been reported to CephFS community through email o=
r by
> > means of=C2=A0https://tracker.ceph.com? =20
> It's a kernel bug and not related to any ceph packages, so I've reported=
=20
> it to the kernel issue tracking system.
>=20
> > Have you run xfstests for your patch?
> No, not aware of it. How is xfs related to cephfs?

The xfstests is the regression testing suite that is used for testing all of
Linux file systems (and CephFS too). But if you are not file system guy, th=
en
it's OK that you didn't run the xfstests.

>=20
>=20
> > > Fixes: bb80f7618832 - parse_longname(): strrchr() expects NUL-termina=
ted string
> > >=20
> > > Cc: stable@vger.kernel.org
> > > Suggested-by: Helge Deller <deller@gmx.de>
> > > Signed-off-by: Daniel Vogelbacher <daniel@chaospixel.com>
> > > ---
> > >   fs/ceph/crypto.c | 8 ++++----
> > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> > > index 0ea4db650f85..3e051972e49d 100644
> > > --- a/fs/ceph/crypto.c
> > > +++ b/fs/ceph/crypto.c
> > > @@ -166,12 +166,12 @@ static struct inode *parse_longname(const struc=
t inode *parent,
> > >   	struct ceph_vino vino =3D { .snap =3D CEPH_NOSNAP };
> > >   	char *name_end, *inode_number;
> > >   	int ret =3D -EIO;
> > > -	/* NUL-terminate */
> > > -	char *str __free(kfree) =3D kmemdup_nul(name, *name_len, GFP_KERNEL=
);
> > > +	if (*name_len <=3D 1)
> >=20
> > I believe that even if we have *name_len <=3D 1, then current logic can=
 manage it.
> > Why do we need this fix? The commit message sounds really unclear for m=
y taste.
> > Could you prove that we really need this fix?
>=20
> I've added this protection because otherwise I do pointer arithmetic=20
> without checking bounds. I couldn't give you a better excuse :) I could
> simply remove it on your request.
>=20

OK. Let's analyze the code again.

	char *str __free(kfree) =3D kmemdup_nul(name, *name_len, GFP_KERNEL);
	if (!str)
		return ERR_PTR(-ENOMEM);
	/* Skip initial '_' */
	str++;
	name_end =3D strrchr(str, '_');
	if (!name_end) {
		doutc(cl, "failed to parse long snapshot name: %s\n", str);
		return ERR_PTR(-EIO);
	}
	*name_len =3D (name_end - str);
	if (*name_len <=3D 0) {
		pr_err_client(cl, "failed to parse long snapshot name\n");
		return ERR_PTR(-EIO);
	}

First of all, we try to create a NULL-terminated string from unterminated d=
ata.
If we provide name_len =3D=3D 0, then we should allocate 1 byte/symbol stri=
ng that
contains only termination symbol. Potentially, we could not allocate memory=
 at
all if we are under memory pressure (this situation is managed by !str chec=
k).
However, it doesn't make sense to try to allocate memory at that case. So, =
the
length check at the beginning makes sense:

	if (*name_len <=3D 0)
		return ERR_PTR(-EIO);

Next, we expect to have '_' at the beginning. Let's imagine that we don't h=
ave
any '_' in the provided string, then it make sense to try to allocate memor=
y. I
suggest to call this next:

        name_end =3D strnchr(name, *name_len, '_');
        if (!name_end) {
		doutc(cl, "failed to parse long snapshot name: %s\n", str);
		return ERR_PTR(-EIO);
	} else if (name !=3D name_end) {
                /* we expect '_' at the beginning */
		doutc(cl, "failed to parse long snapshot name: %s\n", str);
		return ERR_PTR(-EIO);
        }

If we have found the first instance of '_' at the beginning of name, then it
makes sense to continue logic.

        if (*name_len <=3D 1)
		return ERR_PTR(-EIO);

And here we can continue the existing logic:

	char *str __free(kfree) =3D kmemdup_nul(name, *name_len, GFP_KERNEL);
	if (!str)
		return ERR_PTR(-ENOMEM);
	/* Skip initial '_' */
	str++;
	name_end =3D strrchr(str, '_');
	if (!name_end) {
		doutc(cl, "failed to parse long snapshot name: %s\n", str);
		return ERR_PTR(-EIO);
	}
	*name_len =3D (name_end - str);
	if (*name_len <=3D 0) {
		pr_err_client(cl, "failed to parse long snapshot name\n");
		return ERR_PTR(-EIO);
	}

Does this logic make sense to you?

However, I have started to think... Could we completely remove the kmemdup_=
nul()
and to operate with the initial name only? I think it's possible, we simply=
 need
to use much smarter technique of string analysis. What do you think? It wil=
l be
good to exclude the memory allocation here.

Thanks,
Slava.

