Return-Path: <ceph-devel+bounces-4259-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D86CF5FB7
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 00:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11478305F657
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 23:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE002DF707;
	Mon,  5 Jan 2026 23:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OGQ53VKA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD8A20299B
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767655570; cv=fail; b=SPu4+gtfuo/V1TZPIj27YdX+LPvDBz8W6DtrSrIm+PWJ7A2cfZoYDanfJQD/ywOPm9tN6gwmCJ7tcTEq9ZUIIjRcdULJgQPWHjIv0pYca0MbuJNRhKqX2F7FYF4JhU3xekMdvffCrPAqi/rkf09R9bjEw3HZ5jAu9dgq2kPGGQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767655570; c=relaxed/simple;
	bh=x5qB2zg6Iq5j4UNPv8NjwUbbkV6Mwa0suaYVch+OGt8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=mdIRxs540mxpDKpTKM0HAqQWq7J7L+LvO2XncWdT4PUFXE7Je5KAJj4bPEKllnBDZDnbdcv3Kq2h9jXMmJe2YabLaP7ndT+mM/1WieUFGMU4lWw57bg4tqH4IbxsI9eVvgEOy62PWVZvj5Ii0KCmSaVgyiPdwFZDev47kDfoHs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OGQ53VKA; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605EVMBL026728;
	Mon, 5 Jan 2026 23:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=x5qB2zg6Iq5j4UNPv8NjwUbbkV6Mwa0suaYVch+OGt8=; b=OGQ53VKA
	HutPYFp59H4cB4Y4uEsQc6NsN6ACP4ceL6+o1669pv7kZPnTMkqcRmZIhGM9IMkk
	+GeCceNYAeT6Jb/IBPG2gcDZoBsVeQ0tuUkrSGvukmsxpvRHN251i1CE8QCYFxwc
	YbQ150HYA8XQ5oK7nMrqmrMGrFziJMQW1j3V6/3tefzQPpWp1Rv3gn4nEhUOf5c5
	0c7mG/YQD/T1ioZL1WuyRQ7lsaT2YGyX4QBO7Zyo3UW4Yix64VHQknY1diGLsh7N
	XLC+KTjPQ79z+9Xlm4e6cTUTyq3YTGxfwkttpUTceAr1qhl2UzSQYiHnLTjQCtTa
	cKRXPe5m4QuRGQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm71k6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 23:26:02 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605NNUvT013865;
	Mon, 5 Jan 2026 23:26:01 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012035.outbound.protection.outlook.com [52.101.48.35])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm71k6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 23:26:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDUFEyM76lrl/WFg9MCJ6WxTwlDN1KdlA0tAldcTYWUkxpmJEe4cDD53ogMg1elqy0oFsx8EeZzpgs96YbP9Ixncv4hw++fnR8GjU7hn23uRP2jTEuiU9fyxmMCluYMpWcvlAs+CIo1DcAAgnOW1Rg5c4XlFONom4rvMFPppT7B0+DEoXoKxUOjmf++TEiryqb4lrpDZn2B5GsgMIcJpaDCwrhW0L3lG+Lr+HwoQcJ0t0502JeZRQvJYBDpOvho75WCVMTIx2IKg0QDu8CZrqsAD3GF9VC7+iyIAv6hU2voGDIcdItd1V2Ue1rlKb3iIIxYc/ZZCMtk1gbRljajrQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5qB2zg6Iq5j4UNPv8NjwUbbkV6Mwa0suaYVch+OGt8=;
 b=WYo0J3DTLTxh+oAVYDgQddyLQqzkGczOBxwlN8QPRMGoHyYKNavokGxyyGqliYM2CEoQiu0mJ4Uuft2H/0Ds3u/VTZ2XNVvVf0I4+kunmF7We5YrLqiM8qRIIHjM8PUG6Pl2IYhkr+9skPMNmRxyVsNHOL8i88yMCXy9aUzc8tMQNEObK8dGivKRvtYLatBtPCexFTKaOZ0jFk6ODYRRrZv/xTcbQt2YgICOtBizwY9o20DgqWSaTYmPwexrBsK9Vwq8DErFxBzyxyUgpKTNWppvLk5WVQQAmFxmRYmz7BZxCTUdi5QktQCK6HrHSPgq3Cl/kUuAAfcBK2B2q/BbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA3PR15MB6560.namprd15.prod.outlook.com (2603:10b6:208:51c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 23:25:59 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 23:25:59 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "aad@dreamsnake.net" <aad@dreamsnake.net>,
        "slava@dubeyko.com"
	<slava@dubeyko.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "qian01.li@samsung.com" <qian01.li@samsung.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: add support for multi-stream
 SSDs(such as FDP SSDs)
Thread-Index: AQHcdRnqnYVdz7N+C0mLZzAUj+1nJbUxZXIAgBLlpQA=
Date: Mon, 5 Jan 2026 23:25:59 +0000
Message-ID: <907f8145791e03996c2c839c5d877836f2d6b77c.camel@ibm.com>
References: <14583623641f27955592ae17dfcd88c0418ac289.camel@dubeyko.com>
	 <F9170EA4-B6F9-4CED-853D-EB1B15D73583@dreamsnake.net>
In-Reply-To: <F9170EA4-B6F9-4CED-853D-EB1B15D73583@dreamsnake.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA3PR15MB6560:EE_
x-ms-office365-filtering-correlation-id: 8963cf62-e8f8-4e37-346e-08de4cb1c89c
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmQ1b3NGaXJWYzd5dEovUVVqMVROeS9ncFBVclhldms4WFNpM3ZXZ3lHUU4w?=
 =?utf-8?B?amV2VmlyNitWMkpNZVJudHR4U29jYWIwQUVDM3h3Z0FDUG0zM3RXYVhoREgx?=
 =?utf-8?B?cDlydVIxeGRVcWtLR0NRUDhkWkZWTmUya0lDWVVUbVhRQklHeGRSM05QMHB1?=
 =?utf-8?B?SmoxYVZYSDUzbzA4SE9kRHBXRFZIRDVnOExiTFFRSlZLQm84azFNSFpJUkFn?=
 =?utf-8?B?Zlp4ODFBa0UwT1NQWDdYWDJ2bFgrS2oxWnVocEdzWlVUbmF6aFo2U1V5MVUv?=
 =?utf-8?B?cmh5QkpoT3gzVmNFNkxZaTFDMUlJcU4ybmJKL2hVL29PeHI5Uy9yd0ZXMDhV?=
 =?utf-8?B?QjZtM0xzcVNUTkNxUkQrQnpVOHBTKzZ3Z0tlclVRVVkzaWs3K1FZYXdYK3B4?=
 =?utf-8?B?QjVZdWs0Z1lJSkkwdXMvSjNpUjlxMldId2MzOXkwNG10dHRrY2FXcEZPZzFX?=
 =?utf-8?B?NHpTU0VpV1hBZTdJMzlXNWtrUWlZR3pwTkxlMXEzQnFVNHhabG9ZNGpPMmRO?=
 =?utf-8?B?L0NyemNvNGszK1ZWL002UjNSYnQ5YXRvUGl4VWJIanh5T3l3NnFGeUdnSG9o?=
 =?utf-8?B?Z2d5N0NHUGZIeFR2eEVFbTlvcE1oVHo2b2N2czB1QVNnYUtBL21RSFVFK09K?=
 =?utf-8?B?Q2JldW5iSTYwNHMyZW9XSHM1YjlsTlk5a1Z6NVNpRjBjTVVSbHpzZFNnTHNj?=
 =?utf-8?B?dFRSYWpsdUFjRDNLVjAzV0VpMzMwRjVRcEhRK1BHWnpjem9qcTlqeFNmc0xu?=
 =?utf-8?B?eWUvN0syLytWNFNJYThhWGV5ZzJyZWNaQnhWWmdJNk5abS8vbWxtMVZiRnJS?=
 =?utf-8?B?SUp1by85aUdiNmcrNmN6OHRVK1F3WnZFZGVtNXlwTFFWVE9hY1dGZ3FtRVJp?=
 =?utf-8?B?QzVkazFGSDdBOTZWdXBORzRuNzhkc0Q5NHFiQ2hMK3ZzamlQcFk1ZTk4eDI3?=
 =?utf-8?B?VGJXU1dEK2RYRzhYVnhiaHo3WDF2dHI4L0RmeHYvVVk2Y3pMS1ZwWlBRNHdx?=
 =?utf-8?B?OVlidVQ4RzhoR0dVVEdWK3NzWU9BMGwrNzF6TUFIaUMwUE4zQndUc3AzZ0tO?=
 =?utf-8?B?MHJ1MDloU1p4SkF4VE8vbDFQdnRid2h4dVZFNkI2R2hPeEg5OXVIZ3Vjc1p0?=
 =?utf-8?B?all5VkgwTkZDVmNsYVZFZXdGK0JyRXgwQmo2bXcya0RaK29LZm5RTXdUWVZx?=
 =?utf-8?B?NlU1dlY0dUc3dE1zTlY1dFU5VWFFanB0UFVEbnc0U0Zqb2RYVFNGMDNIYXRL?=
 =?utf-8?B?bTJ0K0VLb3k2OUhNaWNrZ1oyTE9yT0o0VFcvQ0cybDZPUXh5SXZKY3lrZVJN?=
 =?utf-8?B?VnBubEZLUTBVSk5Ja2FiTDUwYUk0RitIb0ZZbnF4YUwrc2JLSFMvVjBLWmdY?=
 =?utf-8?B?Yks5Rm5WUTFtU0cyL1pVQnZMd0FaMHRwdDR2SG4vMWZpRS9OL21uOHJNZWVr?=
 =?utf-8?B?aW0rZWI4Y0pxNTkyeGRQcVlHU0l5RnVIZEI2eGJxTWhtTi81RG52b3Q0WEVB?=
 =?utf-8?B?bWdqdCs4QSsyMHdHci9Kd3N2Wm45Rnd2c3FCUE1VaHE5dUI4RFYreUozbVMy?=
 =?utf-8?B?Q3pTQXZITndOQzhIMXZQN0RZK0dPanNsbVVSaFJRMnRzdkNwQmx6aEtqeU1m?=
 =?utf-8?B?R3pnR3VwbDhIMkRhM3lzVkZrTXI3V0tDdEtSeU9kK05YVEVKaFUzbVpTSUdZ?=
 =?utf-8?B?K1I1NkhJM1Fya1dhSDRndzB5WmJkcWVWTjRnTFA1MnptcmxGSXFBcXh1MUQ1?=
 =?utf-8?B?emNXc0NWaVA1MHNPc05UNm5GbVNCNnFnRE0vWGcwWHVpeDFEcDRiSHJQN013?=
 =?utf-8?B?NEtDMmltVm4xR3JNcVNDSVVOZW12djlLK1l0emhjWjBzRnQrNDJTS2tsYWxD?=
 =?utf-8?B?enk1ZUFENEJ4TjJmRHZjN1U0RzJQb2k1c3NqbXFTY1c2RlpyeEp0eUthRE5Z?=
 =?utf-8?B?U2xVRFRFL0czNkQxMGhYV3RZdFJiZWY0cytDV0FDcGEzWm0zOG55RXFGQ05R?=
 =?utf-8?B?aXo3SVBHVktYUEoyWGwwa2dkZnBWR2Y3cXd5N1lycnZDQVpBOTE2c0twY0s3?=
 =?utf-8?Q?l0D7GK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MGROSXFaU1NUNUJiWmxiK1BNb2Q4eHZUUVF0RnNGVmpTVmRLN25KNXV6RFVS?=
 =?utf-8?B?UVVaKy9XbFJxS1JFZThPZmVhcExHcW82ZkxLOGhXcWpQWDVjdGtEMkd4UWJJ?=
 =?utf-8?B?cXFQbGo4bEEzYXRNLzdJY2RDZ1VSNzlJYk5TZ2lMREh3ZjhZbS82NGtYUlRr?=
 =?utf-8?B?NzUxRHE2YVhwT1JDK1hKdElWU0dZQ0w2dVhwQ1Urai92MkxaNS9mSWpub25C?=
 =?utf-8?B?dC9lVjNSaC9xc3FpQ1RCN2tNbWVWUDd0dE94S3B0cXBVVENHendtb1A3T0Ux?=
 =?utf-8?B?SDlOYm9WVGNKSFhJOVRZSTlzM3VTNFVUTlQrbnVtL1pNV05udGk1dUoraTRI?=
 =?utf-8?B?UGJSNDhTSlRNUWtnNTZWSGlydStNb2pjMndRSlN4TFNnZ1RvaGV4MlNkS2cx?=
 =?utf-8?B?THlDb09WRE9DV01EeTFxY29BREFCN0xYY1I5L1oyTXJzNmhyV0FNWDk1MU9j?=
 =?utf-8?B?WDJRZU5lQUw5MHl1Rk16a2ptNE1PaTlSQjBaaVdIdlNxMi9QSHNSMVpMYzFH?=
 =?utf-8?B?Wmd5ckhFWkxpLzM3R3N5eEhzR0x4ZHE1RVFINDJLbnl0eDJxQTZldGdPbVNH?=
 =?utf-8?B?L1gyQmtqNzAzbVluZlFqVEJHbHE0bGo4NlF0Z2RVaUp1c3FHMU5JcnJnWWFz?=
 =?utf-8?B?K3lDMHZQdDN6ekowZXp0ZUhabTFZN3pxMlkrditUZ01neXRYRGFkRmJmMW1C?=
 =?utf-8?B?Nm1lTXMxT0ZER2VsTWxvckxLSXl6K0NYSXl3ZFBITmJyQzV5SWxZa2FQaW1V?=
 =?utf-8?B?YnlaUi8zRW03N3d6WGtSQ3k5R1BHbE4yZk5tVnhQOWF5OG1IWno5bjdMZVgr?=
 =?utf-8?B?OEhET0tFN2k1K2FjZCtUclZxRnJyZHQ0THRGMnNnMGV5dEJPQzYzZTRtUUJF?=
 =?utf-8?B?SnJ3Rk9zUmNTRXNiUUtqeEdaWi82ZnJPcE9OUnhRT09nVjlrN2p3djhJZ3Fo?=
 =?utf-8?B?eDVIRGRrUVdxZ0ZzUmRLZkN6T3NXUTdMQi9HcmxLbWpvRUdJU3NQS2daSE1B?=
 =?utf-8?B?MURWWUZXSU1oVEJjRzNDbS9rMUI1RU13VkpiVFE4T1dRc0hmdTBqVHB0bHNP?=
 =?utf-8?B?WWFUc0kzV2RYUy9KSFhNWWtKOVNYVVJMOS9aV2NEMllqNXdYMTYwNmdIdU15?=
 =?utf-8?B?Zk1SOUxZTDI1SHk1SEtuN3RuZVgvYjd0Si9GQXJSZHdXd05qZnIvR3kvWnpB?=
 =?utf-8?B?M1B1Q0NLNm5xVlpaT280OXAxcjh4cUNyeXdjemNxZ1pwVnEyMENuVmdFc1dT?=
 =?utf-8?B?Y2NkYkZtb0JCdW83ckNxc1FBV0xRVDhRaWRUZXdBSGVqMGpJRmY4Q1Z4UWlw?=
 =?utf-8?B?djBZU1ROUGQ5WjhJbnVTZjhzUkJheWN6MWFLYjVUVXQ1WCtRTGZzV3VVYXBy?=
 =?utf-8?B?MkJwMDFQUTZKZXJNR1JEWnR2M1V3d0F6Zi83R0UzWDF0Nm95UTJkTnprb2kr?=
 =?utf-8?B?ME95V1phUDNDbDd0S1Z0SGlzYlBUUG5FVmk0V0tMaFA4SmZ6SGlsRkh0YWxY?=
 =?utf-8?B?Tm55TEF5d0t6OTdmZjY3Y1pUTVpQZEkzcmtObGthbW5kaU02elVBM21MR1FL?=
 =?utf-8?B?NkZxa3BaeW4wVnRoaHlsU0txN0ZENjJEaXBsc2h4dVJwSThHb0ZSSE41N1l3?=
 =?utf-8?B?bnlHM3p1Y3Bjak9ObnU2eXhITHhvZ2s1N2JBSUEwY0t4cHFkK0F3aHVGbzRG?=
 =?utf-8?B?UGIwY3gzT25CTDcycks0cVJLZHN3SlZEK2UrMjVNR1JjR3NqczVNOWtpTDRi?=
 =?utf-8?B?aFU3TjVFZU1uMmo2ZkNTY1F3Y0pKRlNJSU03Uk5MeWdZM3kyNlJnR3daUHpk?=
 =?utf-8?B?b2FicVhnUVpiTVJMa2o0WDB2WCtMYkF6OE1zMkFUaEhKQTlneTBtY3J5cEtt?=
 =?utf-8?B?eC80ZE5NcGZ4U2NXSk44c2kwdHdzTGFZcGpaWElzNHR0RmdpM1hnVXltRDFD?=
 =?utf-8?B?QUMzd2sxVGVGSml3V0d2emxRRXVteG9laU5RYmg5Zm5XNzRURUxIbHI0SkY2?=
 =?utf-8?B?RXNVdU5HMzVnU21CYWxxYlFwclloMHg1MCtuaWJsY1B5NTJrZHZ5ZHpkNjV6?=
 =?utf-8?B?NzRhVzBNTEtLV0JhcmdpU1UzdEtPc2hSaHZ0MVk3NzZTUkZlSUFtUEQwZy92?=
 =?utf-8?B?aFN4c01VVXRUWDZJNXVCNG9uSUdrN1lqMVpVSHBWam1zRFlxSkh4UGp5U3V1?=
 =?utf-8?B?RUE2UDkxL0FHSGkxSWJZY2NtN3NxaFgrSENMR2tzZHVQSjJTMTFKNThCWXB1?=
 =?utf-8?B?cVlBRHpnVExxTGZYVk9TR29BdnRIL3VqM1dVMzdHSkdlWDJiMkNHWEtIall5?=
 =?utf-8?B?bnpDdFhyMmRXWnBJYkUza1h2TGdLMGwwZC83Tm1WYmZyTHlZVU56eE1ITG5h?=
 =?utf-8?Q?PN/Yk8CmL3YA5zEr+X59xEtNzTk1xxD3Z35yn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <918771B9DDDC064D95AD1783559BE65C@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8963cf62-e8f8-4e37-346e-08de4cb1c89c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 23:25:59.1761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxxhOjZe3zUV6mIwbGB/7MLFnHKT/Rucd8G8HVwzj1QoJPE/ga/5daBQ1Zy7gMuc8Mn6g3xZsgYWylSAVGQ+6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR15MB6560
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=695c488a cx=c_pps
 a=SJ7/6Usf5opWGcqe47ja0w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=0Iu6dNfosufKnY_aIbIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: k1A9vqHaR2wqw8VPlBkbgsOLKqCY5554
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDIwMSBTYWx0ZWRfXwrLhPBYCfBug
 mWHzKTyPHslLfDEpmA6erEkb3j/NI8V8dHFGC1loOOtUeuTA4momlkTLcfINFvPlLLlZtRiNLGl
 /XGL8g8ODD4mn2S2eo+2wXxYb2jnZnMByW7SOcw6AtGdZJ10bU4O6uXZvPqm64uRbgleFLUyWwn
 XrlzKciH05LGGiQpOud9h3H0/YQu5kjaji1cGGYRyM0qPukLnqesc8OulIo2kXe6yXr15JvbtbJ
 2DEnL3kQkiQAYISzpoxmpkYiA7XIB+DGvGfbbvi7dpKW3ubrynDiaaqZ1eam7nG3TJIb+p0SerU
 izU1iZn2dV4APII6+UC3sjGCjGRG/rHsNvuDeYGCa3vZtFJqQ/X+7NJmBwlBNhzBXSBadUQA2mg
 X0XfUEr0t5vJm3udxT4RwMqFI514TjCsVPNm46ULLuhxopbKBMX4x3sAEB14kP0bsCnWjJYioPv
 8bb6O4Hpia3ccdrEwPQ==
X-Proofpoint-ORIG-GUID: N3WdDHXj5UrqLLS3wZkt0ADm5BFFvnqo
Subject: RE: [PATCH] ceph: add support for multi-stream SSDs(such as FDP SSDs)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050201

T24gV2VkLCAyMDI1LTEyLTI0IGF0IDE3OjUxIC0wNTAwLCBBbnRob255IEQnQXRyaSB3cm90ZToN
Cj4gPiANCj4gPiBBcyBmYXIgYXMgSSBrbm93LCBGRFAgU1NEIGl0c2VsZiBjYW5ub3QgcmVjb2du
aXplIGRhdGEgbGlmZXRpbWUuIFRoaXMgZGV2aWNlIGlzIHN0dXBpZCBlbm91Z2guIEl0IG5lZWRz
IHRvIHJlY2VpdmUgdGhlIGhpbnRzIGZyb20gYXBwbGljYXRpb24gb3IgZmlsZSBzeXN0ZW0gdG8g
ZGlzdHJpYnV0ZSBkYXRhIGluIGRpZmZlcmVudCBzdHJlYW1zIGJhc2VkIG9uICJ0ZW1wZXJhdHVy
ZSIgaGludHMuDQo+IA0KPiBUaGF04oCZcyB0aGUgaWRlYSEgUUxDIGFuZCBldmVudHVhbGx5IFBM
QyBTU0RzIGhhdmUgaW5oZXJlbnRseSBsb3cgZW5kdXJhbmNlIHNvIG5vdmVsIG1ldGhvZHMgYXJl
IGFkdmFudGFnZW91cyB0byBtYWtlIHRoZSBiZXN0IHVzZSBvZiB0aGUgYXZhaWxhYmxlIFBFIGN5
Y2xlcy4gIA0KPiANCj4gPiANCj4gPiA+IEl0DQo+ID4gPiBwcm92aWRlcyBtdWx0aXBsZSBzdHJl
YW1zIHRvIGlzb2xhdGUgZGlmZmVyZW50IGRhdGEgbGlmZXRpbWVzLg0KPiA+ID4gV3JpdGVfaGlu
dCBzdXBwb3J0IGluIGZzIGFuZCBibG9jayBsYXllcnMgaGFzIGJlZW4gYXZhaWxhYmxlIHNpbmNl
DQo+ID4gPiBjb21taXQgNDQ5ODEzNTE1ZDNlICgiYmxvY2ssIGZzOiByZXN0b3JlIHBlci1iaW8v
cmVxdWVzdA0KPiA+ID4gZGF0YSBsaWZldGltZSBmaWVsZCIpLg0KPiA+ID4gVGhpcyBwYXRjaCBl
bmFibGVzIHRoZSBDZXBoIGtlcm5lbCBjbGllbnQgdG8gc3VwcG9ydA0KPiA+ID4gdGhlIGRhdGEg
bGlmZXRpbWUgZmllbGQgYW5kIHRvIHRyYW5zbWl0IHRoZSB3cml0ZV9oaW50DQo+ID4gPiB0byB0
aGUgQ2VwaCBzZXJ2ZXIgb3ZlciB0aGUgbmV0d29yay4gQnkgYWRkaW5nIHRoZSB3cml0ZV9oaW50
IHRvDQo+ID4gPiBDZXBoIGFuZCBwYXNzaW5nIGl0IHRvIHRoZSBkZXZpY2UsIHdlIGFjaGlldmUg
bG93ZXIgd3JpdGUNCj4gPiA+IGFtcGxpZmljYXRpb24gYW5kIGJldHRlciBwZXJmb3JtYW5jZS4N
Cj4gPiANCj4gPiBXaGF0IGlzIHlvdXIgcHJvdmUgdGhhdCB5b3UgY2FuIGFjaGlldmUgbG93ZXIg
d3JpdGUNCj4gPiBhbXBsaWZpY2F0aW9uIGFuZCBiZXR0ZXIgcGVyZm9ybWFuY2U/IERvIHlvdSBo
YXZlIGFueSBiZW5jaG1hcmsNCj4gPiByZXN1bHRzPw0KPiANCj4gTXkgcmVhZCBpcyB0aGF0IHRo
aXMgaXMgZW5hYmxlbWVudCBmb3IgZW1lcmdpbmcgZGV2aWNlcywgYW5kIHRoYXQgYmVuY2hpbmcg
YW5kIGNvZGUgcmVmaW5lbWVudCB3aWxsIGZvbGxvdyBhcyBkZXZpY2VzIGJlY29tZSBhdmFpbGFi
bGUgdG8gbW9ydGFscy4gIA0KPiANCg0KVGhpcyBwYXRjaCBoYXMgYmVlbiBzZW50IGJ5IFNhbXN1
bmcgZ3V5LiBBbmQgU2Ftc3VuZyBoYXMgYnVuY2ggb2Ygc3VjaCBGRFAgU1NEDQpmb3IgdGVzdGlu
Zy4gQWxzbywgSSBhc3N1bWUgdGhhdCBRRU1VIGFscmVhZHkgaGFzIEZEUCBlbXVsYXRpb24uIFNv
LCBJIGRvbid0IHNlZQ0KYW55IHByb2JsZW0gd2l0aCBiZW5jaG5hcmtpbmcgYW5kIGNoZWNraW5n
IHRoZSBhcHByb2FjaC4gSSBhbSBzdXJlIHRoYXQNCnN1Z2dlc3RlZCBhcHByb2FjaCB3aWxsIG5v
dCB3b3JrIGZvciBPU0QgYmVjYXVzZSBpdCBiYXNlZCBvbiBmaWxlIGJhc2lzLg0KDQo+ID4gLiBJ
ZiBpdCBpcyBzbWFsbCBmaWxlKHMpLCB0aGVuIG9uZSBvYmplY3QNCj4gPiBjb3VsZCByZWNlaXZl
IG11bHRpcGxlIGZpbGVzIHdpdGggdmFyaW91cyB0ZW1wZXJhdHVyZSBoaW50cy4NCj4gPiANCj4+
IEkgdGhpbmsgUkFET1MgZG9lc27igJl0IHdvcmsgdGhhdCB3YXkuICBJbiBmYWN0IHRoaXMgY29k
ZSBhaW1zIHRvIGFjaGlldmUgdGhlDQo+PiBvcHBvc2l0ZS4gIEJ5IGdyb3VwaW5nIGRhdGEgd2l0
aCBzaW1pbGFyIHByb2plY3RlZCBtb2RpZmljYXRpb24gLyBkZWxldGlvbiAvDQo+PiBUUklNIHRp
bWVmcmFtZXMsIHRoZSBmaXJtd2FyZSBjYW4gcmVvcmRlciwgYnVmZmVyLCBhbmQgY29hbGVzY2Ug
b3BlcmF0aW9ucy4NCg0KVGhpcyBwYXRjaCBzdWdnZXN0cyB0byBzaGFyZSBoaW50cyBmb3IgZmls
ZXMuIEFuZCBJIGRvbid0IHNlZSB0aGUgZGlyZWN0DQpyZWxhdGlvbiBvZiBmaWxlIHdpdGggT1NE
J3Mgb2JqZWN0cy4gV2UgY291bGQgaGF2ZSBidW5jaCBvZiBzbWFsbCBmaWxlcywgb3IgYmlnDQpm
aWxlcywgb3IgbWl4dHVyZSBvZiBkaWZmZXJlbnQgc2l6ZXMuIFdlIGNvdWxkIGhhdmUgaG90IGZp
bGVzLCB3YXJtIGZpbGVzLCBhbmQNCmNvbGQgZmlsZXMuIFNvLCB0aGlzIGlzIHdoeSBJIHdvdWxk
IGxpa2UgdG8gc2VlIGJlbmNobWFya2luZyByZXN1bHQuIEJlY2F1c2UsIEkNCnRoaW5rIHRoYXQg
c3VnZ2VzdGVkIGFwcHJvYWNoIHdpbGwgbm90IHdvcmsgYXQgYWxsLiBJIHNlZSB0aGUgcG9pbnQg
aWYgT1NEDQppdHNlbGYgd2lsbCBzaGFyZSBoaW50cyB3aXRoIEZEUCBTU0QsIGJ1dCBpdCdzIGNv
bXBsZXRlbHkgdXNlbGVzcyB0byBzZW5kIGFueQ0KaGludHMgZnJvbSBDZXBoRlMga2VybmVsIGNs
aWVudCBiZWNhdXNlIE9TRCdzIG9iamVjdCBpcyBub3QgZmlsZS4NCg0KPj4gQSBOQU5EIHBhZ2Ug
Z3JvdXBpbmcgYSBkb3plbiBzbWFsbCBSQURPUyBvYmplY3RzIHRoYXQgZ2V0IG1vZGlmaWVkIHdp
dGggYQ0KPj4gc2luZ2xlIFBFIGN5Y2xlIGlzIGZhdm9yYWJsZSBjb21wYXJlZCB0byBkaXN0cmli
dXRpbmcgdGhlbSBhcm91bmQgYSBkb3plbg0KPj4gTkFORCBwYWdlcyBhbmQgYSBkb3plbiBQRSBj
eWNsZXMuDQoNCldoYXQgZG8geW91IG1lYW4gYnkgTkFORCBwYWdlPyBEbyB5b3UgbWVhbiBlcmFz
ZSBibG9jaz8gQmVjYXVzZSwgTkFORCBwYWdlIGlzDQo0SywgOEssIDE2SyBpbiBzaXplLiBBbmQg
aXQgaXMgc21hbGxlc3Qgd3JpdGUgcG9ydGlvbi4gSG93IGNhbiB5b3UgcGxhY2Ugc2V2ZXJhbA0K
NE0gb2JqZWN0cyBpbnRvIDE2SyBwYWdlLCBmb3IgZXhhbXBsZT8gRXJhc2UgYmxvY2sgY2FuIGJl
IDFNIC0gMTI4TSBpbiBzaXplLg0KQWxzbywgaXQncyB1cCB0byBTU0QgaG93IHRvIGFzc29jaWF0
ZSBwaHlzaWNhbCBzZWN0b3JzIChvciA0SyBMQkFzKSB0bw0KcGFydGljdWxhciBlcmFzZSBibG9j
ay4gVGhlIG1hcHBpbmcgYWxnb3JpdGhtIGlzIGEgc2VjcmV0IHNvdXJjZSBvZiBhbnkgU1NEDQpt
YW51ZmFjdHVyZXIuIEFuZCBzZXF1ZW50aWFsIExCQXMgY2FuIGJlIG1hcHBlZCBpbiBkaWZmZXJl
bnQgZXJhc2UgYmxvY2tzLiANCg0KPj4gVGhhdOKAmXMgYSBzdWJzdGFudGlhbCByZWR1Y3Rpb24g
aW4gd3JpdGUNCj4+IGFtcCwgZXNwZWNpYWxseSBmb3IgYSBjb2Fyc2UgSVUsIHdoaWNoIGluIHR1
cm4gZW5hYmxlcyB0aGUgY29zdCBhbmQgY2FwYWNpdHkNCj4+IGFkdmFudGFnZXMgb2YgZXZlbiBs
YXJnZXIgSVVzLg0KDQpJIGRvbid0IHNlZSBob3cgc3VnZ2VzdGVkIGFwcHJvYWNoIGNhbiBkZWNy
ZWFzZSB3cml0ZSBhbXBsaWZpY2F0aW9uLg0KICANCj4gDQo+ID4gLiBBbHNvLCByZXBsaWNhdGlv
biBhbmQgcmVkaXN0cmlidXRpb24gYWxnb3JpdGhtcw0KPiA+IGNhbiBtb3ZlIGFuZCBzaGlmdCBk
YXRhIGFtb25nIE9TRHMgdGhhdCBjb21wbGljYXRlcyBkYXRhIGRpc3RyaWJ1dGlvbiBhIGxvdC4N
Cj4gDQo+IFRoaXMgY29kZSB3b3VsZCBzZWVtIHRvIHdvcmsgd2l0aGluIGEgZ2l2ZW4gT1NELCBz
byBteSBzZW5zZSBpcyB0aGF0IHJlYmFsYW5jaW5nIGlzIG1vb3QuICANCj4gDQoNClRoaXMgaXMg
d2h5IEkgc2VlIHRoZSBwb2ludCBpZiBPU0Qgc2hhcmVzIHRoZSBoaW50cyB3aXRoIEZEUCBTU0Qu
IEkgZG9uJ3Qgc2VlDQpob3cgQ2VwaEZTIGtlcm5lbCBjbGllbnQgY2FuIGJlIHVzZWZ1bCBoZXJl
Lg0KDQo+ID4gdGhlbiBPU0Qgd2lsbCBoYXZlIGEgY29tcGxldGUgbWVzcyBvZiB0aGVzZSBoaW50
cyBmb3Igb2JqZWN0cy4NCj4gDQo+IFRoYXTigJlzIHRoZSBpZGVhISBTbyB0aGF0IGhvdCwgd2Fy
bSwgdGVwaWQsIGFuZCBjb2xkIGRhdGEgYXJlIGdyb3VwZWQgdG9nZXRoZXIsIFRoaXMgd2lsbCBy
ZWR1Y2UgdGhlIGR5bmFtaWMgb2YgUk1XIGN5Y2xlcyBmb3Igc2hvcnQtbGl2ZWQgZGF0YSBkcmFn
Z2luZyBhbG9uZyBsb25nZXItbGl2ZWQgZGF0YS4gIExvbmdlci1saXZlZCBkYXRhIHdpbGwgZXhw
ZXJpZW5jZSBmZXcgb3Igbm8gc3VwZXJmbHVvdXMgUk1XIC8gUEUgY3ljbGVzLiAgVGhpcyBpcyBz
b21ld2hhdCBha2luIHRvIGVuc3VyaW5nIHBhcnRpdGlvbiBhbGlnbm1lbnQuDQo+IA0KDQpIb3cg
d2lsbCBpdCB3b3JrIHdpdGggaGludHMgZm9yIGZpbGVzPyBJIGRvbid0IHNlZSB0aGUgd2F5IGhv
dyBpdCB3aWxsIGJlDQp1c2VmdWwuIA0KDQo+IEZEUCAvIE5EUCBTU0RzIHdpbGwgdGVuZCB0byBi
ZSBsYXJnZSBTS1VzIHdpdGggY29hcnNlIElVLiAgQ29hcnNlIElVIGltcHJvdmVzIHRoZSBjb21w
b25lbnQgZWNvbm9taWNzIGJ5IHByb3Zpc2lvbmluZyA8IDFHaUIgb2YgRlRMIERSQU0gcGVyIFRp
QiBvZiBOQU5ELCBvdGhlcndpc2UgdGhlIGxpbWl0ZWQgcGVyZm9ybWFuY2UgYW5kIGVuZHVyYW5j
ZSBvZiBRTEMgYW5kIFBMQyBkZXZpY2VzIGlzIGhhcmRlciB0byBqdXN0aWZ5IHdpdGggYSBzbGlt
bWVyIGNvc3QgYWR2YW50YWdlLiAgQSBjb2Fyc2UgSVUgYWxzbyBlbmFibGVzIGZpdHRpbmcgYWxs
IHRoZSBkaWVzIGludG8gdGhlIGZvcm0gZmFjdG9yLiAgQ29uc2lkZXIgYSBwdXRhdGl2ZSA1MDAg
VEItY2xhc3MgZGV2aWNlLCB0aGluayB5b3UgY2FuIGZpdCA1MDAgR0Igb2YgRFJBTSB3aXRoIHRo
ZSBOQU5EIGludG8gRTMuUyBvciBldmVuIFUuMj8NCj4gDQoNCllvdSBhcmUgdGFsa2luZyBhYm91
dCBvcHRpbWl6YXRpb24gb2YgT1NEIG9wZXJhdGlvbnMgd2l0aCBGRFAgU1NELiBCdXQgSSBkb24n
dA0Kc2VlIHRoZSBDZXBoRlMga2VybmVsIGNsaWVudCBpbiB0aGUgZXF1YXRpb24uIEFsc28sIHBl
b3BsZSBsaWtlIHRvIHVzZSBIRERzIGZvcg0KQ2VwaC4gQW5kIEkgYW0gbm90IHN1cmUgdGhhdCBG
RFAgU1NEIHdpbGwgYmUgd2lkZWx5IHVzZWQgaW4gQ2VwaCBjbHVzdGVyIHNvb24uDQpJdCdzIHRo
ZSBxdWVzdGlvbiBvZiBlY29ub21pY3MgYW5kIGNhcGFjaXR5LiBJIGFtIGV4cGVjdGluZyB0aGF0
IGhpZ2gtY2FwYWNpdHkNClNTRCBhbmQgRkRQIFNTRCB3aWxsIGJlIHByZXR0eSBleHBlbnNpdmUu
IA0KDQo+IA0KPiA+IEFsc28sIG9iamVjdCBpcyBhIGJpZyBwaWVjZSBvZiBkYXRhIChhcm91bmQg
NE1CKQ0KPiANCj4gUkFET1Mgb2JqZWN0cyBieSBkZWZhdWx0IGFyZSAqYXQgbW9zdCogNE1pQi4g
IERlcGVuZGluZyBvbiB0aGUgdXNhZ2UgbW9kYWxpdHkgYW5kIHdyaXRlIHBhdHRlcm5zLCB0aGV5
IGNhbiBiZSByYXRoZXIgc21hbGxlciwgZXNwZWNpYWxseSB3aXRoIHRoZSBGYXN0IEVDIGNvZGUg
dGhhdCBhdm9pZHMgcGFkZGluZy4gIA0KPiANCg0KSG93IHNtYWxsZXI/IEkgYmVsaWV2ZSBpdCB3
aWxsIGJlIE1CcyBhbnl3YXkuDQoNCj4gPiBhbmQsIGFzIGEgcmVzdWx0LCBpZiB5b3Ugd3JpdGUg
aXQgc2VxdWVudGlhbGx5DQo+IA0KPiBXaG8gaXMg4oCceW914oCdPyBWaWEgdGhlIElPIGJsZW5k
ZXIgZWZmZWN0LCBPU0RzIGluIGFsbW9zdCBhbGwgY2FzZXMgc2VlIGEgcmFuZG9tIHdyaXRlIHdv
cmtsb2FkLg0KPiANCg0KVGhlIHJhbmRvbSB3cml0ZSB3b3JrbG9hZCBkb2Vzbid0IG1lYW4gbm90
IHNlcXVlbnRpYWwgd3JpdGUuIEZvciBleGFtcGxlLA0Kam91cm5hbGluZyBjb2xsZWN0IHJhbmRv
bSB3cml0ZSB3b3JrbG9hZHMnIHRyYW5zYWN0aW9ucyBhbmQgd3JpdGUgaXQNCnNlcXVlbnRpYWxs
eS4gRXNwZWNpYWxseSwgcmFuZG9tIHdyaXRlIHdvcmtsb2FkcyBvbiBPU0Qgc2lkZSBjb250cmFk
aWN0cyB0bw0KbW9kZWwgb2Ygc2hhcmluZyBoaW50cyBvZiBmaWxlcycgInRlbXBlcmF0dXJlIiBm
cm9tIENlcGhGUyBrZXJuZWwgc2lkZS4gVGhlDQpyYW5kb20gd3JpdGUgd29ya2xvYWRzIG9mIE9T
RCdzIG9iamVjdHMgbWFrZXMgdGhpcyBwYXRjaCBjb21wbGV0ZWx5IHVzZWxlc3MuDQoNCj4gICAN
Cj4gDQo+ID4gU2Vjb25kbHksIGFzIGZhciBhcyBJIGNhbiBzZWUsIHBlb3BsZQ0KPiA+IGNvdWxk
IHVzZSBIRERzIGZvciBDZXBoIGNsdXN0ZXJzLg0KPiANCj4gU3VyZSwgaWYgdGhleSBkb27igJl0
IG1pbmQgcGF5aW5nIGZvciAxMC0yMCB0aW1lcyB0aGUgREMgc3BhY2UgYW5kIHN1ZmZlcmluZyBi
dXJnZW9uaW5nIHNlZWsgYW5kIHJvdGF0aW9uYWwgbGF0ZW5jaWVzLiAgTm90IHRvIG1lbnRpb24g
Y3Jvc3NpbmcgeW91ciBmaW5nZXJzIGZvciB0d28gbW9udGhzIHdoaWxlIHRoZSBjbHVzdGVyIHNs
b3dseSwgcGFpbmZ1bGx5IHJlY292ZXJzIGZyb20gdGhlIGxvc3Mgb2YgYW4gT1NELiAgDQo+IA0K
DQpJdCdzIHF1ZXN0aW9uIG9mIGVjb25vbWljcy4gU1NEIGNvdWxkIGJlIG1vcmUgZXhwZW5zaXZl
IGFuZCBhZmZvcmRhYmxlIHNvbHV0aW9uLg0KQW5kIFNTRCBjYW5ub3QgZ3VhcmFudGVlIHRoYXQg
aXQgd2lsbCB3b3JrIG1vcmUgcmVsaWFibHkgYW5kIGV2ZW4gZmFzdGVyIHRoYW4NCkhERC4gQW5k
IHlvdSBhbHJlYWR5IG1lbnRpb25lZCB0aGF0IFFMUyBTU0QgY2FuIGJlIGtpbGxlZCBtdWNoIGZh
c3RlciB0aGF0IE1MQw0KU1NEIHdpdGggd3Jvbmcgd29ya2xvYWQuDQoNCj4gDQo+ID4gQW5kIGl0
IG1lYW5zIHRoYXQgRkRQIHdpbGwgYmUgY29tcGxldGVseSB1c2VsZXNzIGluIHN1Y2ggY2FzZS4N
Cj4gDQo+IEkgZG9u4oCZdCBmb2xsb3csIHRoaXMgc2VlbXMgbGlrZSBhIG5vbiBzZXF1aXR1ci4g
IA0KPiANCj4gPiBPdGhlcndpc2UsIHRoaXMgcGF0Y2ggaXMgY29tcGxldGVseSB1c2VsZXNzLg0K
PiANCj4gUGxlYXNlIGJlIGNpdmlsLiBJIGRvbuKAmXQgdW5kZXJzdGFuZCB0aGUgcGhhcm1hY29r
aW5ldGljcyBvZiBHTFAtMSBhZ29uaXN0cyBvciB0YW11bG9zaW4gYnV0IGJvdGggYXJlIHJhdGhl
ciB1c2VmdWwuICAgDQo+IA0KPiANCg0KSSB3b3VsZCBsaWtlIHRvIHNlZSB0aGUgYmVuY2htYXJr
aW5nIHJlc3VsdHMgdGhhdCBjb3VsZCBwcm92ZSB0aGUgcG9pbnQgb2YgdGhpcw0KcGF0Y2guIEN1
cnJlbnRseSwgSSBkb24ndCBiZWxpZXZlIHRoYXQgdGhpcyBwYXRjaCBjYW4gYmUgdXNlZnVsIGZv
ciBDZXBoRlMNCmtlcm5lbCBjbGllbnQuDQoNClRoYW5rcywNClNsYXZhLg0KPiANCg==

