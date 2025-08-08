Return-Path: <ceph-devel+bounces-3368-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93567B1EDEA
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 19:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F37141C27C62
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 17:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A872874FE;
	Fri,  8 Aug 2025 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SEtst9vB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A16283C8C;
	Fri,  8 Aug 2025 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754674898; cv=fail; b=h71lfl+5Rn1Xx6OA7BvI+6oSSZ6f4zXK1o+xgmOAzj4VT6tGPzPfUph7I1j5KcTTJIHHsDNVfeGIdF0pOJwMBmuW+sWextftpNAnlAT761oCDuIA3ivI9B9gadGhXPEhvOyMtWPxWF/6OGS0M5zpmBr9AXFee3bRdnHgG+KR0sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754674898; c=relaxed/simple;
	bh=a6x1DXCJ2vHz/N629kged0TJrtNHb5/IdOJ9Q/W2LN0=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=X3SB+iPIDd9jWeTY+Srqqx2WqJs0cjbtbw0egoN9ewp2TwqxquEX6iXGL/MX5PjyGdn40xKcd4RREt5Q6/8MlDJT38uxCc3QnzR/DTBnpsU9si0mGRLICldBl6Yke2FRFrX6mZaAWX04+Anx5IK/ApZIjDL7N/NRROZILZ92fDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SEtst9vB; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578D4CdS028175;
	Fri, 8 Aug 2025 17:41:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=a6x1DXCJ2vHz/N629kged0TJrtNHb5/IdOJ9Q/W2LN0=; b=SEtst9vB
	Hx8Lf3SC/Ady2hemO2o3kcbUZZydPrhaTYQVvm+oHNveain7x232UZRufARxVCLO
	wDnXnhylpjuSV7CzO/UyxBm5nqKl/MmAhO80+ZsMsXP07ZNXdhsv9h+xxua1Rtua
	4tjQ6oYsSAMR3Rlw78BX712YyHl9Vl/6y0nOUeNKgaY5l5NXzJ2YewLEnLor+2K1
	AGBMqNvY4U8Wq8gVpZfdGikgHyMQzef8BA49/EUXCx5UXrZTjS03W8d/mlEYkACE
	4dtZFgYIAZWUTbz19Ef7n/VgAdahzvERr0nFoRPhyuKX1gUdp5i6PL+g9ngmaEjm
	gKnv6DeakVGACw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq619yrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 17:41:31 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 578HcU5P018041;
	Fri, 8 Aug 2025 17:41:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq619yrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 17:41:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NIYXBLZd7514jnbW6l0cJkQ3yRoIMLfx5DpHFRTgcHrMfvOr9gPRt9RzZpMX4CdannRaix/Rl0B5xKB5HHfvWgrfu4KHVY5y21Uid6OjH3uWOkdZZAMl59oXdoVgnR3ca7YazBrc350hrxto/6si8W9y+k/cE0h+mDebxoIQkYW3UD8xmnKMiSjITD+2/9tHxFF7MEwlg7iIsCmF1dVh7N079jqoXiwsWyiib8oemYMA9BOJgUGEoDIBlHDoI4dYLXAX1BnU0Hs2+vobd8gPh/lEHPdCTDkyoR1N4I8Bn3CsgP3C7JNW5/gwiccvWES2QXTSPmb5FUKdptDWSRtwZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6x1DXCJ2vHz/N629kged0TJrtNHb5/IdOJ9Q/W2LN0=;
 b=cWD+ebsHB393cGhj34Lp1JTFbYxx98yaIELj6RbBOvMkF/zSxUpiAShMKrDlqlSkIVgS/nl39lAtgHy+G8C3jbYGrWo9lU6E+dzt8eTCCDKZMQIVPBA54WMmhuctdtHbIvNWd6qwSAQ5jJzasi2tYBIiBJLiFDJwLORVB72f5GK2EsrkUmPq2xE1puldglm80uBVURTVet0R4yTxFY2ll2yx4XIo8Dvf8OcGxA6qVy6ruhQLjjp2P78/x2t0HlZ9UltgOj4VlItKFG21cMOfwqNj2T9+JRZx7RLFtym3cdSI8fZKkWm70Hr/Ru6fgaU3ePe48pBxERYxzNTbhh4AYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH3PR15MB6478.namprd15.prod.outlook.com (2603:10b6:610:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Fri, 8 Aug
 2025 17:41:26 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.8989.018; Fri, 8 Aug 2025
 17:41:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH 3/3] net/ceph/messenger: add empty check to
 ceph_con_get_out_msg()
