Return-Path: <ceph-devel+bounces-1267-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC6E8FE6EE
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 14:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 660351C244DF
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 12:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD538195B30;
	Thu,  6 Jun 2024 12:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="n/yvhJMd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2130.outbound.protection.outlook.com [40.107.7.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B556195B15;
	Thu,  6 Jun 2024 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717678655; cv=fail; b=qKeKIKlNbK1qR0zc0Wuu0N3OUemyGdHVuI4roThL1BrH+m31I70Cagk/4ULs13mgXnMc/HkvU6niXJYi9On9TWIfhhuaiEvPMWA1De8NC97mb7gWuZiyEZQC+fY09PKYuX42bqYJ5zrCW2nrti+aDkOcUvyNg/GXGu+hqx+yMIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717678655; c=relaxed/simple;
	bh=cxqpQxKGVce74KGAAA3XZd3TT3prvR7spsHoUXU9Khc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y+T0YnYoHAtL9d2IQGqfTJmZ5js11Xp0KNp7G5L4bDFv/PXgMv+P2wMC1lZAuputdBDiEgbo5f9Kn+Kkaai6Q1VLIzJvfGSN10nCRaNeSfwXKeXixbZ9t+pmHjt1kvILxiBzLNcJMCY6plZEmhj9g04esiGF9n2ElLI8jBrcfd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=n/yvhJMd; arc=fail smtp.client-ip=40.107.7.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNcZx+zjg3RglHNGLPEVqC9HO1u3PopPrzoR34cAuF6ByWk81Ri78Qqnpw5L/2v6TvUqGtMhyqDT04U6c7xgVdIJ3nk8f22x6+KZO2jRTB6rxjFyuFMpr2TUEy9MZ2VKTX0eX7HxAYoYCCG4V1/PP/EFqljSDYDWXCebaRe9vNvRvGg3Vi7spETKgZ5q4Pq4rvrpxf0dlYGyoCdLmSYhRjx/Ij4ydcdn2uC7zi/gXwe0Q064noZTKivoIyLueLjFDcpJS4ZA+wakSgAmFhZdo8cG19yYU/tSGcrrCKzvM6nyP7TuauCno6g2Z7tvO252lmVxsGeU/UN1E07U0THLHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxqpQxKGVce74KGAAA3XZd3TT3prvR7spsHoUXU9Khc=;
 b=jlN6/2TBGsxJ7pGW9Hmkt2EMVQmxDjzhWj63N6igvUcv1UjXCxK8IHFYYNEevHIqlbTt242bc12TRtEgvuz2XbiPBtOBtj7HUAaukZb1Se9Ew+6bWilPT0o1ej3PimcB4pPAIBjwilbMc71mvJOO+lL1RZpBcEyofKFvckrJeom6fVTSRnx7nMqj/P047s/4CFiYHYBAy5UmGfkTtXzRZB82wDdNQoATnhNaUEB3Y0ggbqUJnNHpEqd2Tkr2cGUhGZE8VT/B6OM+DVAog7wQDvUPUSLKg/854hW3pt7Cx2QUusmct77+89D5arX7Jm06dhagWlWc7arwg6UNR+pFJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxqpQxKGVce74KGAAA3XZd3TT3prvR7spsHoUXU9Khc=;
 b=n/yvhJMdjyyfADQHATqG2HSU2DPwY+pICb/vnHWhVgNt5vRN1zPsBOBJn1TlXk1600vqd5dnKor2auvvN7obM2IEEY+Q7ujqAYYsyPPux7lVKJvEg+7Y6cYFzBGuz9ud0XIbwmUOdOqJViHPyQbS8ipTamBL4quM8Pk60JhEX8Lc0RkJyLib59cOQ05dS9ca3Zv2pqt4RxipGGSQtBWwEoCG7moM+g0iFIhHiA7j67sx0umW5Q9a2RgmmVf1m1FLMtJf23nIGhPWdJ5TU/p/voAukxx/R5izlwga1OkVmAXFEWmduM78rV3i8XFoohHP0DPeaaDi/HvNJMLmfCNYJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AM8PR04MB7410.eurprd04.prod.outlook.com (2603:10a6:20b:1d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 12:57:29 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 12:57:29 +0000
Message-ID: <b13305d7-35c8-432e-bea1-616410a9da15@volumez.com>
Date: Thu, 6 Jun 2024 15:57:25 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
To: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240530142417.146696-2-ofir.gal@volumez.com>
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
 <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
 <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
 <20240604042738.GA28853@lst.de>
 <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me>
 <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0010.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::9)
 To AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AM8PR04MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: 591d5d7c-1c27-4084-11bc-08dc862838d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azVRK1ZaOVJndEs3VnNCejFkR2VVeTZCc3dkeDQrTmhsZjk5U2gzWWdmUVg2?=
 =?utf-8?B?OGNkL3Q4SW9mYklmNFdCRDIxckVwNFl1RWpKVmVxYkVpbGdkdmdkc0prSWcz?=
 =?utf-8?B?ZldINUFNVm5WT0NSRXc4c2wwVUxEbEVGRURObys4SkNxeE1WYjVlQ1BYZ0Fm?=
 =?utf-8?B?WnRMNkYxb2FIVzR5RTFldGNKRVVZNWNyejFjaGVhSlJUaTYrSnpqNTFzejVi?=
 =?utf-8?B?M3NzUVlIQ20zRjErVTVVT3RiSFgxR1dOcmdXQVBhSlpNQkpxVDI3Yis4cVF2?=
 =?utf-8?B?blZXWjFlK2NJRXhBck1iRktoQ2l6TDU3VmlRSWVQbGNtZWxxUENsVGhtelRY?=
 =?utf-8?B?enVJMFlxeXJyc3pEbnhSSEhpeHZLczhVNUtlMndpTmlRc3Znb0ZFQ3BtVCs5?=
 =?utf-8?B?ZXFZcEJ1dDdRa054cG5KdFlZNUVOTUl3OTgvbHh1eGxlckhtWmU4ekxjanpy?=
 =?utf-8?B?UkkvRFJmVEZETzdwOFdoTW52aUMwOFB2Rjk2UlN4amtwV2NwUWZpV2tnaE1P?=
 =?utf-8?B?UGtpWXdNTUphejkvYnJraldSWG9nczF3RGdvaHJuMTNTWkZza2ZISTdhT0VQ?=
 =?utf-8?B?UDQwRE5nUVcvVjFwUWJOSFpIRkZmMStMclV1SXNGbGlLZC9tRGJ6dW5lL2xE?=
 =?utf-8?B?Y3FoQTVEbG8vV2FTZk1RanhnSlNCdnVGMHNneFV5TWpidXlpRzJ5bVVVc2VZ?=
 =?utf-8?B?bTFuaHBkMFlGUm1uVWZGRDdGbXdiWlVjREdDdmhoanlsR3RUajVXYXlwNnBN?=
 =?utf-8?B?eGhoN3hTTU9sK0V3cWkwNlBqWWpFSEtSaUhOb29CNnFMZ2YzSFQxZHp2czF3?=
 =?utf-8?B?bGYxb3hSZ3lHcndLd2JMenJXa2xCMTgraTdUYnByd1JFa2gyR1RBK2FvNlVC?=
 =?utf-8?B?TXc1azhna1FGMWpzVHN6RW1JZWgrL05mdkIyZXAwS2loeTVWNGhiRjZURnVm?=
 =?utf-8?B?WFB5THJWU3lLakJJNFNtdDlERVlFMUlxNmtqekxLNGs0L2hXYTBiN3htcXAx?=
 =?utf-8?B?b0ZjVW9PMUlMOVY0V2kxaGprOVFTZ2VJQ0dleEMrcHZOMElreloxWm4yUzIz?=
 =?utf-8?B?MHVGT1E4ZnE3UkY2MTViWi9wbHpBVmpvb1BjUWhZc3plTXcyOXBmOFRyR1o5?=
 =?utf-8?B?b09ZY1FDTEY4cll2SmdGcjJPeHB6elFYZWVOMHVSYVVWaEhpbDM0NXI2a2o2?=
 =?utf-8?B?QTVBNWJHa3FYa0NENm1RMDdicVZTK0N2S2QzMDRYYmYxcTJUL1ZWd2FrSjc3?=
 =?utf-8?B?U0NQVjQ4Ly9Ib2FyMmJUV2Z1cmF0bkZuakFrV0p3R3dFSVdHbGxLOVVLOVZF?=
 =?utf-8?B?M09NZDdhWjBWa1cyZk5QSlYzcDIzV1hSam9GWTQ3M3FJZDZHam9VenZsTWg4?=
 =?utf-8?B?cW9xM0JONHBqVk53L2loRHY2QzN5Z0tSU1cxWGk0NVZvN1FvUjRueWg5Snl0?=
 =?utf-8?B?bUZyL0Z3RHd6MmtkdXU4dkN5dVd2N3FheFNBcGZTaVZPcld2WVU2VGN2OXk0?=
 =?utf-8?B?N3ZNQmJTRE1MU3gvSGRuRmJZalFHNnROTENwSG5xc3hxVC9NdVA2STFZZ1Vj?=
 =?utf-8?B?YmxHMHBhbjBHak1XMGF1YUZYK1BZN2lZZW5ZcW9BU251aGFEam0wdVd4dDFp?=
 =?utf-8?B?OGs2N0dZbDM5cERMRFF1Y214TnRRdStoZVUwRldiMGMyVjIyQmZ2M29TNnIx?=
 =?utf-8?B?MVRRa1RXQWpxeERHQTVVdXFjaldSRW5waW04b0NMb0VNT1AybUpBQ3d2eTdU?=
 =?utf-8?Q?N7u3VCpULVm1nZqYt7ZXkwa4jius04HzzmHyYUH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmxQWXl3QWFZVUk1ZzZYY2lLNmFVNzhJMlZYOEFJZXkxUXBtSjhYT2hwQmdI?=
 =?utf-8?B?VFg0TTNoMDBaclNvMnFxRUEyYmZlcU9MREhDY1pOeUN6TkY4clJGR0k2c1Z5?=
 =?utf-8?B?UFhRV015NFk0Y3ZEQjZUQUVXR0RSR28zVHUrb2tWYTNwN1pZUzdmUm1qZjJQ?=
 =?utf-8?B?MUNMTXVnR3E2Q0ErOG5nc1hUYzZiV0lNUmwyeFJjVmJrdmlKWHRCZXZ2YXVp?=
 =?utf-8?B?aG8xVDhRUHY1U2VkczcvYWJMM0xTQ2pJUmpUc3VTSHpNc1NhT1VFYkR2OVZm?=
 =?utf-8?B?TWpLT1VMOE1PNmZ0TWFSSDJucW1ENFUwY2ZxQXMyVEVZak5iRk1sNFRpOFJJ?=
 =?utf-8?B?OU1ZcVA1b2oyVTlvMllnQmt5RHdaaTFGOVJlcUpIcDdteFQ0ekFsSTFidlJ4?=
 =?utf-8?B?aW1SeDdXa2hBZUw5dm5ad2o3dDFXcHEzd0t0TFpvVC9EZ29TYzFCQ3QyQTBk?=
 =?utf-8?B?QW5iYnZ6NkdBbmZBNGh6OVdiMkhDRVZhclhWaHpBcEZIUUh2cjFOSndSRHVt?=
 =?utf-8?B?TDdvTVhjRlJ1NytPS3hkVExmUTl6S2VWbEdESG9rS3RUL1lkTnVSb3N6dHZp?=
 =?utf-8?B?TnF0ZVVkcXVpOTdRbzBKYjEzZnRzU1RqTFo2dldPQ052MzJPS3NMK0Q3cGp1?=
 =?utf-8?B?M1poZU5GMFdRRndWWjBWcWNvN1BsRGppb3N4Z2hmc3FHL0FFLytlWDd5K0Vz?=
 =?utf-8?B?Um5hc0NrZTdaaHFNMkp3OXZ4T1Q2cDB3Vzl3WDEvQm5Wb25sN1N4MXAxYzJy?=
 =?utf-8?B?eFgzTlZlL1l1Q0JpTnhSZjN6ZW5mcTdnN2pLZ0ticllLdy96MG5tKzNod0tG?=
 =?utf-8?B?dVdGckVMb3BmR3hpMlYzRi9GQU9yOHZRYWxJUzI1OFJqWVVGL1FBOVo0a0V2?=
 =?utf-8?B?UGZsaEhBV211Yit6cVkzWUtlZWhLQ1RFT2l1TmRwaXRxd3I0WU1SUGVoQWZk?=
 =?utf-8?B?WlV3M0RwNFNhRW5pWjZSMytyeE5aQi9PR2RzUlZNWXhlcHZkZ2VoUUVaY3pU?=
 =?utf-8?B?ajhkVlZZSndvb1h3VVhteG1jczZQUDJ5SmZDTFJiTVB4bTF6WU9RSG1aamIw?=
 =?utf-8?B?V1dNbzlxeEdHSzdGRkdrQ3VsK2w2Qzk4UTlyb1RJWGNTTEFhdVM3T25DUFhE?=
 =?utf-8?B?UHVrRkJyblFqZUlrcWdKeXE4aTlicWtoTDR6VWg5SzVnTkdIYmwrUE5iaVpL?=
 =?utf-8?B?anZySml2YXptZnRTc0w1ekI3cTJjWjIybmlWY0lJcmoxYjdhWVJPSmpVYXF3?=
 =?utf-8?B?UmJtdEttdWk4NWFiY2h5TDhWUDJMZHBzRkVyTE4zU0hRcVI2dVRicldYZXQ2?=
 =?utf-8?B?L29WdVViT1BGT0tEamF2QTR5QkdFN2ZIS0EwL1ZQcTRxWkVYWnJRYitOYUs2?=
 =?utf-8?B?WFRJL0hTMGplZ3VQS2RLQWhIakJxU2tiU0Q0NGhFMnRXYXAzMHhrcnBkNUsr?=
 =?utf-8?B?ZXk5UCtjV0NLVjQ4U1RKcHZpVXp4MG5QNm5IOVNySzZYTndIcVlyM1daeVU4?=
 =?utf-8?B?SkF3QzdtMndZNTFlT0RWc3RsbDRQbDlkdFZkQS9VVGFvRlJJeS9lOGdVODNq?=
 =?utf-8?B?SmRJcTNCRDRTb21kaVo5ajdYbXhhcmNRVDJiMG9mWSt0eElQYkQ3YjExRnRV?=
 =?utf-8?B?SlA3Um84d3JqMC80MzFOSVhRQUlPU3FwZWRqNnNZeVdTckZ2K2pEZkZNVjdZ?=
 =?utf-8?B?dkJuc1ZjWjFDSjEwLzAvSVRZSjFrcy92RnV6M0ExRWtPSkE4RG5xRXFqcDNG?=
 =?utf-8?B?Z1NYalJKWTZ4V0NObXVHNWpVNnYvMGVNRHlLWjdpMzhoSFhlT3ZQTE5Hb2d6?=
 =?utf-8?B?eTdVRUZOL0VDQTBXOTA2L3FReHdOMHh5Yi9zYlhOWisrMWF6YWpQVmtwTG5h?=
 =?utf-8?B?YWlYRUNKRTdxOHdnQmRKZHhGdmNhc25mcC83OFl3OWdoeTFUUlI4RDV6Tldz?=
 =?utf-8?B?d0tGV1NINmRFZkgzRHRNck50eDN1NWFXdHVqK2cxSlhIcCtIV01KbmxLMXFS?=
 =?utf-8?B?a1VGRDk4SkdkYmVOQUZYMnY0OXZpY1V4cjlPQkVTa1VGRk1Nd21RZnhQS0V5?=
 =?utf-8?B?MVJsbWhVUzJXZGxRNS9sNkZFN3FxMWRPZ0pDd21maGV4M1ZJTWE0QkdKNW0r?=
 =?utf-8?Q?xw5HEltzlB4IFTGZIfpSDTSmx?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591d5d7c-1c27-4084-11bc-08dc862838d5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 12:57:29.1796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6WfaZzmzoQ7oEMtzwz0Z/7V2BC86xfOSMFkJQ+xO2hLmvfYfTn/VJrrrJPU+R/2/68V+grGxgKbuNuqhgznSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7410



