Return-Path: <ceph-devel+bounces-4226-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB80CDACA4
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 00:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67AA930115CA
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 23:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56EFB248176;
	Tue, 23 Dec 2025 23:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PDMNkWqE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90953F50F;
	Tue, 23 Dec 2025 23:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766530899; cv=fail; b=Q4oR2kJ1P2Zti+eOwUEjk5bCxJRS51DLIHb/a3G/mwkWHu/z+22ofXDr5a5GgrSTkMa6J1Rd9kN+UKWKl6BdG18ETGINmIsHjxcJ0vwCj6TEF8XTeJcPqzPp+PdLII21qCRep51hYfjRgDRpv1uxdoSmv7gwxpKZ/ZAd7spcaLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766530899; c=relaxed/simple;
	bh=8ij0kdpBVnNWVyKBQwmqf83pvIsyAqVnl4yRm9OzVIk=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=L6p/cGKehSScL6hWyLTqPf2v6Zl9YId4SFxzfFBPpKVPqAsTxJBHI9EulLLLMuXlh8fE/SzdXHx8O6u4XF+yh9elo7ZKaQrkY0ljKVQ6w4DhHyK46e0gKqNakNi/Y5O0DTTgZXPz8/f+lu2rhX8wUnOFa6+hQadfsnaw1U9VSbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PDMNkWqE; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BNDC5t9014884;
	Tue, 23 Dec 2025 23:01:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=8ij0kdpBVnNWVyKBQwmqf83pvIsyAqVnl4yRm9OzVIk=; b=PDMNkWqE
	ZTE1BH7ybv/1eK82JV0sZrMAvcLRVKNSexjT+aMt1U1C5gn52yV3Qlr98CdOpg4Q
	Kl8WiFFSaMoyGGz8iPdugykLh0gOSnB7UwFh58I3tvUxEtvl4KmK7hS0b6fHLyvO
	awFUdxBDbtr/Cpgf5k/NTv0s3Nd4x5ok3v/gzQGUIlIeZ/6GI3WtRDTonSAReJIi
	Fu5dFsLLLtJB5qfVo0CqpIEyWN7LKqS3cro+y+e0HPXy/jfoQ+ap1DWI9p+GzrLQ
	XXA0FVbFvgJJ2fHs/CKHNBW2GoWhSkq8UNsEpJ3wwG38JEnhIwjfnxsES65qIJke
	N9avpIfrOvCIEg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kfq6yt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Dec 2025 23:01:34 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BNN1Ytl007679;
	Tue, 23 Dec 2025 23:01:34 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kfq6yt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Dec 2025 23:01:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vasffHrQSoNRiEZ2WKPOfoCeBXmmUYtyE5PTyrzQGqKDpMUxU4MnPpSAysfR00mk6+XHG3yJEa+tZ2TKnAoY5yU+3yyO2jpPIoCoXbud1JWbMEcwW63NNsB2YZyYJfYhfLPHW6O6Pz/182gz9C095k6GRIojGX7Gc9XGeCE0Y2A/Pm/Rep5eVk/eGtRgKdtIJWw0amfoD5fmvoTJNe2UtyIGvTEiGzS5/3Wz9MQhG7GddgdQEV3OqTQhEdY7JRS5jjNC8uw/sKeCbipBX6ZYZiUnat/SO4SAUGGv5Wx0cGuAfDUyU0Wmb8EUTWZMzhuyScehyC/famoK1V6Z38CZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ij0kdpBVnNWVyKBQwmqf83pvIsyAqVnl4yRm9OzVIk=;
 b=uVXohOH0dfICaLHbgBnT3KIzS65jjAGyF/av1D3rJBtGfIKXC1NCc62BAq8Ukktk2in7I19q9LRHAM2DiT1HxB7yzkyX10Y/wkCegHxY/lxw4KJqcInLzhDxNzSurQSvRpxGApBeo/Mmk6MjtSN/kk+ToK3BO8K5vB2SOZzcTHFALr/ocVcItttvei8mM+GMDMDBs9s2oqJk+EXEkAr2mlDwBX1MhT1yT1zi/P65Omar0EpxOL4QmfG82/OhEPKqpZgvEJ9rU3lRd9BL0anwuaXARGPQ62R80nqmLpyjRnR6+AskK3Nd317Eubha17JB9SRdMI3lerKEzvKgWzrVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4742.namprd15.prod.outlook.com (2603:10b6:a03:37b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Tue, 23 Dec
 2025 23:01:32 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9434.001; Tue, 23 Dec 2025
 23:01:32 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "islituo@gmail.com" <islituo@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2] net: ceph: make free_choose_arg_map()
 resilient to partial allocation
