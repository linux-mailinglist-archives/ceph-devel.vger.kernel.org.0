Return-Path: <ceph-devel+bounces-3505-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE4EB40F4A
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 23:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B38F3BFE08
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 21:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4022E9753;
	Tue,  2 Sep 2025 21:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KzB4avvl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3140227146A
	for <ceph-devel@vger.kernel.org>; Tue,  2 Sep 2025 21:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756848084; cv=fail; b=t1t/g3pkdxVGIIvPWMzD+B/w3lJS1RwhirJrGTU6SZvaOS8XjX4tJbCQOtKlS9q+d5S1u5G3A7BLsquepv5lxspesjMgnYpxIDI1TP3cFDh65LOMndlOJIoN9HIrVwZs3TCSlnevZHgkfgN1WO/Kyt2Ti3MtYV1OzkEq6zOXibM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756848084; c=relaxed/simple;
	bh=uiU8Kj/IJ+LjrpAEhzxGd+7LXzR9JDYznHgxOCDhCmQ=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=gUw3EfwcvPXljq72NcweRNhEoHBKeHxMNAwUiYBuIolq2bGbBUZ665DX250zLrZkqH5nVkohxs4UdSW+VLEZ3ycibUSx5LLG+6nepO9xC9CC+oeYducTaWbxy69k6yg7a4DfNxR3ajW/zeSFJWTmpYxBJi92vnwzfn6s6DtRSnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KzB4avvl; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582CVMrx027660
	for <ceph-devel@vger.kernel.org>; Tue, 2 Sep 2025 21:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=uiU8Kj/IJ+LjrpAEhzxGd+7LXzR9JDYznHgxOCDhCmQ=; b=KzB4avvl
	h2KnBFj3zNs6d4nzVll+lgEkvNXDERCjPmvU76zLrGvDYk0i9+ymui3qAtHd6pVL
	a5UaH6XAOqnzAD4iWx5q7Oio39fNfONaaQfZj9m9w7B2gNu3TmWhVEHewTjWACj+
	oQQd5I2JpLWM4nhZr6+aVMa8Lrhgw2ng546qxaNvTaHqBxqHFZPG466R1ckHqQVG
	PSYjJQp6uNYq021YO3UTkN4J/Ih1dxIFOScDGhbxxRhQ/aqvUosIPvwMZJMbS/LJ
	LTMZCddnurcODhD5He/yyasTGKNTxtYfdJptTHHnygOE7bnEF3cX8kXLrn/2zN4W
	fBX+NfQFsknklA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usvfrhb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 21:21:21 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 582LK2fn002257;
	Tue, 2 Sep 2025 21:21:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usvfrhb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 21:21:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMJqaTsu+fuHX/Rl81SqzPRUEzjSBzACZ4kMe5IzYrk19Q+s4QDp8711v7tA3ZtimmH7nqDUr2XsLvRLcMjG31RSWn2iGepEDo8/DZ+H0lpZdxSktGRlJM+oxcVI91lzy32mhae8SLGpcpf7k8iB/RKboi87M9hQ4N5sP0v6pOKutyziJnUM0PXeIzVG+191P7NlpYW2MBYtriuGBXQBrBUarjF9WfzgvR2uayE8keXMJnxdzYCH4+PGbjxqU6wgcSPH/qltdwKznaZbGai0LUTjL2qF+MzCDvJt6qEuFcmoClQtLTJhTe8fi9U8SP58ApFslhJ0xZuOf2b4W7V5XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsBjjg+2Dol2N1Jocg0rS+gdnHdiMCDWzF6qoTNjptk=;
 b=fJjYHCTkJKKm+tvsv6bjbyKXNlzHTkvxFCj+H6A4BfhZiOGlj4cKJ1JfgSGDpNrhoz32xbkkIbX9QlXOCOAp66SOyayzGPZDToKqflVKRx2k5i559aq1qhpbu8kxYgSkYj05YZAe+kAsO2VDwbW+YJ3RCVNBFXSkBkRWFp8g3d49c2YwnUxEsoDYJd1AwuUQWm8bQ2y4oeM5e5+5XLMc9AyCp4sOTbVArqYD8WlN2NIvukUhet36cqecNSuNmwARdZbYp1vkoUsQv9PQArbypSQyXDgql0rBaaapr/EUlYB3k661qZjoKirlXCktxzBvGVG4UBPC8xHvMqX7gl8Rpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by PH0PR15MB4335.namprd15.prod.outlook.com (2603:10b6:510:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Tue, 2 Sep
 2025 21:21:14 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611%4]) with mapi id 15.20.9052.027; Tue, 2 Sep 2025
 21:21:14 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>,
        "visitorckw@gmail.com" <visitorckw@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: optimize ceph_base64_encode() with
 block processing
