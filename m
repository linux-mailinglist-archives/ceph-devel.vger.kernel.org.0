Return-Path: <ceph-devel+bounces-4102-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6183C81F5F
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 18:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F7CA3AB882
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 17:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBFD2BE7B2;
	Mon, 24 Nov 2025 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lS2XEhIa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C9BF4F1;
	Mon, 24 Nov 2025 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764006376; cv=fail; b=EtUc2tpZHqcpF2DGw4b16H/XWuHj07S+x8vLMehCEuB8vhPKD7nMXde5BPpH6SCJvzwgyvj9Po3/hbN798bHoWGlbnUozBVLYRRKOnC4za1oYX58Q/3lGK1e9u5tR0JZtIougJXXzPr1UUnSpI0Bojg16YaEM5N/6pFd8tNR72I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764006376; c=relaxed/simple;
	bh=wGOtYjv8g9anqVlZCZ0Wtt8ruThFdlNZZW0pyyDz2XU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=fMPRKXWwpJeP0qpM/VFSjrg2mwHR/ua2JF73CwFkcq9zeivphQuuPkREb4MiD1nFVQCi+9jS75OB0Jrui5aqiJwPdY94oU3JYdkT1nbm5kiLZJoGSusTKhZg6eqf4nNV5CfvhyBoIZO8KSG+5MzRPokH/DZ/NKFRXgQWBHLX1Rk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lS2XEhIa; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOEd4Ox015710;
	Mon, 24 Nov 2025 17:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=wGOtYjv8g9anqVlZCZ0Wtt8ruThFdlNZZW0pyyDz2XU=; b=lS2XEhIa
	hMfSuhPVQuR2/mSg0P96gUM4daqd4wN/9lqQxnnb87gg+2XLwmefiAqbeDaHEU5I
	PDdRztABoxNn6F/sxhfjxmc7FGbwQnlzlEGyHv2zfTHh/pzfs97pC52/H2GHnW9z
	0rpi7UbjOiwOwv8ODJb1syAi1HrPLGTO/ORXEKUBOJP3PDr3s2zTdrNUnn2oCE3l
	UKRX5Oh8D1ea3TDOyq50pDvqfCBfg1JrC0o0ypU6xbcN1YHzf8GPuobNGO0+JWZp
	c+ZWScBPohMnMgsSrEIbTtExefSDqoSYAn/sVChAbzcv9egjK4oxMYk5nyUryPXo
	sLr3pj7m+NAvDw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uv1es0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 17:45:59 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AOHThxM001961;
	Mon, 24 Nov 2025 17:45:59 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013031.outbound.protection.outlook.com [40.93.201.31])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uv1erv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 17:45:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ly9GvPLh/MeTTt6IxYiuDN5trGlpEteEibb5Zbi6vAkzBEah78SqsCmfpcVrV2p7pp+1kBbCOH7JGh2emMMtPZ8qrX4rKJbq3cbMG3Lv+HfFBdTouWvqyaX51qR2EkrdjT9rme7Uq2U3OEvuQ3rYCmtzWOHQECWYsovmsEdvjn8JA1fGdLBjpGJJOh3gYj0iA8uHK4eDzZ6QmlkViytb7sPbkDNuV2iqHJs/rIYK4+h6kxpra8WBsj5E7aUG0cdImXksJgW+GDWnMeKJrENVfdAGwLGRURrEUNE5qhA7K4PHZMlmqKG4ogtk1Iln7O/+o/EGWtQpt+cTPR5gp4/K/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGOtYjv8g9anqVlZCZ0Wtt8ruThFdlNZZW0pyyDz2XU=;
 b=JikD/axMuQ1WBxbNEiJ2mJA8KivESRT6jE0xQxC3k6am2mMQaF+iBLoYbMxYytC++jZb30qrcrvHedYSyXtwGDHJhai4QALKDFVT1vROYYCK7w+rdFtey87cdWJA299c9SMbwUFGxtGy/2NfE/N4m8LjHGo/FVk3bIYqspcm0NXEGkVSCZDyUOr1SuqMJnakHEK2SN4DOmvle7Z3yD9v6vsCue21s1GT/ZKC/jJPYGdEvblNUqxJvDI0+tzQr5IYdhTLHwLuwZLcox6XdxvDZ4M7KP8irtM5JLIR7p/2Q0J8jts9wc+U5v/ESAS5muGt3VPgeicmDuT9+uE2nNQO7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA0PPF82B36C0E0.namprd15.prod.outlook.com (2603:10b6:20f:fc04::b30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:45:55 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:45:55 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "morbo@google.com"
	<morbo@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] libceph: Amend checking to fix
 `make W=1` build breakage