Thread-Index: AQHccdwnlyf8KiploEK5KyjRJ+rsD7Uv3G+A
Date: Tue, 23 Dec 2025 23:01:31 +0000
Message-ID: <dc95e2dbc1293fe00aea3518443a241b890eef79.camel@ibm.com>
References: <20251220181149.46699-1-islituo@gmail.com>
In-Reply-To: <20251220181149.46699-1-islituo@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4742:EE_
x-ms-office365-filtering-correlation-id: 0e54138d-714c-457d-f86b-08de427736c2
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dkpQRTl0MXMwMjRQK1IzRmE0SU9LSFdicUNMVkZrWlZwa3lpUzhYRXQrSmg2?=
 =?utf-8?B?Q2tSeEVpS25yK1hIQkxqcjJOK2ZsbjFwcFhiYm1XT01tR2NtQWdSaGQzamI4?=
 =?utf-8?B?MndNUk0vYnBHeHpoUFRKanFTTHM1Q1NMcGtEcEhPeGJ3MlVjS1VWaEd2K0dE?=
 =?utf-8?B?TG05ZEF4a29tNEl0U1dFTHMzWlhUTkxEUmFOUDVXUzJVOEEzTWNPM3kvczdO?=
 =?utf-8?B?LzNKK2V1ZWtkalNtUndlRzhTM3BZbHVCZUlTR3VUTXRQUGtQM0JubTVCRzRk?=
 =?utf-8?B?eVZ6UVgxWnh2eUUxSXJZSXJNd2VWdndwUC8rWlR2ZUltK0JJeHRDZjNWSVlT?=
 =?utf-8?B?VzVnTUR3b1Z5SDdnWXRheWN1dmljcjk4ZWxPYXRiR1lleGJrVk5jdFoyOWdP?=
 =?utf-8?B?UTFEMGFsdTRMRWV0R216ZjROc2JVRy8zSTJSOGJTQlFrZ3FadmJidmtmQ0xi?=
 =?utf-8?B?MmlNMTV5WmsvQ3FoTlNrR3N4YlZQbGg4RXhCVmY5RlRNSFpyT25mNkYyR016?=
 =?utf-8?B?MjR5U1FvMlpld0sySndNaFdaRFpLTE9sa2hiQzZhaGtzWGVIVjg1WjBMckRX?=
 =?utf-8?B?Zm1RQTM4QUF3WTdhSGZpQzc5cDY0Szd4RWZOZFpkNHY2MWlyazNOTWVJSW5v?=
 =?utf-8?B?N25NNy9NOS8wYnpUZWVnMlFPeEJoYklvZmgzTmQrTFhraUppbnBqN2s0bEUz?=
 =?utf-8?B?YUtSY2p0bFNWSjJCb1I1S3NDWmVGaTdlTmpVRDMvS1FHTEhEd0U3N1l0RDlt?=
 =?utf-8?B?NWJudkJWdzRDcjNqRk52MWEyZVNIeXlDaXdDRlYzQmk2czVvWm1RRmVrb3Vx?=
 =?utf-8?B?SHFSNWZpOHR5OHJqRExQc01SMVdzR2ZjVjR2a2xtZFZ3WEZnTFVhbUN5WUlJ?=
 =?utf-8?B?L0UrejF4VVpQY0hDdzBvZlVxVXpVVVJacnVpNm1mWDl5bFZNOUh2ZC8vRENN?=
 =?utf-8?B?M1JMVmRFSHlvbEQ5ekVwTlhjenovS2xOZE05U3RPUGx6dkNOdGVwaFlMVzNN?=
 =?utf-8?B?N0Z0MzYzQkI2eUJXb0VGdDBkaUxPZTBZcUJ3emNVdi81ZjlQOWd1c1Nob1NE?=
 =?utf-8?B?UFI5U2RiK0JRQUl5dEtZN3ZpZVZobWwxUSs0ZXRVaDhpUUcySDZFQlB2MHVI?=
 =?utf-8?B?d0NVOUhSbG84dFdSa1FhQmpsTitpMEgxL3ZITGhDWjM2TkVwWFN2OTJFN0ha?=
 =?utf-8?B?RVpISjFQTml3UjBHdkxobG4yYVkxR080SXRDTGNOcnFLVnQ1TjVzZHpONDJJ?=
 =?utf-8?B?T3lJcmVvLzM5ZjlkSldiU0pVb1VoeTNkZno0eDhIcFFIUk5TSi9qaG5FSStP?=
 =?utf-8?B?cDNNZ0lvaVlUL2d4OVRtYUNnZWx2TGxTZWNzclRoaVp0WnlBeWJSdWtkSUhs?=
 =?utf-8?B?VDdMWTNhZ1dVQ3JvcnhQcHFoNkdQWmc1dlJjN1E4TFNvQmx5dDkxNThSYXhI?=
 =?utf-8?B?UDYrWFRGeHBBMzRXNkVhZ1MzY0pYWEhnWGd1UHFDNjVHcFY0Q0l1TFBDb3o2?=
 =?utf-8?B?bThFajdMbUhZNkNTK3JaY3h1VGZJNmtKTEN6RjJueXBINVRackdqS1gyZTg4?=
 =?utf-8?B?N2hqK0NSOTVxRngrRy94RVc0WStOR1ZZYTY0M0Z6UGxKUVJzWTF1d205L2lR?=
 =?utf-8?B?cmRMZVJna09tazJxSWNXU0E2RWY2OC9QOFFyYjRuOVJYdWdtTFpuTjhmWnVZ?=
 =?utf-8?B?czdLWmE2eEN5UG1kNlA0bVd3WGJYYkdMVVE2SXJuWlBTMVk0bG52L2UraXdM?=
 =?utf-8?B?aW96UUZwTmlIcktVd1p5bUpWK09uMnNDS21XREo0VndrdTBsdEpJYm5sQW1p?=
 =?utf-8?B?ZUExYmZ2d00xL1NERmJDUGdmbjFIR1ZQTXFyb09RVnlMQitkeFF5c1ZMWDJD?=
 =?utf-8?B?emptcmFGQlVpVWdNZjM3WHluaWFWbWR5a0xQL1lIYThXNTNGV2xiOEh4RFJD?=
 =?utf-8?B?ZjlLdEF2VnlBYXBUS05zRzVPWVpZOEdhZFpBMlcwQUxEUHd1eXFzL3FDUmZX?=
 =?utf-8?B?ZjAxcTQrU3hOZzNiejVQZDBkSXBTd3dnMnFTUENKSnBYcjh2S0FyYXdpMW5X?=
 =?utf-8?Q?Lqbn3L?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Qk11RU1haE5XUmVhU2YvRUVIS216STFPb0ZQVHBIeUlYZTduWXVxY0o3Sjcy?=
 =?utf-8?B?eGRMeDFLRFk5SURFdEcxRFZKMHVjc0g5RjVNN2hXNnR4b0pSbGNCYmhMemFq?=
 =?utf-8?B?eG9RMm1OZDAxK3pDcEdZVjFPMmRZSjVEeUQxVU5jQWEwUDZEblExdXpWTEhL?=
 =?utf-8?B?bGc3TnlTbkNuOFVpZG1NM0dFY2lKZ3FpSTFiWkpQOE9IK2k2V09OT040WEJI?=
 =?utf-8?B?cjAvTmdTZnhTbUpzZzBXUm1YRlRvSEJNdi9TV1JmejVHbEhjbWRTYk9wbHRz?=
 =?utf-8?B?ZmMxR0crd3EwcWZmbkFoLzR0cFZYdFBFQVlNR1AvN1Z5aUsxazJneWU3Yy9v?=
 =?utf-8?B?YkY1bVJPMzZVbEExYndkODhHZFVqUW1zaXk3ZUVPMktkOGQxSHNYK1hhRC9p?=
 =?utf-8?B?ZWJmR3RlMjB4UkdtUlNibDd1N2VwM3VzMkVnb0FkbWxNVjRpc3VoQkpKWXpD?=
 =?utf-8?B?SGxONmlCNDVzLzR0V0syZ0VuZ1JGd1Y1TlU2akMrMys2eDRUVTA0RlJaUXBE?=
 =?utf-8?B?TzRLY0hGWEJjWUxFN0c3RVE5TnlMNnFuTGlwQzRac3NURitNV1QzMCs4dXI3?=
 =?utf-8?B?QnZlK2JJTmJyZUZGMHZlUVhna3dLcDVySWZJYnI5aHdhUngwWGVkVGgvQmdh?=
 =?utf-8?B?QUxwK2hrYjYxeWYwZEhUSndoSEZqV0pmZi9RcTBFY2xEOHFuT2xFVTB2czhY?=
 =?utf-8?B?Zjl4SWVPQU1WaHJiQno1b2IvMXZ1K2dTZWJHMkNSSEl5enh3eHRZa0pwdmtN?=
 =?utf-8?B?OTNYbmFlZS9MREpnN0R4eVoyd3ZCQXlWZis4anVlRi8rT1owRlBxQ055eVhI?=
 =?utf-8?B?OEFXaXlQN2RBZ1c4QjNMU3BOS21oSDdIbFVnNVJpVm96M0NMeVU3eFBKWEJF?=
 =?utf-8?B?anRldlBHSkhidzkreFM0RmtIbXZDRklLaGg1OU90amUwTTgxWVFEcEVTeWt3?=
 =?utf-8?B?M1N0ajU0bTBnSTV6M3dGUk85WUZwcjVOR2lCMnRtd0FMbVM1QXVFTkNhSzJj?=
 =?utf-8?B?SFBBNUV1ajZVRElISEt0ckdqUnk4NklnT1dCRkhsTXYvS2JkTjBKRnladk9z?=
 =?utf-8?B?cldManJ6SWJxcnZZRC94VFY1emF5UGxJK1RUZ0VuaUtGNEpyQWNsblJHRi85?=
 =?utf-8?B?L2hjZUhLNVRjQUNuZFVOSTBrYUt0cVM0V2dPYmJhU0RBaTMyZ0RYQUs3QzUz?=
 =?utf-8?B?cFk1cVdKYllrNlFDbXJoaGhTN0FFS2luMUJVKzYvOVVJRnhjSmwyUnp4MVhP?=
 =?utf-8?B?dEZBVTA3bkhJYkdRekowQWRNRGV0NHhiazZDZzdUZkk2aWpNWDNrV3YzU2Vq?=
 =?utf-8?B?VHcvRDgxb3I1dzYyOThMV1MxbzkvQzVydVN3MWN3WlRzWDVtYmlmelpYbDZt?=
 =?utf-8?B?MmNlNUdsZUFYUmIzSHNpV05RY2xLYTM1VkxrQ2NBNzJENXdoRG9XKzJpaEls?=
 =?utf-8?B?OE5uMjE2akxrZkt2cW1FSk95UFdFT0QwZHg3Nk5Udll0TkVlUlJkK0lHU0p3?=
 =?utf-8?B?aWZVK1lSUkpHa1pHdzJYc3AyMWIxMDFxZVgyQmp2WlA4aEtxK3U4Y3c4SlRt?=
 =?utf-8?B?OFpSN2k2ZEpjTWRNM0dMSktUWXJyRHQ3MEtiWVRGc21CSDFzYjdjQmw2UTYx?=
 =?utf-8?B?M2RPWEN0Nm1aVXRGTFdTdXNldXFiMjRwTDZpL21HSTR4ajNkNkRWS3pDWERN?=
 =?utf-8?B?Q1djOXVmSjVRVTBqMXFkOTFpQTZGOGlWcy9kWjVhcU1tenlvY3RpdUdJVFZE?=
 =?utf-8?B?UG01cXh6T0w5aVVIbG5hTm1wTVUxS1lCdnV1WkNJZUs3dXVROURJU2hpQWR2?=
 =?utf-8?B?ajhVYW80WHp3N1F3cTNmY2pRSGh4cmxicGxod2JPTlZJTVRCdEhndlU2WVpV?=
 =?utf-8?B?VVJjQmVFU3p5QllOVFRmc3lIR2FGemI2VVBPU1Rwbk90bTZaV09BOFpWK2Jw?=
 =?utf-8?B?WFoxTVVaOWNvNElhc01qcFdOQ3c3ZUkydDJKQmdvcVptaDhHek5ZcDkxcndT?=
 =?utf-8?B?bmtkU0RuMzAvaDh1WjRqQklmdlF1c2drOTlqWEFpdDQ1NmZhK0tKT01BNG5p?=
 =?utf-8?B?MXdHQUlIVENaTmwvZGsxUVFScE80Mk1lRm81TEJVWFdZelRFSmxXVWZST2JR?=
 =?utf-8?B?ckN6OTB5eGIwVWtSbTFJSXVjTlV4V3Y1MlE3SGdQbkc4K1hQUG5rcVZhRXN2?=
 =?utf-8?B?b2N6Ykp1NUhGQUFBZ1VuZThxNll4ZG1wUElyWkV5akdqSjVIc3NMdjBhdGJk?=
 =?utf-8?B?VlFiNUo3Y29FN2dhUTZBN3NNN01nMlhiTFIwYzRJQVJUTGhDeU83QUZUTkpP?=
 =?utf-8?B?U01vckRGUjgyelB2eG03V3NyaTFabTZLamhWNTVwZUNRQWp4VWZMSEphTk9o?=
 =?utf-8?Q?g4G7vIhlZxq3lLbhPxika9AVC3hljkAhtFUdd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A45BC8A3732AC4B8DBE24C29365BD6C@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e54138d-714c-457d-f86b-08de427736c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 23:01:32.0003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xuFSVYTvIRKT/g0UHHQODySk/MKpEvR9CuIKg4SZsuJrBhW/4dARi7b63ywT+ocWLX25sjSW3aAZwZ01ALLtfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4742