Thread-Index: AQHcHE1qR1FElGksrEesyv2NMLoHjbSAZmmA
Date: Tue, 2 Sep 2025 21:21:14 +0000
Message-ID: <f4f33ae461e0f1cf2f28d1c22546bd67cd9c4da3.camel@ibm.com>
References: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
	 <fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>
	 <aLdcNhKrPXxaEUtm@visitorckw-System-Product-Name>
In-Reply-To: <aLdcNhKrPXxaEUtm@visitorckw-System-Product-Name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|PH0PR15MB4335:EE_
x-ms-office365-filtering-correlation-id: f9de6ce6-82eb-4109-717a-08ddea66a5cf
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aWJ5Wi8xTlVsSDcxbzFIY0tSeWY3ZXl4eENSNXo1d3JGQS9zTWIwaklNYlds?=
 =?utf-8?B?cVl6Z3VMdURuQ1VZSXlxbmt1Q0lEeEg3dUU5Z0RwZ1psbWg3MVNHK0h0MTV6?=
 =?utf-8?B?b0VjT0RsL2pncjdWaVlQODArUXkzTFV1cmZaSElXMGJ2NzF4T2JJK0I5d1VT?=
 =?utf-8?B?c0ZOSkxjTWJ4eFR4b3RwSXdmcVRtRDI5cVVtTzR5dDlsb2oySkZaaW00VlYx?=
 =?utf-8?B?amZwM3ZNdUR4VWdwUkErTG1OTlR1Q2pxN3lQRTNuWW1OQWIvbFc2bXZEYnFj?=
 =?utf-8?B?UXhzNEFmT0ZxdnhETUhsVDRDSVdleElqVFhvMjRCQTFPSjVsWVdsZ2M1c1Vl?=
 =?utf-8?B?Rm9uTVVUMjd6T3Vjc2tKZUE5TWRyWXJlc012T1VIQkhvRDQxNzhGSy83WXVq?=
 =?utf-8?B?czZRMjdRZ0h1Ty9YazRWaFdxV2hwUmpJVHdNNWg1MjcvTGJZUEhhSWVHR2RR?=
 =?utf-8?B?VG1WVDM1djNvQmhnUjV4MHBtRWVtR29KM2tGMHhLSDNxdEVMTkFZVUZhdmlw?=
 =?utf-8?B?bHZQL0FvNzFSeFNuSkpySXdYT1plM0hKS3FCU1duSHA0bG1yMHRScHhJdUJ0?=
 =?utf-8?B?ZWFmTDRWWU1mc096VEdIQW5oL0JsRjkyd0ZLSEljL2l0aUpoa29xb1p0Q2ZX?=
 =?utf-8?B?QkNKdnRPNVZwTWkyWGRIak5sKzZnTzR2L3hzTm44QkR4OVFYSVE1NHU2Ymw4?=
 =?utf-8?B?alNXQldqemIrdTdINldWZTcyVTZDNG9uelFFTU5FaHVrRzlGeFpSQ2YrUTkr?=
 =?utf-8?B?ZEdzVmg2aXc4Z091a202MmVZWTk2QUlkejF3MGxFOGpzQVIwSVNZR2g5ek1I?=
 =?utf-8?B?UCt3VGZVZGphRzUrM0x2SGkyRUpWcEtDN3Awb0IvOFRnRjFYODBlZUt2ay85?=
 =?utf-8?B?MGIvd3NZQjhJdUVGeFB2Z0NabEF4SC9YWE9nRlM0c0k5aXFDZ0lNSUI2bkRG?=
 =?utf-8?B?Y2lmd0tCQ3JvR3R0QzFnRW1RR1FzSjBMdVRzb2xXdmRzMGxZWlMyRWMzTzBj?=
 =?utf-8?B?dURwc2pXbnhvaEdlWDRKY1hOcU1hZVl5Ti84eHFlWjdsZUFRaXRVWGtTRTF3?=
 =?utf-8?B?bkV0SE1sbmQxQkR0amZlNW9rNitKbG5TbVJLOWxvL0pHVnovM3J0eDFVQmxI?=
 =?utf-8?B?M1NNR21tK1d0VVB2N2tBOStheEdnanh5ZUIzOVZneEkvZi9EMHp0RFk5ZzZH?=
 =?utf-8?B?SGFMMzZDSVdxRkczdTd1dE50bHErejBRZ3dPMXFjUjFuempiNDlFaVRoblIv?=
 =?utf-8?B?SitvdWorejVnZlMzM1NwTy9qbm1ndkVjQ0pXR2I5QWtsVDZsa3VMdHZvcHNh?=
 =?utf-8?B?dlJsblFISms3VUxQc1ptZ3BTMHp1STZwOHFQUVZwb0JsMCsyK2JkQzNHKzZk?=
 =?utf-8?B?ME1HWUFuUFNRaVFCdmVJSVRIaElsTEVKWDZydVJTTUhEM2twVEtGOGVDT05l?=
 =?utf-8?B?VkhRNS8yaTRHdzk0ZjVUdzlmL0tFekg0Rm8rcmpHeEtwNmdldzVhSkhOQTlJ?=
 =?utf-8?B?RVE5UkpqYld0Q2EzUVAyejUrZ21CdktlNXg0ZXExc1pLYTYwaEdLWVhzdEwx?=
 =?utf-8?B?dU5yUXo1YVFNU3VhaVQxN09JSUZhcm1kaEVtdlpCQ2FDcFVxQ3REV0pLTjdW?=
 =?utf-8?B?aWFCMmV0UzhleFlEUXplbDBQSGNLSXgwZWZYNVBvYklLVzJ6MCtTYjhWbWdB?=
 =?utf-8?B?K2pPVEtabGRjK2o5M0JiQkNyY294VThUNlcrRUZsTlNydlUyVW5QcmpETUh6?=
 =?utf-8?B?Tll2UERSOE01VXpqeGhOZEJmMk8wNkNSQm1URFpXNThGQTh1UUM4SnZmSHh0?=
 =?utf-8?B?dy9CU3VQbUgydTlNa3A2alZ6aC9PWVliMXBEUXhRR2VjMDNUYlBET0xCVXdy?=
 =?utf-8?B?b0dETmYzUnY1L1FRUXo5T3Q3anc2L2g3UmZFU0JKVXR5eld6RDZFTHJ2NDJj?=
 =?utf-8?Q?+7ygE68GrwI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eXc3VjVJZmVUYThxSUw4V042MmduM3BDa0dVcElUV2EzOERJaTZzM2JTL3lo?=
 =?utf-8?B?U3A2S3luREtmNk9qaVNWTTFHQ0t1VEd5MUVGcS9od3JsK0tCMWlVTjdXTlJL?=
 =?utf-8?B?MVp4WkdQSXZIWTV6RU44NTg3MnJvaGp2MU5IbGdIdnhXcENBd1NLbjJEdzFR?=
 =?utf-8?B?SUZMVkJaaEoxRnY5cjFaQ3ZGWkRqQ3JFSWlqeGdYSmJtT1pnZ2NrVjlzUWZm?=
 =?utf-8?B?d01PaVdzTmhCeEVsVytWTTZVSzEzRGdHd3VGSC81WWlEaTRqY0xyeHd1RTh6?=
 =?utf-8?B?Qy9hbTNHNEpDMDB3SmNBVlVWMVU0SDZYZ0ZMWmorN2JDS2F5M21lcHhhUW14?=
 =?utf-8?B?bjZJZWFTYlU4N3ZEWGhYV3dIcExqbjJLUGhVY2NzcjR6YzdWaUNFL2tTMlFj?=
 =?utf-8?B?c1lwN0NMaW92ZWQ2WHRzdjRRdUhVVXVmTGNUT1FZQy93ZDRRVkFzRWd6OHly?=
 =?utf-8?B?ZDZ6NTZjNC9EeDJROHM5bW82RzMySWQzUUhob1VrTk8wejd4ZSsvZkdUSFJI?=
 =?utf-8?B?Q1FDRnBUY0RTbUFzUDlod0ZLZUJzTnBQa01zNiszUnVVTUtzRWpLUWtSaW1F?=
 =?utf-8?B?aitGdEpRT3BrelFkWGx2RmFPNSttMHZmaitKa010WVZoZFFyOTZHMTZEN0tB?=
 =?utf-8?B?c3ZhOGp4L3ROYmtYc1BPeFdYU3kvak9EMHRiK2l1SVk5ZXFuZCtEdkRKSHAz?=
 =?utf-8?B?V1F5SDRBSlJXb1V4eWhoUm56MkJqUWdzcUdoTk1Ra1IxQUZHWkV3QjdZVncy?=
 =?utf-8?B?V2FWcVZpUkI5RzhvcGpISkFtb01ucEVTYlh1ZDdiOXVWUkRlbUxTYm85SGE4?=
 =?utf-8?B?YTJja0lGc2QxVUZwdFlFbUNSZXI3M241ME55OHROWlc0Tk8xUWE2R0NmR01y?=
 =?utf-8?B?QXBIdVgzTGgzSjM3anJHUWFTSDAzblo4Q01nTmlkU2hSRDBmR1A1N1FNTDFk?=
 =?utf-8?B?ZjlHUHdPS3RZUzl3bExydE42TTNTVVAwbTQ1QTJpNUhVSzZFZEkwa1RHa0dK?=
 =?utf-8?B?MTl6Yk53bFQrYi9wNEthNU55b2ZFbjFucHFSUEdMNTRxckxsMFAwcHQyR0RO?=
 =?utf-8?B?L3E1bUVsRFo1cHB5ekMwOElUNHZtVmFKMHZuY3I1RHExbkNiQlpEYURPMFJj?=
 =?utf-8?B?Q2ZqWkp2VWJ2YThqYXFoL0dSNFlJWkdLaTNZKzdKVlFGekRlK1c4Y2RUZnpo?=
 =?utf-8?B?SDVKTWdva1NaOWR3dWZBdmZyN2tlTU8yUVl4NWRkWHExTTNjTDAyVzE4a21P?=
 =?utf-8?B?RWpiUDFmWXlUenlEQTRnRWNidUkwd0s4TDYyVU1XcmVCaDlqbnZ1UUFQM0JU?=
 =?utf-8?B?enlKTWFqZ2FMQVljcWk1RE9TTTlNdTdtSE9DK3FWM0liUEJqUzFWK0F1VHF4?=
 =?utf-8?B?bjV6azFyOVZldVN5b0l0aHJULzB2bTUyakJLL3BqVXNxTERUUkJ6WEowQk5X?=
 =?utf-8?B?WDVvUlRKaTlMYzN5QlBJN0hHZWNEK2ZwbG85Z0hlREVoMGEvcGZuTXM4ZlNp?=
 =?utf-8?B?dGYrVGc3aklpcXl5cUkzV3owRmMyNGwwTEdoRUY0dE0xUTBmRUxFUll5MmVM?=
 =?utf-8?B?RmE4aFNxMzhLeUZEd0g1cHUveTlZTzMzV3FFUDVQclcrZUFISXhieENPSXph?=
 =?utf-8?B?Mk93QkJLa01GeXdCd09vRytLVjRHUXd5Q3FjQ0doaStZcW1NSzJIclR0S3Jj?=
 =?utf-8?B?Rld0eEZ6S21tc255QU1RMFNPMWx5KzZIclpnRHFtbUtZL0NtZ25LVmlzY1Jh?=
 =?utf-8?B?SmhTR2dXVlZaM0tRMW02NlBJN2RPTkwzbHM4WVpGSnprSWs2QktMb29hU09m?=
 =?utf-8?B?aW4wNGRoNnMwUVZ1b0t6czBBMUpxWlE0bXJKUEo1dzVMMzhwR2pSQmVtWit2?=
 =?utf-8?B?SzB5N0FsbTljMThNajlEZ042T0lTNS9SSnJGaUlBZHRoaWplK2RkS0ZjcG1E?=
 =?utf-8?B?MWZJalREVUxza2FVV2tJZHduUXBXM3pyQVk4enY5NVZGU2N1bUwvZWNkOC9U?=
 =?utf-8?B?L29QK1lHZVZDUFJZckllZmRQdExPSzI2QTY1aEpMYWNBbUlHbm8vS1Y1ODRB?=
 =?utf-8?B?QmZ6YVIwT2xYcVFLTTJhYmVSc0VVN3B6Vi94QU8veW13ckE0YlFJLzRENFBq?=
 =?utf-8?B?MUJyYVpmR0ZtZHh1L3ZkWVIveFBkRnNSVFBuUlozeW1MVWh5ME9yekxmQ2ZO?=
 =?utf-8?Q?zH3qur3HKNjIqSvcXpBQS3c=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR15MB5821.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9de6ce6-82eb-4109-717a-08ddea66a5cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 21:21:14.4973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vu3vh527pKBKw2P/WpJiwnNBLJHkhXRaVoAsSPue0/wnxNvN8CB4bSit1agyeFbone/oDYXOzlYr1OdyJ0vDXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4335