Thread-Index: AQHcUnlPhfQgFpzlT0W0ropk0kVgoLTsX16AgBWkWwCAACuxAA==
Date: Mon, 24 Nov 2025 17:45:55 +0000
Message-ID: <d4a49f37f2ac64036f1bb254abcca6cef743074d.camel@ibm.com>
References: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
	 <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
	 <aRI-ohUyQLxIY1vu@smile.fi.intel.com>
	 <d33fedf2943e0de53317ef19840b46aedb58186e.camel@ibm.com>
	 <aSR1LFQnZgBgkN0t@smile.fi.intel.com>
In-Reply-To: <aSR1LFQnZgBgkN0t@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA0PPF82B36C0E0:EE_
x-ms-office365-filtering-correlation-id: 2b7d61b7-a160-41b9-1af0-08de2b81518d
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?VG14dWhTTVVGa0ZOZkloU3k1U3pLQm5PaFlBMm1YQUczOTA5YmQ4WUxEdmJC?=
 =?utf-8?B?Mnh3Z0hQSGs0UlZobHZFVHF0UDBzdjFvNm0rZW1VSzEzSGZxRCtJOFIwK0I2?=
 =?utf-8?B?bWJBakx4M2hab3NOMmRtMCtpS0ZBbXlQQnlxT0llUHdSbkFsNVVhamxTSERU?=
 =?utf-8?B?d2trQXovWENrOFBnMitUVFhLOU13c0pMM0I2VkFvUnB5NDI0akxzUkY2NW1y?=
 =?utf-8?B?TUNTcTduSlQ3blRwbjUyWFBTdVlYTGc5eGh4OTRmZ0RkYngrOHorTFNubktj?=
 =?utf-8?B?TGtLNnNzSDk4RlNHeFZKcmxsa2RuZlNVUlB4WDRKc3ZEMWh4bEFQQ29pN3Aw?=
 =?utf-8?B?bzlyZmZwOURXaEI1d0tTcnZLU05Kdm5BbjJibk5MWDZWOVNOaUVlZXdxVDBi?=
 =?utf-8?B?d2dURW1YTG80Q29Wanp2dVZNSUhkdW03VlhrZm9qV00vOUVUMkZHdVBtTU03?=
 =?utf-8?B?a1R5U2FoYmp0a25FN1NOb1lUQU1FVmJVSDZDVUE1NWxxemFyT2cvbWc3UEd0?=
 =?utf-8?B?MC8wMHRNT0xZOGlBalNhZldrQ2dMdTNnWDAvS0Q1eTVvNytMakxJMkF3ek94?=
 =?utf-8?B?THd2ZXpzdmp4N3VVWEVMTEdxcGhuNm9JamdCekdza0lacUhST3pYVkdIYkxs?=
 =?utf-8?B?a0VmWTljSU15TU1BZXFYY2p1TXlIeGNtK25HK3dyRmpuNHBUKzZ5bGh6YjZa?=
 =?utf-8?B?NGxvbFd4SUpjWVpCaVhyQUlJVnprajYwODhVM2dQVmFQK3BoNnlWK2ZlNlA4?=
 =?utf-8?B?YklHRjVEK0lsZTA4SFlVQ0dqeG45UGNjQW9TellxSm1zdDAwUzdZdkowTVR0?=
 =?utf-8?B?RnNEbXlLcU5sZnBvZGJhK3B6dUxIM2VOTGVXNWp1Q1k0WVEvak9RUTM5cjJx?=
 =?utf-8?B?WU5BV1laMlY0VmRSdDlvUHo3R09BS0dQSGFvZXB2bHpITXhtenJ1MVdaaGpz?=
 =?utf-8?B?aFM5NTNPK01MV2J2enhiWkdWZXMrT2tYR3FHVURZQ01XWFdoUEkrMDkyQlBp?=
 =?utf-8?B?TmtVQkVqWlNkWW1jcUZiMW9TTmxDaENFVTFhc3NKaDl3RXBTY2pLQnlZeWtS?=
 =?utf-8?B?Q1FjLytLeVRmQitiMjg4YnNTVEJyRGxTbm9Ga1FBUTUzRWxlNEUwakhRb3dm?=
 =?utf-8?B?LzdVOHVsNUY5NVV2OUEwMnM2YXNOZWNhMFhXd25PUXk3WGVxZnB0RVIzYmhu?=
 =?utf-8?B?RXEyS3lSc2VVdTVJVnZUS1lYTUxqN2x5QkxjOVVxNVU1cTFFVHRWRXh1b1FX?=
 =?utf-8?B?UzlhQy9BTHNvc29PMUkzWEdmZDMxVUVha1pKbUNtckxUc3hTZWdtSzZ4WVY5?=
 =?utf-8?B?RENFOG5mZTJhTmFYQkg5d25TblM0Mmp5VHdKTDVBNGVtclp5YzQ1STlsdldS?=
 =?utf-8?B?Yi82NS9hSU56NGNjY1MxYkJDKzE2alp3QXpXa2NlQUZiWTViVDRYTFo4K3lY?=
 =?utf-8?B?VmxBUDQ3RmlUbWtJREVZTzdUUzIyeXZjYjZrZ3FoOEp2VVZ1TDBhNEhvaUtk?=
 =?utf-8?B?L0dGa011ZjlKMk9TdDZlQkdBYnVva3FwdTdHaUFMWEMxU1J1dGU1YnR1cEt3?=
 =?utf-8?B?Q0YyNEozbUh0eDRJQ1V3K2FwdDBDSVlYRXVySDVBUFFXOFh1ZFI0WW1WRDl1?=
 =?utf-8?B?NFFIUXhvRFh4T1lvUzc1N3dZL01uOEphRXRkd3ZvUFN5a2tYU1lQVEMzWVJP?=
 =?utf-8?B?UitueVZLdjFpQnRKUlN2OG44emFTVTN4cFpBNXd2b282UCtCTHYyTi8yME1T?=
 =?utf-8?B?a2pJVGwzOGtBV1JDU1pDakE1ZlovSkJqa3RMbW5EMW9wN29aOE9tMVVwcVdn?=
 =?utf-8?B?MFIycVVCdW1jNFRZMGhxWHR6OXBLZlJ3d0J5SmxBUTc1aTFvbVFSMmI1eG1V?=
 =?utf-8?B?UEV4WDV3M2ZscVliUFNWSnBINGp3TGdzcjdzN1k3YWdlNzFhMjc0M1YxQVhh?=
 =?utf-8?B?TjBLamNqejU4a3U4ZFVEWjVycHFIZ1pBREgzcnBiZ2FGL0NzUUhJekVYa0hp?=
 =?utf-8?B?RXhjbXFqY2FpVXZRZ1E5b0dPeVlHSnJvNFBCRTEzYUdSTWI5bDJBeWpRdHhO?=
 =?utf-8?Q?X08V85?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?czVvemZJbHdIVi8rRmo5RndaMVNLaHF0MkNhVnNMTXJnU3A5TDh5ZmMwbFBR?=
 =?utf-8?B?U0JjakswMmhVbXVoRFpwNzJ3b2ZidUlETXBleHdiV0dkSHZHb0hVdEEwbEJw?=
 =?utf-8?B?WUNPTjRvalNrRkw0T3BCcVFWMEN2QmJQMHFlQ1ZEY2hWVklTaSsvclYwMTY1?=
 =?utf-8?B?MTRWV0d0dlVzcWZCdmpRNHpUdWY3N1NZWVFTRG4rQVd1Yy9WYVl0anBpWlVG?=
 =?utf-8?B?OUZHQWt3QzV4Yk1ReHoyeml1aVFjVjBmYTJzbjJQdjlHdFk3K2k1aTZ3QWFh?=
 =?utf-8?B?OEhnUUtCTm9IdVhvS0ZJYjlIbmFyRU92V3pHY0lNNFlES25JVFJCT0lnN0lL?=
 =?utf-8?B?WTZJSWZsWURoYUlYQjI3TkRCMWY5OE1hY2diY0lQc1JQTEZ4UFZnZVZBWnpJ?=
 =?utf-8?B?OGNRVVMyVDlvdzQzYTUvSy81OWVwcVF6dkoxMVJIamdDWmR1N1YzL0F2bFpU?=
 =?utf-8?B?T1ZZUS9MM09qcGNlN0NzSERCUGNwb2JqNUN6dmxUWmRzaEdld05SY1RlK2hN?=
 =?utf-8?B?bGNUYmpMTzNKYWtVL3NEUjJ2UytFY3JHYUdzMFJpKzlKNG9yN3g1eUt0VzlQ?=
 =?utf-8?B?ZDhUQm9JNzNhNEpCK3dhY1RUYlg1ejl4UFUvVDhjcjJiRjJqK2VMSE90d3Fw?=
 =?utf-8?B?SVkyeXZJNkw2YW02bUxjRm1tQm9wRk1tY25DN0JEQnArek9za0RFYXcwcXR2?=
 =?utf-8?B?WGpFQWhDT2wwV2E3SC9IeGtpWkV2NEdYUFBNeUtNRWttRjZYRXJ6NWtKYXJq?=
 =?utf-8?B?aTZDNlRJaENnalBMNmQybnhreUl3VUxTWUNGTHBtQzJHVEZWdEdyakxia2Yw?=
 =?utf-8?B?TkJaZXpxTWp6ZHduSys3Z2h5bUpTN09FSnFPa1haZTJwVjJwSlN2UWxwRng1?=
 =?utf-8?B?UE9zcnl0TDgwNU45UFpGdWlKMWVjYk5wMVZ5YlZORmNOM3ZJa056VElzRHli?=
 =?utf-8?B?RjViMkdyZk40UUVOSkV5L3Q4SUVsc1dQUHFRc2VmZlJqa3QxNEo1UzVnQnhB?=
 =?utf-8?B?TkZHa3Q3cGgyVUdPSnMxWG9wdHJZUFNvUTNyejRhblZPTXpIMy9TbWQwQkU0?=
 =?utf-8?B?aENqYXR4MFBmWnkxUHpEZ2FGTmJZZW5xWGNZeS9EVCtYS3ZYek9xS0psNDF6?=
 =?utf-8?B?RjhZVHo1bktwZWoyZnZaVEQzWDlPV2ROWTNzak9aT2Z0bUZpZ3AwcmJQdXdz?=
 =?utf-8?B?aVRkZ0tqTTJzZm9VSFoySHNCa2RReGZvWDh6eTgxcmhPUzV1czh4ck1paUtO?=
 =?utf-8?B?NXdmQ01aVS8xTDJaRGVsdHJOcFVaV2NrWGZwSFc5UWVrK1luQnAwUUtjTVU2?=
 =?utf-8?B?RWdjZm1vMTlabzFUa01tSENKQVZHQXNKNVVrK2N2a2ZldFRoTmlKUmVWWFdv?=
 =?utf-8?B?N1VKNndFajlJcXQzd1YxUWRaVFQ3UEduSXVWU0dXalFNcU9LUnprMlJPRWI3?=
 =?utf-8?B?SFlvYU9KWE9RYU04Lzg1MVV0N1BiZTUyNFRnUWxmdlQwM0dxbjZJUVdWK1VV?=
 =?utf-8?B?TVgwUzdGZHY1Y3BtL3Q2OVorM2swNExjUkVTTVpFeWlVbFplbDlCZDNIWldW?=
 =?utf-8?B?QmZ3cjYzQTcwYXRXUlVha0JKMmNjdU9rRUUySHNWSnA1SHdxcXZWVzdGL25D?=
 =?utf-8?B?SXNJUEhnS1lhekZZM2w4Y1VlckpQaGVHTUd3SFBxb3REQVc5NCtCUmdwMmRa?=
 =?utf-8?B?R1ZHSkNKcUswUFh1UGxDeFM3QW5IZzNTTDE5cis3TC9hY3UwRzhMMksxd2g1?=
 =?utf-8?B?MkcxeFJDL2tZMmNHdEw2OFBaem9DVENvc2F6MXZRQkJNOUdPNXhOZW1yMVFz?=
 =?utf-8?B?a3J6aDVyMFBUaldVbnU1SHZBZUh2UEYrTWFhTS91eXBQL0Qwb0hqcXZ4Q2pB?=
 =?utf-8?B?WjZ2Q0JPZ3Mvam9sVUxJUlNOeTN0VmNkT2pBUENRblpwTGZkbGRxOVBJcVB5?=
 =?utf-8?B?U2YrMWE5U252dnF6NGV2VUpmci95MFhXOENTOFR2Z0tZd205NEJLK3FtSkxL?=
 =?utf-8?B?Ri93MS9rSlNmQzhadjVKZG0yam1qZWU4c1crL3pjdFFHOFBaT05IYVFpNWlx?=
 =?utf-8?B?SHVOQ3F4UWFxVjNIbTF0NFFQQmtQM0JmTE1sU3A1UVVPTm9kNndzTy9qR2RY?=
 =?utf-8?B?Vy9vY2ZmRWtEbVFkWnU0MnkwQVBpSlpObHkvN0tHTDBIZHgwV1N1TCtlU1Bn?=
 =?utf-8?Q?kT27ByVC3vbyqfhsGBdmECE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB5D0995FB557A478FECA52B1370B59E@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7d61b7-a160-41b9-1af0-08de2b81518d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 17:45:55.1829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80WqnOjedE2T5C23Q4xaBbkIwrFYHqCNf1RWMFt6WU1Z5qYZ4/UFHTGLreP9tezfRwr9swEu3p38CF01fRotaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF82B36C0E0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfXzAA/bgR2ASBP
 D7MVJhMzczSZevVpPXeMJZB1frouQoaTtfwp+nCAWXRAXRC7+TsWUXdZkXLhPxEqDyliLokRaqm
 dGExgfvIXjymunJvr627M/Ca8sAgJwDnS/xy3GOZRH3+96Bg6Qdxd45vFKnBHZCuR6ax+hpnQ4b
 NvV8IFCG6h3DZ0/0tiz70VWZ2w6BQf52vA+NkRfj60671g24EgMJ/MiE+x6PuEOZZT4sYv4Msp8
 GNQOfMErnPKVqPeeMp4mRVd79Qug0oXGoLdGBBtv73mvom6tIcwZ/PFoKu4J6lfiFJ/nBdXpHwQ
 OBIIlEkbibUuN/OIo8HEKSuUVyGBcUVEPhs3JUKOzPDjw3UrbPvYlHgpco4sfYpiqnR1zy8q4rA
 gDadrACEkkF+/8ByQBmt25DVyvbl6w==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=692499d7 cx=c_pps
 a=7NCjPUurWbS4kF9YcBnZ4Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=QyXUC8HyAAAA:8
 a=VnNF1IyMAAAA:8 a=wnGvtxDjoSpHgSTOxi4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: yQobkCBn1MQ0R4s6WpXdT6pEY5qaPuw-