Thread-Index: AQHcBrdnyODrRwSSNUqVzpWq/v6bR7RZCeSA
Date: Fri, 8 Aug 2025 17:41:26 +0000
Message-ID: <57af9acc17e333c80f07e2b15478088b4f14ba12.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
	 <20250806094855.268799-4-max.kellermann@ionos.com>
In-Reply-To: <20250806094855.268799-4-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH3PR15MB6478:EE_
x-ms-office365-filtering-correlation-id: 87643577-658e-440d-92e9-08ddd6a2ccbb
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NkYyQXZiSVhZaUtVWWFpUzlvMi9ITU1MRk9MOUhxNEF5YnJzOWs5MWZJOWM0?=
 =?utf-8?B?UkkxaVZsbHVqZVdYSVFTN1hmaG50RHVWTjltc1NiNFRuRmphVXQxY3hSN3BG?=
 =?utf-8?B?K0srWHhKdFZ6N2pjbjUrNVVPRUtVdkZGREsxd0M1bjJOVld1SjhNWEhaSjFa?=
 =?utf-8?B?cmdmck1tT0s0NExaUm9vY0p1UWxqelpURngwY1VsWXVUYVBDV1NkSzd2WFJD?=
 =?utf-8?B?MStXdk0rWnE3aEtQYnJPVEVpOWtNaVdFcVJ3MS83RVpHbmwyZXArNlRqc3NX?=
 =?utf-8?B?cWVrT2doaS9wSjJDVjNLZlBwZGU5QW1lNUtxTzdIRWhJVE9wZFlUdUw5VGZH?=
 =?utf-8?B?UktSMFBLUjNtcmtJS1pqNTdkOUQ4bm1WUHcwQ2Y0TWRZT1dXeW9sMmpVOEdL?=
 =?utf-8?B?YWcwVDBVRlc3Wk8rOUtLQU9EUXV5cGhxMzcxL29pZkpFMnRKMlJmNWF3Qzdn?=
 =?utf-8?B?aGVEa0RkS2lxTmpxUUs3Qm1PWTFGK0VEd3JzbXlxbDB6YnEwUmNXaklPdjBz?=
 =?utf-8?B?MUpqS2dBeVEzdFhLeHJXTUVnM2FjVW9xUTBuaW5KY2FCQVgxaFVoQW5CM0Ry?=
 =?utf-8?B?cEhEZHJWMkFPcnUxOGQwVXh1dG9UT2ZrZmZwMmp3R3dFRVdvcmx1dnR5U3ls?=
 =?utf-8?B?SkxlS1YvamExdGE5MGR3Rkhtd2VaeWp4SitRSU5QOHVGOXp4cWVQbXduZVFi?=
 =?utf-8?B?L2NXeWR0ejRTNkRmakdEcFo2L2ptZ2ZxSm5BWXhEYkZhMThWUDQyZ04zdkEx?=
 =?utf-8?B?aXNLQUZWMUo2YkthRHhjSGZSQkc2OXRQeHlSanNQVjJMakVBL3pQNWI0M2Zi?=
 =?utf-8?B?QXJENjI1MDQ4YnpTUWxSZXQwUVJ0OXdLRFBRVWViRENkT09jbjFVUmdUbmZE?=
 =?utf-8?B?dlhkdW1YQ0JjK25MbUtQcDRWL2tHTDBsWTBnK0ZidUJmanRTNE5iREJQaytH?=
 =?utf-8?B?SjlTN0ErQ09qeUVnUnpBblpST3VuaGZGWjFsMFE2V2ZzekROQlVGMi9yMUds?=
 =?utf-8?B?NTI1ZVErVkFWa1ZHYmxMZVBHaytaTksrcTI0ZHFhOUgyK1ZySjRnVWR0bG9W?=
 =?utf-8?B?VnNyYTFrUVFyRTgrM1FzMTVrRkNsN3o2M1pGc0ZoSTBHQndDc0ZSSFNSWFN3?=
 =?utf-8?B?dS9rKzlaNGdmbDFYSnFCcWtTWEp6K3hJa0hXc0pYTmpQL1RQM3l0VmhWOVA1?=
 =?utf-8?B?SEVQVm9WUGN6SjJLWWkyRkZ5bnh4bzE1QUo4REJUaXVBVzh6SWhtWkhvamZ3?=
 =?utf-8?B?OE40OVZ4ZitkaVFqQnVuczNmcTBiN3hNckJhbFFSaHY4OGswSzdLeTNwLytQ?=
 =?utf-8?B?RkhJSjRtd1JKS1FNVUpjd1drZmN6S0dDQmZhU2dza1llYlJPMExQb0VQUEww?=
 =?utf-8?B?SGxJdDVldVdBVDNSNndlU2s5OHdJSWtiMks0NmlWcUVJT0cxdjFQQUhEeldP?=
 =?utf-8?B?L0thSFRVTVRWa3RPRXZVWndHZVcrREdHd2pOZnNFTlR6RUF5MzgrVTR4Mlh5?=
 =?utf-8?B?OEFGUjd3OGpvWjVscjdreFhRZndZZ0pRemhCRUdPcklnNjJxN1FsejF1b3Ju?=
 =?utf-8?B?YlBNWmlTd2hvMGQ3aktSMCtIdzB6bkdYN3k3V3FwM2xoaFZsU2dvZGJXdXZJ?=
 =?utf-8?B?Q2p5ditWOUtiYzQ5NFRSRkltVnVteUZKbmMyRUtsUHhQVDNvMWE0bVZnNWsr?=
 =?utf-8?B?SXYxZkNRaUo4WVRJdG9Ia0pYUitFOXRKWnpDcG16T08wREtZNmlBUGhlZTlX?=
 =?utf-8?B?OGJJRHJBQS95ZnBuQ0xESFlsVHhjYzcrRG9FWTUrYnU5M0lKbWlMeEM4RkZG?=
 =?utf-8?B?S0lsS1Q0RGkvMnI5cGQ2NUFPVE42WStpYS9Sd2F3QlJVdm9oaCs4OUc1TXQ4?=
 =?utf-8?B?L1VVSFNQY3o0elpWQWFTRXl2bEd3eDFFOEI4R29ubXNSU1RQUVZrQ1VDTk02?=
 =?utf-8?B?eFVEQXFsWThkQzArZ3ZiVlpmZk81UnBmdWNqQm8raWZ5dWxQS3NpVGRGT1BJ?=
 =?utf-8?B?QjVkR1V6aDRRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aEgwWjUrcElIdVVDcTVGbU1OOHp5ZmVoZW1RSU5sc2RSeDc3NGszNU1ic0pG?=
 =?utf-8?B?UmZJcktPZVZkTS9FNEg1cjRmSVdsNE03QmdqNDdCOUM1b0VvSzUvd04zc3ln?=
 =?utf-8?B?dnJKcVNUWmZnQ2JFdFZSbk5JTWJkajZwR3RjZU9qTWovbUozc2lIZi9sY3Rn?=
 =?utf-8?B?Vk5vUVF4N3lDS2lOM2hyRi9waGloa0k4bXZQcEVUZWJHUU5oMzVad3h0enVi?=
 =?utf-8?B?MnFQTGlBV3hGRytVNW1DMlZXVWlpSmxrZjV1QkNHS0FqdTQ4VWNWaEdJYUpQ?=
 =?utf-8?B?OFNlNFl2dnVXOVhuY1B6bXowUHYwa0dBdVlJV25lM1kvUGxSUzJNaVNvNDd6?=
 =?utf-8?B?Vm5jVE14dVV3ZVladjh6NkF1TnYrOHM3MXlEN3U2bzFkaEJzejhrUU9jTGpi?=
 =?utf-8?B?RUdRZFRNbE5CWUdFdy9NL1dQQVFialRVSTVUWUFyOEtUWDR2dG9hbGNwbDht?=
 =?utf-8?B?cVcxa01WUFdXS0dOd3NabHNmMk9aNXF4MVB0TGNaVHlzTUR6WTd4TGc1a2pv?=
 =?utf-8?B?ZVgzcUNxRHFsMS9YTm5yZjZqbWQ4LzZsVXhvV3A5cjN6T0JrSWswS2x1UmVD?=
 =?utf-8?B?VGhqUmNOUGhmcExNTklZTEJBQk9GTzF1YVh5bis4dGNiN1JhUFlVTG4vMElo?=
 =?utf-8?B?NlJqZ1QyRXArUitTNVpXYldtVkdzci9ZWGlBZStGeDF4Ry9yeks0a2hoQ09X?=
 =?utf-8?B?VDQwZHBSZE1KVHFaTy9IQnB6WDdhMnRVOWNDcWtvTko0RkdCazRueHZPcnNn?=
 =?utf-8?B?Lzdnc0VxUFVkWDUrQTVIbTh5REFIWUZobG5JSTVmQUN2K2cvUTJJUzBRYXg3?=
 =?utf-8?B?K0NSOG1Yb0d3TnJycUpmellaS3JtS3ZRT3hSYUZrNzVHWVJXNmZabFIrejZx?=
 =?utf-8?B?WkQ3M05XbGtoMktxOWl3ZEZMbHBzamxnQnIvSkthNHlIRnBqYXR0eGZqK2wx?=
 =?utf-8?B?dUpYdWd3eUhKMGFQUjFEcTJYc1JkUHF5WW9XUGJVNXYwVlo5MmhhTzIyRGtJ?=
 =?utf-8?B?cFI4bFV0cjFhNVhUb04yZGxNdnRiNVVod2toMzlZRFQ5WjEyOU1CZGR3Uk1T?=
 =?utf-8?B?RlJqTmJ1NFgva3pjM0s3cTlLUnRzQmR3Z1pvWVArS09YcjA3Mk4weTQvSGxs?=
 =?utf-8?B?UHJvY1RKSzRmMzZQRmFhREpqRE5nOWZVUlZiR1oxdlVyU082N3pEcms3Y3NB?=
 =?utf-8?B?MmIxM3oxWjJ1UExnWWhPR3AvTGViQ0txbi91SWVTR1RQSlJjaDVZK0lvKzQr?=
 =?utf-8?B?K3djamZ6NEdhOW5DQVJBSUcrZjZicG1kbWFqNkVSTitwR1BWa0k5bnNBMmta?=
 =?utf-8?B?bWJIY3NHQ253aUJ6UGZEQTFKc1YxbFUxTjk1Y2M0NURUTU5ndGZHS3hBbUNO?=
 =?utf-8?B?MVZDeEh4MkpGRUgybW1Mcm9tcjROaDB5RXRQbjZGQVE2ekEzN3lGQ24zZTBJ?=
 =?utf-8?B?OUQ5dklZUXBxSjJhbXRaY2p3SGltNTJ1QTdjSnBNRjZLYjBLWTVGRDhwL3Bp?=
 =?utf-8?B?RURadm1JZk1lbEtTcXN2Mll2RW9zR0NkT0tCMWYzUUpESWs4Q00zYW1qWC9u?=
 =?utf-8?B?QWFEdzl2SU0yQjdJMU1PMldwamh3bS9wQVhpQzZPK0hKV1NKbkkxZUJpYWRP?=
 =?utf-8?B?ZTFWeit5cWJQV25uR3dua1hEYWREQmFjblFmUkZRSElMWUVuNVVDUDdVRXNJ?=
 =?utf-8?B?dVkwRDJOL1pQNEU3S3NvVzl3TEU1ZThyWWNCc2RaSW9qVmYzUjlnbm1YZTBo?=
 =?utf-8?B?ZjRtSEFlUEpKNE9uWWsvTTlsV2lGTWZLSlF2Z0NsWlhua1JPTHhTbURCbnR3?=
 =?utf-8?B?U2VyU0lYNG1EMjBnNUdhM0ZpcDlqc2FWRzQzemZoSXZiMFdqVXc5YWJiU08x?=
 =?utf-8?B?dGVNSHFlMFlyNnV4WjNMYXh0czJORk9NdzR3blZZQWkvNXh3bjEwdHFzbitS?=
 =?utf-8?B?TGlMd0xoVGRtdU9XMGJrdkczVU9TS3dqaXZiVEtCK3crZG4zZklFVERwYWRn?=
 =?utf-8?B?SG4wc3I5ZzAwNTBFaVgyYlhGOVdoVjhqY3hhb0phNkJDMkEwRVEwSFp6d0hq?=
 =?utf-8?B?ai81dHV5cWZzczczaU5heGJZYzByMXlrRHZRUnNJQkE1V2JhMlk2NmNzYXhZ?=
 =?utf-8?B?OEZINE5LUCtmajRrUFJNdzVLc0Y5OStPMFZrekgxc2xnNnV6dExndVNNTHlJ?=
 =?utf-8?Q?Gq6GN2PLvkkhZMThgvUBfh0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66BA8DFDE07B6C44B0877814F87C1876@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 87643577-658e-440d-92e9-08ddd6a2ccbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 17:41:26.4124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAq82MgXtoMVYkaQyVHTan7J7yxLzr3dU/3PjxxFV1pGKPl9SBY3DOIBDYrKFetmyJ8cCXUbBuRtR8sGocim3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6478
