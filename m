Return-Path: <ceph-devel+bounces-4103-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 268FDC81F7D
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 18:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685743AD3B2
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 17:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8194F2C0287;
	Mon, 24 Nov 2025 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m80GfY7w"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846E2BEFED;
	Mon, 24 Nov 2025 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764006439; cv=fail; b=ML15PQvw2L+2DvkcQ+cHic1QUZR8GpWBpNkh/3U2r6wHVhK5pv2YsHWQdBGvDYjyfyR8DdpRX5LhX5FJHFdJb8bxtR/IwwwYEGTVtkSebqwaetYxa3NalT+nDeLNkQw6+FEY0nGPzy+Jrul0wSsxTD41dEt2hQS+Rnqeh9ubjVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764006439; c=relaxed/simple;
	bh=/NwVuvd+qmDeANkvsT6R2R+oftT4pxbfHd2qq9izD94=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=stuPb90pHhVvNTXcuevS5/kNjvsMi2n20bva79GaI7ZAdmo9fC5CuHambgECGTaThrmRugQxDf0dO1GigX9ywU9ZbmQT552CiTBU4PEuSvcv7w/9837E35Fjn1vTqqEyCltVlcLzlZRKKhsGO0mnoWwicnjXyjLsF+IP+Sz4LLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m80GfY7w; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOFEeTi011873;
	Mon, 24 Nov 2025 17:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=/NwVuvd+qmDeANkvsT6R2R+oftT4pxbfHd2qq9izD94=; b=m80GfY7w
	jG/6iZ/+vvyZ7kMwlxKOTXWXJlNqSVHodk1Epc1IZlaTQLaYc187DYitJ8tWqEYv
	KIsd8xNPltwX7Q/YuPMkG5u2oZUNB3ujodHDkUB0n5r3ynXgunYLshVEebkHrZv7
	Tn2CQ7z9qno3QcK9Y6dGpTQUNIFMiCX/97+cFnIFvl2zPo+GCRU4jjOrlC/mH3tk
	L5v1yKS1krMLpPPJCmPceuQ7Gq+ri0xj9i+7M6nS/qV8YkF21kNQr0rJwW7yGIWb
	fdabxB01oNdh0h1NmYVBBY2frddS995NPQL/zFqwKlWzXj9uGDqiD4fGVTBStr1O
	PijReBIU7yDfTw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kjs1vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 17:47:08 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AOHl7US009466;
	Mon, 24 Nov 2025 17:47:07 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012055.outbound.protection.outlook.com [40.107.200.55])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kjs1vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 17:47:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kXUfKm0bu5HrGscLgJDtypmoobbG5or0cjx32rHzbKRsfD3ZZP/m+mjHDSMLm8I+R3wn8MKMhfausHg0cfY7zr8yA38hb2qaHda5hl/KCURGVe/aYaNS6m/+jg/jHFac+270+yUm7XIHJ8egS6NCW15gXy8YeRAuyKnqmFMzmYnWntWbXRMCnrV96UCwQW6+31kRmB2JSMqIcQT5Iza+rewCiATQx0nB70N239Ff54ZosKrMcNKB6sVqAxic/KFv3PydvYS5cfT/9XVDCbSQvNR6h2vr3vUmPbzNa4ykoLq/YQSX0QKxsRa5XCtXuTtVC6hpIJWia3YYV/m1fY9vQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NwVuvd+qmDeANkvsT6R2R+oftT4pxbfHd2qq9izD94=;
 b=EcDq/EoTLm6l2Wg5vdi9BGC9U+JeGtgnZi2MzZIXYCd5UU6tsZgoi6tYYz9Ece8yHWA2DJ2mZ3nERouD7aimatBEX7rQiXDjJeiN3pBvFsILjCITEEkvRa9bWDkdbo22v5I5BYLnLrSvmVqACrV6MltUBqbV2HQmFIH+PS7rJo2b9LmMaaSbbX47rFK511rTnEa0j/WalotXh0DNbRrBlRnrImFJ/IgrqOLpEhAH/cF8M3oLGNhz8iHTT7l7XmkbVV2vjpcBM5b31GX8FD1YK2do7DAny5HlFOZ2vBu5I6KwpEmzpfcX7g7kJ9zzUMEu014OZ7t6Xp0yF70elQLzYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB4370.namprd15.prod.outlook.com (2603:10b6:806:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:47:04 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:47:04 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "morbo@google.com"
	<morbo@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] ceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcUnpBY6YJKfAb+keetMdZm4Ts4LTsYAYAgBWjloCAACwegA==