X-Authority-Analysis: v=2.4 cv=behrUPPB c=1 sm=1 tr=0 ts=68b75fd1 cx=c_pps
 a=3HMnoyM0ZnVJ7rqtKH+Jgw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=Ixu9KHHVPGgUguxH0DgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nfm_bmpjstvJg4_2nvJ5QUDqzkzS7coi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX0qwJsL8EZ2Aq
 j93lCUZU5eL9F0dQfpKdyTw1GIvKp9cpNj+/ejE8TH6Tn3NFsWkhJIpH/FxLp9VcsV5Y4vHK2mM
 MHbi1hT4tZXxJ8Ml3xlNPuzMJh5N2vFE/qjwxoUE9lQbAoyZqzVCapCfiU99vz3+wXtgojp3ivU
 dOf0Z2RK9aMDCtzJUXRiltmWrciQoZ2W9k1duz0EGrWSHXnSKaovLqs3e31+6waDDhibs+TR0MB
 FTK4hinWkjaIAX2CIFeqWFXZR0yP8wtt8bp/y+7xLMI9obIPkUu4dD2XBPQWgBkDBct76YDbQGS
 6V2R6grPcZPwiHK2bJZ9P/WWVyMNa7pRMmEsX2t31ie/M50oJQMpfL4GqyoDyCjRRGwUhm+H0Im
 g3/U54M9
