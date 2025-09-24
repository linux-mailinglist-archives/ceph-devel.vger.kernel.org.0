Return-Path: <ceph-devel+bounces-3723-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DFEB9B1B7
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 19:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8ACCE1B25243
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 17:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0732FDC44;
	Wed, 24 Sep 2025 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I/LbvhAn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8878834
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758736174; cv=fail; b=KNsYNvHcdHlE/ncURMfz4mibTMT3oh8DQbH7PBuw+ZkM90ZOxMZXHBS11wsr1bNuCkMdE09aKgWqlw2ZouKbzWjzzXMuTiiSm4MDKRCbxY45wX6MuwEl8gThSPe1qCezQua0bRwTAoVivfLWXqmBL1ioAQhswfKHNo5oO4DyVZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758736174; c=relaxed/simple;
	bh=PD2U5Mjvsy57tqivZqnm0MhPmj2cjMXCbXijSRG6kTw=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=nsgkb9szoeBBKaYKohpZuFMPh0LgrOGALF0Hd8//zwG6r55DiH+o/fRISQ+jCgF4d6WpqAvUmrmH/QuUur9+Ecw21KFpKMZJBFneDO9QiswX8bfLzerlvIV6tnFjpwW7PKTd01k9YnygYjBwdhBTIXwtcF2s2n/GAoJ2JpydNj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I/LbvhAn; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGJSTE015154;
	Wed, 24 Sep 2025 17:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=PD2U5Mjvsy57tqivZqnm0MhPmj2cjMXCbXijSRG6kTw=; b=I/LbvhAn
	zc5+2DiTxyOjrOAF7Hkg1bn6cA62a8IC6P0YDHQAqscTtElmZDCrTf+/6L/WuIxi
	HdagyaEnsJdq17lWReNWyY1ZlwrgvqYHvi93/vyHtql0YCAz+G66H88xgNbxa2ca
	LvCk33EaFasTbFNHHRk+osuV+tfa/8TEkfDIxz5F8N0VMxZnuy+fRNxg00+giP6l
	E+ieejsD1xRcVR8teogiShMbWIys8ZlbzremK0N3GlN28/OpdqRqddhAgcTHCAuh
	M+XKQ+gR4Z6Tqv04U3VigTWsP/+tuEdYHa6+iN5hWLHgBGunmheCzvwah6q4BSWz
	kfBYpmznK7/Iww==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc16ru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:49:18 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58OHjIZ1019219;
	Wed, 24 Sep 2025 17:49:17 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012035.outbound.protection.outlook.com [40.93.195.35])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc16rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:49:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QR+KbNi8POdx9SXM+yfXjh5hESMniqGNG9QjOdvhMT6w5jKNmc+VNju/2Ge/AQkYAwH4SkKFTxuDQ7C925v9+EgN0j855IdPnVFshMrkDMDSVKp09DRqz5K0ZdYsefqnd0b8m/F3OUz5cXnGg8vVwkCq6+QESjVvapFU2TehOx6in4r74WaHxk0PFQj3CEhcTdKbL5LZ/w9qPqYI1zqa5lCuVI+M1rTUccYRJ0AStZfvCElWbxiBp6/oUWl8Mp6eKOEB/NfCZyBfPrF3NczdYFOKWCg7UrAl8LjuvJGKuxZBbM8tJ8gJ6ivy1O3Gbw9EvMYJx5LrA94/Nfp0ARq/9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PD2U5Mjvsy57tqivZqnm0MhPmj2cjMXCbXijSRG6kTw=;
 b=n4uMc2vTs5croq3EZYShzDYPo7J3OJTB/coqvoz5X7VCo8NHJxkUMdTebBn60bCS3EzSZX5IRj8UteeFL0YjmALMqUY0H5/7b4sGQNbhMPBmBqEihILUaWCcKdT0sDH0ZCaNrdsygmlKkPpy+Z7dkOV257qwAhIc0iFOxmIV6awzV7Cen06M9Zvr60k5dgSoQuOKITIJnDzHRle4zjPSDy5dBeJcuQUstv8ivZfvHCd5pgWBvYUBAO6GMksaDge8jFYWgv61TdzCEu5InkQrNu7WDfJ/S3S5ikyCX6BfcXUtJZ5pGJpva2RhLno55gAfbjEpRESMQz31YG96Af4RKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BL3PR15MB5412.namprd15.prod.outlook.com (2603:10b6:208:3b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 17:49:14 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Wed, 24 Sep 2025
 17:49:14 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "raphael.zimmer@tu-ilmenau.de" <raphael.zimmer@tu-ilmenau.de>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [bug report] rbd unmap hangs after pausing and
 unpausing I/O
Thread-Index: AQHcLUmKL98VClBwI0S6S0aWJyAzlrSinIEA
Date: Wed, 24 Sep 2025 17:49:14 +0000
Message-ID: <55a73b065d09a1bf1c148e6f7fc9a3735dbb6d5a.camel@ibm.com>
References: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
	 <b94f8a4b7d70a9fd3603a1cfcb6a708cf6bd44b9.camel@ibm.com>
	 <9c9e1775-63ad-422d-b8a2-5cd55c7fa5e9@tu-ilmenau.de>
In-Reply-To: <9c9e1775-63ad-422d-b8a2-5cd55c7fa5e9@tu-ilmenau.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BL3PR15MB5412:EE_
x-ms-office365-filtering-correlation-id: 66c38324-c35f-4084-85da-08ddfb92ad46
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WEhsZldwcFJPYUE5ZGNvRVllaU4wd2IxVjRwL2JwTVN6OTBPUFRrQWljY05R?=
 =?utf-8?B?R0FCRlNBNDUzM1h6TnQxVGxVd09XRmFOYzFEeTE4UVJEcURjUnRJSWhWWmJN?=
 =?utf-8?B?b2VXOW85Ri92WXpvTlQ2QXRzcE40TTVLTjFHdmJLQzNKekpkeWluM08wTHhH?=
 =?utf-8?B?SnM1SjlOQ2RnUVpNYnpCUEs2elFnUkdqMFUzdHcwM2tHU2c5TXNhZ2hKSXE1?=
 =?utf-8?B?a2ZiZnRBZ1NXcVhsckRJMElhK1VqaC9EeEZoQjNRMWpuTGdsQkM4YjFvOVM0?=
 =?utf-8?B?V2RFRGgzWG9nR2c0akxXOXhVN0xJWEJCS3c5NFhWRW5JYkFqdDZiRVpVT3pa?=
 =?utf-8?B?a3VxTEVCcVhrcEFYZStUVGlaMTZuZGxRTUtsR1h3eGthTnZWdjFFUVY5ZWJw?=
 =?utf-8?B?OTVjYXRZaUlnRUxKZmhLNjZ6ZVYzUXUySTFZQWxodG9Fd2lnK3lZamc5YXFG?=
 =?utf-8?B?YkRaM2JONVVLTWNubnFqcEEyODFzK1BXZUYrOHl3VUFlbHVXTDBKUm5VNkJJ?=
 =?utf-8?B?QVJhdkFpVUNVbjMvRjlzbk51SHNPOUFjcW4zdllPVkd5V29FaWxLTXZ3VVZn?=
 =?utf-8?B?eWUwak1mdzRjVnVJb2trZXczcER1MFhXNFZXVm00aVRlK29Xa2dSN1lZcDdh?=
 =?utf-8?B?QXVJZ1RIKzMwQkNUa2RmL1g0bE44YlFJK1BuZHZQZ2I5ZjZMTGRlMjRzY1Iz?=
 =?utf-8?B?SVJNYnBsVWtoVU1LMXFRekF3cmtUWHIvVmpVT3NmRzBCVnE0ek5OdVcvTm15?=
 =?utf-8?B?dFFxS0x6bG1QZ3M0dFUzNndlaU9hNGQzOHY0RE93RUFFMXdiYzEyR0IvYXkr?=
 =?utf-8?B?YzRyM3FVUGpQUmNHU3lNcldIVlNmN2tzTTkvY1BUaDVyam1NN3FZWW8wT3Iz?=
 =?utf-8?B?Q3lNK080NVhhdjErUVdYcXRGS3Y0Y21nN1RXNXdMaTV5Z3BsQWdEYmlTdGFk?=
 =?utf-8?B?ZWNsbTRjU1ljV2xXOTA1Y0dLY0F4ZU0rMzhmSGxjZHp0eE5acVJDTWoza1k5?=
 =?utf-8?B?TVR3dDlLYjhNamRRS1dwaVBKRkREWi91ckh6MFA2amVPcHRLdHlzNVhEM2ZL?=
 =?utf-8?B?dXVoVzU3M3ZSUzVFVE44am5vbmtaRldWckI5OEh4T2JtNzMyT3VqMkpDTjEy?=
 =?utf-8?B?d3VDaEZ0cUFBQzR5RXhVVzNRY3c1VWsrekpmL0MrU0liamprblM5L3lJMk5S?=
 =?utf-8?B?Q1NvTHN4VTE3ZC90dUV6TUtzdDdCeHJFeGxNQ3RheCtRQUN4RzFCMERJQ2Js?=
 =?utf-8?B?OXA2SXkwUXNJOXFkZHpHMngvNzIrMzlkV2cwOXgzd1lMRERlMjN4dkUxVHZw?=
 =?utf-8?B?cDc1YlNBRTBITVEvdGlUOFlSN2hkTWFld1YwT3l0dGxmcnVvUDdYSm1pdm0x?=
 =?utf-8?B?RUFlQWpWek9obHBjelZRSkUyT25ySEdTYm9BSWFBWkg4OXlMOWFZU0xNdE90?=
 =?utf-8?B?Tk0yMjZLNmc1WE9LeGdPNlR2QlY3d3UrYjhabkk0NEpGWkIyeFExRzUxYWFi?=
 =?utf-8?B?MkNQaWt0RWxaS1hKaDRFVVFTWFNHQ0lhakZHNTBENytXTWlNeXVRT0lJTDVM?=
 =?utf-8?B?U1lTOHdUcXpuTVRDZVUrM0pTZzYxZjMyWEtyTHNiWCtodGxtR3R6aDZwaHA4?=
 =?utf-8?B?VDRrUCs4OE9tdjlLM3RxWk5xUGVWdjRWc0JvZUJoeGNxdjJMeWxhWFVWcldV?=
 =?utf-8?B?UEF4dW9IZnVDKzBZTEtyOS9OZVRvZTVEWXpONmxmeFE5a0NURk9sNm1zNzNk?=
 =?utf-8?B?eUpwaEZJWDhacXkzNGJmSXU4bVFWYUJVaTJCZWRaNk5TUEUraU4rTGFBMVp4?=
 =?utf-8?B?ZDJjSWZLN3BCbkxiaXM2NFZpanBPdTQycVB2ckZ3a2NESkRvK1RnQ1dZcmND?=
 =?utf-8?B?ZVRkMEJUd0xKN0tiV0hObncxdDJKRHJuNHpCR2FzQXNQbEhHWjRVOFVHTFUy?=
 =?utf-8?B?QWVVd0FTMTFJRTR4K0RsNVBYYzVxN1J0elVYYmN4ZkFGd0pNQ085SkRjTkI5?=
 =?utf-8?Q?AMeYud92yAQKuQx/FTH0H868IJN+kc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c3hXMzFTd1BWZjhXWVpOc3lJTGZKQ0tIMWJQeEs0RHJNNHhaUm9hZUw1dVd1?=
 =?utf-8?B?Z1VMbXR3Tnl1aWRPdS9ETStUWnFOM1J4Smx0QVhCckIwNzdvRXNra0ozWmY1?=
 =?utf-8?B?ckYrZVRrY2ZwRFlSdFFpVkRJL1duenk5aW9EQ01xZ2E0cmJ3bnljM3ZaYXQv?=
 =?utf-8?B?YWJtZHk1Ymg0N2NPSjBmOXEzKzI0TFRIR3FGalJlOTkzL2VIbXY3cGNrRm9D?=
 =?utf-8?B?QlIrNFdFVHRuOEJaeWVzelpOUHZqZ3liU0hudGI5RHUrbHluelZwbTNPaTFL?=
 =?utf-8?B?SWVhb0RZSFQwQi9OczN5NUtBbG5wcmNRM2k4WnNGcXZERXdsMDJpbEttaWUx?=
 =?utf-8?B?NTdjMVlPbUxsaTQwMWZYTE1UR2tzUXMvUWNUQitEOE9MQTBVMnBOVzlnZk9a?=
 =?utf-8?B?ZUt6cmJUNnFDTkJIeFBjdjRDeXdyTENOcU5ZN1VITW8rL1V5UWs5UVV3bmVs?=
 =?utf-8?B?dFVxNEtEMnNDS0dhM2liTkU4dTJCODB3N2lvTmNXaXQyWEZsUDFwMkVoaHMv?=
 =?utf-8?B?S1dhMlhmYVVjaXRxRkNjTjR2S2JaZGxqdUhjQnNGSTQzTFd5V1VHditibUlC?=
 =?utf-8?B?S1VKVjh3dFJzYlVnN0VzNlM5aTFZeEY0NDJoejlocFV6M1NweU8ramhZdWZT?=
 =?utf-8?B?RXpiMFJST29ROFl3eDRjemlSNWdYci9jN3BDVUJ1VXBraUV3TXNjbXV2N09S?=
 =?utf-8?B?VW9MSFRpUmZQRHN1cWk4dHFBUko0ZGVtTms3TDlWMWdvU2tzMDI2bng0Z0k1?=
 =?utf-8?B?Qk9ySjlQRW9lbTRBWU1oaDhBQUNDU0dlYXd2NXJXNDBuNU96Z0M2UUN3UGpL?=
 =?utf-8?B?VGkvRjRYUUgralNRNzV6Z2RRUE1QTGpBL29GOWlrSlhCUUNDVjlBUW1GSXpq?=
 =?utf-8?B?WnZKa2hZUDVsTTRGTkl6a3hGSDMxRE9iV1JhZmlpdFJqdFgrbE9oNStiQ0h6?=
 =?utf-8?B?enpCa2E5L3c4WWQyK2xZSHlVeG54M3pmUEUyeEJSSlAzZzlIazBwWDcyQVdN?=
 =?utf-8?B?VGlEaGpZRHNqOFg3TTIzUllpQWV3M00wd1hwSCtyK0FTWXhOK3Y3UEQwdjBK?=
 =?utf-8?B?d1NUc1UyL3FVdkZ1NzQ0YU04MTh4eU83TUZEa3c1RkZYSjd5TEthdlFrYlhk?=
 =?utf-8?B?SGQ0eS9zL05jZ0VFNXBRekRUclR3QVBzWE9QRUdjL1hBbGlrRDFpM0ovRkht?=
 =?utf-8?B?WjhkRkVwQjFpTnFHeGtRZHJCa1dHQ0h2aW4vaUg4aC9NRXRZeFFadldnZkdL?=
 =?utf-8?B?czVVK0NOY0NCRitkTngxdVdrU3prVkFlM21jeFBOQnVPSmJoRjRPSnRxNzc4?=
 =?utf-8?B?d0Rta0tkWXhQbnd1Y0Z4aXJWQXVHZFhqM1FvK3V5OG5ONHdYamFFNHBkTUFr?=
 =?utf-8?B?L1pNT3B3blNXTktDbU5VWk1TOUtJd0RaRGJnQzNFdUtpQ1VicnNacnQ4OHlC?=
 =?utf-8?B?UWc3RFhDRkp2S2JtV0hQN09aNCswK3B3cWV2amRXK1ZUU25ocjltQWlyRXl3?=
 =?utf-8?B?MmViWHhqOEFoZUpuQ0xlWEFjK1BpRVNFdll1MmkzN291c0JIYjhBcytOdzVE?=
 =?utf-8?B?N0c0SDFEckFNNnVPUnpRdkE2QzU5TkR1RlYvMmtSM05yZWMyNnJKQndGVms2?=
 =?utf-8?B?bU12UnVvSWhlNzVPTDFlS2Yva0NvOFpmVkFST0tHbWw4bTBzMUZmNEF5M0xt?=
 =?utf-8?B?RmpqbjgwY3IzOXZuanNZNmZOanRpdHdPVElEUWxiSS9Na2dDVnY2cjVSZXFp?=
 =?utf-8?B?UU5RanBLWm51OEFEdE5JM21ZTStMTStFaWloTGVCNng4L2E0VUYwKzd2bTdp?=
 =?utf-8?B?dU1sN2VhdWQvbHFpaTFGNk5qUERtVENKZUo0bmZldWFBdXdadVpoV1g1dThy?=
 =?utf-8?B?MEUrcWFVSElWcGgxc0g3SDlnUHNMME9FdjI4ZXNGbHMxbkdKa2xxeUVYa3dE?=
 =?utf-8?B?UGZleDlkc1BmdVZmdEcrV05xNTlBSUQ0ZnVDV01ZcVpjR0RNaThIb2VGVzIv?=
 =?utf-8?B?bmhFVGZxUFY1cTNEU1FzUUNDVGROb3ZIalhNNjl3b1RzcmdMV2NkSE9WU1M2?=
 =?utf-8?B?OWRZckZaTWRQVm0xQzFGVUZud1lDZ1lqWjR3QzNpZW5ZWmhpbXp5Y2U0V3pz?=
 =?utf-8?B?Mmo1MGtYcG5BT0tGdkpVMlJJVkRnVDIxWktXM1dzT2tqeVJzaVMyV0tldXpC?=
 =?utf-8?Q?mwRkREg+FJISIsOGTLMd8WE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EA5BCAC87B414469ED9509965412275@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c38324-c35f-4084-85da-08ddfb92ad46
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 17:49:14.6754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a5PZXurDvm4BwwKpaPwp1PcCeTAB5tfOBBUqKIf3RWOF5naNmU+/G7f9ZRx5NnUH0HSdwnAh0RFSM0VF3Fgszw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR15MB5412
X-Proofpoint-ORIG-GUID: TMWZDYnUxuPackeLxynm6SeX3nMxO88X
X-Proofpoint-GUID: biWhI8ZqZxZxDoczcOhBX7Y94MvKYZpx
X-Authority-Analysis: v=2.4 cv=SdH3duRu c=1 sm=1 tr=0 ts=68d42f1e cx=c_pps
 a=SAua1AGvvEPKktuR1BOyGQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=D_DS8eiFI8xvuMDAJ80A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfX44Zo8Ng8NMYX
 Jfq73oQKSGVe6/G+zFpT8/UUNC1ce86VkyfuOhDWNmsHwZVKNUB0p8gxoYVAqfCRNGOrybi+nDi
 OdzJSKU21NFkT6U58nx+KD2noWwSTqPxExUYQzQZC/rqerNKxPwe7qzy8FXcfxw/9CncQdKUkCP
 b4cOunQ7vzWcKDZdyfExm3NgMxNSHt6RFA89ngDHybeX74CW0GCh+Xpu6OcxJurPxFTAwCFEX0n
 bgXW3BTlhT071+Dw9HdSckqO6gcuoBsn/TpCxzptHy9VIP2EOLKWh12SZnL0TETsUcv5rWHEhOR
 OjOYqRrersV1peuAt/6Z5RWuz2O8+cS0EB3vLNhHSzVrA7ch8ftvfCV9fAxrcpdx9EoRBj9Blfo
 LzNRCUWE
Subject: RE: [bug report] rbd unmap hangs after pausing and unpausing I/O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDEzOjUxICswMjAwLCBSYXBoYWVsIFppbW1lciB3cm90ZToN
Cj4gT24gMjMuMDkuMjUgMTk6NDIsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCj4gPiBIaSBS
YXBoYWVsLA0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAyNS0wOS0yMyBhdCAxMjozOCArMDIwMCwgUmFw
aGFlbCBaaW1tZXIgd3JvdGU6DQo+ID4gPiBIZWxsbywNCj4gPiA+IA0KPiA+ID4gSSBlbmNvdW50
ZXJlZCBhbiBlcnJvciB3aXRoIHRoZSBrZXJuZWwgQ2VwaCBjbGllbnQgKHNwZWNpZmljYWxseSB1
c2luZw0KPiA+ID4gYW4gUkJEIGRldmljZSkgd2hlbiBwYXVzaW5nIEkvTyBvbiB0aGUgY2x1c3Rl
ciBieSBzZXR0aW5nIGFuZCB1bnNldHRpbmcNCj4gPiA+IHBhdXNlcmQgYW5kIHBhdXNld3IgZmxh
Z3MuIEFuIGVycm9yIHdhcyBzZWVuIHdpdGggdHdvIGRpZmZlcmVudCBzZXR1cHMsDQo+ID4gPiB3
aGljaCBJIGJlbGlldmUgaXMgZHVlIHRvIHRoZSBzYW1lIHByb2JsZW0uDQo+ID4gPiANCj4gPiAN
Cj4gPiBUaGFua3MgYSBsb3QgZm9yIHRoZSByZXBvcnQuIENvdWxkIHlvdSBwbGVhc2UgY3JlYXRl
IHRoZSB0aWNrZXQgaW4gYSB0cmFja2VyDQo+ID4gc3lzdGVtIFsxXT8NCj4gPiANCj4gPiA+IDEp
IFdoZW4gcGF1c2luZyBhbmQgbGF0ZXIgdW5wYXVzaW5nIEkvTyBvbiB0aGUgY2x1c3RlciwgZXZl
cnl0aGluZyBzZWVtcw0KPiA+ID4gdG8gd29yayBhcyBleHBlY3RlZCB1bnRpbCB0cnlpbmcgdG8g
dW5tYXAgYW4gUkJEIGRldmljZSBmcm9tIHRoZSBrZXJuZWwuDQo+ID4gPiBJbiB0aGlzIGNhc2Us
IHRoZSByYmQgdW5tYXAgY29tbWFuZCBoYW5ncyBhbmQgYWxzbyBjYW4ndCBiZSBraWxsZWQuIFRv
DQo+ID4gPiBnZXQgYmFjayB0byBhIG5vcm1hbGx5IHdvcmtpbmcgc3RhdGUsIGEgc3lzdGVtIHJl
Ym9vdCBpcyBuZWVkZWQuIFRoaXMNCj4gPiA+IGJlaGF2aW9yIHdhcyBvYnNlcnZlZCBvbiBkaWZm
ZXJlbnQgc3lzdGVtcyAoRGViaWFuIDEyIGFuZCAxMykgYW5kIGNvdWxkDQo+ID4gPiBhbHNvIGJl
IHJlcHJvZHVjZWQgd2l0aCBhbiBpbnN0YWxsYXRpb24gb2YgdGhlIG1haW5saW5lIGtlcm5lbCAo
djYuMTctcmM2KS4NCj4gPiA+IA0KPiA+ID4gU3RlcHMgdG8gcmVwcm9kdWNlOg0KPiA+ID4gLSBD
b25uZWN0IGtlcm5lbCBjbGllbnQgdG8gUkJEIGRldmljZSAocmJkIG1hcCkNCj4gPiA+IC0gUGF1
c2UgSS9PIG9uIGNsdXN0ZXIgKGNlcGggb3NkIHBhdXNlKQ0KPiA+ID4gLSBXYWl0IHNvbWUgdGlt
ZSAoMyBtaW51dGVzIHNob3VsZCBiZSBlbm91Z2gpDQo+ID4gPiAtIFVucGF1c2UgSS9PIG9uIGNs
dXN0ZXINCj4gPiA+IC0gVHJ5IHRvIHVubWFwIFJCRCBkZXZpY2Ugb24gY2xpZW50DQo+ID4gPiAN
Cj4gPiANCj4gPiBEbyB5b3UgaGF2ZSBhIHNjcmlwdD8gQ291bGQgeW91IHBsZWFzZSBzaGFyZSB0
aGUgc2VxdWVuY2Ugb2YgY29tbWFuZHMgdGhhdCB5b3UNCj4gPiB1c2VkIGluIGNvbW1hbmQgbGlu
ZSB0byByZXByb2R1Y2UgdGhlIGlzc3VlPw0KPiA+IA0KPiA+IEhhdmUgeW91IGNyZWF0ZWQgYW55
IGZvbGRlcnMvZmlsZXMgYmVmb3JlIHBhdXNlL3VucGF1c2UgdGhlIEkvTyByZXF1ZXN0cyBvbg0K
PiA+IGNsdXN0ZXI/DQo+ID4gSG93IGhhdmUgeW91IGluaXRpYXRlZCB0aGUgSS9PIG9wZXJhdGlv
bnMgYmVmb3JlIHBhdXNpbmcgdGhlIEkvTyByZXF1ZXN0cyBvbg0KPiA+IGNsdXN0ZXI/DQo+ID4g
SGF2ZSB5b3Ugb2JzZXJ2ZWQgYW55IHdhcm5pbmdzLCBjYWxsIHRyYWNlcywgb3IgY3Jhc2hlcyBm
cm9tIENlcGhGUyBrZXJuZWwNCj4gPiBjbGllbnQgaW4gc3lzdGVtIGxvZyB3aGVuIHJiZCB1bm1h
cCBjb21tYW5kIGhhbmdzICh1c3VhbGx5LCBrZXJuZWwgY29tcGxhaW5zIGlmDQo+ID4gc29tZXRo
aW5nIGlzIGhhbmdpbmcgc2lnbmlmaWNhbnQgYW1vdW50IG9mIHRpbWUpPw0KPiA+IA0KPiA+IFRo
YW5rcywNCj4gPiBTbGF2YS4NCj4gPiANCj4gDQo+IEhpIFNsYXZhLA0KPiANCj4gSSBoYXZlbid0
IHVzZWQgQ2VwaEZTLiBPbmx5IGFuIFJCRCBpbWFnZS4NCj4gVGhlIGJlaGF2aW9yIGlzIGNvbXBs
ZXRlbHkgaW5kZXBlbmRlbnQgb2Ygd2hldGhlciBJIGluaXRpYXRlIGFueSBJL08gDQo+IG9wZXJh
dGlvbnMgb24gdGhlIFJCRCBpbWFnZSBvciBub3QuIFlvdSBjYW4gcmVwcm9kdWNlIHRoZSBiZWhh
dmlvciBieSANCj4gZm9sbG93aW5nIHRoZSBleGFjdCBzdGVwcyBmcm9tIGFib3ZlOg0KPiAtIHJi
ZCBtYXAgPGltYWdlLW5hbWU+IGZvciBhbiBhcmJpdHJhcnkgaW1hZ2Ugb24gdGhlIGNsaWVudCBo
b3N0DQo+IC0gY2VwaCBvc2QgcGF1c2Ugb24gdGhlIGNsdXN0ZXINCj4gLSBhZnRlciBzb21lIHRp
bWU6IGNlcGggb3NkIHVucGF1c2Ugb24gdGhlIGNsdXN0ZXINCj4gLSByYmQgdW5tYXAgPGltYWdl
LW5hbWU+IG9uIHRoZSBjbGllbnQgaG9zdA0KPiBZb3UgZG9uJ3QgbmVlZCB0byBkbyBhbnl0aGlu
ZyBlbHNlIGluIGJldHdlZW4uDQo+IA0KPiBTaW5jZSBJbHlhIGhhcyBhbHJlYWR5IGlkZW50aWZp
ZWQgdGhlIGlzc3VlIGFuZCB3aWxsIGF0dGVtcHQgdG8gZml4IGl0LCANCj4gZG8geW91IHN0aWxs
IHdhbnQgbWUgdG8gY3JlYXRlIHRoZSB0aWNrZXQgaW4gdGhlIHRyYWNrZXIgc3lzdGVtPw0KPiAN
Cg0KSGkgUmFwaGFlbCwNCg0KSSBiZWxpZXZlIGl0IHdpbGwgYmUgYmV0dGVyIHRvIGNyZWF0ZSB0
aGUgdGlja2V0LCBhbnl3YXkuIEJlY2F1c2UsIHdlIG5lZWQgdG8NCmdhdGhlciBhbGwga25vd24g
aXNzdWVzIGluIHRoZSB0cmFja2VyIHN5c3RlbS4gUG90ZW50aWFsbHksIHdlIGNhbiByZWNlaXZl
IGENCnNpbWlsYXIgcmVwb3J0IHdpdGggdGhlIHNhbWUgaXNzdWUgaW4gdGhlIGZ1dHVyZSBhbmQg
aXQgd2lsbCBiZSBncmVhdCB0byBoYXZlDQp0aGUgdGlja2V0IHdpdGggY2xlYXIgZXhwbGFuYXRp
b24gb2Ygc3ltcHRvbXMgYW5kIHJlcHJvZHVjaW5nIHBhdGguIFlvdSBjYW4NCmFzc2lnbiB0aGUg
dGlja2V0IGRpcmVjdGx5IG9uIElseWEuIEhlIHdpbGwgYmUgYWJsZSB0byBjbG9zZSB0aGUgdGlj
a2V0IGFmdGVyDQp0aGUgZml4LiANCg0KVGhhbmtzLA0KU2xhdmEuDQo=