On 04/06/2024 16:01, Sagi Grimberg wrote:
>
>
> On 04/06/2024 11:24, Sagi Grimberg wrote:
>>
>>
>> On 04/06/2024 7:27, Christoph Hellwig wrote:
>>> On Tue, Jun 04, 2024 at 12:27:06AM +0300, Sagi Grimberg wrote:
>>>>>> I still don't understand how a page in the middle of a contiguous range ends
>>>>>> up coming from the slab while others don't.
>>>>> I haven't investigate the origin of the IO
>>>>> yet. I suspect the first 2 pages are the superblocks of the raid
>>>>> (mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the bitmap.
>>>> Well, if these indeed are different origins and just *happen* to be a
>>>> mixture
>>>> of slab originated pages and non-slab pages combined together in a single
>>>> bio of a bvec entry,
>>>> I'd suspect that it would be more beneficial to split the bvec (essentially
>>>> not allow bio_add_page
>>>> to append the page to tail bvec depending on a queue limit (similar to how
>>>> we handle sg gaps).
I have investigated the origin of the IO. It's a bug in the md-bitmap
code. It's a single IO that __write_sb_page() sends, it rounds up the io
size to the optimal io size but doesn't check that the final size exceeds
the amount of pages it allocated.

The slab pages aren't allocated by the md-bitmap, they are pages that
happens to be after the allocated pages. I'm applying a patch to the md
subsystem asap.

I have added some logs to test the theory:
...
md: created bitmap (1 pages) for device md127
__write_sb_page before md_super_write. offset: 16, size: 262144. pfn: 0x53ee
### __write_sb_page before md_super_write. logging pages ###
pfn: 0x53ee, slab: 0
pfn: 0x53ef, slab: 1
pfn: 0x53f0, slab: 0
pfn: 0x53f1, slab: 0
pfn: 0x53f2, slab: 0
pfn: 0x53f3, slab: 1
...
nvme_tcp: sendpage_ok - pfn: 0x53ee, len: 262144, offset: 0
skbuff: before sendpage_ok() - pfn: 0x53ee
skbuff: before sendpage_ok() - pfn: 0x53ef
WARNING at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
skbuff: !sendpage_ok - pfn: 0x53ef. is_slab: 1, page_count: 1
...

There is only 1 page allocated for bitmap but __write_sb_page() tries to
write 64 pages.

>>> So you want to add a PageSlab check to bvec_try_merge_page? That sounds
>>> fairly expensive..
>>>
>>
>> The check needs to happen somewhere apparently, and given that it will be gated by a queue flag
>> only request queues that actually needed will suffer, but they will suffer anyways...
> What I now see is that we will check PageSlab twice (bvec last index and append page)
> and skb_splice_from_iter checks it again... How many times check we check this :)
>
> Would be great if the network stack can just check it once and fallback to page copy...
Nevertheless I think a check in the network stack or when merging bio's
is still necessary.

