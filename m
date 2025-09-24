Return-Path: <ceph-devel+bounces-3725-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7ED9B9B7AE
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 20:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9F0719C2A58
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 18:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD4923957D;
	Wed, 24 Sep 2025 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BLDIpJG+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74371314B73
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758738430; cv=fail; b=vA9HatFH+aq7DBDbV9/LIGLC2013U0jy0+SIjx7s73aX7k+Fe/GkS5Ya2aLT1tyflrWjErOR/ZoI0sHyJtxGhjbIA9f7EAIHw/X9vZKWPgvWMvLbZNmJngdSuUgQC+TXkFsgiVmgDN0qcld9r2yVspao3K6xLMNx4HIC1XYzvMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758738430; c=relaxed/simple;
	bh=6K2Y2XtcpT77e2yKBHOxDM5rLNBVjMYpv4Oq542kbZY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=YyPHqLahfWbTk83Mq+yan+KEsekEW/f4+E0hPLFgFd4P6vmbqOTw5cFwF8e2CZq4Nu8xP81OqNTF54j6XWrDkHgHLWr2R1ASG6Dl02vCoBJMu+dT8oKyi23Z1nqskkjKR5yVoZZ0cSREWlnbu8WN0MRfX9OJ8aTzT4bEcgQTUlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BLDIpJG+; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OBedHv003988;
	Wed, 24 Sep 2025 18:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=6K2Y2XtcpT77e2yKBHOxDM5rLNBVjMYpv4Oq542kbZY=; b=BLDIpJG+
	mu3DRQAR1ftivHjs91kUY0fELoUNK6UHYJ6tcvray8Xn3/CcLNhBjy7j9pATlgYK
	MxXdz7R/yKPbd1lyBShzjxGsHN5Zn5mfMygh8WndcGxlmL+hIfe8dZk1/+u3mfny
	Yee7El2KQNiBMl9eIHbptJPfbRCNfnNegV+rPDQb5YlrrGkGzpESSptwZ7qhXtQR
	PvoXJGl598V1jELhCtAI1lxLn9ynZt0PoIr4giVCS88CSDY620ab27nmlpgEcrVF
	RS9RnT6Q5in+1wrk6lcfx+m+PwM9ot4HynW7StMjIEOaK8Lw41/WFaby+wG9Pfkm
	xArRsu1jRIdAPg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyrh2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:26:54 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58OIQs9G001954;
	Wed, 24 Sep 2025 18:26:54 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010033.outbound.protection.outlook.com [52.101.46.33])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyrh2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:26:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NWhlRniDNegQ12JkGnEFcy+SFxrV8s/9UlXtY97Iu2Kfll5Srk704UFNDvoFpzFMUFhlerVj4wcbvyL0O1FBHbNgrsF7bHCksKEYbhBJpF+0sR5mTQu916JtClDzyNB8A9l6iQaXs0qX3y5pvRKvFec7/t0I2yHUXHQ8UYOOeC3yh19g078/tcA8Wm54gtPxGQRWNNZLrlCWUMEF29xlSNIMptQzfz6UrI60JAa5UkZo5bwyZzEbV0J8GLnvr74FUsyNE3lwnlhwtp/mxRXoE7PFGCj3bzSd4WGFjBCjmscGVUS4WvztwEixmiTz2+6wO3lFCxxPf0BeOEkWcDBiaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K2Y2XtcpT77e2yKBHOxDM5rLNBVjMYpv4Oq542kbZY=;
 b=PhuZUgvgbLYN2sSYCtvEx2fHCYAhvF9W61j2Fi2VdhuLYGPIS6XcfNpkc9G4vw3dwyuk86ZVKmL5LxM9EJw/qW85CCZjVfsp+YXMRe9VyWF6iFEWWsuWddC3REa71udhcHhf0q6EV0KkIBphZ1sflYgr263iFE8gjbokSBOpH+Y3erSYNENETczOvnD/pW1sTzKHoI1yIqmwyvc0EDcBaPf8xRXlYjUr7GlDojhATCF2NJUEIR5/K0aTm+L9ZtBH3ATpqhLn4cQZAuGVyHZscbtOU86/TBPoscNej2PJ0tSzCqjYhCFf1ZZkgosVhvKvHooawkWMIgy7R8ku5Hg9Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4958.namprd15.prod.outlook.com (2603:10b6:510:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Wed, 24 Sep
 2025 18:26:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Wed, 24 Sep 2025
 18:26:51 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "ethan198912@gmail.com" <ethan198912@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "ethanwu@synology.com"
	<ethanwu@synology.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph: fix snapshot context missing in
 ceph_zero_partial_object
Thread-Index: AQHcLTnWa/U1cGgEC0uqy0ay6K4d7rSipyIA
Date: Wed, 24 Sep 2025 18:26:51 +0000
Message-ID: <396d9279317ff76f26eabf541281ff94fda5505d.camel@ibm.com>
References: <20250924095807.27471-1-ethanwu@synology.com>
	 <20250924095807.27471-2-ethanwu@synology.com>
In-Reply-To: <20250924095807.27471-2-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4958:EE_
x-ms-office365-filtering-correlation-id: 02e46aa5-3019-4ead-0b9c-08ddfb97ee62
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?aEZHNE1WZ3dRZ0h2SUpDcnhRd0piQUdHbVBNeFhTendWeUp5YmgvdmJJVjVj?=
 =?utf-8?B?SVBsaUZwa3lPS0RBSnRUUCtTelFpcVN4bDE3ZDRDVGpCM1YwWXV2Qmx5Q282?=
 =?utf-8?B?YnpKVUhsNTl0NjlBRTBRTm5XZCtOSmlQSTd4S3p4UFhlNzNGMHQvZVM1T0dm?=
 =?utf-8?B?MzFIUlJZNnpOL3c3OU9VT1NYajd1dHgxNkRYTDNWYXZNWCs5OW9aRXUreFZK?=
 =?utf-8?B?MUpjY0ZsK1FmbFRjUFR1L2JCU0FWY3hlaTB6d3lrRkozbStPQkljQituLzJV?=
 =?utf-8?B?TGlMVGo1OE1wOHRXejFHUkU5WTIvbUM0NUJXeEdyQUIzZmduUHpBZXc0cnl2?=
 =?utf-8?B?Y0FvZFB3dTBrSDZ2am40aGF4Ni9uRVN2ankvZ3FKL291a0RTbSs1WWtjdm9E?=
 =?utf-8?B?UWVPalhSZjA4enVsNjE3SmdULzlpOTBLUldhVDlSbHdLQmUvK1hsdzM3T1dW?=
 =?utf-8?B?SEdWc28zMm9EMlUrRExidXNGZTE5NWVLaVhKdHkzcTZmYXkrTzg3RHdoVXN3?=
 =?utf-8?B?dFN0Skp0RExYZ3UzZ243blptbUhVYnlFaTNVWDZieWdDZkthbmxwdVRuNVh0?=
 =?utf-8?B?R1Ziejk2ZDl1dlBTaXBXZTIrZmRwd05XcWM0Y2Q5b3RhOC9jRWR4cUVFTVVw?=
 =?utf-8?B?a2ZXY2dnY01MZ1FvS0VKV0lxWU1PZEZSR2lBWE4weGNmOVNiNnQ5cHVFdGdl?=
 =?utf-8?B?ODdEUU1IOXliRm5OTkw0WEVMMG43WHpmTzl0ZjU2RjZSNjBJb2ZhdE82NU5B?=
 =?utf-8?B?Sk5XMjZtL21mbFRDNzJlaFdCNmVzYTJhd2NPVFBldEVtUnl6YXJlQ09PdVpw?=
 =?utf-8?B?N2tZU0tIR3hFdW1DMEk1eWppa2E3dTkyWlhWbnB6TktxWmxWQkgzYTVwbzEr?=
 =?utf-8?B?b3ZiMERuUXBtVzhPTmJ3YXgvb0J6ZWxrTC9ZKzNtNnVQQnl2Q2RxNVVweTFV?=
 =?utf-8?B?YjNQVk9RZ2cwSGV2NnI4aFYyR2UvcVJJTzJkRkdxY2FZMEtJVnV2QWVTckxL?=
 =?utf-8?B?NXJUc2ZYK2lIUmMyWDIxeTY3eFBia0thQW5GM2pNWU42aHlxcnMwSlIwd2R6?=
 =?utf-8?B?U2lRUWYzTHErdzVxREpGRXIyVjk1MmNtTXVTNC9KRUc1cWdVV0VjWkxLNzJ2?=
 =?utf-8?B?ZU9RRmxmQ01VS0p6TTRtOXpyQ1N5RllRM2hNOXhVWit5T2NPOHlCMVdyb09Q?=
 =?utf-8?B?WG9FN3VtSmNHbG1kajBlN1lKOWhITTIvRWlJZ0lHNVVxaC95SlYvdUFlWmVK?=
 =?utf-8?B?N1Y3L2Y3V0RDZFFiWDF1aTJmTDJ3dXE1TjJ6UnFZUU5ab1JjSVpJc2g1dTg1?=
 =?utf-8?B?WWpzaDEzOXpESkM0ek1CY0pnMFpRcEpsb29HOHExSzFsOEtoVGQ2ZE0wb2hv?=
 =?utf-8?B?VjJDbGM1RmRLTDBScHhLM25EVWRMTWdzcWZFcjhiY1k3Y3lxaWNnUDRKQXox?=
 =?utf-8?B?SyszaG9HdzVzZTJ6YmNFTWd1b0lQS2d3YlFDODhrMG9nejJrWnJIQmJlVisy?=
 =?utf-8?B?d3czdGZ1WFNyQU8rblBPVWZvRUErZU5tcmlLZDRFVmpOMUczRFRhZGhCU3lz?=
 =?utf-8?B?ZzVTWFp4WDRRbDRSbXgyd3FVNi96c2tJWGtSSmtoWkVYMG1Vbk0xNmVqWjlt?=
 =?utf-8?B?YWo1WXFYbGw3dFdMUmJrbUdJZkQ5VW1rak82TEZrUWpUNDhFV1VKZHQ5Nk1U?=
 =?utf-8?B?L1FJeUk1a3MrdEFubjVnbmxQR1htd1k5MUkvS1p6NFRnby9WRmJ1U2xnR3dm?=
 =?utf-8?B?cnhqZnQvNW4vU3NzR3BySEFvOFExSzdicVpkVldQa2hKZ2QwY2JJdzE0akY5?=
 =?utf-8?B?anVKc09CcEoyRlBlQUVuQ2pUS3Nxb21ubHduZVVScjFUa3NJMXJ5UnpoeDRP?=
 =?utf-8?B?Z3ZOT3RydmJ1dmJuUFZWWEUwMGU5Z0dXUVdKV25XRzQxYW10a2F6ZXFna0NG?=
 =?utf-8?B?MWlVQU51S0d4VlhIbXQwVHREYWtXNDFnaW1xWGVVNytodyt5cmlXTUREbEV4?=
 =?utf-8?Q?4RLyZ0SVtUB9XOU72JtR2+p7w6LfxA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WWFidC9kK1hWU0JFZ2NMRVl2N1lRQVJBdldpVUo4VFdOdDF5RS9GeWh4TldF?=
 =?utf-8?B?aEE5RUZOM2hqejIwNy84MS83YlJJQTdBL2JXUTU3eStNdmMraldCOWM3Y3Fs?=
 =?utf-8?B?OFQ3QW9VODlCYnErMmpDcmRyaDBsbFpwZUFtRGtQcHovbkxBeVZ3Z0tId0ZJ?=
 =?utf-8?B?bHpyMzViYkVGdXFyRXNZSXF5MW1ML2pvKzE0ZHRidlRuUlljSVQ4RW9Tb0VN?=
 =?utf-8?B?Y2sxRTdvYllCVG9RNUduMDBjOU1SeTJWaGVkdnBnK3BNVEozZnFVaDhrSXQ4?=
 =?utf-8?B?cVFaZUZ3WUNKL1plUUI5bjd6TGtGY0xWMDZUZ2NFemsxS0VQS1ZJZkc1L0lK?=
 =?utf-8?B?bnNhNGNQMGc5ZlRMeGI1OWY3VXJUOUJQc1dnKzlKYjNZTlVuU0dUc3JWV2Uz?=
 =?utf-8?B?SG45R2djaHdDSS8veFFtVHlyTFN3YlZCNnpxbzVsTld1Ymg0WE9qaGMwcTRo?=
 =?utf-8?B?b00yaFBiL2c0RmdsYjdBWFZOVzRIV1I3SldwZlB0YW1IQU4wMDNqdm1seTgw?=
 =?utf-8?B?TXNRM3pEcG9EV3I2eUplb0tnK3JNbSsvZEc5c01uY1lzV3VNc05nYkdiSTRh?=
 =?utf-8?B?ZnBtRVFqNTdNZUE4THpmNG1HYjdCRmIyS2d0ejZiekRxRGtvdGRoc1N0Nlpz?=
 =?utf-8?B?aFdvWjNFeFo5TVdEb1JYb1NmZE82cDl5aFlPKzJsYjdURnkxb3pNT3RpWlBG?=
 =?utf-8?B?VEtBYUVZSnpBYlMyeEgxQ3R0bEp3MWJWb213YzJJV1Vmc2xLdVM0TVpHcm5k?=
 =?utf-8?B?bTB3YTlmcVllaTJWWGZ5T0x2UjZOS0xBMlpMMGpCTE9ldzF1QVJJZjhOZlZs?=
 =?utf-8?B?YXZ4cDFmN2lwYjdhRkc4T2NEVWxDQjVUN01KREx4QlFXTitMaTV4bjZaODBk?=
 =?utf-8?B?QzJ4Z01Udk5JRjFaMVBXTXl0UVJNTWhISmh4cnZPbFl2dVIxL3dEOUhJaXls?=
 =?utf-8?B?SDFwWHFqWjlJZ2tCSVovSFpySmdRb09PZTBlNlhETklnQTQzQmh2TGo1cXVO?=
 =?utf-8?B?cTRPem1RV1lSOGxRbGlVcXhrd2gxNWhGTkJ5aGlkeUV3bXBhZ3oyY0dNN3B4?=
 =?utf-8?B?MGdGOG1LSGpLb1Zha2UwVFBFZVF5dmh2cGROVnRPL3l2ZmFIR3llSVdtQ0No?=
 =?utf-8?B?SWVSSjNEbkpQN0JWckdkc2hhcTNDYTZiM3lHdWhEMTl4bDZYVGhzaEdQVlZW?=
 =?utf-8?B?Vks1QWRnZWREZWd2NVdGZTVXbmp2WldRMi81VXpzNEZReVF5eURvR21iQ2Jr?=
 =?utf-8?B?cG5rbXZYc2VnRUNlR2tiaGpUbjZ2NlV0aFRGK3RkNTNGZXJ5Z3MwOHhYaUVj?=
 =?utf-8?B?aE9kdFlRSU1nR3VETTZ6K0lzOTFFU1NCNXRTejdVR3lZbXYzSWU0N1I4R0l5?=
 =?utf-8?B?RFZNVURvMVVJRkZJU2FmMm85V0V6RVAyZGhLeS9oR2hsMjM3MHluNmhQRVM1?=
 =?utf-8?B?VXZvamZnS1QrM2gvdW83dnhKbkJyaFJ5WCt4ZzNYMTcwRHpmSnlPaTRkbXFH?=
 =?utf-8?B?TkVzb2VnZi9WMmdMNTZQRStNVGp2R2l0dVZiRVZucENxUHR0b3JTZXFIamR1?=
 =?utf-8?B?THN0MDFXRVhod3I2K0FZL0N1K2ljQXIvdGV0TFJucWtRZDRVWnQrVUYwOUdE?=
 =?utf-8?B?angrRFhBRm9qSUFLYnpnTTF0bHdEVG5WWkpObDRETkVWQlBjVUYxN1RFSm5a?=
 =?utf-8?B?NFdmWlVXVC84cTAxU1YvWEI0bUhET2JYcUVpWE42c1RCVWxaWkE5TTNlM01v?=
 =?utf-8?B?ZTY3cnBXWjJuTmZNKzg5Q0JYWndqRks0bmRzTDhhUm9nOGFScllQeFhMdWlj?=
 =?utf-8?B?ZCtWQ3hHY1ZYNnNJMW1DYk0xczEza3JjSkgyMFhsWVlRUGpYalY1Q3dNaXJv?=
 =?utf-8?B?UitjdE5PdEYrajQrNVAxRExRYU0vWGtDdTE3VXBDc0RZR2owRWxQdUM4R0xt?=
 =?utf-8?B?b0tKejdmZDhHNkYrakdBcGVQUjk4VXF3R3dNbEFNMW9lTzBlb0djbk93U3VV?=
 =?utf-8?B?ZHVHTkZJM1d6YitqMWhwYlVhZEhlNHZpdGQ0RlVEUXdWOW50S29iMTJIalVX?=
 =?utf-8?B?RER2cm41SWxhVFBLazRzRTkxa2VHdzlCSEgwWmczbW0rWXJZbHhQTWozVFhh?=
 =?utf-8?B?SGl1MzRyMHJyUkNxckVLY3JxVy9GV3lmUHovK2Rpa2t3by9EZ0oxUWVnekgw?=
 =?utf-8?Q?itXPmZQmYTMYV5VxeN/s6KM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C5DF60F4169C94E9AC8759F7CC48C68@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e46aa5-3019-4ead-0b9c-08ddfb97ee62
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 18:26:51.3970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dE+VtHtZGohNJJMwmiBANDJWsHYru5Rz39vbhIXJdgxd6cga47bw68MBHLUpwr6vVIAykZvdv1uRbDM5Na2Riw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4958
X-Authority-Analysis: v=2.4 cv=J5Cq7BnS c=1 sm=1 tr=0 ts=68d437ee cx=c_pps
 a=BmqlPTxv9Tigz04FbX2T4Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=LM7KSAFEAAAA:8 a=qbhD1xvcCa7mYHvVm84A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: tiDUFKGxqJq7TBPVY_SP1MoJr4yeiFUI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNSBTYWx0ZWRfX0VnrAP3XVCPa
 WDKluHUIWiR121mdMmPc6o03s3t9tVhx9Ja5ajKCTxcObjUBxv/1WHOw5X/Hjhv7adQbXY3ectY
 Tigyl3/4eh6pD/gljgjBkAN4LEwZeW/ieq80BcDaZM+Qfzub4siU1XR5nXVnKtM7E4hCA33CnbE
 oMDbClyTFBzfnyIHKu6IYs7Ofy+4FKSzIPNh7UvH/XSCWgy6pSFzuCYx9k8zgsMezbfGGBGWYEC
 rpNEfKsaILfJiYZwX9LZ7WpUueIqpTOgYnuCNMWYlQIQQ/6Hr7eqtmoJ7UGHcPcjO3WJWrafiAl
 eKAYf3G35qpuWPhGZVT8/KjzXRmYn8J0Sd/yyQjtow6/d0yXaHoLT4H4NYtME1PK1qA1Dn2TkpV
 oV86ly6+
X-Proofpoint-ORIG-GUID: y3Jb-EogtuXsuEQqGJsPRPBs5jozpuG4
Subject: Re:  [PATCH] ceph: fix snapshot context missing in
 ceph_zero_partial_object
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200015

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE3OjU4ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBUaGUg
Y2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0IGZ1bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFw
c2hvdA0KPiBjb250ZXh0IGZvciBpdHMgT1NEIHdyaXRlIG9wZXJhdGlvbnMsIHdoaWNoIGNvdWxk
IGxlYWQgdG8gZGF0YQ0KPiBpbmNvbnNpc3RlbmNpZXMgaW4gc25hcHNob3RzLg0KPiANCj4gUmVw
cm9kdWNlcjoNCj4gZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9tbnQvbXljZXBoZnMvZm9vIGJzPTY0
SyBjb3VudD0xDQo+IG1rZGlyIC9tbnQvbXljZXBoZnMvLnNuYXAvc25hcDENCj4gbWQ1c3VtIC9t
bnQvbXljZXBoZnMvLnNuYXAvc25hcDEvZm9vDQo+IGZhbGxvY2F0ZSAtcCAtbyAwIC1sIDQwOTYg
L21udC9teWNlcGhmcy9mb28NCj4gZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3AvY2FjaGVzDQo+
IG1kNXN1bSAvbW50L215Y2VwaGZzLy5zbmFwL3NuYXAxL2ZvbyAjIGdldCBkaWZmZXJlbnQgbWQ1
c3VtISENCj4gDQoNCkkgYXNzdW1lIHRoYXQgaXQncyBub3QgY29tcGxldGUgcmVwcm9kdWN0aW9u
IHJlY2lwZS4gSXQgbmVlZHMgdG8gZW5hYmxlIHRoZQ0Kc3VwcG9ydCBvZiBzbmFwc2hvdCBmZWF0
dXJlIGFzIHdlbGwuDQoNCj4gd2lsbCBnZXQgdGhlIHNhbWUNCj4gDQo+IEZpeGVzOiBhZDdhNjBk
ZTg4MmFjICgiY2VwaDogcHVuY2ggaG9sZSBzdXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogZXRo
YW53dSA8ZXRoYW53dUBzeW5vbG9neS5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9maWxlLmMgfCAx
NyArKysrKysrKysrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2ZpbGUuYyBiL2ZzL2Nl
cGgvZmlsZS5jDQo+IGluZGV4IGMwMmYxMDBmODU1Mi4uNThjYzJjYmFlOGJjIDEwMDY0NA0KPiAt
LS0gYS9mcy9jZXBoL2ZpbGUuYw0KPiArKysgYi9mcy9jZXBoL2ZpbGUuYw0KPiBAQCAtMjU3Miw2
ICsyNTcyLDcgQEAgc3RhdGljIGludCBjZXBoX3plcm9fcGFydGlhbF9vYmplY3Qoc3RydWN0IGlu
b2RlICppbm9kZSwNCj4gIAlzdHJ1Y3QgY2VwaF9pbm9kZV9pbmZvICpjaSA9IGNlcGhfaW5vZGUo
aW5vZGUpOw0KPiAgCXN0cnVjdCBjZXBoX2ZzX2NsaWVudCAqZnNjID0gY2VwaF9pbm9kZV90b19m
c19jbGllbnQoaW5vZGUpOw0KPiAgCXN0cnVjdCBjZXBoX29zZF9yZXF1ZXN0ICpyZXE7DQo+ICsJ
c3RydWN0IGNlcGhfc25hcF9jb250ZXh0ICpzbmFwYzsNCj4gIAlpbnQgcmV0ID0gMDsNCj4gIAls
b2ZmX3QgemVybyA9IDA7DQo+ICAJaW50IG9wOw0KPiBAQCAtMjU4NiwxMiArMjU4NywyNSBAQCBz
dGF0aWMgaW50IGNlcGhfemVyb19wYXJ0aWFsX29iamVjdChzdHJ1Y3QgaW5vZGUgKmlub2RlLA0K
DQpBcyBmYXIgYXMgSSBjYW4gc2VlLCB5b3UgYXJlIGNvdmVyaW5nIHRoZSB6ZXJvaW5nIGNhc2Uu
IEkgYXNzdW1lIHRoYXQgb3RoZXIgdHlwZQ0Kb2Ygb3BlcmF0aW9ucyAobGlrZSBtb2RpZnlpbmcg
dGhlIGZpbGUncyBjb250ZW50KSB3b3JrcyB3ZWxsLiBBbSBJIGNvcnJlY3Q/IEhhdmUNCnlvdSB0
ZXN0ZWQgdGhpcz8NCg0KV2UgZGVmaW5pdGVseSBoYXZlIG5vdCBlbm91Z2ggeGZzdGVzdHMgYW5k
IHVuaXQtdGVzdHMuIFdlIGhhdmVuJ3QgQ2VwaCBzcGVjaWZpYw0KdGVzdCBpbiB4ZnN0ZXN0cyBm
b3IgY292ZXJpbmcgc25hcHNob3RzIGZ1bmN0aW9uYWxpdHkuIEl0IHdpbGwgYmUgcmVhbGx5IGdy
ZWF0DQppZiBzb21lYm9keSBjYW4gd3JpdGUgdGhpcyB0ZXN0KHMpLiA6KQ0KDQpUaGFua3MsDQpT
bGF2YS4NCg0KPiAgCQlvcCA9IENFUEhfT1NEX09QX1pFUk87DQo+ICAJfQ0KPiAgDQo+ICsJc3Bp
bl9sb2NrKCZjaS0+aV9jZXBoX2xvY2spOw0KPiArCWlmIChfX2NlcGhfaGF2ZV9wZW5kaW5nX2Nh
cF9zbmFwKGNpKSkgew0KPiArCQlzdHJ1Y3QgY2VwaF9jYXBfc25hcCAqY2Fwc25hcCA9DQo+ICsJ
CQkJbGlzdF9sYXN0X2VudHJ5KCZjaS0+aV9jYXBfc25hcHMsDQo+ICsJCQkJCQlzdHJ1Y3QgY2Vw
aF9jYXBfc25hcCwNCj4gKwkJCQkJCWNpX2l0ZW0pOw0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3Nu
YXBfY29udGV4dChjYXBzbmFwLT5jb250ZXh0KTsNCj4gKwl9IGVsc2Ugew0KPiArCQlCVUdfT04o
IWNpLT5pX2hlYWRfc25hcGMpOw0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4dChj
aS0+aV9oZWFkX3NuYXBjKTsNCj4gKwl9DQo+ICsJc3Bpbl91bmxvY2soJmNpLT5pX2NlcGhfbG9j
ayk7DQo+ICsNCj4gIAlyZXEgPSBjZXBoX29zZGNfbmV3X3JlcXVlc3QoJmZzYy0+Y2xpZW50LT5v
c2RjLCAmY2ktPmlfbGF5b3V0LA0KPiAgCQkJCQljZXBoX3Zpbm8oaW5vZGUpLA0KPiAgCQkJCQlv
ZmZzZXQsIGxlbmd0aCwNCj4gIAkJCQkJMCwgMSwgb3AsDQo+ICAJCQkJCUNFUEhfT1NEX0ZMQUdf
V1JJVEUsDQo+IC0JCQkJCU5VTEwsIDAsIDAsIGZhbHNlKTsNCj4gKwkJCQkJc25hcGMsIDAsIDAs
IGZhbHNlKTsNCj4gIAlpZiAoSVNfRVJSKHJlcSkpIHsNCj4gIAkJcmV0ID0gUFRSX0VSUihyZXEp
Ow0KPiAgCQlnb3RvIG91dDsNCj4gQEAgLTI2MDUsNiArMjYxOSw3IEBAIHN0YXRpYyBpbnQgY2Vw
aF96ZXJvX3BhcnRpYWxfb2JqZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ICAJY2VwaF9vc2Rj
X3B1dF9yZXF1ZXN0KHJlcSk7DQo+ICANCj4gIG91dDoNCj4gKwljZXBoX3B1dF9zbmFwX2NvbnRl
eHQoc25hcGMpOw0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+ICANCg==