X-Proofpoint-GUID: i5UxW2teq_ACSqtw5bTJHwng00i4AwbB
X-Proofpoint-ORIG-GUID: rBUAPp29o7_6bomPhCHZlnHA6SLDPu7C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDE0MSBTYWx0ZWRfX5D6/DvBaptPJ
 qk/4I334xypBEbPe+W/RdX+vWtLQktfJLJV/yPtnUKJrefG27NEVl0NlVlY0A45xRwkgngdorI0
 pGVCJam2+wNYpR7nL+erZyJPCj5zRGjMGri3uKGkA2Zy6mEOCwTvL4TVcBu4o60QaEzjI0iFgZu
 fA96b93YtOi/yKZBb04VkpJgbxcfnF24VRI5CE8NG/XJguZ8h06x0g6ciswPD5ouBqDj9JYXGPm
 OHl6wDf48iRixxy2GVkouVwJwyc/Y6jZVh/hoK/a/xvzMhmQazoBNHTfuxiLFt2XCbu4CZy4zrO
 W1PqOthnTPAbm0TeSowRKgJn/nxndVGz9aPLIgnGX2LGAf1lm0o+XITpNROXN+Ug3iKjVu34g/3
 ozvxVR/JcKX8Wwuvx5+1/Cu/vWt8Q0lRBEChnw86b2P+dTZPt5Mn5qQDgx17kIaZHxmQfoIK