X-Proofpoint-GUID: 2bMXpzG-EbQWp2bfkc-oEA8foO5XkoVq
Subject: RE: [PATCH v1 1/1] libceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

T24gTW9uLCAyMDI1LTExLTI0IGF0IDE3OjA5ICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDEwLCAyMDI1IGF0IDA4OjM5OjQ5UE0g
KzAwMDAsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMTAg
YXQgMjE6MzYgKzAyMDAsIGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbSB3cm90ZToN
Cj4gPiA+IE9uIE1vbiwgTm92IDEwLCAyMDI1IGF0IDA3OjI4OjM2UE0gKzAwMDAsIFZpYWNoZXNs
YXYgRHViZXlrbyB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCAyMDI1LTExLTEwIGF0IDE1OjQ2ICsw
MTAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+IA0KPiAuLi4NCj4gDQo+ID4gPiA+ID4gIAlj
ZXBoX2RlY29kZV8zMl9zYWZlKHAsIGVuZCwgbGVuLCBlX2ludmFsKTsNCj4gPiA+ID4gPiAgCWlm
IChsZW4gPT0gMCAmJiBpbmNyZW1lbnRhbCkNCj4gPiA+ID4gPiAgCQlyZXR1cm4gTlVMTDsJLyog
bmV3X3BnX3RlbXA6IFtdIHRvIHJlbW92ZSAqLw0KPiA+ID4gPiA+IC0JaWYgKGxlbiA+IChTSVpF
X01BWCAtIHNpemVvZigqcGcpKSAvIHNpemVvZih1MzIpKQ0KPiA+ID4gPiA+ICsJaWYgKChzaXpl
X3QpbGVuID4gKFNJWkVfTUFYIC0gc2l6ZW9mKCpwZykpIC8gc2l6ZW9mKHUzMikpDQo+ID4gPiA+
ID4gIAkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ID4gPiA+ID4gIA0KPiA+ID4gPiA+ICAJ
Y2VwaF9kZWNvZGVfbmVlZChwLCBlbmQsIGxlbiAqIHNpemVvZih1MzIpLCBlX2ludmFsKTsNCj4g
PiA+IA0KPiA+ID4gPiBJIGFtIGd1ZXNzaW5nLi4uIFdoYXQgaWYgd2UgY2hhbmdlIHRoZSBkZWNs
YXJhdGlvbiBvZiBsZW4gb24gc2l6ZV90LCB0aGVuIGNvdWxkDQo+ID4gPiA+IGl0IGJlIG1vcmUg
Y2xlYXIgc29sdXRpb24gaGVyZT8gRm9yIGV4YW1wbGUsIGxldCdzIGNvbnNpZGVyIHRoaXMgZm9y
IGJvdGggY2FzZXM6DQo+ID4gPiA+IA0KPiA+ID4gPiBzaXplX3QgbGVuLCBpOw0KPiA+ID4gPiAN
Cj4gPiA+ID4gQ291bGQgaXQgZWxpbWluYXRlIHRoZSBpc3N1ZSBhbmQgdG8gbWFrZSB0aGUgQ2xh
bmcgaGFwcHk/IE9yIGNvdWxkIGl0IGludHJvZHVjZQ0KPiA+ID4gPiBhbm90aGVyIHdhcm5pbmdz
L2lzc3Vlcz8NCj4gPiA+IA0KPiA+ID4gUHJvYmFibHksIGJ1dCB0aGUgY29kZSBpcyBwaWVyY2Vk
IHdpdGggdGhlIHNpemVvZih1MzIpIGFuZCBhbGlrZSwgbW9yZW92ZXINCj4gPiA+IHNpemVfdCBp
cyBhcmNoaXRlY3R1cmUtZGVwZW5kZW50IHR5cGUsIHdoaWxlIHRoZSBzZXQgb2YgbWFjcm9zIGlu
IGRlY29kZS5oDQo+ID4gPiBzZWVtcyB0byBvcGVyYXRlIG9uIHRoZSBmaXhlZC13aWR0aCB0eXBl
LiBUaGF0IHNhaWQsIEkgcHJlZmVyIG15IHdheSBvZiBmaXhpbmcNCj4gPiA+IHRoaXMuIEJ1dCBp
ZiB5b3UgZmluZCBhbm90aGVyLCBiZXR0ZXIgb25lLCBJIGFtIGFsbCBlYXJzIQ0KPiA+ID4gDQo+
ID4gPiAqQWxzbyBub3RlLCBJJ20gbm90IGZhbWlsaWFyIHdpdGggdGhlIGd1dHMgb2YgdGhlIGNl
cGgsIHNvIG1heWJlIHlvdXIgc29sdXRpb24NCj4gPiA+IGlzIHRoZSBiZXN0LCBidXQgSSB3YW50
IG1vcmUgcGVvcGxlIHRvIGNvbmZpcm0gdGhpcy4NCj4gPiANCj4gPiBJIHRoaW5rIHRoZSBwYXRj
aCBsb29rcyBnb29kIGFzIGl0IGlzLiBBbmQgd2UgY2FuIHRha2UgaXQuIElmIHdlIGZpbmQgdGhl
IGJldHRlcg0KPiA+IHdheQ0KPiA+IG9mIGZpeGluZyB0aGlzLCB0aGVuIHdlIGNhbiBkbyBpdCBh
bnl0aW1lLg0KPiA+IA0KPiA+IFJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZh
LkR1YmV5a29AaWJtLmNvbT4NCj4gDQo+IFRoYW5rcywgY2FuIHRoaXMgYmUgYXBwbGllZD8gTXkg
YnVpbGRzIGFyZSBzdGlsbCBicm9rZW4uDQoNClRoZSBwYXRjaHNldCBoYXMgYmVlbiBhcHBsaWVk
IG9uIHRlc3RpbmcgYnJhbmNoIGFscmVhZHkgWzFdLg0KDQpJbHlhLCB3aGVuIGFyZSB3ZSBwbGFu
bmluZyB0byBzZW5kIHRoaXMgcGF0Y2hzZXQgdXBzdHJlYW0/DQoNClRoYW5rcywNClNsYXZhLg0K
DQpbMV0gaHR0cHM6Ly9naXRodWIuY29tL2NlcGgvY2VwaC1jbGllbnQuZ2l0DQo=