Date: Mon, 24 Nov 2025 17:47:04 +0000
Message-ID: <82c49caff875cc131951a7e5d59ecb45efbb9224.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
	 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
	 <aRJASMinnNnUVc3Z@smile.fi.intel.com>
	 <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
	 <aSR1FU6uCqpOUFeb@smile.fi.intel.com>
In-Reply-To: <aSR1FU6uCqpOUFeb@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB4370:EE_
x-ms-office365-filtering-correlation-id: 9c5ba013-b2fb-4cd7-3e1d-08de2b817add
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|10070799003|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?Tm5YdDRSNzBLZS9iaEVFYVI1eHRBenhKeUpuVmRuUC83d3hSVlg2d2tzUUZv?=
 =?utf-8?B?bzJPd1pDZkJoWnBkYWxvbzZyUjBPamFuSmRoUE9RUlB1NWZNcmxmUGZGRFpm?=
 =?utf-8?B?MTdNWWoxR1F4T3RrV0tPL3VnV3Zsa0ZkN253N0NBY2dER0FVVXkzRXFobndW?=
 =?utf-8?B?R1lTMU9SY0o2eFVSNVZnZ2NBOTdYMFBDTWZOTDNBdlFiV2RHMVJKcFZ0eDdY?=
 =?utf-8?B?bU5jdGdiTkxnaVRpdGQ5T3luVk1qSkRTQzdQVWdHVVlETnVWUk5BZ0VHdml4?=
 =?utf-8?B?bHhiUnY0L2Q3U3dDM0I2bU4zSVF0TEdDc0R6T3NpZjNUTUZzTmczV1FXR0Z4?=
 =?utf-8?B?a0s3eDRsaUxjOVdKVjNFZjR2eWRxaWlBZWQwUDgwR3MvOHFuUk5ZQis0dmxD?=
 =?utf-8?B?dXlYSlFGY1FXRVNtbGo3UmxzU2JNVWIvR2IxYU5nUHlMbkpRYnR3UTJvSDY0?=
 =?utf-8?B?N083R3pDaUxaL1VyaXIwMlhRaHhyRCt5Z1JXRVRIYmdoRTVnU1NGSDJ1YTMx?=
 =?utf-8?B?K1JaWkVWcXpTakxEOTQyeld4UENHYXdKZE9jTVFKZEZEa0hTNGhiTUVHam5W?=
 =?utf-8?B?cTNxdVN3QzF4Wnd2aDJLaHd5bTVKbkNLdHdyWXhCLzg2WjNWUktkU29IdFIw?=
 =?utf-8?B?bEw5TnV0L1B6SlhFcnl1TUlkMVRHeUx5QmRUQmMzVXN1QmJGWmtqdFkzNE5N?=
 =?utf-8?B?TzRxN0lwcTNsdU5rS1J2bEI1WGRZNkl6RFEwUHI2OU0zNWRVcjJUamNlbUJU?=
 =?utf-8?B?WXdTRjE4bzlZdDlnQ2JiR2o3N21GTHBPb3Y2c2RJZnAxcTFuemUwbGZrcXVk?=
 =?utf-8?B?Mks0YkxQODBncVhpeEpMV1ZhYU0vNnZjSms3dWFDSTR0b2k3WGEzYVRQWlFV?=
 =?utf-8?B?eDY4NUJrcWhBd1U3VHo1eWhxazR3cHdVMGNNaEZ3NFUzeUZQODByR1hBQ2Zw?=
 =?utf-8?B?ZTByMWRQQ0R4WGRNL0NZZEtURHNtS2hFcUxKWk8vN20rdk0vaWlEdU5FWGVQ?=
 =?utf-8?B?ZEl4anFyWHE5Z1NmZmxKdXlMNU16MEl6UFFySmlZdFNDOEVncklRWXFvejI4?=
 =?utf-8?B?dDU4U3JyUzFzOVBEUm5tT2llVUc4MmNWbzluWFh6L1IrL0prTXJxeDZmK3pS?=
 =?utf-8?B?NEh0bWsvZXVKMDdsUTl1aWcyM2xEVC8rQ2tWSmVvNFpzaTBCbk5lUkFiWFhi?=
 =?utf-8?B?YndlWlVZVVB1SXNJbzFzaGVpWGk0aXorUkNYb0FVQ3lYc0NLR3B5SElhQTZX?=
 =?utf-8?B?cGZvbEFGcnd6M1JzMUdtY2FKbUJNMkNGZE0yeHNtcXpLc1paZTh6YjJqUkMz?=
 =?utf-8?B?QWZjN2Y1U21IWlVGZGVRU3ZwcEd1SW9mOHNLS0Z1TVd6ZGtHUTE2Qjd3dlA3?=
 =?utf-8?B?eVArbkJZanY2aWozTEVSeG0xY1NhYTNlRmRaZCs1QnZRUFN3c2hFMk0ydFBh?=
 =?utf-8?B?bjBxYUFZaUtnVVc5RDFkR0dGRnBjWkJrWE1ablNYMmxzSlhEb0hHczVHdC84?=
 =?utf-8?B?UUNnMG5jT3lxTWZveUpMZnFiQ3hzVFMvajRNK0JGZ2RMV210UFFNdTBUc1lR?=
 =?utf-8?B?OS84MEo4MXBYNHc2MHJYZ0RDdU9DUDhjTDV1eEhPVGU5SEhScFRQMUhqSkZS?=
 =?utf-8?B?YWEzZFZCVlc3eEVHcWtwakRvRzZ0S2lVM1NLam1TOWl2V1M1bHZEdktiWWx5?=
 =?utf-8?B?aXhJWmxkY0hjbXI2RG0ydlA3UkxZQm5pUEZPdjNQSlNvU0RrQ0tiSGowandU?=
 =?utf-8?B?RFpQdGdmM0M4MlNZSW82amFBb1R1K1gwT2E5TlF1bENHbjBFRXMyMjZOckZk?=
 =?utf-8?B?anpIQU5MUHo3cStNNDJDNjRsSFJCbURXTS9oeC9JTEF4ckF6SWJ1dE1xSHBK?=
 =?utf-8?B?dXZOZGhaWFRoQ0JXa0FqWXdQWjZHS2tjWGJtdDUrWEdqNFd1b1g4QzRmdlVX?=
 =?utf-8?B?WFMybnVIaGdXRU1paW1SNlJ0d0p1aG94T0VNUGlSd1h6M082Z3RTZEhsVnlM?=
 =?utf-8?B?aGFtSVFVQlk5Y3RXbFpraEFIRW1LbEFlOTRtQXl3M2VtZjI2RUVNNXFETmpv?=
 =?utf-8?Q?9RE3mG?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(10070799003)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ajhjai8rNHdaSnl3MnovU3d1MWRSVUY2em9WNWoxZW9ZR0xUWlFUNktTa0Ix?=
 =?utf-8?B?NEljTDFjTi9uZ3NwdTcxdTlzN1ZzclVSam9PZXp4Wk9MeEZQUTlDMXQ1RS8w?=
 =?utf-8?B?eWdVVUJGVFlzN1ZTbjI5a1VIUzFJZEZYK01VdHA3ZWREVlRLQ0EybmhPeTlx?=
 =?utf-8?B?S3pNUVYrRnllZWF2UE5PMGFoWFZzRitMSFBGMnhFa3d6Wmx3MlhoMmF3dHhC?=
 =?utf-8?B?cEZTczRWOVZOaGd1RXBiSzJXM3Z0RCtwMDcybTdyZ2UzVXV4blorTEJQYStp?=
 =?utf-8?B?NzR0a05iQ2VTTVJWaElodXQxSkRsQVo5N1pra0hIYlRYSkVBUXdDQ2lhRlJ1?=
 =?utf-8?B?UzVaTWVyZ0lOdjVldkY1dHZLYVJCdVVZakZrcHNIVDJ6WTd6UHh6K1c1Vzlx?=
 =?utf-8?B?Q1lyLzlVRUtqaU11WE4wZUxtZ3R1VzFLV3B3UGF6cUlHZGJFRlVaMnplaTYy?=
 =?utf-8?B?UVo0dGZFckJpdld1Z2VNbTd2bEZmdDYrT0l2emJ0aXVZNmZ6ZXlBRkdyRzVt?=
 =?utf-8?B?blRKNGErcTk2VHhDQTN5c2VScVg0VXo1bHhmSUdrbnRZMHMweFlxMkJVOFgv?=
 =?utf-8?B?NnNJSVd5empmWW1VdWVlcnJMRFZRZUxTTEJTQUlRMjJGVWx5TElLazhPN3c3?=
 =?utf-8?B?RUp3ZStBRVp0cEtwcUNHMkFvTnQ0QlllQzV2ckdPNmFvd1J4dVpKOVZUdjBM?=
 =?utf-8?B?N1BCLzZyVUw3cGlWUk9tWlBNQWt0L1VEb2MrdDBKZVB4OVVwdFVWTklIT1U2?=
 =?utf-8?B?UFJ2Q3F0czhwbTJ5WUxwMTcrTDY0MGgyZittTWpKS0U4Snk1R1JMcWEzNVFO?=
 =?utf-8?B?QjBoOEpZak1acEc1NWlaMnlBL0N1enJUQlpCcDNpdCs2bGw1WnJzTjI5Q0NH?=
 =?utf-8?B?Sllpam83UnNqZEY5bTBQOXhIMGZ3WjlvazdqNmZwYjJaeHJhRFlPeU50eWdK?=
 =?utf-8?B?dGVEL21HSGlpdDV3dGFGMktIUDJzSVBBZHZyb2Q1cWRsTUkzNThUZll4QUJ5?=
 =?utf-8?B?R1VCOTExVEhlRTZoU3hxeXNwVE1wU054VVdYUjRDTUR3U21xZkhxdUkyR0lq?=
 =?utf-8?B?MGdlbWpkeFFOZW1tT2hRc1RqeTBPTHBFUjBJaC9JSjdscWtwVnN3TGQwZ0o5?=
 =?utf-8?B?RnVTOUtGWEY5Q01oNDBuMTFxS3Vyc0VYNzJJSk41SzdkQU1yVXpLUDVzNUto?=
 =?utf-8?B?Skg0dnk5K0U1dFF1dEh1cFMyVGV2azQ0TllZZ2ZBWmgvQnpkY0ZJcFFsdm1x?=
 =?utf-8?B?SWc3WXNXRkxSUEZzVXBuOFlsQlh4RG1LanovNGQwUDZHOFBKeHdXTFRSSHRZ?=
 =?utf-8?B?YkQraGtRejVCM1g1UUhCUGk3bW1oN0RTZGRWVFlXZWtPSHdGbHdmMnl0OWVM?=
 =?utf-8?B?RU82SHZXZFFkTEZGMGR2Rkx2d3pUQUk1RHZ6U3ZzVWZ6TlNpZWQ3djRZenE4?=
 =?utf-8?B?dWtzbFAwU0lldzlZTnlGbXF4cEU1c1l2UnZ4ZUxMRUdVMjFha0szekRPSTBG?=
 =?utf-8?B?Zkdnc204bDgvV2lVMVB0Rjk1Z3Y3R3FiU1ZYQllXbzRVdUhJRGdpWHFqaGFs?=
 =?utf-8?B?bksyMkNLM2ZJS3kxZ1E1SGNRbFFzNlJyMEFWRG92YmFDZzZkRm8yL1BncTM1?=
 =?utf-8?B?YUF6SDhJUGkzVUVjNEl6RnYyekIyQ2pQdUEveXFNazB0YUt6dEw4RlZmci8x?=
 =?utf-8?B?OGNITEtMM3pJMUNGdWlYa1gwSzlaZkdyekZ3dHliSGtkMEkxK3JLTmJKM1Yr?=
 =?utf-8?B?RkE4Ni9hUmw0ZStnSDcxKzJqUy9vQitNSng5bFl6VjJEWC9UZk1aRnhGSEVl?=
 =?utf-8?B?blNpaFlKVmE5Mkx4Zm4zcTlNaHUwNFpOcDdDdnFMY0tFOU05L0tpK0hUWGMr?=
 =?utf-8?B?a1ZHVmJYT1ZpUDRac1plYzkyZHNaV2g2UEFHRWMvMTdFaU1laVJxUTczalNl?=
 =?utf-8?B?Z2RlMzREdXY0bFRnUkJyNGdmMVdiMURvRHYzM2JsSjROR2lWL3JiVW01RUI0?=
 =?utf-8?B?TU5jb1JpVllyWGMwSGJ3dnBuZzFGT3lWeGgxNW93aGlKQVljSkF0U1Ura0pC?=
 =?utf-8?B?SzNEZ0l3a05nbm1icUxuL3VNZHk4S3pvZWhaemd3Nk9DTHFaaDZKQ3FQWHN1?=
 =?utf-8?B?R0gvSTZKU1htVURpR3JETEcyallMdzRPbmZJNzZUL05xK3BIYnd2TEJ2MU5s?=
 =?utf-8?Q?4m5mEZ38x+EHGhMnRuOyWCo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9306A54ACDCFFF4E843ED269443B8576@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5ba013-b2fb-4cd7-3e1d-08de2b817add
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 17:47:04.4761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /zSgc/R/2W54g6Ny4KaUzLWxFMrZAs1IBSectFeIODovOCGxZuPRYfkXj/HNaxCSSjiilXFEup8JMp3T1bKaDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4370
X-Proofpoint-GUID: XFdySd12PX3i2mrBil3ypC8JIE-xuaTR
X-Authority-Analysis: v=2.4 cv=frbRpV4f c=1 sm=1 tr=0 ts=69249a1c cx=c_pps
 a=JQIjQaBRt2POjw1IEeT7Rg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=QyXUC8HyAAAA:8
 a=VnNF1IyMAAAA:8 a=5Yiz0lNn3Vab9qnQaWsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xafz8BtY8U7EwHNt5qvdmLeo5x9rybjb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwOCBTYWx0ZWRfXxCTTQFSGlQB5
 XiirzxcytPqtbZkCp00rGsXaZ9vu9W46z76g4Q0NUVgIAfPlbcdNUu+A03997n3hhRof3iS45HC
 Eca7T8YbazGms0LHb121md6NpSVDoyYcd0+dxr38ZV2qjREb3gHyOlkPv79avxyY568UxuzUWOt
 K4wdL5Tx/VMr4i6Z4vVnSzbhkCH4A7eNpnxjrjGpa3gM9Rfcrk9/MluvgHG0inqQ4yNjLqImUS7
 EJ336ieKX7hLknxkX5k4EqupYMQHKpC3MljwIguh2ePfRr4Wqu9bFb9afpDJWhCM//hpnHOFtHl
 x9FnxNxdoIC6UZr7fJXvJRUw5WwtlSHvaKfl3yKeFWjoI9rU7tiobY7YlPd5dzNLsD3LK03CsEJ
 UgvSwY606y3KVDcAvD1UfIGN8T2ciw==
