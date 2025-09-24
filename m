Return-Path: <ceph-devel+bounces-3726-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C7AB9B7E1
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 20:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3486321EB9
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 18:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0616120FA81;
	Wed, 24 Sep 2025 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KCy0cIpx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F51FDD
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758738766; cv=fail; b=OLVm/dPOxnb9m1Vd3jMsVx7q0rHYBTepKBkfFYlLTaF210IzK3C9ilIOkO/2hsIJcLSlZs1DLZ0uCqZZxYsdCBff4RjxSJ+OXshJ6dm5xw6c7wXiCZ3jIo/PBhJh0llM7XlfdQ98nKLUaKjO1ycrgs6jEiRqNr0fwB5ZbTsUoLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758738766; c=relaxed/simple;
	bh=ZafbJfjUoJ7RfjsA4MrrJCDC1ZA7qMN/2rAuK+A3Xcc=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=MAugHZRY3zL5wcq519RFoVe6N9Dyys33ZVFVf1pkz4COAb3j/03ifPRKt557/H6z3/ad84FOTRu7VQJdaoxnU8YSO5QpRxStkD+gCy2khnDcop7UnShMkDh5FtAVwmPPTqqDGkDiB9D5fBn2lhTY9kdbSypzc6C31tTA7OlmYYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KCy0cIpx; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGDDSS023754;
	Wed, 24 Sep 2025 18:32:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ZafbJfjUoJ7RfjsA4MrrJCDC1ZA7qMN/2rAuK+A3Xcc=; b=KCy0cIpx
	iZ2Q08pPRCtHQhdaTdw1+1kb2M2TqDf8FcbLwQnK4n8YP51KRikLQd/edfjlWL9J
	UO5+5JoCfDP3l5m9l5/jO0efnkwfJDD6N40XnzfQ0Nn3gRakjyChYh/Aoq31Ve+M
	kGO9kNxw7Xdc0LaizFUyHxx8+J6O2rB2WPR7Dvk7ehoXAA9pajx86T7SZyvb7kyJ
	gbfUhSDQo/P5I78O+siApHc0e7/r3lYQRGLhN7M7jPHTwkFmMARvsJQj4O73qNdY
	MnuUkCPQXPwz6tlgYnjLkvPSUnaWEL4TN44iEvhe01bJSRrQklSmFuGulFI7zjSZ
	ESQxRI+VFUrcDQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499n0js7pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:32:37 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58OILJjV004833;
	Wed, 24 Sep 2025 18:32:37 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499n0js7pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:32:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQHzdqiORiPHteW4etYIdLMPXeGaQXmss+hKHszjrU8W2wZglGZwru91nuMpFayoQhiok+HQQU8oxtdSsVyKkJglVw80hak3ZtqJ5pMdYuKMYU2DvuGtirr8wFQJw1RCnnoLqOHYAR5UVOaYRXF440ycPVjRRBbWnlAP5q+kTUgFDdXNbWSZqfs+/qPUa2bVSZiOIpPgFcxNtHyCagSqBum2DQlXFHZmeuoZXdak1Ho3FNK78RuhYIMqRixxJh5mDf9Z7iYYCW89W84CApfjCoTbkcFhho2g7sxWRw1EHFlgTKr1v9onT3CmfUhaqlrnXIEL2h85FlpeuMIrCZWpww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZafbJfjUoJ7RfjsA4MrrJCDC1ZA7qMN/2rAuK+A3Xcc=;
 b=QW/+HcrV3ql64kZwfqdh61VS3HxNYO0N/yZDOSGrBC4u++NRaClKesgnvWdmSHfVLgopF2IpwryDJnrEFFI+GMZqcSCF14+LnLzbKlNwhUXO0+DyixFjL9fCAM3y4zBV1uD3Z/bIbR6/ZpDP9JHx9nDoawysAlWINokkWTj6P4UMhdcOQoEBaqdoRqOB053t0otBtD0tUL3kGe7fmTSHXgdLHbnRNxOQYRACaNp2CIMuv1dL56hNeIbi5WSavGL1FGXJKqT9zYUpFDbjk2bpONTPSKfI3Begt+CkLmLeLuFnyhW/8lRh2enhc3Cfw7j0FERj3CPCEIxZ2qBfXoz4ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV3PR15MB6433.namprd15.prod.outlook.com (2603:10b6:408:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Wed, 24 Sep
 2025 18:32:32 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Wed, 24 Sep 2025
 18:32:32 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "ethan198912@gmail.com" <ethan198912@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "ethanwu@synology.com"
	<ethanwu@synology.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph: fix snapshot context missing in
 ceph_uninline_data
Thread-Index: AQHcLTnXUsltb8fD/0mMfd9Hod5sz7SiqLoA
Date: Wed, 24 Sep 2025 18:32:32 +0000
Message-ID: <6887aa7e6557737a3950e83d4ad5acc84a09d7ab.camel@ibm.com>
References: <20250924095807.27471-1-ethanwu@synology.com>
	 <20250924095807.27471-3-ethanwu@synology.com>
In-Reply-To: <20250924095807.27471-3-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV3PR15MB6433:EE_
x-ms-office365-filtering-correlation-id: b751e1aa-f5fb-4804-73ac-08ddfb98b9bc
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SEJVK2UxNkNoekRZU1RXNXo1UzdyWEEyWHhoL244V0MxUWdoVkVCSTJ3STZX?=
 =?utf-8?B?elYzNGp0ekhDbkFjV0JrbmJBdzZYZ2NzUkxjOTFIdmdidzBwMGtremIxejFX?=
 =?utf-8?B?V291enIvUGhHVzNDek1xNHI4RkZMTkpxSjRPbFM4anNsdXlKL2dCd2JhVzVW?=
 =?utf-8?B?RVNpckNVY3pJS0hyNk9HcC9IVVIwdXB1ZnhlbHloZkM4SHEzNmVnNUlsWHIw?=
 =?utf-8?B?cy8wQWsrbnl0TUpYTStJWWtSZGt1dzhvaEFad2lZaWNuZ1JkTCtyN0RUcWg3?=
 =?utf-8?B?QVRucFlyUkdBSy9mTTM4RTNaaTA2VHhRN0FLelRsWlZPM2NEcDF3U2xxN2Zj?=
 =?utf-8?B?WVZOMHphQXh6Tjd6cFNpaEhzTC9HWWdKKzhTNUtoM2o5dFo5U3h6RzhxcTls?=
 =?utf-8?B?dm94SlFqdHU4WlFmcU9ERlAwNG9QOFVhOXplYnhGby9oVnU5QmNWT2hjV0pv?=
 =?utf-8?B?TnZWVzJYTXZtN2RrWW9PaHlEZDVXWWZoMWpoTDM3dWhtdHB6TUhhZDlzUVZk?=
 =?utf-8?B?ZmV3S3l6OFo5cWhnOTJXRjVHV1dYcVBqeEowK3daSzhLaE43QzFMTnV4VWlJ?=
 =?utf-8?B?MSswTFkyYkJPdktYc2g4U2c2SktNSEtzWktQY1pJNnZHRkJSa09KL083cjR6?=
 =?utf-8?B?RUtrUnI1NkI1Ly8vNHVSZEdmUUF5czRRL0thSjhYYjd6UVh4U3R1TU43MHhv?=
 =?utf-8?B?YkxWTHNFMWtIQit6MUMyWjl3RHpOWllESWNyVDVWcFU3SG1LMS8yN0ZCMmJI?=
 =?utf-8?B?THlrTDUrWmVaZVYwSHNPeTBvZzdXSm5jVUQzcXZzYURvQ2d4V0NzWjN2OE1i?=
 =?utf-8?B?SUdZUmRrUHlzSzdsRVZCRGp0M0w2dFVYVGhzZ0U4dDNOTUE4SVZSQXlvdTBV?=
 =?utf-8?B?RnpYaHRiQmV4R2Q4eFYvaXBicUlyNmwxZU5tSm9WWDBSRmxhSHNWSVJMVmdJ?=
 =?utf-8?B?R1Y1TER3b0tUc2QrVFVObnFFam02S3Fub1I2MmxCNjhnbWl3MkxXdVV0MzRv?=
 =?utf-8?B?d0lsa2I1YXgrb0ZVcFp1SUg1bEpSb1Q1aG8xSWpOMVBucGhwSHVYQXkxNmQz?=
 =?utf-8?B?bStNOFllWWEyMGVrNWpmZy90UloxMUZKUDFOV3FFV0ttSjJxTGZKWXVGRlBN?=
 =?utf-8?B?bURBalFLcXBzZUxkZS9NVlg0SmpHWmU3M09PZXNwMUpqRU0xVER4enZLc0s0?=
 =?utf-8?B?WFAyYTI1RHlnRVpHeTlDcS9DZVZaSE0xeDlMMEYxMkpROUJzQTBHVDFNcEY0?=
 =?utf-8?B?ZFRtTTlsc25RUFczYlBZcmpEb1FGbitZM3ZBZlpoYXArQkx4K2cvM29PMDIz?=
 =?utf-8?B?V3dENE1JSWFhaWE5VU94N2s5QzJFQURPb3VPcHpzNmI3enVsSGJrYUp0NTEw?=
 =?utf-8?B?MVVKbVNFQ1BTNlVMUk9HNkx0VjJIRVZEc3c3cGt4QUE2UTNvSXpTMkxvVW1a?=
 =?utf-8?B?SmtoMFNPejJ1VEhhT2pUVWRXcWtQRmVsdWl4VVl6a21zdndZTUNBZzYrVmdy?=
 =?utf-8?B?N3pmSkJsOTNqK0NZRDdQRXlDSVFER2VWaEZOWjZYWFRiQWw2RzRtSXFoMmJP?=
 =?utf-8?B?MklqVGp1OTF3b0o1SUdGQStSWEhvMk1MQ0g3bi9Pa2MvRW02MzZHUndSb1RI?=
 =?utf-8?B?ZzkvdzltOENwalNRTk9YRXhhek5GQm9WYWhFN2kyRDE3WVYzR2Z2NTUrRUt5?=
 =?utf-8?B?eXZPbjBKaFNDMXVrNzRvL3REcUNabjJIS2g0RVNrWFpzaGR2bDZvMTczN3Zr?=
 =?utf-8?B?cFpGazhaakE4MFdhQ3Y4QVdGd0d0ekhCRC9TZk9PdEpWN2N2dlNoZDd2Z0pH?=
 =?utf-8?B?ekE3OHBpUk1CZXFzb1Z6bnNLM3NQQWszTjhCdHlMNE1JNER6bHE0YmR1bGky?=
 =?utf-8?B?a1dCSit5Z3ovRWNwTnY1Tm96MFpyZENGaTMxbm1qY1hScytnaUx4TmxoTmNo?=
 =?utf-8?B?eVNMOTk5SUtibFVUdFJ6R0NVOEYzTTBXWVI3eXB3TVBJelE4UDRqbHU5cEF4?=
 =?utf-8?Q?kGmloNOIlRQD0QUebVDf9ISKx/8eOM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SlE3UU5CdE44M1ROdUxoR1QxMlpZQ2tmWU1iQ3RmakllalpRdC9raGJYU25K?=
 =?utf-8?B?Y281MzdTQlhMTm9ZeEtJREM1MFhBdEgrWERTQTRoZ0pQME1PYmZwT3h1Vkcw?=
 =?utf-8?B?SE14cWg2RHdqTWZjclZIS2FSMk5oWU0xZWVwKzlyRm9TRkh0WFVvNTEvczQ5?=
 =?utf-8?B?OHJmbkRRNFVhajY2ZWdBNkZiWHpsNWttSTE0UGJlR3VrOHdmaGhrK29YV1l3?=
 =?utf-8?B?SDM3SjlPMXBPS1o2UjZyait3U0czWnhQMUlXQXIxSFRPbEVqTW94OHJibXpi?=
 =?utf-8?B?TXZZMHJ6eWUwSUZtSG5jUjBzSU1UVUIyZ1BFcVFmejJDMFFrVWxId2pnbXFY?=
 =?utf-8?B?akFoenhrdlFURWM5bisvYXRxMzNXWEk3dlVWbkhJS1g3d0dPb0tvWitUOFdS?=
 =?utf-8?B?VnhUdnp5SVdtR2cxQjVJSGZOdXBzZDN0cEFtU1lrOGpYMlJrd2diY0o1NlZ4?=
 =?utf-8?B?WGZ2M244S3dlc1FncWRmMzNBc0FMM3NBN0p6bnd2Um5qd1hDeW9OWXd5MDFq?=
 =?utf-8?B?Wm4xY242ckpKbkZpL1JRanFMNlBEdkRjRnA3SGhaRzdYeEYyNHNRemNoRUpK?=
 =?utf-8?B?Rzk2eVVtSEhiQ253RDl6OWE2cWZpaGhGekdBcjF6TDJuc0tzREs5bTFYS1FT?=
 =?utf-8?B?NEwrYUFrUkR0bUVvMlhxb2FxMG1na2N5K1FHN3R6ZStCcjlxQ1o2WFFvN1or?=
 =?utf-8?B?NkFXTEdSZmtWYkNkV1ZaREwxaHg5NWlxTVBHWTBjcEZVN1NzSHJwZG5DRDc1?=
 =?utf-8?B?YVhYZjN6UUNYdlphOVNTQWVFRnJWVXFjc0ZFQjBVRHhYdUJNeUplMkt3Rk1K?=
 =?utf-8?B?NHZLMVU4UFNpMGFjczNSNTdtb213aTd3d1dhSHhrbFBMdVlIMzIzRlNZajA2?=
 =?utf-8?B?bFVKVWZxN2c5elhjc3d3MlVEbTdzWjBzZmNJemxWSW1BL1htY283eHg2VHQw?=
 =?utf-8?B?ZWNOa2UxbGZCYU9IMytKa0pQaG4zZkY4MzNwT3RHOWtlM0tWc2dKVlRmVnhZ?=
 =?utf-8?B?cWI0VEpUTnFqYjNRZWEzZnhIVFZSdFM1dHNXZUdwbitxSW9idjBEZ3dLYlBq?=
 =?utf-8?B?ZnR5aEtRbXdlQzQxclJNS3BCSldReVIwRmQ4Q2Z1VWMrMzZHcDV5NjBXbHk4?=
 =?utf-8?B?YTJWeW9jYjVYazJYZzZ0OXlkOVEvZlVLaWRUK29aUWdVTDlyZkZKN2Y3RlVl?=
 =?utf-8?B?NEJHMlZSdnFycVNkNklzSDBvZk41ZFZQRkRGTTBqY210UE11V2g5SE9ad1Mw?=
 =?utf-8?B?N1lkR1ZuQmp6aTZSdkFpV1pGNlNPamRLQTdCT1BRaXY1aUtPamd2UngwSXFD?=
 =?utf-8?B?U0F6YU1XNDNsazNiZ25wZ2g2b1RUbTh0K0d5TWRtS1JLcDdHbE1EaHNoTTRz?=
 =?utf-8?B?aVhuMXlabmNhZ0x2OEtxUmNMbFRMTU5IdmdMcXdHYW1DUWE3aEU2Z0ZpUXBi?=
 =?utf-8?B?bXZROUFicFpHeUVtK2hHTlYwMmFPRGR3Nk55a0E2UEhvMllwaVlCdjFCRElR?=
 =?utf-8?B?bDk4MU5OVHhWM1RPZlJyVkhTZGNxREhZb2NselBJMi92SWhCYWFMdDFhMVhi?=
 =?utf-8?B?LzhmQWtIZXRqY0JDRFRaZnVzVDFkWk5hTXI5NEVmWG4ySkhLbFNDeU5OQmRi?=
 =?utf-8?B?SXY0bjEyR093RXgxSVJOWGJnRnJ6TDRqUDNldjRiaDJRRkxzZDl1eXFqbGk0?=
 =?utf-8?B?YUMybG1HYXNWZUlvYWJWYi80WEE3dlAwWFVLTHQ2UGE1U0pEZW41TU9PVHgr?=
 =?utf-8?B?andSYTYxaFY0WGpDOXRRYXg4eGw4Y2k1RXg3b3Z4Qit6ZFNVd0lQSVppeFZl?=
 =?utf-8?B?U3B3dUhqdVRRelM5bXM3a1pGTW95VkFhQVdjZy9OdHNtQUZFa084U0doNy9t?=
 =?utf-8?B?STloTEp1MjZGQmZGVkkvUmh5eWhUbFNLQmlpQTFJUW1kK0JIUUJoa0lnM3J3?=
 =?utf-8?B?eWpwdHpkTis3VmRlK0JwdHptVzIxN0hTQXIyT2RXRUZIREFCc3RwNHpZcE03?=
 =?utf-8?B?Zml5ck5TcGpQNEpUMkJnMlRQVGpyeHc5dGo1K0hHeHg5dThnRXdnQmQ3UDAx?=
 =?utf-8?B?U2M5UFBwbW0yZElub2FlRWlvQ2hmOWs0UW5RNVA2ZUY3UnNqcnFhT1BldVp0?=
 =?utf-8?B?NzJKOEdZS0xOZVpabVVvSjFmZVpSR1hvSDEzanFjODZ0Rko3MVNPUno1YkFC?=
 =?utf-8?Q?uFnB8bj/byyPsGWNzm/RA9s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0652F47B05BC2848ACF0E6311295C119@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b751e1aa-f5fb-4804-73ac-08ddfb98b9bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 18:32:32.5847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +S2DdXL07fTuETUyvHmArINKGiRVMeqF+7cIv0mcz6O4BhpA7aoRnWUvOniG0twD8hm6vxsX7Ge0glZRwmQrDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR15MB6433
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzMyBTYWx0ZWRfX212UwSiiy4Ii
 OVcl2YjvZwtgr3TspGtftL5ruPJaKc2lzTnlQqy/JiURgONDPyoG80N3WLsPPOUsda3u0mif9xx
 pVzjJd1If/0E26ipMVZFKIND1RQDTPh/oeuGSt3GvRA2J+oyZcTbutQS+As1qr8uno+VFSCh9vv
 1OlII2tv2+pKnm12eHrZ2Z3Nh+1wjIPwCB03iAGc6lFPz66RLO1nAbVQ1xBZ5VoJvk7XWVMbx7V
 oh49I4cLciE6vKN/o+RYbYkhJcouQvMt89xlLKMT2XVEdywsNeY/5KparDqUEq1ANJzQhdAIMTw
 aoQuXiVPrQwwIeiZUYfSlIL2uSEaS75UMZqEq+lBkjVfO07Zrl5TbApnJMKSOC16vWROLThNJLM
 N8Tdx0Gf
X-Authority-Analysis: v=2.4 cv=TOlFS0la c=1 sm=1 tr=0 ts=68d43945 cx=c_pps
 a=r8U4PY7g8F27BymEuqiK4A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=LM7KSAFEAAAA:8 a=Uz1gsIH36BB_iyEAbzEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: eowdVCvKPV6H90jvRgBQrqDqyEGHKPNq
X-Proofpoint-GUID: iQzTTtEf2g_guv1aLEiAsqkPw3aximuo
Subject: Re:  [PATCH] ceph: fix snapshot context missing in ceph_uninline_data
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200033

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE3OjU4ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBUaGUg
Y2VwaF91bmlubGluZV9kYXRhIGZ1bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFwc2hvdCBj
b250ZXh0DQo+IGhhbmRsaW5nIGZvciBpdHMgT1NEIHdyaXRlIG9wZXJhdGlvbnMuIEJvdGggQ0VQ
SF9PU0RfT1BfQ1JFQVRFIGFuZA0KPiBDRVBIX09TRF9PUF9XUklURSByZXF1ZXN0cyB3ZXJlIHBh
c3NpbmcgTlVMTCBpbnN0ZWFkIG9mIHRoZSBhcHByb3ByaWF0ZQ0KPiBzbmFwc2hvdCBjb250ZXh0
LCB3aGljaCBjb3VsZCBsZWFkIHRvIGRhdGEgaW5jb25zaXN0ZW5jaWVzIGluIHNuYXBzaG90cy4N
Cj4gDQoNCldoYXQgaXMgdGhlIHJlcHJvZHVjaW5nIHBhdGggZm9yIHRoaXMgaXNzdWU/IEhvdyBp
cyBpdCBwb3NzaWJsZSB0byBjaGVjayB0aGF0DQpzb21ldGhpbmcgaXMgZ29pbmcgd3Jvbmcgb3Ig
ZnVuY3Rpb25hbGl0eSB3b3JrcyByaWdodD8NCg0KPiBUaGlzIGZpeCBwcm9wZXJseSBhY3F1aXJp
bmcgdGhlIHNuYXBzaG90IGNvbnRleHQgZnJvbSBlaXRoZXIgcGVuZGluZw0KPiBjYXAgc25hcHMg
b3IgdGhlIGlub2RlJ3MgaGVhZCBzbmFwYyBiZWZvcmUgcGVyZm9ybWluZyB3cml0ZSBvcGVyYXRp
b25zLg0KPiANCg0KSGF2ZSB5b3Ugc3BsaXQgdGhlIHdob2xlIGZpeCBvbiB0d28gcGF0Y2hlcyBi
ZWNhdXNlIG9mIGRpZmZlcmVudCB1c2UtY2FzZXM/DQoNClRoYW5rcywNClNsYXZhLg0KDQo+IFNp
Z25lZC1vZmYtYnk6IGV0aGFud3UgPGV0aGFud3VAc3lub2xvZ3kuY29tPg0KPiAtLS0NCj4gIGZz
L2NlcGgvYWRkci5jIHwgMTkgKysrKysrKysrKysrKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMv
Y2VwaC9hZGRyLmMgYi9mcy9jZXBoL2FkZHIuYw0KPiBpbmRleCA4YjIwMmQ3ODllOTMuLmE4YWVj
YTk2NTRiNiAxMDA2NDQNCj4gLS0tIGEvZnMvY2VwaC9hZGRyLmMNCj4gKysrIGIvZnMvY2VwaC9h
ZGRyLmMNCj4gQEAgLTIyMDIsNiArMjIwMiw3IEBAIGludCBjZXBoX3VuaW5saW5lX2RhdGEoc3Ry
dWN0IGZpbGUgKmZpbGUpDQo+ICAJc3RydWN0IGNlcGhfb3NkX3JlcXVlc3QgKnJlcSA9IE5VTEw7
DQo+ICAJc3RydWN0IGNlcGhfY2FwX2ZsdXNoICpwcmVhbGxvY19jZiA9IE5VTEw7DQo+ICAJc3Ry
dWN0IGZvbGlvICpmb2xpbyA9IE5VTEw7DQo+ICsJc3RydWN0IGNlcGhfc25hcF9jb250ZXh0ICpz
bmFwYyA9IE5VTEw7DQo+ICAJdTY0IGlubGluZV92ZXJzaW9uID0gQ0VQSF9JTkxJTkVfTk9ORTsN
Cj4gIAlzdHJ1Y3QgcGFnZSAqcGFnZXNbMV07DQo+ICAJaW50IGVyciA9IDA7DQo+IEBAIC0yMjI5
LDYgKzIyMzAsMTkgQEAgaW50IGNlcGhfdW5pbmxpbmVfZGF0YShzdHJ1Y3QgZmlsZSAqZmlsZSkN
Cj4gIAlpZiAoaW5saW5lX3ZlcnNpb24gPT0gMSkgLyogaW5pdGlhbCB2ZXJzaW9uLCBubyBkYXRh
ICovDQo+ICAJCWdvdG8gb3V0X3VuaW5saW5lOw0KPiAgDQo+ICsJc3Bpbl9sb2NrKCZjaS0+aV9j
ZXBoX2xvY2spOw0KPiArCWlmIChfX2NlcGhfaGF2ZV9wZW5kaW5nX2NhcF9zbmFwKGNpKSkgew0K
PiArCQlzdHJ1Y3QgY2VwaF9jYXBfc25hcCAqY2Fwc25hcCA9DQo+ICsJCQkJbGlzdF9sYXN0X2Vu
dHJ5KCZjaS0+aV9jYXBfc25hcHMsDQo+ICsJCQkJCQlzdHJ1Y3QgY2VwaF9jYXBfc25hcCwNCj4g
KwkJCQkJCWNpX2l0ZW0pOw0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4dChjYXBz
bmFwLT5jb250ZXh0KTsNCj4gKwl9IGVsc2Ugew0KPiArCQlCVUdfT04oIWNpLT5pX2hlYWRfc25h
cGMpOw0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4dChjaS0+aV9oZWFkX3NuYXBj
KTsNCj4gKwl9DQo+ICsJc3Bpbl91bmxvY2soJmNpLT5pX2NlcGhfbG9jayk7DQo+ICsNCj4gIAlm
b2xpbyA9IHJlYWRfbWFwcGluZ19mb2xpbyhpbm9kZS0+aV9tYXBwaW5nLCAwLCBmaWxlKTsNCj4g
IAlpZiAoSVNfRVJSKGZvbGlvKSkgew0KPiAgCQllcnIgPSBQVFJfRVJSKGZvbGlvKTsNCj4gQEAg
LTIyNDQsNyArMjI1OCw3IEBAIGludCBjZXBoX3VuaW5saW5lX2RhdGEoc3RydWN0IGZpbGUgKmZp
bGUpDQo+ICAJcmVxID0gY2VwaF9vc2RjX25ld19yZXF1ZXN0KCZmc2MtPmNsaWVudC0+b3NkYywg
JmNpLT5pX2xheW91dCwNCj4gIAkJCQkgICAgY2VwaF92aW5vKGlub2RlKSwgMCwgJmxlbiwgMCwg
MSwNCj4gIAkJCQkgICAgQ0VQSF9PU0RfT1BfQ1JFQVRFLCBDRVBIX09TRF9GTEFHX1dSSVRFLA0K
PiAtCQkJCSAgICBOVUxMLCAwLCAwLCBmYWxzZSk7DQo+ICsJCQkJICAgIHNuYXBjLCAwLCAwLCBm
YWxzZSk7DQo+ICAJaWYgKElTX0VSUihyZXEpKSB7DQo+ICAJCWVyciA9IFBUUl9FUlIocmVxKTsN
Cj4gIAkJZ290byBvdXRfdW5sb2NrOw0KPiBAQCAtMjI2MCw3ICsyMjc0LDcgQEAgaW50IGNlcGhf
dW5pbmxpbmVfZGF0YShzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAlyZXEgPSBjZXBoX29zZGNfbmV3
X3JlcXVlc3QoJmZzYy0+Y2xpZW50LT5vc2RjLCAmY2ktPmlfbGF5b3V0LA0KPiAgCQkJCSAgICBj
ZXBoX3Zpbm8oaW5vZGUpLCAwLCAmbGVuLCAxLCAzLA0KPiAgCQkJCSAgICBDRVBIX09TRF9PUF9X
UklURSwgQ0VQSF9PU0RfRkxBR19XUklURSwNCj4gLQkJCQkgICAgTlVMTCwgY2ktPmlfdHJ1bmNh
dGVfc2VxLA0KPiArCQkJCSAgICBzbmFwYywgY2ktPmlfdHJ1bmNhdGVfc2VxLA0KPiAgCQkJCSAg
ICBjaS0+aV90cnVuY2F0ZV9zaXplLCBmYWxzZSk7DQo+ICAJaWYgKElTX0VSUihyZXEpKSB7DQo+
ICAJCWVyciA9IFBUUl9FUlIocmVxKTsNCj4gQEAgLTIzMjMsNiArMjMzNyw3IEBAIGludCBjZXBo
X3VuaW5saW5lX2RhdGEoc3RydWN0IGZpbGUgKmZpbGUpDQo+ICAJCWZvbGlvX3B1dChmb2xpbyk7
DQo+ICAJfQ0KPiAgb3V0Og0KPiArCWNlcGhfcHV0X3NuYXBfY29udGV4dChzbmFwYyk7DQo+ICAJ
Y2VwaF9mcmVlX2NhcF9mbHVzaChwcmVhbGxvY19jZik7DQo+ICAJZG91dGMoY2wsICIlbGx4LiVs
bHggaW5saW5lX3ZlcnNpb24gJWxsdSA9ICVkXG4iLA0KPiAgCSAgICAgIGNlcGhfdmlub3AoaW5v
ZGUpLCBpbmxpbmVfdmVyc2lvbiwgZXJyKTsNCg==

