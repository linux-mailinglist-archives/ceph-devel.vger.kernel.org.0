Return-Path: <ceph-devel+bounces-4176-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBA5CBF9C6
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Dec 2025 20:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A662304D56B
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Dec 2025 19:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054E831B102;
	Mon, 15 Dec 2025 19:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AHpeBozO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197592D9796
	for <ceph-devel@vger.kernel.org>; Mon, 15 Dec 2025 19:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827786; cv=fail; b=NZgeJ6TjVFXFckCq+4pYKBIdcfMJiA2j2rlvOPF40YdRMbkReWRdBPCSlfrgEkvYS1YtM1/i9iGp3FEHU1iUNNrjGUJjYWAe5g877WWN4rpZg0qcFFlpwW3aWNJwdYc0/D62d6GBuFtLqtT+bHtSEmsqyeysHnkb/WvcQlrsZOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827786; c=relaxed/simple;
	bh=2cpj/yFdFtc4Wa85NwOuOfXm2NuYv6s5A6ov3yqZBC4=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=fpWrXuuKndGxOXLsjQQeIHF41F3tBPzM5hnLWBlN+A9lFPqF8gNQhAjb1aNucbap3qiZF6nMeSaICrXKU9/HQT66mxVf2pCPjyvEvo0W+nXNTPWde+90mwPskid08d8N19ejv1IVTgq4C6E5AQSeQnK+/DwZnGqjShXPrWyol74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AHpeBozO; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFD2Qg8018120
	for <ceph-devel@vger.kernel.org>; Mon, 15 Dec 2025 19:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=QRsh5zUWFOiC0fL8bfXTexFgL9h/mRXoLZ8A7XrPlHs=; b=AHpeBozO
	QaZOlykJiOQ35BrHPOrFDW3H5JrOrVCzA3slVXXSMfs6tSSKm99gKdEJKpNIG6o7
	6wWw8uV+KSHzkg/4Yk6Cpq4ghcHupXbVsP520kPFfbJ8B4vdI3dfFedXj6159GJs
	Pv1Hqzoo5zFz2FO+D0vfO8RfwK2S1WMJGpw4M/f3mXFHt+wPcvWVR8h0QsXTZq8N
	rgNiWpQmtxtkI1UeF6xw+bsU/7K8tdrVBhp+oPK9K3imd7UKBjr9C6LDjNLzDRrX
	Zg52R5NMPhUb7NsRX6CRewPbFzyZ3GAkyfS+w2+bXfqd8eEKyQp8hbLpEBjXhkhX
	SnueMrqqbrIWlw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yvb3ntf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 15 Dec 2025 19:43:02 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BFJWT9N029546
	for <ceph-devel@vger.kernel.org>; Mon, 15 Dec 2025 19:43:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yvb3nta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 19:43:02 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BFJalrd005311;
	Mon, 15 Dec 2025 19:43:01 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011018.outbound.protection.outlook.com [40.93.194.18])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yvb3nt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 19:43:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImBl3XEBgKBpusjAEPDiavB1RBO5WZE2rEBm4sAjCZUxF77+iiLQ6fUCYLYkdHx3Qmp9YFwoeSfzhwpUoyeENesy2U1Ivy5mvJbAyC3e1KCvcQblW4Fm0QAduEherhfYflljRatBTxQdJ/X0YvOJlitCF2Xwp8ZlncwGYKeEspH1bOvriCPXM/ks6aGwJsXKk9kGrrBn686tbs7YfYnIoIZgXT3bwWFC3UFyTqzb2wCV+wNd5Odg0SMwi6bUVsXIe1FtBHjoYqFvx1b+ET0ZGNMXO97ZZQuJA9/w67trDgmNG3gAEzsC6rUmucfelmvEK3CriVSHWUWkD58XpeZqTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwrSxpjnrRYYonx9zTLEF5azD+1i/dW9sfYvvpla0J8=;
 b=xZjb1GhGiuGHnHhXtj6bs8yKWPPXrmqR04O0H78AwWi3AFwfFgs2wLjs04fr4In6NbBeD69op8ksUXjiUu+0y+kbq9he9Fue40WN5X4QnMGEizRLEr0lK4wBE5kPzNfTAoOYugMeLqtjYA4y9HvVANhrjv2x+vDU2rcIR3LKD/bmlX1CAYhQCspNYMxTyLHPIE1CL24RdtgYSAhr+Ez8eBdhgPU3aaXaolJcvAOiYQ11jy1OCI08VYtY5h0Jz3odKgO247RMXzWm5xGTAk8Ro8qEE3Sg2XsfnI3KlIrsNZi51jANNRoh+gv+b8AdUKLptiRten8ldI/yKqduuEIl4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS0PR15MB6093.namprd15.prod.outlook.com (2603:10b6:8:12c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Mon, 15 Dec
 2025 19:42:56 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 19:42:56 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "malcolm@haak.id.au" <malcolm@haak.id.au>,
        "00107082@163.com"
	<00107082@163.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "surenb@google.com" <surenb@google.com>
Thread-Topic: [EXTERNAL] Re: RRe: Possible memory leak in 6.17.7
Thread-Index: AQHcalYDU1NctrlESU+S2CMf8hQ3tLUjIVeA
Date: Mon, 15 Dec 2025 19:42:56 +0000
Message-ID: <8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
References: <20251110182008.71e0858b@xps15mal>
		<20251208110829.11840-1-00107082@163.com>
		<20251209090831.13c7a639@xps15mal>
		<17469653.4a75.19b01691299.Coremail.00107082@163.com>
		<20251210234318.5d8c2d68@xps15mal>
		<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
	 <20251211142358.563d9ac3@xps15mal>
In-Reply-To: <20251211142358.563d9ac3@xps15mal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS0PR15MB6093:EE_
x-ms-office365-filtering-correlation-id: 9117f7f9-0442-4196-6b67-08de3c122547
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QlhSUFFXTkFaZmUwTVpHUjN4NVUwTVRsdk9TL2oxWTdKaW5TcEdnS1RDcVpa?=
 =?utf-8?B?VkJVYnNvcnR4SFY3c2FBWmNwRFQ1VWRTblBsa2VLWG8xZ21PLzJQbFljazZj?=
 =?utf-8?B?aTIwejJaVUx1UlE5N3doRE1LY0J2aUg1aEpjcHlVWWpvM0t3ZzNtaUxMcnpQ?=
 =?utf-8?B?SEpUc0xxallCcnZxNHRkQ3FlY2w3bkVjamUxbTUrTDBKS0pIbnNYME9GZ3oy?=
 =?utf-8?B?VmJiRm92VCtPMWxrbjZrRlE5WkdZL3FGUUYrd1lTRXplZndQNWJ3QVkvcUdi?=
 =?utf-8?B?VmlkRm5FakJvSzJLMG1yb0RRY3ByWkZ3SUhETERBRHEyczhFNnJxQ3RjMmRX?=
 =?utf-8?B?ZEowOFZBbG1DbnV2N00zZCt5NGU2Mld0bklTVG5QakFXazV4eUFMZnNBZzM3?=
 =?utf-8?B?WER3UTBpL0doM253WDlMSE8yUmU1UGg1czdja0NPanlicjFQUktrQk9MMGFS?=
 =?utf-8?B?TnBCYWZXbnR6N3dzMTl0c0V5RnkzUDNHSEJzKzlKVjJLSHdLQzN0VHVZQk5P?=
 =?utf-8?B?Qkl0RURNbVdXT2ZNSTE1SmJXOVdoVXF4SGg5UmVJK1c4OWRuRnNkNDg2eFV0?=
 =?utf-8?B?S1ZHRGZhaWc4VHZMQnZ0Qjd1RDMxK2pZSXZkd014TTJzcVJmQ295M2NHY3B3?=
 =?utf-8?B?ZVhUeW50Qy9nOGd3UnU2M2VJMDZaTnc3aUp3cUI4VG1JNzRHeEN4amt4K1Uy?=
 =?utf-8?B?QXFsWHl1L2dXYVUyaTBraGtXdCs4Q2VTZ0xiWDZsV2xKWEtYUDlKT3NwZDEw?=
 =?utf-8?B?Nkx4SmUzNmRwVTB1ZFJaTDk0QTNZdzNENjJUZ2o4RHNwWmQxMFVOQitjNTFW?=
 =?utf-8?B?SmZLb015d3J4WE9wYmR5bFhXQWE3RUZ1QUllWHNvQ3hkdDNwRE1xKzJLMXFx?=
 =?utf-8?B?OTFNYjFWbTJoMGdYTGpOTjhVdmpRUmZzVFZ1NjEyNGtoWmZ1eGtqVnliMHV5?=
 =?utf-8?B?a0htTlA3Q1VrUmxURUQ4M0ZZWkwzais5aXFpYnJpczhXQUpVOVk3NG0zcEtM?=
 =?utf-8?B?U2o0Q2VzUW5GZE9PdG00M3FscUlQMFpTTHpyNURvSWVnNmY5NWxqOVEvZm9y?=
 =?utf-8?B?bG15dmR6RHpZQlE0N1hsNjRDVHMvdWY0dDhyL21ZUFN6ZjFtZmJ5alZ5STNv?=
 =?utf-8?B?dEh6T2ZSL1UzNFR2RWtpL0hONUpyNzM0U0JKUS9pMHB3Q2RKRU5qRkUxZHMz?=
 =?utf-8?B?dDMzOHN1MSswSUkyWXNHYVYyR0N1T2JEbFdLOEsxcmYxclpJUFJaM2IrNUtu?=
 =?utf-8?B?UUE2U3VDVm9PVy9BeFBzUmZhKzNvR042RUY4ZkNJR2RNdVFod0lIQTlGSStr?=
 =?utf-8?B?a2lXMmNKQWFRYWM0M2pXWXJ4NElqVmFjU25YT3plaVkvaSt4ZWhscks4ckxV?=
 =?utf-8?B?am9KdXBuRThudS9pUEhDd2kybExUblg1c3ppRVVrTllPTnhvUE56ZFdIVWxU?=
 =?utf-8?B?NFRTYmprczBlSkFhQnQ2NVh5MkhjVGJtbnNxWEtPMFVHUUJpbjNlU0lQWXQz?=
 =?utf-8?B?RkQyZDBCeDlibEx2L04vS2ZJemhjaEhsYjVsSzU1K3hRdTg3eGJ5WDB3R3Yz?=
 =?utf-8?B?emlRNmFqZjJtWWJYRkpDSjJBbm5LODJpSE1veU4ydmJYaGlWdmJHcHpPb3p0?=
 =?utf-8?B?UlB3R3U2Vy9EYVk4QVpHV3FNd2hUQmEwQnhJM0Q1SDZrdXJIZlU3M1FvUlZW?=
 =?utf-8?B?UWlmbHRSTHdmR1VPS1orOW9FUnFnMWx0MG5TNm1PV01uZlZmVkxFaVRremQ2?=
 =?utf-8?B?TXk0QnFPMHFvblJpQW5hUWxwcjlDSXBZL2g2c1hnL2pJWDhmTTZURFVlSHpN?=
 =?utf-8?B?V2h0YzFIRVhiZTJ0b3E3Qm9rcU50U2tHajJyTWdMOVV6UVViV0pjZTRpa2Vl?=
 =?utf-8?B?cytCVHdObzNlOXdlZjU1M3hGTTdDTGNYRkU4OFZmTmVXR1ljUDQzUDhaVUs2?=
 =?utf-8?B?M1Z6QWVaNHJFQ2Vmb3NiOXlDRUduWU5CRGNQYXBnc0l5Q1crWERUUXQxM2Nx?=
 =?utf-8?B?ODRhUlJqY0ZWY0lLMVRIYitvMllwcFRwUE5VTXhSVkh3RXlzOWVoZGRwWmhm?=
 =?utf-8?Q?9vuD/H?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0tqV3VWMmNwdW5OVGN1eTUxUTVadXl2cXJFYmlON3ZELzFJY2tpR0tkZEhP?=
 =?utf-8?B?OWxya3ZUR1owWFRXY1g1SmFkcTN3UGdIa3Q1SCthaVpUZWtRQWVhS0I4U3Fk?=
 =?utf-8?B?YzNpSWpCVk1RWkRiYzRUdHhFUjVjcmpGMGVWbzVkMkgxbzJZZlBHd002YzBH?=
 =?utf-8?B?bGNFdnkweDcrdmd2TmMvejZ4TVFPOC9nMjROeFpUYXNFUkJvcDNodWpYTkc3?=
 =?utf-8?B?SzVzcGsyWWRXM2RYcXBDeDE5OWFqK3VURVRheEIxU0xqc3AwWERlWUh4WEpw?=
 =?utf-8?B?L2hRYnFBSXg0ajNSVkNtWFhKaHUzdUxCZ0IvN1hMMVRKcTZQMHg2MlhBVHZk?=
 =?utf-8?B?c1Bzc09saW5aUFNGYURXcnlEK3JXR080eDc3QTNPMThGbHlWeTVoNkpLS2hn?=
 =?utf-8?B?TTRucTRIQWpISjFFN0JBUGxENytiWFhXa3F0Vjl6eTZkWERseWY2K3RZVGJ5?=
 =?utf-8?B?K2pPczNuZkhPL3g1MW9NN3FldkVFOGNVNHBtQzF6VlAyTE1uUmt5bzhVUFNj?=
 =?utf-8?B?V1hKc2FCTjRMNlFEam5Jak01Y1VQQ1ZYZ3J6VlUweTFrb0g5b1ZmMW9nSjhl?=
 =?utf-8?B?K3o5ZE1pMEhQaDR2c3RhN011cnMyVDR5ajFMYkFWYlJOaVVISFNIakFlWEh1?=
 =?utf-8?B?MDJ6ejNDZ2pUMXlIR3B2VndGL3BRMmc2WFdZZWx4ZXdMVGpmaUxsUTdqWnBk?=
 =?utf-8?B?VXlKVTNEcFdpdW42ZGFONXd2c1o5bVQ3VmZPbllFVnhVS2MrdDRhT3hVR1Zn?=
 =?utf-8?B?UFhPS0YvOVZuYWkyR05RZmp0eitJTFZuVStwQ1dQaTdYSTlFVjBJRlRkU1pi?=
 =?utf-8?B?RFdWOU90SWFMNmkrcUo1UnlneHIzcVExUmFNRXBjVW1wVnlPNkZ4UG9Oc0pB?=
 =?utf-8?B?WTJ1OHJpV1A4MlNhZC9ocnlLbVI4dCtMVFU3ZmEzSzZ3UGhBQzQzVENoMVlw?=
 =?utf-8?B?dWQyUWZXQzZVWkpybmFaYzFWMktzOHhOcm1qQ0FUS1JYbWFHamhycXAvcDYz?=
 =?utf-8?B?YjFWbXNmeXlvalg3M1J3R0Evb1lQNzc4RUdFYUQwTGh6OGtJUEJOd0dJZjMv?=
 =?utf-8?B?ZVZzVTRxYTArYzVycHlUbXJ0engycGkrN1VtenVXMFg5WjhobGRJcmVoaWR6?=
 =?utf-8?B?YjRJdjlJaVBVZlVNbkZnTmJVVmhGWFNNMDlvY0EySHNvWGFOL0laK2V4ZDh2?=
 =?utf-8?B?M3cxRDF6WmE3RkozakczbjRldk1hMExvKzlaUTVtMC9TaWM5cEd4bk96STJ2?=
 =?utf-8?B?SGFnL3dSY3NaaGRpRTg5VVl5S2hRYmZzV2RIbGpNOUZ1TWYwWXplVklzaE01?=
 =?utf-8?B?ME56STY4d3Y2Y2R5WFpsdUpHVWEzSXhsakxYVG5CcHhvUldpc1BER2k3NXFa?=
 =?utf-8?B?QlQyUWlmT1Fzb2NvekpPTVpDd0ZMemRSVEhxQk5JWUM5RXlSV3l4WlF5dnUw?=
 =?utf-8?B?a1AvRll3Z216U2NvT3ZZTERWaEVvNG1LREs1TldCVG1IeHVXYWJDc3JHYU8x?=
 =?utf-8?B?RVRwRVJuR3RkMlVHNTNiQWtPVHdSWUY5c01jUk1qaUtIbXVkNmRuMVpmTERG?=
 =?utf-8?B?ZVRuZWdyeGZYVW4wVkFLM3Q1ZTBnVThLZ1c1MnF1T2RlMTVDMnZGVDlFOEg3?=
 =?utf-8?B?Sk51dEIreHRjNit1eUNPV1dPSVNFU1ZnblNuRHRkV1ZKUDFYcFNSd09YTGw0?=
 =?utf-8?B?R01rWFZiakRLSmpuTHp5NzdGdU5KQkJEOG1sZFBTbm9DNFlEN3ZGQkZ5Z2hG?=
 =?utf-8?B?akxTZkxRM2JPK0tvd3BlU29pUTFpSXgxR3JRN0xuOFN0cGxFM1BIV3N4aGpP?=
 =?utf-8?B?SzhZbklCR1RBNVlUSk1kaHFQa2JuQVZyVDFyVkQ0RkQwUFR0VkNlTnpDVVVj?=
 =?utf-8?B?cGdoeHJ1R0tjenhnd21VR01XK01yOU1LQmVFQ1dmV0ZVWXpmQXNZYUgyenln?=
 =?utf-8?B?STFrZzMzWDRoclEzRWNjYWE1VXZrUmpmSWhsamJCRzV1dDFvQmN0djBUT3p5?=
 =?utf-8?B?YlZwK09ZOUZiU1p5YVF2cFRmMHBZc3BuakQrd3N1ZVlzakVoR2VQRkxsSEM0?=
 =?utf-8?B?WVAwc0ZJZXlESStKbyt1L21IZlVaMmlodWptL3FWcURKbjl4Smo1eGRYMUpi?=
 =?utf-8?B?NE1sdEZLMXRzb0lkTlhNOHpld0FnTFlMV0tDVXFHS0hhcW03QzZnbWkyUllR?=
 =?utf-8?Q?s3FrwdQVAQododws8muARJc=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9117f7f9-0442-4196-6b67-08de3c122547
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2025 19:42:56.5442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f8eRXNkT7cWjSDxaBDZaGfKONiIbwK1I09iuPl4oDXBHdqd4/xXfdKOMFcEYgq6dtjuTSLWnsRpqXCt0PRQekw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6093
X-Authority-Analysis: v=2.4 cv=V/JwEOni c=1 sm=1 tr=0 ts=694064c6 cx=c_pps
 a=jA10WLhXiBAWrDGJQFCh7w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8
 a=xOX-IIiaxov_uOVt2iYA:9 a=QEXdDO2ut3YA:10 a=_HJTmwTDQgIA:10
X-Proofpoint-GUID: uGMi-eMTRgON6ryyHl1LNxQiISili08S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfX1fESk8bN9Z5O
 N2JPlDzzmQPlfCs0Po7Wh0h2AMtbGcnrZEfrBYh0Clsvjvq4vfsI8x5ng1tHPo5/itA/u84RW97
 dbu3stBMPPafuhZmRP5HD6jjo4GRRY0GA4Gj+U8BsEtWTldY87SucHKhxvZP9l/MPXpbK+w3KGb
 QtdAroC7YSOoKYiq7So54J8gQTlg2u13arw0/te2vXDcMwvhAKuc3UwfLWXJ1N9XmooDRjjRirn
 eY1KX+sPjJnjE1d7FQD1n7wGXkaBd9vD5KEZHlYzK5yx2J/jGCqon5/PCUXAdlI2hNZVWE+cLaW
 DpT7/MfvnSejAV+gk6E5DSqsETyqxqXubsDAPQIs3F9+OyvSS9woWl88fTKGfLGi2fgaDeEGdTW
 GsjSJRVlOer8wwEWvhFxoY1ctFyHWg==
X-Proofpoint-ORIG-GUID: S1GotUYUmvGSDNN96mY0u6YQ0sD2t-ri
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CB5CE9AEDA18C45B5BBED756C3AEC7B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: RRe: Possible memory leak in 6.17.7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_04,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2510240000 definitions=main-2512130023

Hi Mal,

On Thu, 2025-12-11 at 14:23 +1000, Mal Haak wrote:
> On Thu, 11 Dec 2025 11:28:21 +0800 (CST)
> "David Wang" <00107082@163.com> wrote:
>=20
> > At 2025-12-10 21:43:18, "Mal Haak" <malcolm@haak.id.au> wrote:
> > > On Tue, 9 Dec 2025 12:40:21 +0800 (CST)
> > > "David Wang" <00107082@163.com> wrote:
> > > =20
> > > > At 2025-12-09 07:08:31, "Mal Haak" <malcolm@haak.id.au> wrote: =20
> > > > > On Mon,  8 Dec 2025 19:08:29 +0800
> > > > > David Wang <00107082@163.com> wrote:
> > > > >   =20
> > > > > > On Mon, 10 Nov 2025 18:20:08 +1000
> > > > > > Mal Haak <malcolm@haak.id.au> wrote:   =20
> > > > > > > Hello,
> > > > > > >=20
> > > > > > > I have found a memory leak in 6.17.7 but I am unsure how to
> > > > > > > track it down effectively.
> > > > > > >=20
> > > > > > >      =20
> > > > > >=20
> > > > > > I think the `memory allocation profiling` feature can help.
> > > > > > https://docs.kernel.org/mm/allocation-profiling.html =20
> > > > > >=20
> > > > > > You would need to build a kernel with=20
> > > > > > CONFIG_MEM_ALLOC_PROFILING=3Dy
> > > > > > CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=3Dy
> > > > > >=20
> > > > > > And check /proc/allocinfo for the suspicious allocations which
> > > > > > take more memory than expected.
> > > > > >=20
> > > > > > (I once caught a nvidia driver memory leak.)
> > > > > >=20
> > > > > >=20
> > > > > > FYI
> > > > > > David
> > > > > >    =20
> > > > >=20
> > > > > Thank you for your suggestion. I have some results.
> > > > >=20
> > > > > Ran the rsync workload for about 9 hours. It started to look like
> > > > > it was happening.
> > > > > # smem -pw
> > > > > Area                           Used      Cache   Noncache=20
> > > > > firmware/hardware             0.00%      0.00%      0.00%=20
> > > > > kernel image                  0.00%      0.00%      0.00%=20
> > > > > kernel dynamic memory        80.46%     65.80%     14.66%=20
> > > > > userspace memory              0.35%      0.16%      0.19%=20
> > > > > free memory                  19.19%     19.19%      0.00%=20
> > > > > # sort -g /proc/allocinfo|tail|numfmt --to=3Diec
> > > > >         22M     5609 mm/memory.c:1190 func:folio_prealloc=20
> > > > >         23M     1932 fs/xfs/xfs_buf.c:226 [xfs]
> > > > > func:xfs_buf_alloc_backing_mem=20
> > > > >         24M    24135 fs/xfs/xfs_icache.c:97 [xfs]
> > > > > func:xfs_inode_alloc 27M     6693 mm/memory.c:1192
> > > > > func:folio_prealloc 58M    14784 mm/page_ext.c:271
> > > > > func:alloc_page_ext 258M      129 mm/khugepaged.c:1069
> > > > > func:alloc_charge_folio 430M   770788 lib/xarray.c:378
> > > > > func:xas_alloc 545M    36444 mm/slub.c:3059 func:alloc_slab_page=
=20
> > > > >        9.8G  2563617 mm/readahead.c:189 func:ractl_alloc_folio=20
> > > > >         20G  5164004 mm/filemap.c:2012 func:__filemap_get_folio=20
> > > > >=20
> > > > >=20
> > > > > So I stopped the workload and dropped caches to confirm.
> > > > >=20
> > > > > # echo 3 > /proc/sys/vm/drop_caches
> > > > > # smem -pw
> > > > > Area                           Used      Cache   Noncache=20
> > > > > firmware/hardware             0.00%      0.00%      0.00%=20
> > > > > kernel image                  0.00%      0.00%      0.00%=20
> > > > > kernel dynamic memory        33.45%      0.09%     33.36%=20
> > > > > userspace memory              0.36%      0.16%      0.19%=20
> > > > > free memory                  66.20%     66.20%      0.00%=20
> > > > > # sort -g /proc/allocinfo|tail|numfmt --to=3Diec
> > > > >         12M     2987 mm/execmem.c:41 func:execmem_vmalloc=20
> > > > >         12M        3 kernel/dma/pool.c:96
> > > > > func:atomic_pool_expand 13M      751 mm/slub.c:3061
> > > > > func:alloc_slab_page 16M        8 mm/khugepaged.c:1069
> > > > > func:alloc_charge_folio 18M     4355 mm/memory.c:1190
> > > > > func:folio_prealloc 24M     6119 mm/memory.c:1192
> > > > > func:folio_prealloc 58M    14784 mm/page_ext.c:271
> > > > > func:alloc_page_ext 61M    15448 mm/readahead.c:189
> > > > > func:ractl_alloc_folio 79M     6726 mm/slub.c:3059
> > > > > func:alloc_slab_page 11G  2674488 mm/filemap.c:2012
> > > > > func:__filemap_get_folio =20
> >=20
> > Maybe narrowing down the "Noncache" caller of __filemap_get_folio
> > would help clarify things. (It could be designed that way, and  needs
> > other route than dropping-cache to release the memory, just
> > guess....) If you want, you can modify code to split the accounting
> > for __filemap_get_folio according to its callers.
>=20
>=20
> Thanks again, I'll add this patch in and see where I end up.=20
>=20
> The issue is nothing will cause the memory to be freed. Dropping caches
> doesn't work, memory pressure doesn't work, unmounting the filesystems
> doesn't work. Removing the cephfs and netfs kernel modules also doesn't
> work.=20
>=20
> This is why I feel it's a ref_count (or similar) issue.=20
>=20
> I've also found it seems to be a fixed amount leaked each time, per
> file. Simply doing lots of IO on one large file doesn't leak as fast as
> lots of "small" (greater than 10MB less than 100MB seems to be a sweet
> spot)=20
>=20
> Also, dropping caches while the workload is running actually amplifies
> the issue. So it very much feels like something is wrong in the reclaim
> code.
>=20
> Anyway I'll get this patch applied and see where I end up.=20
>=20
> I now have crash dumps (after enabling crash_on_oom) so I'm going to
> try and see if I can find these structures and see what state they are
> in
>=20
>=20

Thanks a lot for reporting the issue. Finally, I can see the discussion in =
email
list. :) Are you working on the patch with the fix? Should we wait for the =
fix
or I need to start the issue reproduction and investigation? I am simply tr=
ying
to avoid patches collision and, also, I have multiple other issues for the =
fix
in CephFS kernel client. :)

Thanks,
Slava.

