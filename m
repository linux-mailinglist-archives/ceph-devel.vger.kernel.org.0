Return-Path: <ceph-devel+bounces-4257-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D4BCF5DAC
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 23:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00834303A03D
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 22:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967412D7802;
	Mon,  5 Jan 2026 22:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aMsqUfAc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B311F4180
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 22:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767652577; cv=fail; b=oQHyExB1qdGf15KxnDdLRVIPXAzr5A3WMjRBPa0T9/5ZE/Rc2Q4SsGtsgVnOA8JFCqArcIorSCEMarEuScP5WLY+vJIz5DOdqF4THch5HhN9pBMxYcoYObzbLGchlIM+An0xI7tzebZ2tt7/XjEeQBYTPfYMebgSHxdlFRSgtJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767652577; c=relaxed/simple;
	bh=E6ijKju0JX1eReUe0EOZzhmbcURdzrRh/7n6ptKeAF4=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Fo9SMAkurAVeOlZUPMD4dHiE53BGzK6SVFUiLn2cGEf0W/xgiX5Ew0+zeG3vaob4bEiN3PGjZp6xMjG9YDu/lpyein2sO49yLrRCngiyeO8q98NFmqo/AVrar/CUkRkzdbjf4oTXQHe8MKs7J/Q1lDLRaZ7jc91ozsjV0xe4HEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aMsqUfAc; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605Cm2Xt021887;
	Mon, 5 Jan 2026 22:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=E6ijKju0JX1eReUe0EOZzhmbcURdzrRh/7n6ptKeAF4=; b=aMsqUfAc
	TADaSlsFk1ECx+EXdtOsk7Z8FU1Qoy9Bs/NQKR7KE7OcGbVQfxsKABV0w16hbaCT
	4gYT79ouM1OBicJ+h+wv9xxwjEQQVyBJbGlY4vPCV4CxOCEV4BBOkIRHs52whsqf
	7Hy9wPVcMPDnSOe34CX/nf7w9TfwBDNtHLFO8rBJu5Pt/6MVZ9Q+7yQin946BmUk
	DBBFL3sWUBLwlVf3XaHRY+pIU9u3PzWwMCGMlRupu+yQutPIxd+ydj2gZwv0qRih
	10mk86bRFpe2POK9VFL5ndGcJG4ksXouJ3ED5JR1aCm059EFGc90nexe3JPCB8Ci
	8mIyc7OHnDgPEQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu61etp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:36:12 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605MVpgC008833;
	Mon, 5 Jan 2026 22:36:11 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu61etn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:36:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z8nf+HPLS1nPUhHTw9e7V4yR4MasocFuwol77HTyu21GueI5YpMrFYepKCZCp3NDRrweLIH9weIrjY3p7DzQTBRd4WKzsshbaQKTuXrh6abVDbAT/XDbTJvJ7pJLrIU+rzclf0vBDKrRBnAF5Nf1aW08AWHuJqPA23w1vMxbvphTDRF/pFDCU/onhFnNzKw/y6iv0mTFhw5AC65J6O9nKl/ON+sTLdCMoEZ74n4O7VVnLhHLgcnbfgiuX+Iobdg6yKeSVInr2FTf1ws8jXw3cJctp8whn3VntSJRZXQ7rsVNKHTic2eetV0QY5dDX89DY2eDwIZ42jOFisoSf4kAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6ijKju0JX1eReUe0EOZzhmbcURdzrRh/7n6ptKeAF4=;
 b=uSCcO/WtM3I6cIbtbH11t/ClvSRYMNQhgxQZVkAzkTW3OtiqdJ77vsWJETZdeI8sRbhTQEalfyqkmOVRDmDuklJPyVvh2CkMPcpPWbNzSXsNYmmVtuOaiQTROOghyIdd5tXGUcISRwz48uPc8uaYTWkCJNzKwpQWrmwMpl/b6UZv6bZwxZQIES0F8HWfTSpMqZPTHHhNuO5ZWEGXGQly4592sSuRaRPKAUmg7yoy58Op56J/sAaElwdif7pJQV1Hogd/MCxZu515irue89kWOgRZ8k6JlrKQY4PhGWhu2PLlrXZeP4Of/Ov6DETYharn/3o5GRr4TaSnedBpetucvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4519.namprd15.prod.outlook.com (2603:10b6:a03:378::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 22:36:09 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 22:36:08 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] libceph: return the handler error from
 mon_handle_auth_done()
