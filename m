Return-Path: <ceph-devel+bounces-2280-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2469E9E47
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 19:46:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D6B71883B1D
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 18:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC26155A34;
	Mon,  9 Dec 2024 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c953JziI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AAD13B59A
	for <ceph-devel@vger.kernel.org>; Mon,  9 Dec 2024 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733769983; cv=fail; b=EOnzsXlRjP9E2q2IJN2pmsX+zV5LEbf67vwg1jSpUUIHrRq5hXFwIlY3goPs95j90Zastdw1u2WgWcQcrhpXs0pUFfvCumCqBH4A1iZI5sV+fPmFRG82e8g9RPGKCj4d/KFtwGK3cg0ppQLE53VnirAGAl1XF1wightvmF5T2C8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733769983; c=relaxed/simple;
	bh=GePRzu9SRKmA/QJNONmbBc8Yh5VBoicmFn5EmW3YsUc=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Lyoh4HEXIf4pRV8g8qD6fcbDsgypUXpTBSwWyL8euQpSy3INGQiPQSGhhSZIZnm0OO8Ja2M8heRBi8bjvHNiBVzOnbqp32IwHm5ciOCk2GfNlrm5WKNAn0PtHtTyrRQMFFKd2RLP+61qTuyxtuzIj9O/bG1eIqxJzZq0Y0rCyOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c953JziI; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9Ebe3c011087
	for <ceph-devel@vger.kernel.org>; Mon, 9 Dec 2024 18:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=GePRzu9SRKmA/QJNONmbBc8Yh5VBoicmFn5EmW3YsUc=; b=c953JziI
	NcZD1ByMSx7Eib+UTjGGUbaaCChOVZNzlfVTp2wEWSPb8sah+bOTZU63i29wIEmc
	j2WTa1KnpiagD66sUL5ZKtUkb2j5DyR6lwJcBBpmTA/S6rhOdKvcC+4HgRyR2dn3
	8Yo/9YAeB5gQ9JeriesxqEz10ewbIyUvb7soVTVwKb4rv/1TmXgADKLR5ZYxi2sw
	7dLxP0Jx7iWuvO1og8Q4PIEEyIMkCzIC8AytBRZj0YV6gXWagkYUZmRJ7JJqrlkv
	6mgvXaR4Tzi5dX+MWHBSW8OmjRTqm8cOOUx0XN429F2dNWxAgmO2juJhJWMGr+vF
	+eWSegaHu7joWw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8k1ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 09 Dec 2024 18:46:20 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B9Ii27V009127
	for <ceph-devel@vger.kernel.org>; Mon, 9 Dec 2024 18:46:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8k1yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 18:46:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEbUXxVyw+cKhXXFsr+8cn4EC4pMdq6xPOZC51zYfqatw+UvGALp4Um2UBj46qPhcdqVALl0ZWVHaqINGs2QSiJpHojIPDrAEUNDnPVxuE3IxOehZexVLt6mqU2zi0HuJTITH+zKB/3wgkGaBnpjtQ7MKxZgg1InparEIOFUUPxJ8ZSAe3te/nIv5ENaf15kU/mjCYx+uQTpTa/Lfx/j9QzfRUwdmNssReDIlhgrZ0jG/s2ROnkENKFd5+ubm3je6DfhgH51RfOmc65S41si+11di+HFresBYr60nZcX+To1uULVXAndDqBzaHV+IP39xLZLYiRfECwDV38ByHI8SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zkAaJ4cuJ6sb238LfvkyPI0J+TXwYKxyzl/bHp9fVY=;
 b=QASnf2+tKjhoysWx1SvZ1pOV5e59PLyCnhMAOC/5r2wghYsQG6QCZ1xCuA4pXn8JcmLWBxcJZ+T/8nEqAcnFWC8sQ/X1E+MI88W/pNfQRpEkGrdimuV774Hin8OgrY8hAKyiz/sZmb7Y9HHMiMK8AZfdrHnDqJqIv9LS0Bs1Ss64+kxdbBWNNgjAIEAL10yNVcOepbkq45tuuRxosRD8432vK6M/NQ6O2ZPugg3+BAv2l81Tnhl2VcY+f2bVWy77edgM56OFXnkdN/YIteL2SaadqIS/cg+DpVwnjF4/ZrNAt3+zIsk6i0ATjHeL3Mf97+oAlPWvhMAiWQTfD6EZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH3PR15MB6261.namprd15.prod.outlook.com (2603:10b6:610:163::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 18:46:17 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 18:46:17 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<Alex.Markuze@ibm.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph: improve error handling and
 short/overflow-read logic in __ceph_sync_read()
Thread-Index: AQHbSZchpaDtxBRPtEiqVZCjH9oDnrLeQhMA
Date: Mon, 9 Dec 2024 18:46:17 +0000
Message-ID: <c96977d8fb8321251fd5cc5e5ad02c6ffd5edd43.camel@ibm.com>
References: <20241208172930.3975558-1-amarkuze@redhat.com>
	 <CO1PR15MB4876E2C9F48D78426091DCD092332@CO1PR15MB4876.namprd15.prod.outlook.com>
In-Reply-To:
 <CO1PR15MB4876E2C9F48D78426091DCD092332@CO1PR15MB4876.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH3PR15MB6261:EE_
x-ms-office365-filtering-correlation-id: 5d586f26-fc2b-4b93-dd44-08dd1881c3d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bFBwKy80K3hoQU1STWNQVWl0dWw1QlcwQXJZYmJKYlRMU1o4RWd5WFBKQXhq?=
 =?utf-8?B?WEJmaWl0djRpYzhicHZZSHFaOUJmdmRONWtaUWN2cEFSRGxublQvSHlrY2Nv?=
 =?utf-8?B?TmxNQjkxUjhHZE9HSUExbTV0aWg1MW8rRHpMbkIzYWl4UHFrejQ0YjUwSjFP?=
 =?utf-8?B?alVRTGtibzc4b1RwTmZRQkpiR2lQTUZpTG80WU8yQWltbWJyaE9lWEZ1VDdx?=
 =?utf-8?B?WnR6bFphK2F0OUpZNm5MRElucVhxNDVjRVVBaG5EVmVoK1hMQ21oSUpZbW9C?=
 =?utf-8?B?RDBWL0tiSGxTREJsSFMwZUlGbW9DbzBoa1dWT1BnQWNsWmEwS0pCNzZYS1RM?=
 =?utf-8?B?NnhmMy9odC85T0hUM2E0emNTeGpnQmsvcTJ4M2RYM08yNUREM3ZBTXQrS0Nv?=
 =?utf-8?B?b2pYSWc2R1lvakEvWVN1S21IMzRGMjhMN0M0Z09XTUNmUVdQK25PTklJM2U0?=
 =?utf-8?B?MFF3MmRHT3VneXh2RkZqVDhCd0RFVzBVTkpiUCtRc3dSRmwrN0hSR0craTAz?=
 =?utf-8?B?QllTVklUdjBHU1BXZjh4LzlwWGxZMjNiUWxVZmUvSzdPL3RSZGhOZUJCUStQ?=
 =?utf-8?B?QmxOY0hMUmlWQkF0bXBCcXZxbkN6VWQ5emRodS9JTzR2WmpBMTg0NDZTNElX?=
 =?utf-8?B?dVFKUE1IMEkyUHBzN1FndENDWG82Nk9peDFYTzgrTTcxb05yay95bVBKc3Ja?=
 =?utf-8?B?MG0xWisySEZycGRtQUpvRXU1Z2FvaXFnTnZnUlQ2cHZKQWpIdUFkQkZXTTZN?=
 =?utf-8?B?TW4rbEFWcGhybDUxMm9hc0xHQXFvWkl3NVEzVFM3TDhPdnB5Y3ZvR3dtOUxY?=
 =?utf-8?B?SDRyV0R1djU4YWRIZUREK25QR3pSOGpOZWo1Wko4QldGa2QwK3Y5b3B2ZDBz?=
 =?utf-8?B?VjBUOHBtK0NDaUNFRXBMb3Q3bGRPcEhjdjJ4emp2a00yRDhyU1psc3hBeWs3?=
 =?utf-8?B?V2tLRTZXZkZpWG9aUWdSeWZ5VWtuVlhVbC9rN1Z3a25sblE4V3hBT2F2ZVAz?=
 =?utf-8?B?Q20venhEbE40RGkvN0VqM2NFaDE0TWVaUUhwdlBPUjBwaTB3TTRLMmRPZ1Bh?=
 =?utf-8?B?RW9FTHkxS1dtUnNFNTJ2ZHdqR2NhNzBSb1RKbVBVdTA5Z2xtM0ptd3NsUlAr?=
 =?utf-8?B?c25WdXZFK21vdTcrSlVCcTNub256SmROeXhLSHVsUVJiTGJSRnJWR1RPUjhC?=
 =?utf-8?B?MlFjRllIMHV0OVVlQmdFRjZtYmhIcHgwWDB0dWVmeWg1ejFIMytGVzFjVm14?=
 =?utf-8?B?ZUs5VndzN1h5NCtuWWNlMVRNcVVJMTlqRzdnVGE5b0pkZ0JZaGg2Tlp1a0cr?=
 =?utf-8?B?b09aT2dqSEw5UTEzRFNkd3NUanYwUUdKZlB0U3U1eUhYVTZ4Qy95bTg5MHFB?=
 =?utf-8?B?cFNiTWdjZzM0QXNOU1VyUXEzMlo3Y1k3aUhYR2xBZGxDQlIzTDJ4VXdCMHI0?=
 =?utf-8?B?VWZmTEFzU1h2QmFCcUZpWmVpbWZRaHdta1FpV25NUXZvanJaS1FOVnlUc3pK?=
 =?utf-8?B?aGlxVWJ3UjI4YUFHc2VjRm1qZWtrRnNERStqTGM0Y25BRytueEUwSzNTL0k0?=
 =?utf-8?B?MkhvNjNMSlhiOUJGTFNIdFR1bzA4NHl3TDNUa0N3MHBEYWpRaXJYVDA3VFE3?=
 =?utf-8?B?RVBFVFU1cVphaEE5NFQrMFFGNHQrTEJNMUEyWHp6ZVV5OURKL1ZhbGMvVGR0?=
 =?utf-8?B?enpRUUlvdlkrTlZqVzVqTlJXRDNjakJ2cmhSSG9MYWxreUZJUmFBZTYrSmZt?=
 =?utf-8?B?cS9hdUw4ZjhRTGNRTWxVQUdjd1dQUUJ2S2tTUFo2UlMrUUowcndlblBQaVJI?=
 =?utf-8?Q?KpYjq2txxEm0bahuU14/3rTh1hcPJk/2A5Pxk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eWhSY2lCZWoxWXc5Y1l3Q09KYmd3Znd3SW5sNkE5dlgvZE4zUEFFZ2NNQzJ2?=
 =?utf-8?B?U1hPb2Vuc0ZYaGhsQUphVlcrQk9lTWtteE1Ec2RtK1VtQXRrZXRIOTdTd3pM?=
 =?utf-8?B?VExrWldZZStTcC93ckFrREd0VzkvMGpYbU1VMDh4YklCRGtPRHhnWmNBTmV6?=
 =?utf-8?B?QXczSnpiZFlqeWM4aGNaRklEa1pqU1VVQTRmZ0N4UWdPellxdHkyOWJIamFJ?=
 =?utf-8?B?Yk9DTGkwQ25ORER3U2swVUJRcEExbEFxQ21xQ2tEeUJkNTZod2N3MlY3SnQv?=
 =?utf-8?B?Mk5vQStVOWNhSzc3c2ZhM0J1YnRwaHRnT2ljQ1ZpdFlCRTNvakY0NCt4bFdS?=
 =?utf-8?B?cDhvSFI2SDEzZWhXT2NoMGNBU0E2OStiZFBXMGRiRGkzd2o1N28rTmZvS1pk?=
 =?utf-8?B?a0l5NHNpdVM2VzU0enlISFZEbTdGRXhJNlVWWVlVRmhUVDZYa3VzOGR6UHpv?=
 =?utf-8?B?WTMzcm02NHloeXJSRmVXdW9qbnpsdkFWZkE3V0FKNCtUVHYyQ1BjMjFyMTlI?=
 =?utf-8?B?T1kwUC8rSHhDT1IyQXNKaS9tTlQ2Wll5c2tWRmlMUUJTY2FVb2s3MDRmWHVi?=
 =?utf-8?B?ZW9mdWJyejZsRW5xK3ZIZjBmeUhmMGd6SmtvMHFydDFLcjVaODF6MTdWUktD?=
 =?utf-8?B?eUxUanNCV0pJU0MrdEl1SkEwQXRqVTQrNFR3N3JTcm9YQ09SdmVTT2ZQVU1G?=
 =?utf-8?B?V2U3NWVTUWxJOW40dE1wcTRIbkQ0NXRCa3JtbE9KRzJHaVZQdzVWUTZTQkRw?=
 =?utf-8?B?R2tjN3pVbHpGVFJDY1BldEMrV2RHa0ZPYnJCbVBHQUczbjh5ZEpvUXZhQjQ3?=
 =?utf-8?B?OFFJTTYrOFA3OVVEbE9yaExiakRMNlNNdldmTjZ2cDlBU0s4M2U4bjdVVEp3?=
 =?utf-8?B?eFVGKzFvQUVUTENmandZWngyblZWMm5samFZYlN4N0ppUE55K09aUDJpSmI3?=
 =?utf-8?B?Nm91ejRsOUNlc2Rsd2V0TEhaS0VCbkVpdDJHZm5aMVppVTg5NjBiS3ZTR05q?=
 =?utf-8?B?VXUrdDVUZ1pSS3BPV0RKNHpBRmNiZzQ5ZE9uOXNuUWxlVmNPT01EM1ZHZzZQ?=
 =?utf-8?B?S0JmMFVua0xKQytYSHVvK3BaMGZGTkRFMi84TkFlUTlMK0NTRy9VMHE4c2x1?=
 =?utf-8?B?OHZ6KzhUdDllckxUem1nMERITWxXTmRqQXNHK3U0Z01zb2RUbXF5Z09mZU9l?=
 =?utf-8?B?MFRSMUJWdTcxUitNUExSRzYrdXVHMTlKMHZGRUdQa3l2aXJpNGpvN3RhSjRH?=
 =?utf-8?B?UDJSOC9TRHFVZEZIbDdQN2pweFdrUW1kOFNhRDRHT0lzL09QZzJVc2hybG9p?=
 =?utf-8?B?SXljN29zbHZUOENqWjhFaWZrd2Q1bUhmTXFqajNKTkxWaGs5c0w4aklyOFRM?=
 =?utf-8?B?OHhVQ2tQREhtSVdFdFlkWTFjMnpBN2EvZmlPeWxjTDIreVlHVEJXRkwwWnVh?=
 =?utf-8?B?eVpNcHBqeHRad1ZtQW5ZN3FLYW9uMk5KRDJ1VCtrc1ZGVjlxSE9sUHRBQ2hw?=
 =?utf-8?B?ZXFFY0E0amd6VFcvaEY2ME1pRy8zRVdRS2p2dk8vaDVmV05aZ1hZdURpWUlx?=
 =?utf-8?B?WFR3czk1T3dlRmorVTRUeWM0anJPTUcyOGdOYnpITmM1aXY3M1h3aTFERFp0?=
 =?utf-8?B?dUxXZEhlVkhPbzRsRTJKbzBFR3BOQkQ4YVhuOFZ5bzRjSkJyV3JKUkdRMWhq?=
 =?utf-8?B?dzdIc0lNRkh0a1NCS3grNG1GZi9ZV1M3MXgrbENzWWlNbHVXYWorVWVJRXl0?=
 =?utf-8?B?QVVwK0RDbGlJSVc1NVZXbjI0eGNlWmdlbHZ2QzlMbndiY3F3L0FXaVRVUnc1?=
 =?utf-8?B?cHNnZnJvdkxFbGNvdW5leFpSaXpNbjBFUjg2V2lsYWs2V2NOY0k3TkVOSzJI?=
 =?utf-8?B?UDJNK3Z5VEtJbjFYVWtJYnpJRU1RMStYU0ZrTS9UM2JScUZkNDVUUERuNGJ0?=
 =?utf-8?B?dzNsOXppYnBNZ2ZvanQ0azl2UUVoWldjYTZHK3VOb05tSlZnczZBaTlpbDI0?=
 =?utf-8?B?WCtVVHdJaDRid1BMNjZJa3lkVzA4ZWtRM3dsSURwWnhWY2NUS2FqVHhTbTRW?=
 =?utf-8?B?VHd0QWplZjNaUSt1enU5YVBrZGVkWnpWeXAxNlNqR3VTT2MrbTk2RkdvSDVZ?=
 =?utf-8?B?dURNZythOWhNVGM2eTJJMHpMVHNDOHRjckV5Z1Ztam1TYnRZNzJSL3VuRUNK?=
 =?utf-8?Q?85bXcRjSBLq/1NO+UpWZ3O0=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d586f26-fc2b-4b93-dd44-08dd1881c3d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2024 18:46:17.1503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cdnO4dcTCRhFstRwwcxtUrg1p8wQIeQXQvUz1WWU+5hdjnnxLBZjbAfJ5nKV53bW8tje2lQWVaw+2oJu9tQdTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6261
X-Proofpoint-GUID: Y7QUjWq071iNFgyBkR-56GsuU-LDmpHk
X-Proofpoint-ORIG-GUID: WEnBEgKNAM9XbxWRjik1H4bvvoX5ikMb
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B4AAEB7E753264E8589981F85AF0E59@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] ceph: improve error handling and short/overflow-read logic in
 __ceph_sync_read()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090143

