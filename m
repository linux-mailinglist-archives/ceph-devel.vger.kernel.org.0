Return-Path: <ceph-devel+bounces-3444-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71596B252F8
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Aug 2025 20:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72B425A7CDA
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Aug 2025 18:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249D42D8766;
	Wed, 13 Aug 2025 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pGeEFjYm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF991303CBD
	for <ceph-devel@vger.kernel.org>; Wed, 13 Aug 2025 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755109361; cv=fail; b=NJO3NWeRgZizNycpC7FtTzjRwV48hjoQgUVnNW6DagGqc88HdoTfhlRjs0NsMelABk4GfEkZorPjUM+KR+IU8IAb/cuKDH4OZyp+5efug0mFufssBrP9S5VcB0oeym9PCse5kiOu4wYbK2xyV4h7YfzfA2aYwx39GnNJW0gROTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755109361; c=relaxed/simple;
	bh=oqAwyGPK/xQnl93bFUPKivQP3R528rfdOhBOxL/L4qE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=hSYleuuMvmjVCmyVpo/NlCp8GcfdJgNTDIVAiu7yzSiI9deOgci+XpLGzgXJvDenUlbLZs3MA8gPxEzI44A1LR8LM/xhO49Ir+9b0G+RT1F2thso0QyB8oIFgV+XoL79qtJlya29JHzYwYtEDXE/F6vYzxDlviN//0HTCCUE8Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pGeEFjYm; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DC2bs2016022
	for <ceph-devel@vger.kernel.org>; Wed, 13 Aug 2025 18:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ern+0GkTXBjo8mjSKxCK3ENbpBTz9wWeFcXwuSloNCU=; b=pGeEFjYm
	I97uCrRnJky/b/znD6zVWeuGNxuIPfNLm/48cHLb7fEoYUclBYllxb4hvh203G5j
	mL54O9qZtaqdFBGhjeMqhJLqwutinZpnxDiwHfYcLS14m3gdeAhUF5GBBzolPN7Z
	J/zXlMVkh/F1DZ7NhZs4ZJMbblIBJ/Gyja3iUEBu9lseIoFC3hBMoKTiHI9dXQ+q
	b9p8VRli18iLJc8vJB/mP5zHPe0xEy2/+XJ1rvllZfxmPy/Yj8fEqpVzSrDzUHni
	2sIY3fhOePjvBUIevnk//lY6wv9IDRFZYXD+L+vWAmV3eY2XYo90sbHZY8PJlyfV
	deBt1I2K0eE94w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14p3vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Wed, 13 Aug 2025 18:22:38 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57DIMboG024167
	for <ceph-devel@vger.kernel.org>; Wed, 13 Aug 2025 18:22:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14p3vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 18:22:37 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57DILexq022592;
	Wed, 13 Aug 2025 18:22:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14p3vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 18:22:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbn0coZcke0kOonQUB1BN7gqUkfYzDVr4E6oJbMIvsKHjjbrGNLADf48bTrkWBXLV7hZpkj30whRBAggY1/2z3K08r7Yx7IzLUZcWUZ+4ea4MwSwJWDxGCxFgHpsmBANKt92xgmYD02Y6AtFsnRCK0iYNK4e/8jTbjSNziK9c+MmmpovTewKVn2WctnTIvQ//jhp9VZlEnJKo9GP5y1u+BCbPFDLM/gj72aGhe8taFQ+Xl4/Hm/m5XY6TJlpeTpsdiAzw9We/z3RgFHqUEQ09RbtZF+KOeH81tlxiKg0t/OnwBfNV4WGQ3MruOfQ3ytGchp7xx/aat2WyiSvlkvnBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBo/7Qa6wad77Defv+R+4emf066sVmnCChxOUfrSv2M=;
 b=GAYGbosvy1Z/qOlA64oHLYtpOHRlpSxMMNB4e6c6vPCrJl1WJPMtEY1V588pYa30dwgQNKOE6QFLEqkjyV7m8XXsxoKlL6r8MZaaodRkLIzENApXO6sMl/wz9iNJuRHwJYg+pEHg1nreSX/2hFDA1BCNtRZg5b1BMiyTSbPPfJRuFMivPnKgxS8bmfzL+PXpYKCg9k4mFuu+DqsLfwRa9hkriR5wgCpH8M0PQoQSgCWdW9VWoWB3mJBh3tPTq1mCUglvtuju0eswOjAD8UAjXnezdddRv5GDf+LB9nVpyeN3MqozyMR0iyDkv9Yd11AMjfXMNm/B3fvAATWeDCZR6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CO1PR15MB5018.namprd15.prod.outlook.com (2603:10b6:303:e9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Wed, 13 Aug
 2025 18:22:32 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Wed, 13 Aug 2025
 18:22:30 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<amarkuze@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Venky Shankar
	<vshankar@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix multifs mds auth caps issue
Thread-Index:
 AQHcAwnX8VFv10r3BUWfP7rTtDMVw7RON+EAgAchUwCACKxSAIAAxVaAgAC0VYCAAMJ0AIAAtrwA
Date: Wed, 13 Aug 2025 18:22:30 +0000
Message-ID: <ae92e8a5cf730e997d031adb5e1708f17975e8a9.camel@ibm.com>
References: <20250729170240.118794-1-khiremat@redhat.com>
	 <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
	 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
	 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com>
	 <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
	 <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com>
	 <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
	 <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com>
	 <CAPgWtC5EVzdWZbF3NgntHaT03fiqH=NM-HTUPunE6GeJD1QPSw@mail.gmail.com>
In-Reply-To:
 <CAPgWtC5EVzdWZbF3NgntHaT03fiqH=NM-HTUPunE6GeJD1QPSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CO1PR15MB5018:EE_
x-ms-office365-filtering-correlation-id: 8b8b9b8b-21fc-4e31-e210-08ddda965da0
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UzMvbXpyTnBnZjFWY1J1bEhGa2Q2YjVoRmdJb1VrTGZzTEZNOEdpeHloVlkz?=
 =?utf-8?B?Y3plc3czT2tCYUNtTXdwbXk2dWF3QmkwRWI4WmVtb0piYjJicGJEdFNCT3pt?=
 =?utf-8?B?Nkpsa09NRFRDMnRLVGhONTNSL1NTM0Q5RHhXdHh4QnNQeG80eEs4N2w5Qkh4?=
 =?utf-8?B?ZFZIYXlZME8zekdXay8vcVdSQ2h0Tnl3WDBGdzd3a0gvbytKT1ZYVGxUZnRS?=
 =?utf-8?B?SVdMNHVyQzZvVlU1MHBCcFZVTGk2UXhnK095TFUyNEpGb1hiYXREdy9Eb2pR?=
 =?utf-8?B?YlcxQUJTUnFLRWpkTFp3SWM4elNPV3l6VHVNZkcvc0ZtaWdCRklGWER3a1d1?=
 =?utf-8?B?U1VVejEreVBSTzBLRlhwNmE0OWx6RzlrUTBOUnhTcDUyTEt3VHdmS2txeExU?=
 =?utf-8?B?UW1Oa3Y4TXBya0xSOGRlTURReTY1ZzZwUG5sOGxoN0pPRzZoOEhqWk5WMFMr?=
 =?utf-8?B?WmtMZlplQkV0KzM1U0wxYW1QMk95RjNHVXBIZStBWlhORXhnbzZpTEt4Y3N1?=
 =?utf-8?B?Ump4R3RBTDZyRU51eG9XZzNuMVB5UE9OUS9pelNrSlJVSm5Ua3VUdk83Snow?=
 =?utf-8?B?RHJTd043UEdMMEpHdVhrQkhKL3Y4bUhQY0xzcEI3L2JNREpFdGlRSFAzVFcv?=
 =?utf-8?B?QXczbEJWY2h6Q1NwKzdYS2hTcjN0Y0t5RFdndlV3VGg2WjVjRHg2YmU0ZVJ1?=
 =?utf-8?B?UkZlOFlGVmFTUHl0SmdOK0xIaSsxbG9nTGwxMXBEVXZDckZnOHpzYkRrdlNM?=
 =?utf-8?B?MjFYNDE2MzVqd3UxYmhwaXg4VjNuajFzeDJEMkIyVm5mTEU0QWhENHQ4UjRs?=
 =?utf-8?B?QUt2YVAza2xpRzdlM2VZamZDVEZnQ2MrVnhMZitEcWxHcVFwQkR2NEh6Rmln?=
 =?utf-8?B?TXl0V2tlOXhVSEMxZ04vUzdldFhrdU5XTWtqa0FtdkwwU3hWYVNKWUk3TzhQ?=
 =?utf-8?B?MnlGV0NId0psR09sK0xKWVRPMHltUUt2d25SdCtOYTUwSFhWV3c5MjREM21T?=
 =?utf-8?B?YWIwbEhHRHREenRXSFlDTXBacVZHdHdXTmpDRnRUUDIwQWdXMkxQUFdhUTNs?=
 =?utf-8?B?N2xvbWY5M0s2RjNqb29ETncySi9lWXM0blpvUS9rV3p0WmVJUGFXN2FzRTRz?=
 =?utf-8?B?S01TUEVXZDRBT2dmU3h1WTBTbHhEYm5rL04vZEhPR3hHZmgrUVFhNytJVHJN?=
 =?utf-8?B?Y2tySmdnMTllUDg1SGRXUitnSGdXRUNpV1JjYmdRMldzWlNvU2NMTkRIeGxi?=
 =?utf-8?B?S2JCNW9CZGV3bGRtTy9Cc3RMbmdGVXd2YXRwdEhyT0syQTRVSFVuYUZSU1J1?=
 =?utf-8?B?OUF3NTlPbnRGQTRMdlI1TTFxdXVpQjNsWEI3Z2dQSE1VT29XNk1wdDljOTZs?=
 =?utf-8?B?cDNZcTNCbkpuenBLNHljTUl2T3gwWmRXMW9zWi8xVDJRYk9SQktDemFvVFJm?=
 =?utf-8?B?U2lVTXRjanB1Z1N1RUVaUUZvSDkrLzlvMWtmNTMzM296RDlGbmFNdU9lVWtk?=
 =?utf-8?B?UEs0dkpyOXA1b28rY0ZIaWtmNWRjODU1YmZWdGlrT2hjdHBmSUJMYm8xaVlD?=
 =?utf-8?B?VmNBK1c0cVNYVWtIWVBjcEdnWHp3N1NhZ1FNV3B1MnpTQ0cxbExiZ3pMWXho?=
 =?utf-8?B?WllSZk1jRFByd3R6N1BXL1RWTXF4VGNQRnNEZVNRaEZtcFpBaEU3ZEc0RXR3?=
 =?utf-8?B?OUVneFNyUWN1Z2FGZVl2bmFEWnBGamNjMGtTNkFNV1RacDM4UlNiZUlGOTdY?=
 =?utf-8?B?NlNMcTA5dWI2Z3BGclBlOGJGSjIyY2o3TndJZmFIc1c4TEdWMFIyYkdiSCtO?=
 =?utf-8?B?QzMwKzRlNncwTHN1SVFnQzFjdWZlV0Y4ZEJLTnVkcmkram5kYjBLZFFoRVQv?=
 =?utf-8?B?QVpCRGJ6aVFzQXpsWkkxNTJ5YytLOWxwQStsOGRINURrL2xzYlduWVZlRnRx?=
 =?utf-8?Q?W5vRFKkLVWA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cC9jcTRUWWdidnFBcktRSkRNaWxJQ1R3SStuSTlZN0crMkJpVUVocUprTlJU?=
 =?utf-8?B?WWdoaUdHZ2hOY012Qm15dHoyQzdtUU83QzBuU0Q4SWRxV1NqdFdYUE9SeFVV?=
 =?utf-8?B?TW1BbGZxQ2c5Mm1RQlZTeDljWWp6cEE2cUtyaEFIdnY2Qkh1YlJ3bE1CeDV2?=
 =?utf-8?B?UW9sYkF5c0xNVnF0Nkt2R2VldXk3VGdKMS9QRldrRlBWOW9uZXNodmp6M2or?=
 =?utf-8?B?ZVFiMXEwdjRTS20xWi9wS0Y0aDNFNzNDamNLRWg2ZmF5WWV1LzU1MXU5QlMv?=
 =?utf-8?B?aHA3ZEhuN2VkV05DYUpDdTExK2wwc0Q5Q3RJNVRFRUNJZjVJUzY5ZjY4OWZp?=
 =?utf-8?B?bTJUVkt4c0RDejVlTVB0YnJCZVRPSEJ5NkhEdHBXOVlrZzExeEZxRno4dEZ4?=
 =?utf-8?B?Ym9SMGpjSEd0VjRYalEwSXdhZ2pCeGY5aXphaG9qcDc3ZHdrM1dKZFBxWkZl?=
 =?utf-8?B?N3Y2MjJ4bGpMTUQvVGtTY2NPbjVVV0h6bDVyZy83U0NtQTJCd2twU1E5cjJR?=
 =?utf-8?B?TTNnSXJsYVhRa2d0UDNKSEg5aDcyczNjS1I2MzBVdHhLMTZoRlEwLzExaDRY?=
 =?utf-8?B?VjRoWFVaRC9SQW44S3pYK3FVKzFTSmhqdG1NdFRITi9nSGNKVU5CZlRwVWJr?=
 =?utf-8?B?MlYrM3RwcmlKWjVMWjRCVGgwRmlHelJUNVo0S0JlTkNMNVB4a2dHZWh0Njgy?=
 =?utf-8?B?Z1lDNnZQWFV4YTJhQnNqQVY4MTZoUUFhbWRxdDR3TVFkUXNncmJ4VGxKdExw?=
 =?utf-8?B?NER5RjZLcUJRc1pQa2xVaEtPdXBpQ0RaM1IvK1pLbHpRMll6UFBJVFd6eU90?=
 =?utf-8?B?UDVDTllFMFova2gxMlh6ck14N3ljSi9wcllWeGllQWlZVVFaL2JrN1dHUDhw?=
 =?utf-8?B?MS82bENtV09uS2xQU1N6WWcwMzhBc3M1UGZrenFJK1lUb3F2bmNkdmlzUUhF?=
 =?utf-8?B?RXN6WG9ia1pkR29HdiszZktIZWs5THdNeExZeWMrd1pBalhaRDRubWVhMEN6?=
 =?utf-8?B?MEdrZ2xUMER1SzVrYllzdk9MNy9JZ2QzTkFzaFBiTFZJajFUV3dqVmpxL2RD?=
 =?utf-8?B?TlFkakV4NEpWdmpzcUhFYzYveWZ5aGFCNjVPdnlhRVYrWmhTWmVsL1d5bWRX?=
 =?utf-8?B?TFV5UVkxaXRXYTBBL08zaGpGVzhabHJrVldPT1VhTDQ4VkJHc2swcnFUc01k?=
 =?utf-8?B?UTJzWHhEUWxxaENrMkhJQ3dOQnMwWWVVRU5Oc2IrUGs1OWc3dWNsQUYyYzhl?=
 =?utf-8?B?ZzdhT1doYmpMc05xUit0Y3dqS01zaU5vLzMySVJrMEsrVGQvN0ZTTXpiK1B3?=
 =?utf-8?B?WjZZdmU1VUFaak5qUncxaFk4VnlocjgrWFdPNjhybHY0Rkw1T3V6dlpWZkQ1?=
 =?utf-8?B?Sk5NbUlFeC9PTmI1ZXdoVEJhenkvNGtPdFphRFBuelE3NHB4UTQwL3VWK3FN?=
 =?utf-8?B?Z0NkbnpYTFI3OUtndzNOaENnaWw1RUVJSDk3THVGNm5aZkpCUUlBRUhWR2dt?=
 =?utf-8?B?S20vRzcxNkdGWndqamVKelk4ZE94Z2htcnM3WndUenNvS3FvbHdnQ3l4YzdX?=
 =?utf-8?B?ZEhhd2tGR1BpdDMyTHl6aTZPenpjS3VwZFY1SjMxRXBMQ1V1dFVSK2w1eC9G?=
 =?utf-8?B?OXYwNGs5RmJvTDJ2Y2w3T29IMFAzUUliM2dWSG9LMXJaYm01MDYyT1JENTE4?=
 =?utf-8?B?OUdPbnZuNGZWcFliMDRKbElCU0RHVC9FUUtLMExWbC9idzlzZXkrSFJJMEZh?=
 =?utf-8?B?bUtTcVo3TTh3Z3VFL0h3SHJla2xYRk1pSmxDWUhtdVdwU2hMTHI0Q2JUN1Q5?=
 =?utf-8?B?TmR0NmxuSzh5M3MwL3QzVEg5dTZOU3RKRGl2NVpFWFBFUDhLVkNHa3p3QUNu?=
 =?utf-8?B?NFl5SnpHY0crQitSNEVoZDA0Ky9vWTlVSE9YbWx6Y0tWY3NPVXprMVlWSjk2?=
 =?utf-8?B?OW1Belg4cWJicjFCbEVFcFZhMXdjNDJLUiswUDZrekRSMEtmUnIzNnBNYnVo?=
 =?utf-8?B?Z3NBM21sbWVCNXNSY3VmbFNWeXdsd3BUNmRQa2JHdGRlUm9ySmNoM3FCRTBv?=
 =?utf-8?B?VXRhbStlaTQ4Vy9xdlByejN4aFVGVGNXblNXVFhTOENRZENIUENzajlUVDZv?=
 =?utf-8?B?UUJ5L2FIYlQ2N2daZ25aRlV4dHAvNzFsaVlnYVozQkY2NU1NS2diTEtPam1i?=
 =?utf-8?Q?xK/vbFihsv3Zpc7rs+LvoJA=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8b9b8b-21fc-4e31-e210-08ddda965da0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 18:22:30.7020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zjv+jAkyhRjx81ih6RwYditpeiv9HAS4rmUM1HFRFDOG6GTxI+XwwlI736hkyNP5MDHnY7Zb4hVXkXuBxFsigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB5018
X-Proofpoint-GUID: eyTHunuA88Kb0sFZYRgI6xp64nb1OCHH
X-Proofpoint-ORIG-GUID: 66C0JEqWd0SWoGAcikXIjEy1mRTOCVRT
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=689cd7ed cx=c_pps
 a=jk4H/tjlHtWDEjmWbm1DKw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=P-IC7800AAAA:8 a=NEAV23lmAAAA:8 a=4u6H09k7AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=Le2Qe1d1-suiBEO0VzAA:9 a=QEXdDO2ut3YA:10
 a=d3PnA9EDa4IxuAV0gXij:22 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX9l6CeYDgFEpG
 7G5/MlCIgP++a1vkF20re/BCOtYO9fC0j3hXoRzCHMr5maFyQFzTgL/XFF/hmxg5SeALP/n1HiQ
 CssmSRYQLlHqfYAd4x8X5+Mvmvq/8906Q1tO8KQ+Zd482JFrweiHhHTAQ8cLwY1a1j9a16ICGde
 bMgoSid6t3kGKfhDy8IDJeZ3AERugHluE8GYpT6ceo2bluyuA5Qerbpb1g9pc5bDJXQdcTBNnd4
 3NO9KSii7td9MDw8l+jv7/1aenl1fXlv068LYCgVSb8A6ReIr5/uVLz4qTwEGXhfK/o5Fb6Qbhv
 Tr8tzvKpIVhpehy87hafJXHYT44eZGRj90QtR6aXxGuPY+Z2YvdrmOO7mJ/FQnrL4p23xB2mcYn
 UkCxC97P
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E067E51E2E2EB4E8A808282ED85DC7F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=2
 engine=8.19.0-2507300000 definitions=main-2508120224

On Wed, 2025-08-13 at 12:58 +0530, Kotresh Hiremath Ravishankar wrote:
> On Wed, Aug 13, 2025 at 1:22=E2=80=AFAM Viacheslav Dubeyko
> <Slava.Dubeyko@ibm.com> wrote:
> >=20
> > On Tue, 2025-08-12 at 14:37 +0530, Kotresh Hiremath Ravishankar wrote:
> > > On Tue, Aug 12, 2025 at 2:50=E2=80=AFAM Viacheslav Dubeyko
> > > <Slava.Dubeyko@ibm.com> wrote:
> > > >=20
> > > > On Wed, 2025-08-06 at 14:23 +0530, Kotresh Hiremath Ravishankar wro=
te:
> > > > > On Sat, Aug 2, 2025 at 1:=E2=80=8A31 AM Viacheslav Dubeyko <Slava=
.=E2=80=8ADubeyko@=E2=80=8Aibm.=E2=80=8Acom> wrote: > > On Fri, 2025-08-01 =
at 22:=E2=80=8A59 +0530, Kotresh Hiremath Ravishankar wrote: > > > > Hi, > =
> > > 1. I will modify the commit message
> > > > >=20
> > > > > On Sat, Aug 2, 2025 at 1:31=E2=80=AFAM Viacheslav Dubeyko <Slava.=
Dubeyko@ibm.com> wrote:
> > > > > >=20
> > > > > > On Fri, 2025-08-01 at 22:59 +0530, Kotresh Hiremath Ravishankar=
 wrote:
> > > > > > >=20
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > 1. I will modify the commit message to clearly explain the is=
sue in the next revision.
> > > > > > > 2. The maximum possible length for the fsname is not defined =
in mds side. I didn't find any restriction imposed on the length. So we nee=
d to live with it.
> > > > > >=20
> > > > > > We have two constants in Linux kernel [1]:
> > > > > >=20
> > > > > > #define NAME_MAX         255    /* # chars in a file name */
> > > > > > #define PATH_MAX        4096    /* # chars in a path name inclu=
ding nul */
> > > > > >=20
> > > > > > I don't think that fsname can be bigger than PATH_MAX.
> > > > >=20
> > > > > As I had mentioned earlier, the CephFS server side code is not re=
stricting the filesystem name
> > > > > during creation. I validated the creation of a filesystem name wi=
th a length of 5000.
> > > > > Please try the following.
> > > > >=20
> > > > > [kotresh@fedora build]$ alpha_str=3D$(< /dev/urandom tr -dc 'a-zA=
-Z' | head -c 5000)
> > > > > [kotresh@fedora build]$ ceph fs new $alpha_str cephfs_data cephfs=
_metadata
> > > > > [kotresh@fedora build]$ bin/ceph fs ls
> > > > >=20
> > > > > So restricting the fsname length in the kclient would likely caus=
e issues. If we need to enforce the limitation, I think, it should be done =
at server side first and it=E2=80=99s a separate effort.
> > > > >=20
> > > >=20
> > > > I am not sure that Linux kernel is capable to digest any name bigge=
r than
> > > > NAME_MAX. Are you sure that we can pass xfstests with filesystem na=
me bigger
> > > > than NAME_MAX? Another point here that we can put buffer with name =
inline
> > > > into struct ceph_mdsmap if the name cannot be bigger than NAME_MAX,=
 for example.
> > > > In this case we don't need to allocate fs_name memory for every
> > > > ceph_mdsmap_decode() call.
> > >=20
> > > Well, I haven't tried xfstests with a filesystem name bigger than
> > > NAME_MAX. But I did try mounting a ceph filesystem name bigger than
> > > NAME_MAX and it works.
> > > But mounting a ceph filesystem name bigger than PATH_MAX didn't work.
> > > Note that the creation of a ceph filesystem name bigger than PATH_MAX
> > > works and
> > > mounting with the same using fuse client works as well.
> > >=20
> >=20
> > The mount operation creates only root folder. So, probably, kernel can =
survive
> > by creating root folder if filesystem name fits into PATH_MAX. However,=
 if we
> > will try to create another folders and files in the root folder, then p=
ath
> > becomes bigger and bigger. And I think that total path name length shou=
ld be
> > lesser than PATH_MAX. So, I could say that it is much safer to assume t=
hat
> > filesystem name should fit into NAME_MAX.
>=20
> I didn't spend time root causing this issue. But logically, it makes
> sense to fit the NAME_MAX to adhere to PATH_MAX.
> But where does the filesystem name get used as a path component
> internally so that it affects functionality ? I can think of
> /etc/fstab and /proc/mounts, but can that affect functionality ?
>=20

Usually, file systems haven't file system name. :) The volume could be
identified by UUID (128 bytes) that, usually, stored in the superblock. So,
CephFS could be slightly special if it adds file system name into path for =
file
system operations.

But I cannot imagine anyone that needs to create a Ceph filesystem with name
bigger than NAME_MAX in length. :)

I had hope that file system name is used by CephFS kernel client internally=
 and
never involved into path operations. If we have some issues here, then we n=
eed
to take a deeper look.

> >=20
> > > I was going through ceph kernel client code, historically, the
> > > filesystem name is stored as a char pointer. The filesystem name from
> > > mount options is stored
> > > into 'struct ceph_mount_options' in 'ceph_parse_new_source' and the
> > > same is used to compare against the fsmap received from the mds in
> > > 'ceph_mdsc_handle_fsmap'
> > >=20
> > > struct ceph_mount_options {
> > >     ...
> > >     char *mds_namespace;  /* default NULL */
> > >     ...
> > > };
> > >=20
> >=20
> > There is no historical traditions here. :) It is only question of effic=
iency. If
> > we know the limit of name, then it could be more efficient to have stat=
ic name
> > buffer embedded into the structure instead of dynamic memory allocation.
> > Because, we allocate memory for frequently accessed objects from kmem_c=
ache or
> > memory_pool. And allocating memory from SLUB allocator could be not only
> > inefficient but the allocation request could fail if the system is unde=
r memory
> > pressure.
>=20
> Yes, absolutely correctness and efficiency is what matters. On the
> correctness part,
> there are multiple questions/points to be considered.
>=20
> 1. What happens to existing filesystems whose name length is greater
> than NAME_MAX ?