X-Authority-Analysis: v=2.4 cv=TayWtQQh c=1 sm=1 tr=0 ts=689636cb cx=c_pps
 a=nbHxHWYZ5biEzOhcRz1Xag==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8 a=U2PfdUZJC0cbOMHL2nkA:9
 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
Subject: Re:  [PATCH 3/3] net/ceph/messenger: add empty check to
 ceph_con_get_out_msg()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508080141

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjQ4ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gVGhpcyBtb3ZlcyB0aGUgbGlzdF9lbXB0eSgpIGNoZWNrcyBmcm9tIHRoZSB0d28gY2FsbGVy
cyAodjEgYW5kIHYyKQ0KPiBpbnRvIHRoZSBiYXNlIG1lc3Nlbmdlci5jIGxpYnJhcnkuICBOb3cg
dGhlIHYxL3YyIHNwZWNpYWxpemF0aW9ucyBkbw0KPiBub3QgbmVlZCB0byBrbm93IGFib3V0IGNv
bi0+b3V0X3F1ZXVlOyB0aGF0IGltcGxlbWVudGF0aW9uIGRldGFpbCBpcw0KPiBub3cgaGlkZGVu
IGJlaGluZCB0aGUgY2VwaF9jb25fZ2V0X291dF9tc2coKSBmdW5jdGlvbi4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IE1heCBLZWxsZXJtYW5uIDxtYXgua2VsbGVybWFubkBpb25vcy5jb20+DQoNCkxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5
a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gLS0tDQo+ICBuZXQvY2VwaC9tZXNz
ZW5nZXIuYyAgICB8ICA0ICsrKy0NCj4gIG5ldC9jZXBoL21lc3Nlbmdlcl92MS5jIHwgMTUgKysr
KysrKysrKy0tLS0tDQo+ICBuZXQvY2VwaC9tZXNzZW5nZXJfdjIuYyB8ICA0ICsrLS0NCj4gIDMg
ZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9uZXQvY2VwaC9tZXNzZW5nZXIuYyBiL25ldC9jZXBoL21lc3Nlbmdlci5jDQo+
IGluZGV4IDQyNGZiMjc2OWI3MS4uODg4NmMzOGE1NWQyIDEwMDY0NA0KPiAtLS0gYS9uZXQvY2Vw
aC9tZXNzZW5nZXIuYw0KPiArKysgYi9uZXQvY2VwaC9tZXNzZW5nZXIuYw0KPiBAQCAtMjExMyw3
ICsyMTEzLDkgQEAgc3RydWN0IGNlcGhfbXNnICpjZXBoX2Nvbl9nZXRfb3V0X21zZyhzdHJ1Y3Qg
Y2VwaF9jb25uZWN0aW9uICpjb24pDQo+ICB7DQo+ICAJc3RydWN0IGNlcGhfbXNnICptc2c7DQo+
ICANCj4gLQlCVUdfT04obGlzdF9lbXB0eSgmY29uLT5vdXRfcXVldWUpKTsNCj4gKwlpZiAobGlz
dF9lbXB0eSgmY29uLT5vdXRfcXVldWUpKQ0KPiArCQlyZXR1cm4gTlVMTDsNCj4gKw0KPiAgCW1z
ZyA9IGxpc3RfZmlyc3RfZW50cnkoJmNvbi0+b3V0X3F1ZXVlLCBzdHJ1Y3QgY2VwaF9tc2csIGxp
c3RfaGVhZCk7DQo+ICAJV0FSTl9PTihtc2ctPmNvbiAhPSBjb24pOw0KPiAgDQo+IGRpZmYgLS1n
aXQgYS9uZXQvY2VwaC9tZXNzZW5nZXJfdjEuYyBiL25ldC9jZXBoL21lc3Nlbmdlcl92MS5jDQo+
IGluZGV4IDUxNmYyZWViMTIyYS4uNWViNmNmZGJjNDk0IDEwMDY0NA0KPiAtLS0gYS9uZXQvY2Vw
aC9tZXNzZW5nZXJfdjEuYw0KPiArKysgYi9uZXQvY2VwaC9tZXNzZW5nZXJfdjEuYw0KPiBAQCAt
MTg5LDEyICsxODksMTggQEAgc3RhdGljIHZvaWQgcHJlcGFyZV93cml0ZV9tZXNzYWdlX2Zvb3Rl
cihzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24sIHN0cnVjdCBjZXANCj4gIA0KPiAgLyoNCj4g
ICAqIFByZXBhcmUgaGVhZGVycyBmb3IgdGhlIG5leHQgb3V0Z29pbmcgbWVzc2FnZS4NCj4gKyAq
DQo+ICsgKiBAcmV0dXJuIGZhbHNlIGlmIHRoZXJlIGFyZSBubyBvdXRnb2luZyBtZXNzYWdlcw0K
PiAgICovDQo+IC1zdGF0aWMgdm9pZCBwcmVwYXJlX3dyaXRlX21lc3NhZ2Uoc3RydWN0IGNlcGhf
Y29ubmVjdGlvbiAqY29uKQ0KPiArc3RhdGljIGJvb2wgcHJlcGFyZV93cml0ZV9tZXNzYWdlKHN0
cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbikNCj4gIHsNCj4gIAlzdHJ1Y3QgY2VwaF9tc2cgKm07
DQo+ICAJdTMyIGNyYzsNCj4gIA0KPiArCW0gPSBjZXBoX2Nvbl9nZXRfb3V0X21zZyhjb24pOw0K
PiArCWlmIChtID09IE5VTEwpDQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKw0KPiAgCWNvbl9vdXRf
a3ZlY19yZXNldChjb24pOw0KPiAgCWNvbi0+djEub3V0X21zZ19kb25lID0gZmFsc2U7DQo+ICAN
Cj4gQEAgLTIwOCw4ICsyMTQsNiBAQCBzdGF0aWMgdm9pZCBwcmVwYXJlX3dyaXRlX21lc3NhZ2Uo
c3RydWN0IGNlcGhfY29ubmVjdGlvbiAqY29uKQ0KPiAgCQkJJmNvbi0+djEub3V0X3RlbXBfYWNr
KTsNCj4gIAl9DQo+ICANCj4gLQltID0gY2VwaF9jb25fZ2V0X291dF9tc2coY29uKTsNCj4gLQ0K
PiAgCWRvdXQoInByZXBhcmVfd3JpdGVfbWVzc2FnZSAlcCBzZXEgJWxsZCB0eXBlICVkIGxlbiAl
ZCslZCslemRcbiIsDQo+ICAJICAgICBtLCBjb24tPm91dF9zZXEsIGxlMTZfdG9fY3B1KG0tPmhk
ci50eXBlKSwNCj4gIAkgICAgIGxlMzJfdG9fY3B1KG0tPmhkci5mcm9udF9sZW4pLCBsZTMyX3Rv
X2NwdShtLT5oZHIubWlkZGxlX2xlbiksDQo+IEBAIC0yNTYsNiArMjYwLDggQEAgc3RhdGljIHZv
aWQgcHJlcGFyZV93cml0ZV9tZXNzYWdlKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbikNCj4g
IAl9DQo+ICANCj4gIAljZXBoX2Nvbl9mbGFnX3NldChjb24sIENFUEhfQ09OX0ZfV1JJVEVfUEVO
RElORyk7DQo+ICsNCj4gKwlyZXR1cm4gdHJ1ZTsNCj4gIH0NCj4gIA0KPiAgLyoNCj4gQEAgLTE1
NDMsOCArMTU0OSw3IEBAIGludCBjZXBoX2Nvbl92MV90cnlfd3JpdGUoc3RydWN0IGNlcGhfY29u
bmVjdGlvbiAqY29uKQ0KPiAgCQkJZ290byBtb3JlOw0KPiAgCQl9DQo+ICAJCS8qIGlzIGFueXRo
aW5nIGVsc2UgcGVuZGluZz8gKi8NCj4gLQkJaWYgKCFsaXN0X2VtcHR5KCZjb24tPm91dF9xdWV1
ZSkpIHsNCj4gLQkJCXByZXBhcmVfd3JpdGVfbWVzc2FnZShjb24pOw0KPiArCQlpZiAocHJlcGFy
ZV93cml0ZV9tZXNzYWdlKGNvbikpIHsNCj4gIAkJCWdvdG8gbW9yZTsNCj4gIAkJfQ0KPiAgCQlp
ZiAoY29uLT5pbl9zZXEgPiBjb24tPmluX3NlcV9hY2tlZCkgew0KPiBkaWZmIC0tZ2l0IGEvbmV0
L2NlcGgvbWVzc2VuZ2VyX3YyLmMgYi9uZXQvY2VwaC9tZXNzZW5nZXJfdjIuYw0KPiBpbmRleCA5
MDEwOWZhMGZlNjAuLmUwYjVmMmUyNTgyZCAxMDA2NDQNCj4gLS0tIGEvbmV0L2NlcGgvbWVzc2Vu
Z2VyX3YyLmMNCj4gKysrIGIvbmV0L2NlcGgvbWVzc2VuZ2VyX3YyLmMNCj4gQEAgLTMyOTIsNiAr
MzI5Miw3IEBAIHN0YXRpYyB2b2lkIGZpbmlzaF9tZXNzYWdlKHN0cnVjdCBjZXBoX2Nvbm5lY3Rp
b24gKmNvbikNCj4gIA0KPiAgc3RhdGljIGludCBwb3B1bGF0ZV9vdXRfaXRlcihzdHJ1Y3QgY2Vw
aF9jb25uZWN0aW9uICpjb24pDQo+ICB7DQo+ICsJc3RydWN0IGNlcGhfbXNnICptc2c7DQo+ICAJ
aW50IHJldDsNCj4gIA0KPiAgCWRvdXQoIiVzIGNvbiAlcCBzdGF0ZSAlZCBvdXRfc3RhdGUgJWRc
biIsIF9fZnVuY19fLCBjb24sIGNvbi0+c3RhdGUsDQo+IEBAIC0zMzM3LDggKzMzMzgsNyBAQCBz
dGF0aWMgaW50IHBvcHVsYXRlX291dF9pdGVyKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbikN
Cj4gIAkJCXByX2VycigicHJlcGFyZV9rZWVwYWxpdmUyIGZhaWxlZDogJWRcbiIsIHJldCk7DQo+
ICAJCQlyZXR1cm4gcmV0Ow0KPiAgCQl9DQo+IC0JfSBlbHNlIGlmICghbGlzdF9lbXB0eSgmY29u
LT5vdXRfcXVldWUpKSB7DQo+IC0JCXN0cnVjdCBjZXBoX21zZyAqbXNnID0gY2VwaF9jb25fZ2V0
X291dF9tc2coY29uKTsNCj4gKwl9IGVsc2UgaWYgKChtc2cgPSBjZXBoX2Nvbl9nZXRfb3V0X21z
Zyhjb24pKSAhPSBOVUxMKSB7DQo+ICAJCXJldCA9IHByZXBhcmVfbWVzc2FnZShjb24sIG1zZyk7
DQo+ICAJCWlmIChyZXQpIHsNCj4gIAkJCXByX2VycigicHJlcGFyZV9tZXNzYWdlIGZhaWxlZDog
JWRcbiIsIHJldCk7DQo=