On Sun, 2024-12-08 at 17:32 +0000, Alex Markuze wrote:
> This patch refines the read logic in __ceph_sync_read() to ensure
> more
> predictable and efficient behavior in various edge cases.
>=20
> - Return early if the requested read length is zero or if the file
> size
> =C2=A0 (`i_size`) is zero.
> - Initialize the index variable (`idx`) where needed and reorder some
> =C2=A0 code to ensure it is always set before use.
> - Improve error handling by checking for negative return values
> earlier.
> - Remove redundant encrypted file checks after failures. Only attempt
> =C2=A0 filesystem-level decryption if the read succeeded.
> - Simplify leftover calculations to correctly handle cases where the
> read
> =C2=A0 extends beyond the end of the file or stops short.
> - This resolves multiple issues caused by integer overflow
> =C2=A0 -
> https://tracker.ceph.com/issues/67524=20
> =C2=A0
> =C2=A0 -
> https://tracker.ceph.com/issues/68981=20
> =C2=A0
> =C2=A0 -
> https://tracker.ceph.com/issues/68980=20
> =C2=A0
>=20
> Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> ---
> =C2=A0fs/ceph/file.c | 29 ++++++++++++++---------------
> =C2=A01 file changed, 14 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index ce342a5d4b8b..8e0400d461a2 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ceph_inode_is_shutdo=
wn(inode))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!len)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!len || !i_size)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * flush any page c=
ache pages in this range.=C2=A0 this
> @@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int num_pages;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 size_t page_off;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 bool more;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 int idx;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 int idx =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 size_t left;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_osd_req_op *op;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 u64 read_off =3D off;
> @@ -1160,7 +1160,14 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 else if (ret =3D=3D -ENOENT)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D 0;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (ret > 0 && IS_ENCRYPTED(inode)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (ret < 0) {

If I understood correctly, you simply added the check for error in the
execution flow (ret < 0) before processing IS_ENCRYPTED(inode)
condition. Am I correct here?

Thanks,
Slava.

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_=
request(req);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D=
 -EBLOCKLISTED)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsc->blocklisted =3D true;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (IS_ENCRYPTED(inode)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in=
t fret;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fr=
et =3D ceph_fscrypt_decrypt_extents(inode,
> pages,
> @@ -1187,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 /* Short read but not EOF? Zero out the remainder.
> */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (ret < len && (off + ret < i_size)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in=
t zlen =3D min(len - ret, i_size - off -
> ret);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in=
t zoff =3D page_off + ret;
> =C2=A0
> @@ -1197,13 +1204,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t +=3D zlen;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 idx =3D 0;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (ret <=3D 0)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 left =3D 0;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 else if (off + ret > i_size)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 left =3D i_siz=
e - off;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (off + ret > i_size)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 left =3D (i_si=
ze > off) ? i_size - off : 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 else
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 le=
ft =3D ret;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 while (left > 0) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 si=
ze_t plen, copied;
> =C2=A0
> @@ -1222,12 +1227,6 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_request(req);
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (ret < 0) {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D=
 -EBLOCKLISTED)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsc->blocklisted =3D true;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 if (off >=3D i_size || !more)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> --
> 2.34.1