X-Authority-Analysis: v=2.4 cv=carfb3DM c=1 sm=1 tr=0 ts=694b1f4e cx=c_pps
 a=AdSExLHk7727Th38kKp3hg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=gocFYpvkFn3SaTAWYQQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: vACNDsesw8RO1ww81U35VWuMrYlQjTQB
X-Proofpoint-GUID: 3btNYxUh3Ssdpf6HgGpHI0kIw3h7hbgq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDE5MiBTYWx0ZWRfXzt9B7k2+s7w7
 P8GXWu1VzqSFw4SeNYfCAMxBDxogJctvEw+8my57Is86dK9QXGwVMnkWKANwSZJzN/KoOb2VSkD
 ypIHZaPCmRk0RUm9ATZRHRfL2tT+UyCVopyTnJUnI/NhOwRfEO64w7ZHwo+q38RzhJ4pLOvg2xh
 Rt8M5tMTrXgeVqvKm6KirVrPbgj3+xuvnlfP3fS4pcD0fYWcHKG20xlrdAQPrXlALs83npJTwuv
 ROyTdjnqfEfv56hCrULUeqpRXaKibd/oT3Jn1e5tSLWsmAzZ90I+ACc6o4tICgqxkgkpywhwW/P
 EIV5oSJiJeybBtykdpGyp8b8dTGF8AEbqF/xYYKe641nWOBZkvObgC7+wYYutL4gAvFSteNtXN5
 15j2NCdv+iFaibA5Zt9RMrJkcl+jQlstQ5D8xq7vHy/NQBvVLrmwYd3gTdMOnlwP9n5xm66Hps3
 hjlOv7BOxiM1mB+Wueg==