X-Proofpoint-GUID: dKvOKGtPbGq0hhAAaF6mId-nn7vQ8Btj
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8CB28036868124DA19EFC75F1DA4F03@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH] ceph: optimize ceph_base64_encode() with block processing
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_08,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034

On Wed, 2025-09-03 at 05:05 +0800, Kuan-Wei Chiu wrote:
> On Tue, Sep 02, 2025 at 07:37:22PM +0000, Viacheslav Dubeyko wrote:
> > On Sat, 2025-08-30 at 21:28 +0800, Guan-Chun Wu wrote:
> > > Previously, ceph_base64_encode() used a bitstream approach, handling =
one
> > > input byte at a time and performing extra bit operations. While corre=
ct,
> > > this method was suboptimal.
> > >=20
> >=20
> > Sounds interesting!
> >=20
> > Is ceph_base64_decode() efficient then?
> > Do we have something in crypto library of Linux kernel? Maybe we can use
> > something efficient enough from there?
> >=20
> Hi Viacheslav,
>=20
> FYI, we already have base64 encode/decode implementations in
> lib/base64.c. As discussed in another thread [1], I think we can put
> the optimized version there and have users switch to call the library
> functions.
>=20
> [1]: https://lore.kernel.org/lkml/38753d95-8503-4b72-9590-cb129aa49a41@t-=
8ch.de/ =20
>=20
>=20

Sounds great! Generalized version of this algorithm is much better than
supporting some implementation in Ceph code.

Thanks,
Slava.