As I mentioned, usually, file systems haven't file system name.

> 2. We should restrict creation of filesystem names greater than NAME_MAX =
length.
> 3. We should also enforce the same on fuse clients.
> 4. We should do it in all the places in the kernel code where the
> fsname is stored and used.
>=20
> Thinking on the above lines, enforcing fs name length limitation
> should be a separate
> effort and is outside the scope of this patch is my opinion.
>=20
>=20

I had two points from the beginning of the discussion: (1) consider to use
inline buffer for file system name, (2) struct ceph_mdsmap is not proper pl=
ace
for file system name.

OK. I agree that restriction creation of filesystem names greater than NAME=
_MAX
length should be considered as independent task.

So, if we are receiving filesystem name as mount command's option, then I t=
hink
we need to consider another structure(s) for fs_name and we can store it du=
ring
mount phase. Potentially, we can consider struct ceph_fs_client [1], struct
ceph_mount_options [2], or struct ceph_client [3]. But I think that struct
ceph_mount_options looks like a more proper place. What do you think?

Thanks,
Slava.

[1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/super.h#L120
[2] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/super.h#L80
[3]
https://elixir.bootlin.com/linux/v6.16/source/include/linux/ceph/libceph.h#=
L115

>=20
> >=20
> > > I am not sure what's the right approach to choose here. In kclient,
> > > assuming ceph fsname not to be bigger than PATH_MAX seems to be safe
> > > as the kclient today is
> > > not able to mount the ceph fsname bigger than PATH_MAX. I also
> > > observed that the kclient failed to mount the ceph fsname with length
> > > little less than
> > > PATH_MAX (4090). So it's breaking somewhere with the entire path
> > > component being considered. Anyway, I will open the discussion to
> > > everyone here.
> > > If we are restricting the max fsname length, we need to restrict it
> > > while creating it in my opinion and fix it across the project both in
> > > kclient fuse.
> > >=20
> > >=20
> >=20
> > I could say that it is much safer to assume that filesystem name should=
 fit into
> > NAME_MAX.
> >=20
> >=20
> > Thanks,
> > Slava.
> >=20
> > > >=20
> > > > > >=20
> > > > > > > 3. I will fix up doutc in the next revision.
> > > > > > > 4. The fs_name is part of the mdsmap in the server side [1]. =
The kernel client decodes only necessary fields from the mdsmap sent by the=
 server. Until now, the fs_name
> > > > > > >     was not being decoded, as part of this fix, it's required=
 and being decoded.
> > > > > > >=20
> > > > > >=20
> > > > > > Correct me if I am wrong. I can create a Ceph cluster with seve=
ral MDS servers.
> > > > > > In this cluster, I can create multiple file system volumes. And=
 every file
> > > > > > system volume will have some name (fs_name). So, if we store fs=
_name into
> > > > > > mdsmap, then which name do we imply here? Do we imply cluster n=
ame as fs_name or
> > > > > > name of particular file system volume?
> > > > >=20
> > > > > In CephFS, we mainly deal with two maps MDSMap[1] and FSMap[2]. T=
he MDSMap represents
> > > > > the state for a particular single filesystem. So the =E2=80=98fs_=
name=E2=80=99 in the MDSMap points to a file system
> > > > > name that the MDSMap represents. Each filesystem will have a dist=
inct MDSMap. The FSMap was
> > > > > introduced to support multiple filesystems in the cluster. The FS=
Map holds all the filesystems in the
> > > > > cluster using the MDSMap of each file system. The clients subscri=
be to these maps. So when kclient
> > > > > is receiving a mdsmap, it=E2=80=99s corresponding to the filesyst=
em it=E2=80=99s dealing with.
> > > > >=20
> > > >=20
> > > > So, it's sounds to me that MDS keeps multiple MDSMaps for multiple =
file systems.
> > > > And kernel side receives only MDSMap for operations. The FSMap is k=
ept on MDS
> > > > side and kernel never receives it. Am I right here?
> > >=20
> > > No, not really. The kclient decodes the FSMap as well. The fsname and
> > > monitor ip are passed in the mount command, the kclient
> > > contacts the monitor and receives the list of the file systems in the
> > > cluster via FSMap. The passed fsname from the
> > > mount command is compared against the list of file systems in the
> > > FSMap decoded. If the fsname is found, it fetches
> > > the fscid and requests the corresponding mdsmap from the respective
> > > mds using fscid.
> > >=20
> > > >=20
> > > > Thanks,
> > > > Slava.
> > > >=20
> > > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h =20
> > > > > [2] https://github.com/ceph/ceph/blob/main/src/mds/FSMap.h =20
> > > > >=20
> > > > > Thanks,
> > > > > Kotresh H R
> > > > >=20
> > > > > >=20
> > > > > > Thanks,
> > > > > > Slava.
> > > > > >=20
> > > > > > >=20
> > > > > > >=20
> > > > > >=20
> > > > > > [1]
> > > > > > https://elixir.bootlin.com/linux/v6.16/source/include/uapi/linu=
x/limits.h#L12 =20
> > > > > >=20
> > > > > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h#L=
596 =20
> > > > > > >=20
> > > > > > > On Tue, Jul 29, 2025 at 11:57=E2=80=AFPM Viacheslav Dubeyko <=
Slava.Dubeyko@ibm.com> wrote:
> > > > > > > > On Tue, 2025-07-29 at 22:32 +0530, khiremat@redhat.com wrot=
e:
> > > > > > > > > From: Kotresh HR <khiremat@redhat.com>
> > > > > > > > >=20
> > > > > > > > > The mds auth caps check should also validate the
> > > > > > > > > fsname along with the associated caps. Not doing
> > > > > > > > > so would result in applying the mds auth caps of
> > > > > > > > > one fs on to the other fs in a multifs ceph cluster.
> > > > > > > > > The patch fixes the same.
> > > > > > > > >=20
> > > > > > > > > Steps to Reproduce (on vstart cluster):
> > > > > > > > > 1. Create two file systems in a cluster, say 'a' and 'b'
> > > > > > > > > 2. ceph fs authorize a client.usr / r
> > > > > > > > > 3. ceph fs authorize b client.usr / rw
> > > > > > > > > 4. ceph auth get client.usr >> ./keyring
> > > > > > > > > 5. sudo bin/mount.ceph usr@.a=3D/ /kmnt_a_usr/
> > > > > > > > > 6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
> > > > > > > > > 7. sudo bin/mount.ceph admin@.a=3D/ /kmnt_a_admin
> > > > > > > > > 8. echo "data" > /kmnt_a_admin/admin_file1
> > > > > > > > > 9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED)
> > > > > > > > >=20
> > > > > > > >=20
> > > > > > > > I think we are missing to explain here which problem or
> > > > > > > > symptoms will see the user that has this issue. I assume th=
at
> > > > > > > > this will be seen as the issue reproduction:
> > > > > > > >=20
> > > > > > > > With client_3 which has only 1 filesystem in caps is workin=
g as expected
> > > > > > > > mkdir /mnt/client_3/test_3
> > > > > > > > mkdir: cannot create directory =E2=80=98/mnt/client_3/test_=
3=E2=80=99: Permission denied
> > > > > > > >=20
> > > > > > > > Am I correct here?
> > > > > > > >=20
> > > > > > > > > URL: https://tracker.ceph.com/issues/72167 =20
> > > > > > > > > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > > > > > > > > ---
> > > > > > > > >   fs/ceph/mds_client.c | 10 ++++++++++
> > > > > > > > >   fs/ceph/mdsmap.c     | 11 ++++++++++-
> > > > > > > > >   fs/ceph/mdsmap.h     |  1 +
> > > > > > > > >   3 files changed, 21 insertions(+), 1 deletion(-)
> > > > > > > > >=20
> > > > > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > > > > index 9eed6d73a508..ba91f3360ff6 100644
> > > > > > > > > --- a/fs/ceph/mds_client.c
> > > > > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > > > > @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(st=
ruct ceph_mds_client *mdsc,
> > > > > > > > >        u32 caller_uid =3D from_kuid(&init_user_ns, cred->=
fsuid);
> > > > > > > > >        u32 caller_gid =3D from_kgid(&init_user_ns, cred->=
fsgid);
> > > > > > > > >        struct ceph_client *cl =3D mdsc->fsc->client;
> > > > > > > > > +     const char *fs_name =3D mdsc->mdsmap->fs_name;
> > > > > > > > >        const char *spath =3D mdsc->fsc->mount_options->se=
rver_path;
> > > > > > > > >        bool gid_matched =3D false;
> > > > > > > > >        u32 gid, tlen, len;
> > > > > > > > >        int i, j;
> > > > > > > > >=20
> > > > > > > > > +     if (auth->match.fs_name && strcmp(auth->match.fs_na=
me, fs_name)) {
> > > > > > > >=20
> > > > > > > > Should we consider to use strncmp() here?
> > > > > > > > We should have the limitation of maximum possible name leng=
th.
> > > > > > > >=20
> > > > > > > > > +             doutc(cl, "fsname check failed fs_name=3D%s=
  match.fs_name=3D%s\n",
> > > > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > > > > +             return 0;
> > > > > > > > > +     } else {
> > > > > > > > > +             doutc(cl, "fsname check passed fs_name=3D%s=
  match.fs_name=3D%s\n",
> > > > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > > >=20
> > > > > > > > I assume that we could call the doutc with auth->match.fs_n=
ame =3D=3D NULL. So, I am
> > > > > > > > expecting to have a crash here.
> > > > > > > >=20
> > > > > > > > > +     }
> > > > > > > > > +
> > > > > > > > >        doutc(cl, "match.uid %lld\n", auth->match.uid);
> > > > > > > > >        if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> > > > > > > > >                if (auth->match.uid !=3D caller_uid)
> > > > > > > > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > > > > > > > index 8109aba66e02..f1431ba0b33e 100644
> > > > > > > > > --- a/fs/ceph/mdsmap.c
> > > > > > > > > +++ b/fs/ceph/mdsmap.c
> > > > > > > > > @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_deco=
de(struct ceph_mds_client *mdsc, void **p,
> > > > > > > > >                /* enabled */
> > > > > > > > >                ceph_decode_8_safe(p, end, m->m_enabled, b=
ad_ext);
> > > > > > > > >                /* fs_name */
> > > > > > > > > -             ceph_decode_skip_string(p, end, bad_ext);
> > > > > > > > > +             m->fs_name =3D ceph_extract_encoded_string(=
p, end, NULL, GFP_NOFS);
> > > > > > > > > +             if (IS_ERR(m->fs_name)) {
> > > > > > > > > +                     err =3D PTR_ERR(m->fs_name);
> > > > > > > > > +                     m->fs_name =3D NULL;
> > > > > > > > > +                     if (err =3D=3D -ENOMEM)
> > > > > > > > > +                             goto out_err;
> > > > > > > > > +                     else
> > > > > > > > > +                             goto bad;
> > > > > > > > > +             }
> > > > > > > > >        }
> > > > > > > > >        /* damaged */
> > > > > > > > >        if (mdsmap_ev >=3D 9) {
> > > > > > > > > @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_=
mdsmap *m)
> > > > > > > > >                kfree(m->m_info);
> > > > > > > > >        }
> > > > > > > > >        kfree(m->m_data_pg_pools);
> > > > > > > > > +     kfree(m->fs_name);
> > > > > > > > >        kfree(m);
> > > > > > > > >   }
> > > > > > > > >=20
> > > > > > > > > diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> > > > > > > > > index 1f2171dd01bf..acb0a2a3627a 100644
> > > > > > > > > --- a/fs/ceph/mdsmap.h
> > > > > > > > > +++ b/fs/ceph/mdsmap.h
> > > > > > > > > @@ -45,6 +45,7 @@ struct ceph_mdsmap {
> > > > > > > > >        bool m_enabled;
> > > > > > > > >        bool m_damaged;
> > > > > > > > >        int m_num_laggy;
> > > > > > > > > +     char *fs_name;
> > > > > > > >=20
> > > > > > > > The ceph_mdsmap structure describes servers in the mds clus=
ter [1].
> > > > > > > > Semantically, I don't see any relation of fs_name with this=
 structure.
> > > > > > > > As a result, I don't see the point to keep this pointer in =
this structure.
> > > > > > > > Why the fs_name has been placed in this structure?
> > > > > > > >=20
> > > > > > > > Thanks,
> > > > > > > > Slava.
> > > > > > > >=20
> > > > > > > > >   };
> > > > > > > > >=20
> > > > > > > > >   static inline struct ceph_entity_addr *
> > > > > > > >=20
> > > > > > > > [1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/m=
dsmap.h#L11 =20
> > > > > > > >=20
> >=20