Thread-Index: AQHcfo//kRMB/2ePTEmyWBZZBsAPDbVEKj4A
Date: Mon, 5 Jan 2026 22:36:08 +0000
Message-ID: <b9f11d0303c9b682ab35e076697f199f1a114613.camel@ibm.com>
References: <20251231135845.4044168-1-idryomov@gmail.com>
		 <0c55fc3a434624d4eb67babee7108e23e7774cff.camel@ibm.com>
	 <CAOi1vP97PK23jGxtFBDbqUoNDp_ptbHRXgQvdPDxrk78htKfLQ@mail.gmail.com>
In-Reply-To:
 <CAOi1vP97PK23jGxtFBDbqUoNDp_ptbHRXgQvdPDxrk78htKfLQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4519:EE_
x-ms-office365-filtering-correlation-id: f1200b9f-f8b6-4143-62e7-08de4caad244
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YXd2Ny9vV1VKVVRYZ2YzUVB0YTN5Wk1ZU002ZWZOa0JpdnlmZVNyNnVFNTZj?=
 =?utf-8?B?cG93ME83MitNUFpoRFRsSExZcmlEeDR3aFE1TE9CZlE4Rk9uSzBmbU9uU2Rm?=
 =?utf-8?B?VHAxc0RraTZ4aGFFV0QwVG0reVRrWjRNRFc3ZE92MVBoZ1E1MDBQUnZ1NDk5?=
 =?utf-8?B?NE1VR3cwdTljM2dyTzJCMTlwMEErYUE5cUtUeTdtU3hqQlBTeHM1OVlkRGc3?=
 =?utf-8?B?SEF4VmJRQ004SEpzZk1NNjZlRkt0N2RDalFqbFRVVC82VFFrY0ZPRzl0NXl3?=
 =?utf-8?B?eVB3OFB6azdmTnEwOVlRQ3pOOUQ0MURnT1BOVndIUnRLdE9XUGQwaWdFdW0w?=
 =?utf-8?B?MVZQVS9ObkZDSjRKOUZZNzFlUU1yTThDY1dqZWxnd3NmaUV0SkZjbmZ5NExB?=
 =?utf-8?B?YkNLeVVObGhlMUd4WUdhdkNTMnBjVzBlcXgyT3pQeXd1MEd4Q2hDWXU2dTZj?=
 =?utf-8?B?VXd1bldYL2gzSC84MnFRVmcwQk5UVCt0WmF4V2dhRHVYZHRubHVRTHkwMFBT?=
 =?utf-8?B?cGpISWxLalRjT3VPeDk3WDBQdUZaMGxMMzhJOWI0ZWJzQlJuRzExRncxdWtF?=
 =?utf-8?B?bzZ0SERKQ29xelZJcHpncFlNUlNyM0lrL2xFZGxrTXVacVdnVm1QTTVFZlc0?=
 =?utf-8?B?YjJWMm5rb20zUHpOTFhUc2JycTZnS0pONW1malFDTTVyQTArV1MzRXVNVWdG?=
 =?utf-8?B?SFdZS3hGaFI4aDREOE0ybWdJVkxDb2dnVlZYcEJuQThQVm50bExiVmdZK1hu?=
 =?utf-8?B?UnEyWjZnQnplQ2thSGMwMTRSQ1J2MTFBcGRKc1JqUTFPSXYrck1ueXRzdFVr?=
 =?utf-8?B?alkvUnpUaWZIUGw5NTZMYnVjQXk2NWYzYXlUMkdWT1BFS3BkMURKUENXVG9W?=
 =?utf-8?B?V1NhSkZEWHNDNmw5dlo0V2xHSHE1bmYvQlAvdzJSUlJjVVNDM01rZm9uMHBD?=
 =?utf-8?B?elZuZXZ5d3V1QnphVC9jUXpodGVNYTVjek8wVEJyVUUxRGNHY21KRDNZWjJH?=
 =?utf-8?B?UldvT2Z2NGZGM09WUlNjQUlURFRGUjhFSDh6ekM1K3BnVCtheUhldllySThM?=
 =?utf-8?B?V0VwUldwNXBicWdmSkJUN3FXYmtYZm5oRWpSOWVOdDRBcGJHamxBNWZSdUxl?=
 =?utf-8?B?RTlLUzR0VkN5S3h5dXZ1RmR4QzdGNlFrY2IwQlh2YVF0QjEyZ0J4YUo4Q0ln?=
 =?utf-8?B?emcxRSs1aTNiYjEyQ29ZWGFERXlQMVRiNG9lQ3JOR2ZKdjZHWURuR21hWUlI?=
 =?utf-8?B?NXUwOHZmc3NWM1hZZE5hSk5WMFc5MUtybHRRWk9QWW5SWmtzN3ovWnRKZWkr?=
 =?utf-8?B?ZGp3dkdGVUZQVisvVjhjd0hOZG1XZ0VpTnREREtTaWYvOVlBQUFnWVlsWFFp?=
 =?utf-8?B?a0l2N3pUdGpJbWlwL3M5RHF5RHdvV2wvUklnMEVkSUxLNkxEOWNjNllHTVVC?=
 =?utf-8?B?cDAxemRodzErWWRoNEEvcDZXM3RncTZPcG9nVUNtbVNLdDNHa2VKSFdTbmR2?=
 =?utf-8?B?ZUs0SUV1WHBzK3ZtazFuc2E5cGh0NW5kMWRwbUQ3UnFDQXppcEp1UWp4dklx?=
 =?utf-8?B?djg4cmY3Qk9IMHE1d0x5YW1nV2d6Z01TbG9WbjRLTTZzRGZGWXNxOUtnSmxU?=
 =?utf-8?B?VGJTVVhkMUlKNWRHNDNTMWZxOG8xTytWWlRMNElpUEVkQmtvbU91bFpBd0du?=
 =?utf-8?B?M2hKOWV6OGpZejJOTmpKeWUzTk5RaWs0bHRvQkNSTHcyRmg1M2xYTWp2UDhO?=
 =?utf-8?B?Z3BQQk83RjY5cHdWR0JUSlhzZUlhYWs2em1ERXFqR2xQOGlsaFNHaWdtMEEw?=
 =?utf-8?B?NHBXa1QwblBiSDFvS0tVMUJWYTVlSEQzVUpPNWVFSlQ1YjJmcUNldEhueEFW?=
 =?utf-8?B?OUM4K3JyWjVCbHd3bDNqcGo0N0k5aVdISU9DTnJXN1lZRlBzWFVOclpwQ1FR?=
 =?utf-8?B?QWJjWTRYVVlEUjY3KzhLekpuS0ZtTmsxa1BWMzNRTHNLR2VQMk1BdmQzR3ls?=
 =?utf-8?B?QnVuRHIzZnVONi9rSjBDK080TkRBZmFvMHBzcmVGbFBidjJnbWk4MkNTVW1z?=
 =?utf-8?Q?Z607Z2?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Wm9tUWRQUWJFcVpmRmo0MThjYkt1UFhFcDRmWGxPOEpHcXFkdUNpdCt1UE5B?=
 =?utf-8?B?K2ZRS0oyQXdreFJIMGhINUJCT3lJamVwTDIwQjFvc21zcGdzRnNhRHFOTitM?=
 =?utf-8?B?bWk0RlVnc1ZIdGlteGNEYmRVVEZKOFF3dlUrZ3V6Y29uTk9UejZ2V29peVBy?=
 =?utf-8?B?N0NkclpMaW4zRTVGY0NET2VoSFhVRDdJMHpEUVAyQ0FlcmJhUUMzZjVBVmc4?=
 =?utf-8?B?YTREbzdhcFFZQUJmVTVhbnB4dC9YckhrWThjNTIxRnA4aG1NRVNXdGRWTVdL?=
 =?utf-8?B?NjJLKyt0OTlSV3RnK0JRU3hYMUM1NFg5dThESjdIQzJBQWVYVlg3NHZJQkRN?=
 =?utf-8?B?TzBKL3dhcCtmZEx3MVJqREVacGlsclBNM3hwOUFWYlZneFlscW9TZjhZQk9V?=
 =?utf-8?B?bHFYUmlDTCtQTWFMMTUwU29vV1lLMTdLcldvbWRTMExvYUxxdmlxeFlFeW5y?=
 =?utf-8?B?YzdaSFNQbkhsUVlVVCsxSzVmZGxuNHpMU1o4azlEZkExVTFFRGpJYWhRSTR5?=
 =?utf-8?B?dlZYOHhTdnh2WDRycUNtL2VxSTV1T1YxenJiWXUwOGJ3djVNMkdzNkIzQ3NC?=
 =?utf-8?B?bG9rZ3hWZ2RzalJ1RVpWT0hhc1dHbmFXYzIwWTYzbVVXRXhBWDFhK1dBeXdY?=
 =?utf-8?B?eno1b2xuQVp1NzBDTGlXU1BaeXJMb1EvSGVQckNYQ0dmQlVxdStpalBUaVVH?=
 =?utf-8?B?NFlyeUUvRW9zRWMyWlN5N01GS1htVmVUK1M5elQ4NlZVZjNPZUowSTlBcUJm?=
 =?utf-8?B?WDFmUkc3WUFEbVdyRW1tcU8zQURqY2NuZU1aRlRXQnAvZldTVmJsRTIvZHk4?=
 =?utf-8?B?bEI0R3dZc0cwS0I5THBYWEswTTBFeHlJWVY3dEs2SEM4ODNHRWdmMXc4V1BP?=
 =?utf-8?B?MVFmZHdSVjQrdWljY25VaVgzUDF1N0xyNTVKbEdpS2QyWTVOM3NyUWEzWjFm?=
 =?utf-8?B?N3lzbzZuZ0RLZDRzd2w5ZjUzRGtRS3pJVmhkVkRCOWEvd3oyN2RLQStEL2xx?=
 =?utf-8?B?KzAwV0svTnIxL1B1eG9UYUVOSDBNYkxGS3pGWjAzQkVXS1FoSDd0V1dtczB2?=
 =?utf-8?B?STRDZERJK3d3TWo5OUc1VHllSk5VS1l2LytERFFxeC95QjFGMkZ6S3VWTjZx?=
 =?utf-8?B?TFkxakM2L3IvdGlEaXJ5L2RSU2RDSTdFVmF1TGd3YmQ5Mi85Qm5iQjVvV1Zo?=
 =?utf-8?B?NVdNWVF0ZG5WV2EyVzhxMHJtOXRrYnZWZGxZN2k5OWRHOTFGMmVEVlhzRitD?=
 =?utf-8?B?OEU1R1M3Yllab25SVlZwWUZhNGhlNmI2R1dTTGlqUTM0d3N1SG15OU5oTUhL?=
 =?utf-8?B?UTdWaFdLclIyTXcrcEYrSFFQU2JIZGY4SkdZNFRsbk5Ua1hSRngzVzd5M2E5?=
 =?utf-8?B?LzdKT0NIT0JUUFpnWC8wRngvMzhTZWNkajFxbUVnRHRWYkFYdkszQ24wcFZw?=
 =?utf-8?B?aTVvQ3dHZVNPREFIdzRCeTExZjIxMHZlTnNocE5Ic05hTUhqWmVraGVMWXp5?=
 =?utf-8?B?Z3N6VWRoL2puSzBVcU9nN1Vwbk15enM5NXlkU3V6RXhoU2lDajZqbVJFWlZU?=
 =?utf-8?B?YmR1Y1JyTU1IMGNRaWxpdklFSTFyN3pGYzM5YXFpZXVmMG9vUlFyL3NFejFl?=
 =?utf-8?B?aVk0LzFYQWl4M1MrS1ZlVG9QUWVvNFBuN21EYjVRV09wM0dtV2YvcldRVnNr?=
 =?utf-8?B?SEZBNm1OL25BOHFGdlNSMXRSZ1lJQjFWWmEyQkc5eEN2Q3BRWVRUcisxLzJN?=
 =?utf-8?B?YSs3REVFV1dkUVpNK0xNMGFIQ0E3ZUtaK3A2bHI1K29ZOUh6S0NRRDYvY2tl?=
 =?utf-8?B?TkF2NWVXYS9SckxjS2NmRzJxQnhSNE5XMjVHZkwyR0pSZ0htaTlsTHVPZTE0?=
 =?utf-8?B?MGJpU1RiaExrNmtQcFVhdTlNU0tUaHdaSnZIMnFTM3ZPQlZSQ3I3Yi9NWDRm?=
 =?utf-8?B?MC9ZWDB6anNnWXV5UVN3Ny9MTHNhTWMvU1pEUVFqc3liNVFPTThUN0lUcys5?=
 =?utf-8?B?UHU5MWtNWk5FdE5xNitaOUt3YUI2TzFEcDltUjBScEI4TUlVRGhQWnVFckZo?=
 =?utf-8?B?SFZ1TE5nZFpqUzhLbnZoUStUbTE1YTdsQTk4MEx2bWJGM1I0dWk1czdML3Ns?=
 =?utf-8?B?eWVSZXYzc2RwVnZNTytwdzVaVnQxT0lUWWYxdzdlbGtRNTdVM2FENXBxSHJV?=
 =?utf-8?B?SXlOVDBwNURWbndqZnRRaGlERUg3V05meWRXRFRXMVBVcm5Gd3Y1MDBrV3Rt?=
 =?utf-8?B?enovSVhROXU0eTNQYW53VFFqU1BwWmZ5cm9BclgxQkRYOCtvajFGbTdzc2kz?=
 =?utf-8?B?NDJTdVZTZ1ZtSTVzYlpLRzBScUcxcSs4Y29iem5lMlRiTG5XSVpoTVhYWDFW?=
 =?utf-8?Q?WPpli4m71D/x/6Ea00zjCmUiiXITa9pfE/sWU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97099E684D74464E90ACE4EB9298C57F@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f1200b9f-f8b6-4143-62e7-08de4caad244
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 22:36:08.8603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6FsQwmMI6P2jju5ydGedFdJUJ8ZQ5vODenVHTyvrSTroZQx83uqqfDUtAQWY59bIbaNtUHi+AZ2FCt4jz7mDJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4519
X-Authority-Analysis: v=2.4 cv=QbNrf8bv c=1 sm=1 tr=0 ts=695c3cdc cx=c_pps
 a=jsvbDz5nuWmKqroBXg8QBw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=znJ1jZvouhIw-VTGh_sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FmyxTRitQf5brKg6GKKhYOTrtk_StSrb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE5NCBTYWx0ZWRfXx0LAQ9cfktIR
 BxcB8GDUkspGpyRPYjDdI96CghS4cfKCuLTKmxYjo0jukV/E+M/YNJ2DwtIBKJfN0op4jcAPrih
 cR7zN2NPg9cCe3ThA0cq404Im1benpY8cgyToZTim1FQLIRbCuT7BdG6v0HxHK+d07hUJzZkjHa
 xbwEIe6EG7Bcd4dj0jN5h8hRqIQmRox9O7F0BUVvPkRLMG+V8xdYQ9yX0+MwYMrvdeoYax0FUWi
 dTIhSphYpZNrAT0gqcAQ9qFYDKeDkKnDOD1KKYXIGpAJTx/BuoM+OE6f4P/iZVTHUiBj7zkUWED
 vxqLsxIXuLM4u7XYxdgE20r7/MaTl+RMXrsiZeB3qrgOnlqpxAnUyK8I+YAr0KY3JJJE+S7FYx5
 pBRSXLZCLH8Nm/lxL/ejgRYXV2x1OFgmkb8l91BHtSGRSwE4ZrAdn9SIgozGxjjtzJv7qD/DNiw
 3toWYjGs/9vzyKzgVOg==