Subject: RE: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220008

T24gTW9uLCAyMDI1LTExLTI0IGF0IDE3OjA5ICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDEwLCAyMDI1IGF0IDA4OjQyOjEzUE0g
KzAwMDAsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMTAg
YXQgMjE6NDMgKzAyMDAsIGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbSB3cm90ZToN
Cj4gPiA+IE9uIE1vbiwgTm92IDEwLCAyMDI1IGF0IDA3OjM3OjEzUE0gKzAwMDAsIFZpYWNoZXNs
YXYgRHViZXlrbyB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCAyMDI1LTExLTEwIGF0IDE1OjQ0ICsw
MTAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+ID4gPiA+ID4gSW4gYSBmZXcgY2FzZXMgdGhl
IGNvZGUgY29tcGFyZXMgMzItYml0IHZhbHVlIHRvIGEgU0laRV9NQVggZGVyaXZlZA0KPiA+ID4g
PiA+IGNvbnN0YW50IHdoaWNoIGlzIG11Y2ggaGlnaGVyIHRoYW4gdGhhdCB2YWx1ZSBvbiA2NC1i
aXQgcGxhdGZvcm1zLA0KPiA+ID4gPiA+IENsYW5nLCBpbiBwYXJ0aWN1bGFyLCBpcyBub3QgaGFw
cHkgYWJvdXQgdGhpcw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGZzL2NlcGgvc25hcC5jOjM3Nzox
MDogZXJyb3I6IHJlc3VsdCBvZiBjb21wYXJpc29uIG9mIGNvbnN0YW50IDIzMDU4NDMwMDkyMTM2
OTM5NDggd2l0aCBleHByZXNzaW9uIG9mIHR5cGUgJ3UzMicgKGFrYSAndW5zaWduZWQgaW50Jykg
aXMgYWx3YXlzIGZhbHNlIFstV2Vycm9yLC1XdGF1dG9sb2dpY2FsLWNvbnN0YW50LW91dC1vZi1y
YW5nZS1jb21wYXJlXQ0KPiA+ID4gPiA+ICAgMzc3IHwgICAgICAgICBpZiAobnVtID4gKFNJWkVf
TUFYIC0gc2l6ZW9mKCpzbmFwYykpIC8gc2l6ZW9mKHU2NCkpDQo+ID4gPiA+ID4gICAgICAgfCAg
ICAgICAgICAgICB+fn4gXiB+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEZpeCB0aGlzIGJ5IGNhc3RpbmcgdG8gc2l6ZV90LiBO
b3RlLCB0aGF0IHBvc3NpYmxlIHJlcGxhY2VtZW50IG9mIFNJWkVfTUFYDQo+ID4gPiA+ID4gYnkg
VTMyX01BWCBtYXkgbGVhZCB0byB0aGUgYmVoYXZpb3VyIGNoYW5nZXMgb24gdGhlIGNvcm5lciBj
YXNlcy4NCj4gPiA+IA0KPiA+ID4gLi4uDQo+ID4gPiANCj4gPiA+ID4gPiAtCWlmIChudW0gPiAo
U0laRV9NQVggLSBzaXplb2YoKnNuYXBjKSkgLyBzaXplb2YodTY0KSkNCj4gPiA+ID4gPiArCWlm
ICgoc2l6ZV90KW51bSA+IChTSVpFX01BWCAtIHNpemVvZigqc25hcGMpKSAvIHNpemVvZih1NjQp
KQ0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIHNhbWUgcXVlc3Rpb24gaXMgaGVyZS4gRG9lcyBpdCBt
YWtlcyBzZW5zZSB0byBkZWNsYXJlIG51bSBhcyBzaXplX3Q/IENvdWxkDQo+ID4gPiA+IGl0IGJl
IG1vcmUgY2xlYW4gc29sdXRpb24/IE9yIGNvdWxkIGl0IGludHJvZHVjZSBhbm90aGVyIHdhcm5p
bmdzL2Vycm9ycz8NCj4gPiA+IA0KPiA+ID4gTWF5YmUuIE9yIGV2ZW4gbWF5YmUgdGhlIFUzMl9N
QVggaXMgdGhlIHdheSB0byBnbzogRG9lcyBhbnlib2R5IGNoZWNrIHRob3NlDQo+ID4gPiBjb3Ju
ZXIgY2FzZXM/IEFyZSB0aG9zZSBuZXZlciB0ZXN0ZWQ/IFBvdGVudGlhbCAoc2VjdXJpdHkpIGJ1
Zz8NCj4gPiA+IA0KPiA+ID4gLi4uDQo+ID4gPiANCj4gPiA+IFdoYXRldmVyIHlvdSBmaW5kLCBp
biBjYXNlIGlmIGl0IHdpbGwgYmUgbm90IHRoZSBwcm9wb3NlZCBzb2x1dGlvbiBhcyBpcywNCj4g
PiA+IGNvbnNpZGVyIHRoZXNlIHBhdGNoZXMgYXMgUmVwb3J0ZWQtYnkuDQo+ID4gPiANCj4gPiA+
IEFuZCB0aGFua3MgZm9yIHRoZSByZXZpZXdzIQ0KPiA+IA0KPiA+IEkgdGhpbmsgd2UgY2FuIHRh
a2UgdGhlIHBhdGNoIGFzIGl0LiBJdCBsb29rcyBnb29kLiBQcm9iYWJseSwgaXQgbWFrZXMgc2Vu
c2UgdG8NCj4gPiB0YWtlIGEgZGVlcGVyIGxvb2sgaW4gdGhlIGNvZGUgb24gb3VyIHNpZGUuDQo+
ID4gDQo+ID4gUmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0Bp
Ym0uY29tPg0KPiANCj4gVGhhbmtzLCBjYW4gdGhpcyBiZSBhcHBsaWVkPyBNeSBidWlsZHMgYXJl
IHN0aWxsIGJyb2tlbi4NCg0KVGhlIHBhdGNoc2V0IGhhcyBiZWVuIGFwcGxpZWQgb24gdGVzdGlu
ZyBicmFuY2ggYWxyZWFkeSBbMV0uDQoNCklseWEsIHdoZW4gYXJlIHdlIHBsYW5uaW5nIHRvIHNl
bmQgdGhpcyBwYXRjaHNldCB1cHN0cmVhbT8NCg0KVGhhbmtzLA0KU2xhdmEuDQoNClsxXSBodHRw
czovL2dpdGh1Yi5jb20vY2VwaC9jZXBoLWNsaWVudC5naXQNCg==

