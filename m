Return-Path: <ceph-devel+bounces-4248-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E49CF56FF
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 20:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49D33308D06B
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 19:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9FA2BD012;
	Mon,  5 Jan 2026 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DldOxQK3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57BB280CF6
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 19:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767642919; cv=fail; b=o3Y2VxRVxhf+RNVI4xlPRrjOztp8wixY9FmyCRX6EeBhwAKkqUsunMe3Igjc0kmiF26AFbR2UEWv0URh/zNo9sHnIB4XcS20kehU0cLOXfVsoiVkRq1HHPyxXb6f0eFRfQAgc4k52gEBdY5l4l+qDVswrlRmyw/umC/YKg1WF9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767642919; c=relaxed/simple;
	bh=F+KXG2que84w12s0+ulkmaiep6SojZt1CwOkHs86aoU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=QQf/UhFMilHV0geufLmrTJCNQz3J6beVk9k/KDucOpTDWKwPjRobRzp8jReoIFOw7VMAEgB6SMqb+gyEGvTE1JCHAyUESVNSw6uKnxIRD9agnuMVfF5PgpI+YoG9m0TJ2hHDqia+se+vaRNB6ydyCSGeT863zVb6aJWXYqIxgF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DldOxQK3; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605ERN3o011311
	for <ceph-devel@vger.kernel.org>; Mon, 5 Jan 2026 19:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=XO23SY2yo0j2oiwlsDaLM08ENm2In4sVMTD154YfPMg=; b=DldOxQK3
	zs1lCJ+/LEbJac4AucqebnqxqkjgVdmS+PBIS/zlSFPqzAJvggAHmy8dR7xeunuC
	KA/e6Wvu9DkgsWvEJ9eRNXFf3FdbIdOk2TRBTOyJB9fl5jylVfzfAyA04p4qw4f3
	yz8U6egSo+2s3RSH2qTbdJgTxLIVuszwgeJY94R+QNEWyMZEwo6+HOuh3JhJgAkX
	Fogj+ZrCgCJzcnrAWv8eTQoywAaKnawgQrpWF1nnKMG5YL5+H6/Pvw64rrdQCeLI
	aDgayFom2ARFZee3TTm57mDLsSUW7l4L/5ZZEpIhlvjW3cKDKYYUCG4s/Z4a74rX
	9bRL7ULcHckU0g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhk0j8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 19:55:16 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605JtG41021664
	for <ceph-devel@vger.kernel.org>; Mon, 5 Jan 2026 19:55:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhk0j8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 19:55:15 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605JqkWS017588;
	Mon, 5 Jan 2026 19:55:15 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013023.outbound.protection.outlook.com [40.93.201.23])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhk0j8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 19:55:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stJo2iF6ivtyFGGqL3KNUyWkv4GDd0hnvNSDWJgE5BvYH0gqjIBGk1WD7lwRNRjPP7jd1tuhduCuitB0fAfRYUALuYPUqk07LUq1h/MlZcIwlBkd8N4EB6AmastRzEOMeXsEdKMOEp5pIyhQ5NFvW9JFWP1mHjip0dAYQ+eXVXYaxM4ULCvU4VjA0tsgi8V4riK1odVuvxQhHKRL3dsbouOB0PGwwz37F7+/TRA2uC9RoF9DlkSxNV2qEROPKeRHYXFYpRcenWIqW4rWUgB78NHycYKP0d4S8HJ8ZLa6ekT121mV6wMJN/eJzydWXSfpC1eSCK5Rt+5UZMx1Ujp9ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bD23pqJfhUmD+oOrOpySCwwyXEnxFvBkdkNUjLLVuug=;
 b=Nv5H3SDSlF0Ez+3NFr2Mtg47fFAjl5zn4nV87zfJ3/EZPYw2SJbwF9FKTjG+F9oq6yFf3qOH8lUfde8QFUaG984wxlfywMZDBFymtsMBYNJPzslW0XdS+cDwX/XVCVxvXZU/8LUV94cS1eXG4jgXQ2Wh8Rzm9LJ0U66hEVTofi2kFEbjzlMPfK/cC+fvtE0Ov3VoGCHZkQa8LFSnQQC0PRonaf+6bGHcFnHaUOkH23mYwtmZrLKBdmZuR2HkBRZxmQ0OZ2a0Ah/H3OuFG3XgLb9JgopPsap6a1eK22eJTHZlgRWqFdVTk90BzVZhHj8PBhWbittX7h6s24ANZCqazw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB4450.namprd15.prod.outlook.com (2603:10b6:806:195::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 19:55:10 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 19:55:10 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "lilei24@kuaishou.com" <lilei24@kuaishou.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "sunzhao03@kuaishou.com"
	<sunzhao03@kuaishou.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Alex Markuze <amarkuze@redhat.com>
Thread-Topic:
 =?utf-8?B?W0VYVEVSTkFMXSDnrZTlpI06IOOAkOWklumDqOmCruS7tiHjgJFSZTogIFtQ?=
 =?utf-8?B?QVRDSCB2Ml0gY2VwaDogZml4IGRlYWRsb2NrIGluIGNlcGhfcmVhZGRpcl9w?=
 =?utf-8?Q?repopulate?=
Thread-Index: AQHcfVs7AUo7uZxfMEmsT5W5wm0ZW7VD/62A
Date: Mon, 5 Jan 2026 19:55:10 +0000
Message-ID: <896a69bcc26e1d808e6dfe2d35e25c8b9f8b7f02.camel@ibm.com>
References: <20250808070819.18878-1-sunzhao03@kuaishou.com>
		,<1d51b68168de62cc852fc147fb5e2dc8fbd9373d.camel@ibm.com>
		,<409ca87f8add4a80a7927981059b3c5f@kuaishou.com>
	 <5af9d165d05d4dddbb6c5d6d9d312367@kuaishou.com>
In-Reply-To: <5af9d165d05d4dddbb6c5d6d9d312367@kuaishou.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB4450:EE_
x-ms-office365-filtering-correlation-id: 2c6229f2-db20-4aea-d112-08de4c94555e
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YjZaTGxZWjFuVmtEdkg2dzVQYzExZ29SWkRCQUp5R1dOaEpFbWF3dVZ6V2Jk?=
 =?utf-8?B?WDREWkdqZmpjdzVNQk1VTVdRbFAwaEhwcDdqaGY1VURQb01ORTI2RS9SRGVF?=
 =?utf-8?B?Y3V6UkRnV0k0UnN6aTFtaS9wRjJjbXJVZXlHcitxYjdvdVd6M0l6UVYrWGxO?=
 =?utf-8?B?S1Q4YXQ2WGpVN2NXZDZ2MVNHaXRNa0dhNmQzZUhUN0Jpc0svR0U1TGRQWGpS?=
 =?utf-8?B?Yk96VHc4dytPWFo2akVPMDZVdkRRK2dhTHhrUFZpRklIMllDZGk3OEdJTis4?=
 =?utf-8?B?VDhHYm82aU9uUFRpSFMwczJJL2FUNjIzNjlRZi9LMjl6Rmcybnc2QjZzQjQr?=
 =?utf-8?B?aTZhNzFKc3RUOUlya1pSaDNxV1oyZ2FTVUZsZjl5eEpHL1RWRUZLSklyWWc3?=
 =?utf-8?B?YUVPc2RHOG9TcEwwRURsR2ZFZitNd20vb3QyQjNSMWVNbmQ1dlN0WG5HSVla?=
 =?utf-8?B?bW52Z1gzeisyOEVucFYzVjM5bmExWVNxUEg1WVVaUTN1dHhMWi9Sb0RXV0dx?=
 =?utf-8?B?VkJwZlNkZGwzRHFQYUovdWpGNE5jSDhmLzZMVEszMGgxQXBUZ2RlL0RHMmFG?=
 =?utf-8?B?ZUpCOEtWRGlZVVBVSjQxUzJsTzFGVmVZN29aazJrUEYzaFl3eGVZaFJoRklI?=
 =?utf-8?B?Z3BKUWoya3Zxdno3RnBadXdrdFF6c2czc1RTTk83MGNJSzdTamNla1NuSGtE?=
 =?utf-8?B?Z2xyZHYxQkJ3WkZtTlJHeW5ZNExZTE1OR1BkL2d5bXZRZ0wyOFdFS2VwZDAr?=
 =?utf-8?B?RWw4Y2N0cmNRWmpoTE82eHY2UHlKNCsyWEp5TGJiTGRXNXZaUm5VUExFWC8w?=
 =?utf-8?B?aG9RTWdNWklFbVViNmQreThadXJ2YUFBV1lOWTVUNFk5ait6RHRhTFYyLzVD?=
 =?utf-8?B?NEpWZDMzOTEyUjBPejNaanZIT3lSZXVRanFOQWhHS2xOMVNxMlpLRWJuWkNJ?=
 =?utf-8?B?NXdVbksrb3g0bXArcGlXZldIeXlLSDRiSDA5dU5LMTdDdEdqc01sdXlvZVg5?=
 =?utf-8?B?dW1MZFZQV0xaemluYXNjZ3lsc1hxbnVaMkxJK3U2dkdqV1RlSWtXUEhkaUky?=
 =?utf-8?B?dXVBbXpES0c3K3U5dVZscHBySlVhWGVaRndjYlBxK0cxZ3Vwak9VL1N2blor?=
 =?utf-8?B?MmlqOUdDWEdIUHdidUU1aTdWWlIrZEdtQys4d3FlVVR5eURWS2s5TFA0NWlB?=
 =?utf-8?B?NC82aFhpYlJVeU9OL082cHlUdEhIblIzQjMrblBwWThtSTR2bUtBQ1FDdlYw?=
 =?utf-8?B?Mkdab0lFZnZYWVFNdWtIckFwb3E0ZnNmMkVjRGpCTlhvdUxRSjBLaVF0cEFK?=
 =?utf-8?B?OVBXNlV0OS9XZUhxenNkSEg5UWZ0OWpFNFVVR1hUMlpSbzRtRHhYUlRrelNa?=
 =?utf-8?B?MEM5MUVxaDRhQWJxekZZMklReSsrbENjeTNtL056WXJoMTJOMGNjTjZ5cGl5?=
 =?utf-8?B?OEpWeU41ckd3MERxQ21TOGNYSHZyRGVnU0tTaU9FeDNuQWNnczhnaDBUVjVX?=
 =?utf-8?B?K3dJaHRMSDlSYmFxcit0dUJXNEVVQ2dEbGJpYzhMZ0E5ZTBLZXhac1BhNVlZ?=
 =?utf-8?B?Y3FiK2FTa08xR2RUYU00RGh6c1YzOXR6VGoxamVRUFpIR2NwMzJQZDM1TllV?=
 =?utf-8?B?Zy9SWFUzL3V0RjZ3MnIvT0oxQlVxTEc3ZW1SanFsbXhVa203cmZMSkx6MkY0?=
 =?utf-8?B?SERYK0Uzb3BVbjM4UnErbkk0ZXN4T0pEcTFCMXd3Y3ZPU2Nxc0FSZW05ODNT?=
 =?utf-8?B?VklkL2hNcmRrQ2xrRVlST2p6Q1FXODBNeTR1RndYNFZRcnN3SFlzQzRnVHdk?=
 =?utf-8?B?OGZ6TlhGNjQxOHNZcVcyL1BEUlduK1VBMllMYmhvM2tLTVIxejdvQWhodTF3?=
 =?utf-8?B?WEZocy94a1N1a1N3d1Qvd24xNHJvaUNaV1Y0ZnZDSHN4YUdHdjRXKzJpNnhE?=
 =?utf-8?B?ODE2ODlhQ3pBUkhRZTdYdHdYTU83TTlyd1ZGS0gwQ2lGcW4xYUlGNjNPVXJ0?=
 =?utf-8?B?NEt2d0FaTWRvMWNWRCtPME9TN0Jya1phR25GQnlEYUVSRG9jbkpjdkVrVGtH?=
 =?utf-8?Q?Nwq/Sn?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SEFodVZsRmFpODZBK2gyUEtOazdORG5icDF0Z1pzV0lUT1l0ZFovZDF1anRU?=
 =?utf-8?B?TTFSRUJMVWdDQ2dnM3FSbWZyKzBpQ1N6T1ZPTFBJWFZxMU1FVGlBSG01ZVZs?=
 =?utf-8?B?S2E0L1prMVJ5RDB0UjhKaWU0NWRiWllhMW9XOERUOUxadFQxT3ZsclIza0Rq?=
 =?utf-8?B?SURNdzZQRFdZY3QxOGNYVEZ3QlVtOWhSdjdoOXdDMitjNzI3Z01BMUUyaG9p?=
 =?utf-8?B?UXV5S3d4V29CV1NmdDNFNitVNUxYbzI3N3I0Q3hxWW5ZQ0RmYld4d29nYkk5?=
 =?utf-8?B?OFJNdHhxS3M1OTlZRElzZG9maDB4TXBLajVqUHRmdk92a255NDQvL1ZhMk0z?=
 =?utf-8?B?YndJMXJrbzgyY1R0aVo1MGszdUlySXVRd1NEeVhKeFRtaW9iYmtXbnhZUUVN?=
 =?utf-8?B?R1NjWHd5MXdHTkhVUmlTVXFndlNWaGZGeGFXZWY4Zm1WbGJnL1VGdnZoVno0?=
 =?utf-8?B?QkR6UTduV3hrQXR1S0NqUUFnNUprY2VJa2Q4aE1ZWFlwenhzTitvdkh1ZE1Q?=
 =?utf-8?B?K3YyY2xvWUVUQzdrcFlNd2lLaDJ4dHMzY3BCcFBFUlpKeXZaSFBETVhDMzBD?=
 =?utf-8?B?UUxlbGdhVGwwbzU4bFAxbkFMemxpd3ZFMjkwYStkMGhCdkdXVnFoVDhyM09W?=
 =?utf-8?B?cUZ5NEtRYWFobmVjbExpanNpWTUzMlFDVm8zUWVYaVcweWYwc2xBR3RObVhz?=
 =?utf-8?B?MnRFci9ibE42WDZ5MUIzUXVpTUFid0lWMFVYckErb0V4dGhpaWlEU2R2a20z?=
 =?utf-8?B?c1B1RmJJRDdVZG5EUVRNUjhQQlpkSDcxYXZaakxBbElaeGtRdlhSdm5IUFh5?=
 =?utf-8?B?WW1IVnZUL3Y3SlhNSHl5UHg0Z1MxQXBzdUQ0NWFWRkFOT1Fld1piQm5XMHdl?=
 =?utf-8?B?SEhJNjdZR3lVdkFNTWhkcDJwR2luR2tqRHplSlU2YXpXb1pyaXozVlgxZEhU?=
 =?utf-8?B?VDBNZk43cGtVSHhYSGZmSXVvZERnaDVXRmRYdVJVQXF2ZXl1QWJhaWhZOEFJ?=
 =?utf-8?B?a2ZYaGVwUjFrY2htYm9hS0UwVnkydmt4YlBZVE1SaVR3aHdJT0gxcUlwS2py?=
 =?utf-8?B?T3k5Mkp1NVA2aDd0SUo5OFMwU0hWWEVGTWhvU2dscmJnNDdMQmFWWWorNFB3?=
 =?utf-8?B?WWxsTS9vTWFMclIyc3FVWWZkWnYvSjlIcVJpTTlxMDJZSEpoNEV4YmMwTS9v?=
 =?utf-8?B?OXdpR2NLcGNKQzd5dzVSSDN3NEpoQ0d1bjhmRDA2Q3pDdnB1OHBkVktGbVVm?=
 =?utf-8?B?YzFjVkZjL2VEeFFkbUh4VERsK0FBekxCSkt1UUFLNks5RnptVGczWCtlUzYz?=
 =?utf-8?B?OUFmK2RHQVpiK0ZnVjU1VEpPcURFVjliYzYrWFFzRktaU0ptZlI3eEdLbzFh?=
 =?utf-8?B?ZUxVMjVOc1RRMG9SbmNZRHpkOTdPYUZOWWh0dnphdnlCTVd1ai8wK1BNbmk2?=
 =?utf-8?B?bEdOM0t1cVZKYkJ0Q2FlNFlUV0VPYit2bWRXTXVkeTU0SU5MUktDTG9LSUNE?=
 =?utf-8?B?UEpoaU5UQ21PeWt4WDBkS0l1N25qYkFOWExDSUlwb0dWRkN6ZlY0eDhhK0lk?=
 =?utf-8?B?b3Q5ZVR0ZEkrZ0xjZVBwbk9MaHgyVEF4TURYK0JZejN0cVorZGNYUm5uUG1F?=
 =?utf-8?B?RGwxY203TTJ4eU1rS1RVNlZ1Yjk4STlCbGtsY0pqRi9tZDZXQkEzMzJwamdn?=
 =?utf-8?B?NHFwQjl6Zkd1eTg0dSt1cUNGZXI4dUx0ZzF0Wkc1a1dZR1Q4MHA0OC9HYXNT?=
 =?utf-8?B?aHBnaStURXNaNkw5Q1hLV1lvUlA4eXJ2S3VpbjZWRG9mK2ZCeFFCeVBDYWJX?=
 =?utf-8?B?KzM2RGhmMTYrRGtFVDR4dVhaSTZWVitpckR6S0ZycmhaTHc2V2xsNU9KQ3hy?=
 =?utf-8?B?bGswb0txdk9rbXRtZUVHSmgrbEVXMjE0K1NjOTREMVNYVmtSR09zRk1XeXg1?=
 =?utf-8?B?Z1VucCtzZEh0dDdCNTRyOGcyYVVpRmdPUHZmZitlMW5qZkFCN00wK0Y1OG1O?=
 =?utf-8?B?R2ovQUZlNkdyeWdraFB3UzgzRndOcXMyYkR2VWdwN2gwMnZEYlA0enlCc2NP?=
 =?utf-8?B?S2t1VHJTdVFHL2lncFEwLysxTXlic1hwZDNlU0VzY1Y3aDc4RkFMYTFidkk3?=
 =?utf-8?B?R0NPSlRpTW9yN1Zldjh3L0ZySkwrVmNzSEhOMExaVk1oT2NCZW1BeUpkN3Zw?=
 =?utf-8?B?dDByMzZWU3dzY3M4T2l5bUc3RU1nRXRWLzRuWlZ4bUtid3NVeGpiZkZuaXVS?=
 =?utf-8?B?YW9vOTd3V3VuK2t3bzFycmNSc0ZOUzRLOU9NMnA5ZlM3US80cVNub0xaKzdu?=
 =?utf-8?B?NE4rNzA4eWQzR2pCeGFBbTJPOEhMQ09sa2IwZXN3WFVFVUVMdFBrUis0dU4y?=
 =?utf-8?Q?3P8LZPbCIPcgWYDGRLToiLz26f8MLtFUDVB2S?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6229f2-db20-4aea-d112-08de4c94555e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 19:55:10.3405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Uigs48RsdSuV4/7wQO0Wkswc+u71aFg+h1P/dJ/IFYR3i9EFAgluoS49WEip9ShdDIX/BT96ST0HiBFfHHAUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4450
X-Authority-Analysis: v=2.4 cv=P4s3RyAu c=1 sm=1 tr=0 ts=695c1724 cx=c_pps
 a=lrInUZDIVE0OTqvzw4499w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=5KLPUuaC_9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=4u6H09k7AAAA:8 a=VnNdFuG1AAAA:8 a=3s1R32lohyWp1WkPTuMA:9 a=QEXdDO2ut3YA:10
 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-ORIG-GUID: BCOFaitf_e4C6WHUjOcmQtmMqIOFfK4F
X-Proofpoint-GUID: AhNjl8aIsbehyO7LMdA16_4Op7ccE7w9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE2OCBTYWx0ZWRfXypMye+8KnTgv
 E0FtFDQk5VySo5LyZea2b6iILh8gWlfYsSMwE7Y7KaOULPz9NsEL4YXiGeUnZxEf3q7C/DpMGvu
 pQssCnyTeygX8t8Av3h5gRMjeNXlhgljtI8YzAUFdcYCch0/QxXkx7FcGZlijAskJF9+Euy4Nou
 hDNXY3BGWs4dpLoJ8XE5P2Eg+te621UGpRWUMad4OAw4A14SfrRTjgH6MEiOrqJDs+cooR5dgFL
 Znz9cYUus2NeB5ZW+uVXc83pYeweSQ8KSwKYkDOwCodtRKun76KY2tTU9odEHa7P+LUWxX3Ze+8
 MA+aKUpzmyAeeOjLi7WRfjX4S14b9aCge5gikLX1r2CaIa1FYVDg58or7Vmd9t1ZiJQ8AufXFKR
 nH9WJW8gBq+RGNp5Z8trunGfWZ9hjebn3jxvAfUBdkizURJXbNCp9UMmeAXgR2tO07wIDdYI0mj
 qJYKOWIsuRZGZ/+8NrA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <906183A41AE81246A259D3A8899220C3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re:__=E7=AD=94=E5=A4=8D:_=E3=80=90=E5=A4=96=E9=83=A8?=
 =?UTF-8?Q?=E9=82=AE=E4=BB=B6!=E3=80=91Re:__[PATCH_v2]_ceph:_fix_deadlock_in_?=
 =?UTF-8?Q?ceph=5Freaddir=5Fprepopulate?=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2512120000 definitions=main-2601050168

On Sun, 2026-01-04 at 09:19 +0000, =E6=9D=8E=E7=A3=8A wrote:
> Hi Slava,
>=20
> I guess here is the deadlock scenario described by Zhao.=20
> 1. DIR A has a snapshot and FILE X already in DIR A.
> 2. client submits create FILE X and readdir DIR A requests almost simulta=
neously.
> 3. The 2 requests are handled by 2 different kworkers.
>=20
> kworker1:
> 1. since FILE X already exists, A inode with I_NEW flag is set by ceph_ge=
t_inode().
> 2. rinfo->snapblob_len !=3D 0; So, kworker1 is blocked on down_write(&mds=
c->snap_rwsem);
>=20
> kworker2:
> 1. enter handle_reply
> 2. hold mdsc->snap_rwsem
> 3. call ceph_readdir_prepopulate()
> 4. in ceph_readdir_prepopulate(), it iterates all the ceph_mds_reply_dir_=
entry.
> 5. the ino of FILE X is found, and call ceph_get_inode().
> 6. However, the inode is set with I_NEW, kworker has to wait I_NEW cleare=
d.
>=20
> Please correct me if I missed something. Here is the timeline of the 2 kw=
orkers

This explanation sounds reasonable to me. If you can share the call trace o=
f the
issue, then I assume that you have reproducing script or application. Could=
 you
please share this reproducer? I would like to try to reproduce the issue.

It will be great if you can resend the patch with all this nice explanation=
 in
the commit message. Could you please resend the patch?

Thanks,
Slava.

>=20
>=20
> kworker1 [handle creating]				kworker2 [handle readdir]
> 	|											|
> 	v											v
> handle_reply								handle_reply
> 	|											|
> 	|											v
> 	|										down_read(&mdsc->snap_rwrem);
> 	|											|
> 	|											|
> 	v											|
> /* opening an existing inode */					        |
> ceph_get_inode	(I_NEW)							|
> 	|											|
> 	v											|
> rinfo->snapblob_len	!=3D 0;						        |
> down_write(&mdsc->snap_rwsem);					|
> 												|
> 												|
> 												v
> 											ceph_fill_trace
> 												|
> 												v
> 											ceph_readdir_prepoulate
> 												|
> 												v
> 											ceph_get_inode
> 												|
> 												v
> 											iget5_locked
> 												|
> 												v
> 											ilookup5
> 												|
> 												v
> 											/* waiting I_NEW cleared */
> 											wait_on_inode
>=20
>=20
> Here comes the callstack:
> task:kworker/21:2    state:D stack:    0 pid:23053 ppid:     2 flags:0x00=
004000
> Workqueue: events delayed_work [ceph]
> Call Trace:
>  __schedule+0x3a9/0x8d0
>  schedule+0x49/0xb0
>  schedule_preempt_disabled+0xa/0x10
>  __mutex_lock.isra.11+0x354/0x430
>  delayed_work+0x13b/0x210 [ceph]
>  process_one_work+0x1cb/0x370
>  worker_thread+0x30/0x390
>  ? process_one_work+0x370/0x370
>  kthread+0x13e/0x160
>  ? set_kthread_struct+0x50/0x50
>  ret_from_fork+0x1f/0x30
> task:kworker/u113:1  state:D stack:    0 pid:34454 ppid:     2 flags:0x00=
004000
> Workqueue: ceph-msgr ceph_con_workfn [libceph]
> Call Trace:
>  __schedule+0x3a9/0x8d0
>  schedule+0x49/0xb0
>  rwsem_down_write_slowpath+0x30a/0x5e0
>  handle_reply+0x4d7/0x7f0 [ceph]
>  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
>  mds_dispatch+0x10a/0x690 [ceph]
>  ? calc_signature+0xdf/0x110 [libceph]
>  ? ceph_x_check_message_signature+0x58/0xc0 [libceph]
>  ceph_con_process_message+0x73/0x140 [libceph]
>  ceph_con_v1_try_read+0x2f2/0x860 [libceph]
>  ceph_con_workfn+0x31e/0x660 [libceph]
>  process_one_work+0x1cb/0x370
>  worker_thread+0x30/0x390
>  ? process_one_work+0x370/0x370
>  kthread+0x13e/0x160
>  ? set_kthread_struct+0x50/0x50
>  ret_from_fork+0x1f/0x30
> task:kworker/u113:2  state:D stack:    0 pid:54267 ppid:     2 flags:0x00=
004000
> Workqueue: ceph-msgr ceph_con_workfn [libceph]
> Call Trace:
>  __schedule+0x3a9/0x8d0
>  ? bit_wait_io+0x60/0x60
>  ? bit_wait_io+0x60/0x60
>  schedule+0x49/0xb0
>  bit_wait+0xd/0x60
>  __wait_on_bit+0x2a/0x90
>  ? ceph_force_reconnect+0x90/0x90 [ceph]
>  out_of_line_wait_on_bit+0x91/0xb0
>  ? bitmap_empty+0x20/0x20
>  ilookup5.part.29+0x69/0x90
>  ? ceph_force_reconnect+0x90/0x90 [ceph]
>  ? ceph_ino_compare+0x30/0x30 [ceph]
>  iget5_locked+0x26/0x90
>  ceph_get_inode+0x45/0x130 [ceph]
>  ceph_readdir_prepopulate+0x59f/0xca0 [ceph]
>  handle_reply+0x78d/0x7f0 [ceph]
>  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
>  mds_dispatch+0x10a/0x690 [ceph]
>  ? calc_signature+0xdf/0x110 [libceph]
>  ? ceph_x_check_message_signature+0x58/0xc0 [libceph]
>  ceph_con_process_message+0x73/0x140 [libceph]
>  ceph_con_v1_try_read+0x2f2/0x860 [libceph]
>  ceph_con_workfn+0x31e/0x660 [libceph]
>  process_one_work+0x1cb/0x370
>  worker_thread+0x30/0x390
>  ? process_one_work+0x370/0x370
>  kthread+0x13e/0x160
>  ? set_kthread_struct+0x50/0x50
>  ret_from_fork+0x1f/0x30
>=20
>=20
> On Fri, 2025-08-08 at 15:08 +0800, Zhao Sun wrote:
> > A deadlock can occur when ceph_get_inode is called outside of locks:
> >=20
> > 1) handle_reply calls ceph_get_inode, gets a new inode with I_NEW,
> > =C2=A0=C2=A0=C2=A0 and blocks on mdsc->snap_rwsem for write.
> >=20
>=20
> Frankly speaking, it's hard to follow to your logic. Which particular mds=
c-
> > snap_rwsem lock do you mean in handle_reply()?
>=20
> > 2) At the same time, ceph_readdir_prepopulate calls ceph_get_inode
> > =C2=A0=C2=A0=C2=A0 for the same inode while holding mdsc->snap_rwsem fo=
r read,
> > =C2=A0=C2=A0=C2=A0 and blocks on I_NEW.
> >=20
>=20
> The same here. Which particular mdsc->snap_rwsem lock do you mean in
> ceph_readdir_prepopulate()?
>=20
> > This causes an ABBA deadlock between mdsc->snap_rwsem and the I_NEW bit.
> >=20
> > The issue was introduced by commit bca9fc14c70f
> > ("ceph: when filling trace, call ceph_get_inode outside of mutexes")
> > which attempted to avoid a deadlock involving ceph_check_caps.
> >=20
> > That concern is now obsolete since commit 6a92b08fdad2
> > ("ceph: don't take s_mutex or snap_rwsem in ceph_check_caps")
> > which made ceph_check_caps fully lock-free.
> >=20
> > This patch primarily reverts bca9fc14c70f to resolve the new deadlock,
> > with a few minor adjustments to fit the current codebase.
> >=20
>=20
> I assume that you hit the issue. I believe it will be good to have the
> explanation which use-case/workload trigger the issue and which symptoms =
do you
> see (system log's content, for example).
>=20
> Thanks,
> Slava.
>=20
> > Link: https://tracker.ceph.com/issues/72307 =20
> > Signed-off-by: Zhao Sun <sunzhao03@kuaishou.com>
> > ---
> > =C2=A0 fs/ceph/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 26 +++++++++++++=
+++++++++----
> > =C2=A0 fs/ceph/mds_client.c | 29 -----------------------------
> > =C2=A0 2 files changed, 22 insertions(+), 33 deletions(-)
> >=20
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 06cd2963e41e..d0f0035ee117 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1623,10 +1623,28 @@ int ceph_fill_trace(struct super_block *sb, str=
uct ceph_mds_request *req)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rinfo->head->is_target) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /* Should be filled in by handle_reply */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 BUG_ON(!req->r_target_inode);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 in =3D xchg(&req->r_new_inode, NULL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 tvino.ino =3D le64_to_cpu(rinfo->targeti.in->ino);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 tvino.snap =3D le64_to_cpu(rinfo->targeti.in->snapid);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * If we ended up opening an existing inode, discard
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * r_new_inode
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (req->r_op =3D=3D CEPH_MDS_OP_CREATE &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 !req->r_reply_info.has_create_ino) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* This should never ha=
ppen on an async create */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(req->r_del=
eg_ino);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iput(in);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in =3D NULL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 }
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 in =3D ceph_get_inode(mdsc->fsc->sb, tvino, in);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (IS_ERR(in)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D PTR_ERR(in);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto done;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 }
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 in =3D req->r_target_inode;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 err =3D ceph_fill_inode(in, req->r_locked_page, &rinfo->tar=
geti,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NULL, session,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (!test_bit(CEPH_MDS_R_ABORTED, &req->r=
_req_flags) &&
> > @@ -1636,13 +1654,13 @@ int ceph_fill_trace(struct super_block *sb, str=
uct ceph_mds_request *req)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (err < 0) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err_clie=
nt(cl, "badness %p %llx.%llx\n", in,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ce=
ph_vinop(in));
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_target_inode =3D=
 NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (in->i_s=
tate & I_NEW)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 discard_new_inode(in);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iput(in);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto done;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 }
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 req->r_target_inode =3D in;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (in->i_state & I_NEW)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlock_new_=
inode(in);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 230e0c3f341f..8b70f2b96f46 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3874,36 +3874,7 @@ static void handle_reply(struct ceph_mds_session=
 *session, struct ceph_msg *msg)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 session->s_con.peer_features);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&mdsc->mutex);
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0 /* Must find target inode outside of mutexes =
to avoid deadlocks */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rinfo =3D &req->r_reply_info;
> > -=C2=A0=C2=A0=C2=A0=C2=A0 if ((err >=3D 0) && rinfo->head->is_target) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 struct inode *in =3D xchg(&req->r_new_inode, NULL);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 struct ceph_vino tvino =3D {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .ino=C2=A0 =3D le64_to_=
cpu(rinfo->targeti.in->ino),
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .snap =3D le64_to_cpu(r=
info->targeti.in->snapid)
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 };
> > -
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /*
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * If we ended up opening an existing inode, discard
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * r_new_inode
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (req->r_op =3D=3D CEPH_MDS_OP_CREATE &&
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 !req->r_reply_info.has_create_ino) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* This should never ha=
ppen on an async create */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(req->r_del=
eg_ino);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iput(in);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in =3D NULL;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 }
> > -
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 in =3D ceph_get_inode(mdsc->fsc->sb, tvino, in);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (IS_ERR(in)) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D PTR_ERR(in);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&session->s_=
mutex);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_err;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 }
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 req->r_target_inode =3D in;
> > -=C2=A0=C2=A0=C2=A0=C2=A0 }
> > -
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&session->s_mutex);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err < 0) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 pr_err_client(cl, "got corrupt reply mds%d(tid:%lld)\n",
>      =20