Subject: Re:  [PATCH v2] net: ceph: make free_choose_arg_map() resilient to
 partial allocation
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_05,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512230192

T24gU3VuLCAyMDI1LTEyLTIxIGF0IDAyOjExICswODAwLCBUdW8gTGkgd3JvdGU6DQo+IGZyZWVf
Y2hvb3NlX2FyZ19tYXAoKSBtYXkgZGVyZWZlcmVuY2UgYSBOVUxMIHBvaW50ZXIgaWYgaXRzIGNh
bGxlciBmYWlscw0KPiBhZnRlciBhIHBhcnRpYWwgYWxsb2NhdGlvbi4NCj4gDQo+IEZvciBleGFt
cGxlLCBpbiBkZWNvZGVfY2hvb3NlX2FyZ3MoKSwgaWYgYWxsb2NhdGlvbiBvZiBhcmdfbWFwLT5h
cmdzDQo+IGZhaWxzLCBleGVjdXRpb24ganVtcHMgdG8gdGhlIGZhaWwgbGFiZWwgYW5kIGZyZWVf
Y2hvb3NlX2FyZ19tYXAoKSBpcw0KPiBjYWxsZWQuIFNpbmNlIGFyZ19tYXAtPnNpemUgaXMgdXBk
YXRlZCB0byBhIG5vbi16ZXJvIHZhbHVlIGJlZm9yZSBtZW1vcnkNCj4gYWxsb2NhdGlvbiwgZnJl
ZV9jaG9vc2VfYXJnX21hcCgpIHdpbGwgaXRlcmF0ZSBvdmVyIGFyZ19tYXAtPmFyZ3MgYW5kDQo+
IGRlcmVmZXJlbmNlIGEgTlVMTCBwb2ludGVyLg0KPiANCj4gVG8gcHJldmVudCB0aGlzIHBvdGVu
dGlhbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYW5kIG1ha2UNCj4gZnJlZV9jaG9vc2VfYXJn
X21hcCgpIG1vcmUgcmVzaWxpZW50LCBhZGQgY2hlY2tzIGZvciBwb2ludGVycyBiZWZvcmUNCj4g
aXRlcmF0aW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVHVvIExpIDxpc2xpdHVvQGdtYWlsLmNv
bT4NCj4gLS0tDQo+IHYyOg0KPiAqIEFkZCBwb2ludGVyIGNoZWNrcyBiZWZvcmUgaXRlcmF0aW5n
IGluIGZyZWVfY2hvb3NlX2FyZ19tYXAoKSwgaW5zdGVhZCBvZg0KPiAgIG1vdmluZyB0aGUgYXJn
X21hcC0+c2l6ZSBhc3NpZ25tZW50IGluIGRlY29kZV9jaG9vc2VfYXJncygpLg0KPiAgIFRoYW5r
cyB0byBWaWFjaGVzbGF2IER1YmV5a28gZm9yIHBvaW50aW5nIG91dCB0aGUgaXNzdWUgd2l0aCB0
aGUgcHJldmlvdXMNCj4gICBwYXRjaCwgYW5kIHRvIElseWEgRHJ5b21vdiBmb3IgdGhlIGhlbHBm
dWwgYWR2aWNlLg0KPiAtLS0NCj4gIG5ldC9jZXBoL29zZG1hcC5jIHwgMjAgKysrKysrKysrKysr
LS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9jZXBoL29zZG1hcC5jIGIvbmV0L2NlcGgvb3Nk
bWFwLmMNCj4gaW5kZXggMzRiM2FiNTk2MDJmLi4wODE1Nzk0NWFmNDMgMTAwNjQ0DQo+IC0tLSBh
L25ldC9jZXBoL29zZG1hcC5jDQo+ICsrKyBiL25ldC9jZXBoL29zZG1hcC5jDQo+IEBAIC0yNDEs
MjIgKzI0MSwyNiBAQCBzdGF0aWMgc3RydWN0IGNydXNoX2Nob29zZV9hcmdfbWFwICphbGxvY19j
aG9vc2VfYXJnX21hcCh2b2lkKQ0KPiAgDQo+ICBzdGF0aWMgdm9pZCBmcmVlX2Nob29zZV9hcmdf
bWFwKHN0cnVjdCBjcnVzaF9jaG9vc2VfYXJnX21hcCAqYXJnX21hcCkNCj4gIHsNCj4gLQlpZiAo
YXJnX21hcCkgew0KPiAtCQlpbnQgaSwgajsNCj4gKwlpbnQgaSwgajsNCj4gKw0KPiArCWlmICgh
YXJnX21hcCkNCj4gKwkJcmV0dXJuOw0KPiAgDQo+IC0JCVdBUk5fT04oIVJCX0VNUFRZX05PREUo
JmFyZ19tYXAtPm5vZGUpKTsNCj4gKwlXQVJOX09OKCFSQl9FTVBUWV9OT0RFKCZhcmdfbWFwLT5u
b2RlKSk7DQo+ICANCj4gKwlpZiAoYXJnX21hcC0+YXJncykgew0KPiAgCQlmb3IgKGkgPSAwOyBp
IDwgYXJnX21hcC0+c2l6ZTsgaSsrKSB7DQo+ICAJCQlzdHJ1Y3QgY3J1c2hfY2hvb3NlX2FyZyAq
YXJnID0gJmFyZ19tYXAtPmFyZ3NbaV07DQo+IC0NCj4gLQkJCWZvciAoaiA9IDA7IGogPCBhcmct
PndlaWdodF9zZXRfc2l6ZTsgaisrKQ0KPiAtCQkJCWtmcmVlKGFyZy0+d2VpZ2h0X3NldFtqXS53
ZWlnaHRzKTsNCj4gLQkJCWtmcmVlKGFyZy0+d2VpZ2h0X3NldCk7DQo+ICsJCQlpZiAoYXJnLT53
ZWlnaHRfc2V0KSB7DQo+ICsJCQkJZm9yIChqID0gMDsgaiA8IGFyZy0+d2VpZ2h0X3NldF9zaXpl
OyBqKyspDQo+ICsJCQkJCWtmcmVlKGFyZy0+d2VpZ2h0X3NldFtqXS53ZWlnaHRzKTsNCj4gKwkJ
CQlrZnJlZShhcmctPndlaWdodF9zZXQpOw0KPiArCQkJfQ0KPiAgCQkJa2ZyZWUoYXJnLT5pZHMp
Ow0KPiAgCQl9DQo+ICAJCWtmcmVlKGFyZ19tYXAtPmFyZ3MpOw0KPiAtCQlrZnJlZShhcmdfbWFw
KTsNCj4gIAl9DQo+ICsJa2ZyZWUoYXJnX21hcCk7DQo+ICB9DQo+ICANCj4gIERFRklORV9SQl9G
VU5DUyhjaG9vc2VfYXJnX21hcCwgc3RydWN0IGNydXNoX2Nob29zZV9hcmdfbWFwLCBjaG9vc2Vf
YXJnc19pbmRleCwNCg0KTG9va3MgZ29vZC4gVGhhbmtzIGEgbG90IGZvciB0aGUgZml4Lg0KDQpS
ZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQoN
ClRoYW5rcywNClNsYXZhLg0K