X-Proofpoint-GUID: lnyhwzfNIkof_1kDL4Dw_A-eAoAggzPD
Subject: RE: [PATCH] libceph: return the handler error from
 mon_handle_auth_done()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601050194

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDIzOjA5ICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6DQo+
IE9uIE1vbiwgSmFuIDUsIDIwMjYgYXQgODozN+KAr1BNIFZpYWNoZXNsYXYgRHViZXlrbyA8U2xh
dmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBXZWQsIDIwMjUtMTItMzEg
YXQgMTQ6NTggKzAxMDAsIElseWEgRHJ5b21vdiB3cm90ZToNCj4gPiA+IEN1cnJlbnRseSBhbnkg
ZXJyb3IgZnJvbSBjZXBoX2F1dGhfaGFuZGxlX3JlcGx5X2RvbmUoKSBpcyBwcm9wYWdhdGVkDQo+
ID4gPiB2aWEgZmluaXNoX2F1dGgoKSBidXQgaXNuJ3QgcmV0dXJuZWQgZnJvbSBtb25faGFuZGxl
X2F1dGhfZG9uZSgpLiAgVGhpcw0KPiA+ID4gcmVzdWx0cyBpbiBoaWdoZXIgbGF5ZXJzIGxlYXJu
aW5nIHRoYXQgKGRlc3BpdGUgdGhlIG1vbml0b3IgY29uc2lkZXJpbmcNCj4gPiA+IHVzIHRvIGJl
IHN1Y2Nlc3NmdWxseSBhdXRoZW50aWNhdGVkKSBzb21ldGhpbmcgd2VudCB3cm9uZyBpbiB0aGUN
Cj4gPiA+IGF1dGhlbnRpY2F0aW9uIHBoYXNlIGFuZCByZWFjdGluZyBhY2NvcmRpbmdseSwgYnV0
IG1zZ3IyIHN0aWxsIHRyeWluZw0KPiA+ID4gdG8gcHJvY2VlZCB3aXRoIGVzdGFibGlzaGluZyB0
aGUgc2Vzc2lvbiBpbiB0aGUgYmFja2dyb3VuZC4gIEluIHRoZQ0KPiA+ID4gY2FzZSBvZiBzZWN1
cmUgbW9kZSB0aGlzIGNhbiB0cmlnZ2VyIGEgV0FSTiBpbiBzZXR1cF9jcnlwdG8oKSBhbmQgbGF0
ZXINCj4gPiA+IGxlYWQgdG8gYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW5zaWRlIG9mIHBy
ZXBhcmVfYXV0aF9zaWduYXR1cmUoKS4NCj4gPiA+IA0KPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IElseWEgRHJ5b21vdiA8aWRyeW9tb3ZAZ21h
aWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgbmV0L2NlcGgvbW9uX2NsaWVudC5jIHwgMiArLQ0K
PiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+
ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NlcGgvbW9uX2NsaWVudC5jIGIvbmV0L2NlcGgv
bW9uX2NsaWVudC5jDQo+ID4gPiBpbmRleCBjMjI3ZWNlY2E5MjUuLmZhOGRkMmEyMGY3ZCAxMDA2
NDQNCj4gPiA+IC0tLSBhL25ldC9jZXBoL21vbl9jbGllbnQuYw0KPiA+ID4gKysrIGIvbmV0L2Nl
cGgvbW9uX2NsaWVudC5jDQo+ID4gPiBAQCAtMTQxNyw3ICsxNDE3LDcgQEAgc3RhdGljIGludCBt
b25faGFuZGxlX2F1dGhfZG9uZShzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24sDQo+ID4gPiAg
ICAgICBpZiAoIXJldCkNCj4gPiA+ICAgICAgICAgICAgICAgZmluaXNoX2h1bnRpbmcobW9uYyk7
DQo+ID4gPiAgICAgICBtdXRleF91bmxvY2soJm1vbmMtPm11dGV4KTsNCj4gPiA+IC0gICAgIHJl
dHVybiAwOw0KPiA+ID4gKyAgICAgcmV0dXJuIHJldDsNCj4gPiA+ICB9DQo+ID4gPiANCj4gPiA+
ICBzdGF0aWMgaW50IG1vbl9oYW5kbGVfYXV0aF9iYWRfbWV0aG9kKHN0cnVjdCBjZXBoX2Nvbm5l
Y3Rpb24gKmNvbiwNCj4gPiANCj4gPiBNYWtlcyBzZW5zZSB0byBtZS4gTG9va3MgZ29vZC4NCj4g
PiANCj4gPiBSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGli
bS5jb20+DQo+ID4gDQo+ID4gQXMgZmFyIGFzIEkgY2FuIHNlZSwgd2UgaGF2ZSB0aGUgc2FtZSBz
dHJhbmdlIGltcGxlbWVudGF0aW9uIHBhdHRlcm4gaW4NCj4gPiBtb25faGFuZGxlX2F1dGhfYmFk
X21ldGhvZCgpIFsxXToNCj4gPiANCj4gPiBzdGF0aWMgaW50IG1vbl9oYW5kbGVfYXV0aF9iYWRf
bWV0aG9kKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbiwNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGludCB1c2VkX3Byb3RvLCBpbnQgcmVzdWx0LA0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgaW50ICphbGxvd2VkX3By
b3RvcywgaW50IHByb3RvX2NudCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGNvbnN0IGludCAqYWxsb3dlZF9tb2RlcywgaW50IG1vZGVfY250KQ0KPiA+IHsNCj4g
PiAgICAgICAgIHN0cnVjdCBjZXBoX21vbl9jbGllbnQgKm1vbmMgPSBjb24tPnByaXZhdGU7DQo+
ID4gICAgICAgICBib29sIHdhc19hdXRoZWQ7DQo+ID4gDQo+ID4gICAgICAgICBtdXRleF9sb2Nr
KCZtb25jLT5tdXRleCk7DQo+ID4gICAgICAgICBXQVJOX09OKCFtb25jLT5odW50aW5nKTsNCj4g
PiAgICAgICAgIHdhc19hdXRoZWQgPSBjZXBoX2F1dGhfaXNfYXV0aGVudGljYXRlZChtb25jLT5h
dXRoKTsNCj4gPiAgICAgICAgIGNlcGhfYXV0aF9oYW5kbGVfYmFkX21ldGhvZChtb25jLT5hdXRo
LCB1c2VkX3Byb3RvLCByZXN1bHQsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgYWxsb3dlZF9wcm90b3MsIHByb3RvX2NudCwNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBhbGxvd2VkX21vZGVzLCBtb2RlX2NudCk7DQo+ID4gICAgICAgICBm
aW5pc2hfYXV0aChtb25jLCAtRUFDQ0VTLCB3YXNfYXV0aGVkKTsNCj4gPiAgICAgICAgIG11dGV4
X3VubG9jaygmbW9uYy0+bXV0ZXgpOw0KPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gfQ0KPiA+
IA0KPiA+IElmIHdlIGRvbid0IHJldHVybiBlcnJvciBjb2RlIGF0IGFsbCwgdGhlbiB3aHkgZGVj
bGFyYXRpb24gb2YgZnVuY3Rpb24gZXhwZWN0cw0KPiA+IG9mIGVycm9yIGNvZGUgcmV0dXJuaW5n
PyBTaG91bGQgd2UgZXhjaGFuZ2UgcmV0dXJuaW5nIGRhdGEgdHlwZSBvbiB2b2lkPw0KPiANCj4g
SGkgU2xhdmEsDQo+IA0KPiBtb25faGFuZGxlX2F1dGhfYmFkX21ldGhvZCgpIGltcGxlbWVudHMg
YSBtc2dyMiBjYWxsb3V0LCBqdXN0IGxpa2UNCj4gbW9uX2hhbmRsZV9hdXRoX2RvbmUoKSBkb2Vz
LiAgVGhlIGhhbmRsZXIgbWF5IG5lZWQgdG8gZS5nLiBhbGxvY2F0ZQ0KPiBtZW1vcnkgb3IgaW4g
Z2VuZXJhbCBkbyBhbnkgbnVtYmVyIG9mIHRoaW5ncyB0aGF0IGNvdWxkIGZhaWwsIHNvIHRoZQ0K
PiBpbnRlcmZhY2UgbXVzdCBwcm92aWRlIGEgd2F5IHRvIHNpZ25hbCBzdWNoIGZhaWx1cmVzIHRv
IHRoZSBtZXNzZW5nZXINCj4gdG8gZW5zdXJlIHRoYXQgaXQgZG9lc24ndCB0cnkgdG8gcHJvY2Vl
ZCBhbnkgZnVydGhlciB3aXRoIHRoZSBzZXNzaW9uLg0KPiBUaGVvcmV0aWNhbGx5IHRoZSByZXR1
cm4gdHlwZSBjb3VsZCBiZSBkb3duZ3JhZGVkIHRvIGJvb2wsIGJ1dA0KPiBkZWZpbml0ZWx5IG5v
dCB0byB2b2lkLg0KPiANCg0KTWF5YmUsIGRvIHdlIG5lZWQgdG8gYWRkIHRoZSBjb21tZW50IHRo
YXQgZXhwbGFpbmluZyBhbGwgb2YgdGhpcz8NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

