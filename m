Return-Path: <ceph-devel+bounces-1257-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA768D82C5
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 14:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75AA728A58A
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 12:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA3012CDA5;
	Mon,  3 Jun 2024 12:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="dXn/uM34"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2097.outbound.protection.outlook.com [40.107.13.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30C312C54B;
	Mon,  3 Jun 2024 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.13.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418959; cv=fail; b=Zp9ERKIGYxI9skLKWYTXI8Jqni2YLHryjoPoRQ03Ms1kwk5OPiqN6dOhnLwOlfEaK3ou9JpLypGX6h2f76Q6mQG4NXBFgHWHupuK7vGuzg+oOgzc5hlBJDxfCA5iKe7v88DTLylXTQpkj8XSm9saDBTHA9op5379zf27Ql+fd1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418959; c=relaxed/simple;
	bh=H0/OXU1xpbkWnVJa9N9knR8UbDm+oJzF+IQXVPhHpjw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ihdU7Fyd4+ZFlN1KtJTC2/lrh809WxNeA9kNY667RRzzkxDUIypRXpr7A02I4o53LyXo7Pi8N4cwJVeqRKZUiFLlIAV66Iaj8+RagjsfYY+dOUNYUh88cPfCDnmA2mK7BMswNxFvHORC1OHOGLpQ+28zcd3H5gjd2vhFsWgCMgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=dXn/uM34; arc=fail smtp.client-ip=40.107.13.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPzZzhXZKaLHF4SWT5BCnR67VyyQfdnb7baBmXqmlH3siQAhJlMJF87rd6peyzZIuNsxXlWGyPGv3mN3M9GfIExlY+Vy2pcFNA40kiHkG3ZKIEbBi/JK/KH+YDuWtMdF4GOo/eg/7NYiVTF2GcSVlEOye9+jh2CEUZPN3mHxJl3Mf7p5mTSy4U1mF72FjJyY00wMgYDmIj6/LpTMgs/mTPcsr/Iwho37UZvBRmamUKYNqW3PqDeOdjX3artjiEUXJFTp7gtRegPVNDv0Q2ajAXHUuNSXuLiaot2XASgGV+YaEy653DC3YTpTqeu33ISsEIPImG+zKFDYaVFotJaW2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0/OXU1xpbkWnVJa9N9knR8UbDm+oJzF+IQXVPhHpjw=;
 b=ZB6YUvyBAVMSKxXCEtCYFYLp9SaogifZUCQbXrtkSmUfl8scE0RLiwd/2zEM4XqYdNGQuPXR4lWTLMss34JRtvc45uQ8mmEfvTt1Df8yCIlvRQ8fRxzg7Aha0KyoC4jLzk7cvpKOos2YpNskzalp7Zy/jbhuxXODri+y5eIQND735paG7AoTYlLERJ6h9E4elvOIjmQfdQtgppyzaGspVLoEEMfciCRfNzQFI6V74yLNeG+yyrM+jTf+oHVI1p8/jtHgTmdXuq9nI/xPf52fYM2CnkPjQCuopwRXOe4TmjnGtjxWcR8kBb5PYnQ7Jj4kX7OpoqzpIxUtOzZfGTo0Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0/OXU1xpbkWnVJa9N9knR8UbDm+oJzF+IQXVPhHpjw=;
 b=dXn/uM34cpJRUmW1ezaDR3yFP1jAfQMsa96rUqtufQWVxYhM5Y0aoTQnRKIe9LIcrSH6rznHE0i7DKwMSaNnel3DGfhcbyLp6cHUdVbQ9GmEVrZKKc5cJ4Gfk7hkVnMKwv0SmTb64iDyeAwVOBOMLirAdK/Ps3qQklcTH5ewWKCDVb+WGVYQCX4CTxXH3TurKlyNpgbpZ571dvW3F0wU7ceqibVyFzVt+f9024sqHitlEnHwYfs/0Mgi3P46vpwiux7JAufW6iNcn9mUcnmUPQgQoSLYdVlz+9PXz5ocM5QZpOdfkzInd9fxp1tXnZVw+nFC1TqpBx3r+QkD5Ez9jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS8PR04MB9189.eurprd04.prod.outlook.com (2603:10a6:20b:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 12:49:13 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 12:49:13 +0000
Message-ID: <df9123d5-e542-44f6-b9a8-cada72252cf7@volumez.com>
Date: Mon, 3 Jun 2024 15:49:09 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Hannes Reinecke <hare@suse.de>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <a3fac93a-af2b-4969-8ab5-302089cdb3a6@suse.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <a3fac93a-af2b-4969-8ab5-302089cdb3a6@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0002.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::10) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AS8PR04MB9189:EE_
X-MS-Office365-Filtering-Correlation-Id: ceaf123c-b199-4b9a-6d0f-08dc83cb9263
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDZhdFdUV1h6ajg3Y0NDdXgrOHBUczlvcVVQUFNJelpxc3Z3M3RESTdjK0wy?=
 =?utf-8?B?ay8xZTlkL1h6ZEZtaUVObFQrLzBiTHBKQWNHR2pmMm1ZcWc0cnY4K2RIT0s5?=
 =?utf-8?B?R2RYcWtUK2FYRDc0Q3R3NUdjM3FuQlNGc3lOUURxMEhzdVhmc3FqaEdJTEh6?=
 =?utf-8?B?aU5yTXhyNytJNFA1UVdJNS82Mzg0VER4d01nZFlZUTgwQmZ5dGg4SjhhV2pa?=
 =?utf-8?B?d3c0WnN3aFJNQmJnaFZFUUJuRlpiYzB4ZUYxd3IvR1o2NHVUNzB4VTR2d1lH?=
 =?utf-8?B?ekpqbzdCQUtNTHZUSjdyUTFxSGZZT2VBNlRVTjNabzVhWE9MRUdUeHh3cExU?=
 =?utf-8?B?Si9Scmh4SEtGZFc1RzVRWENJV2R5emNWdTJTblpuSmVuREZNUERmR3ZWUmJG?=
 =?utf-8?B?ak1jaWoyUUdzWDU5ZnZVVmJrSUQzMGkzWldqWWN5UjRCUlpyYlhUSTRTVms3?=
 =?utf-8?B?eUNjK0RIaUhQc1luVUV0U3JDejd2cjJwK29NUFhVclhpNGdDTG93TVBGbFor?=
 =?utf-8?B?eW1xR0Fjd1p5eklOSERLbDdXNjRvbjkvMHZ2M3hrVUdPeURJalgrN01BTUZO?=
 =?utf-8?B?SVJEWlRseXUyZDZ5OWQrU3BKcFc4LytNRS9uV3Z5YmFRWFNKZTlaTGtlWDE0?=
 =?utf-8?B?YnZEVDE2b2ZSNVorb2hTNk5kRUJpUVZ0NzFrWmpoT2dBRGl3MnVSNUZJcTIy?=
 =?utf-8?B?ZEZxRlJIRjllQjdWTDFGUVZvamxUMXZ2bWgxVU44ZnAwNkRJUWxDdmJaYUJw?=
 =?utf-8?B?VTdGS2J6eXErY1pBSSsveTVKcjFxRm5RL1pSRGlYSlNOSko3L1lRVTJhSEE4?=
 =?utf-8?B?dWZzUzdwcGFsT2FjOW1KZzNoQzhtL0xqRDlsejd5WFhvaTAvSlVEc2RlbTlQ?=
 =?utf-8?B?K3NSVTBPQklxbzRBUTdIUG5ub2JrZjJKbjk4eE03VUVRRlJNZUUxUC9QUjI4?=
 =?utf-8?B?MTRxdTUwYXNUakJLeWdOYmI2N295OUhmSy9hWkRkSXdVN1RRNmwyTTNhRlJw?=
 =?utf-8?B?MlVrRXJUSFh4STRSYlFCdkFhL3VMaFN0RmlPSFhYN0htU1ZrRjZQWndkVGZM?=
 =?utf-8?B?aWdLaEJNaEtVTjZVV3QxMHp2aVowRHhVSERwUVFabmVqdUp0ci9CNU5sZ0E0?=
 =?utf-8?B?VzM4VzJKSUZRc1U1d1hFZUNJendxRkRaeWU3bUViMjhCcFlvNEhhSGR2dmFr?=
 =?utf-8?B?b1ZnUHFrZUh5T0FRbnZkbE1XNCtWdzZQbTRhZHJaaG5VR1JwUGVGL2UyYXR0?=
 =?utf-8?B?ZjNUZTdsNFNPbWFuZjZQYmRLK2UyZGIxeERUMUI2dWU4c3ZsUkV1b2p0Z3l5?=
 =?utf-8?B?bGl2UlNoZ25IWVZUbHVTNkxBQ25hRWh6bDRtUnJnNzZGNDZQOHdJQ09zcjZJ?=
 =?utf-8?B?cXYvRW1IY21hZ2VCQjQ0T3Erekdsbi9NYWoxS3NPL0dMS3V0NEcxcExiY1JD?=
 =?utf-8?B?TStXM0JBZjlaTEhSdi93WFZsY3pVdk5xM1lySzhheURUd3hvRkdwWlNzZ25J?=
 =?utf-8?B?S29oMndFby9XMEw1WEtCSVc4b3FYK1IvTWZpWGRnQTU0Q1Z2SURTWXd1ZENj?=
 =?utf-8?B?L0pBbG1wcGtzVGZzOXhmOHNVWVpsSVYvRkdPVDVuY0U1WkVBeWRHRHM0UVpQ?=
 =?utf-8?B?YmRXbTRKUjI1YTF4dWgvUUNMOGpqd2ErME1kZkl6SlZFWVEyM3Y0cmdjc0lK?=
 =?utf-8?B?ajl2NDN1WDRjbXg3NUVzVHUrbUh6VHNNVmVYVXpMTTBLcVRXd0pxUlFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU1kU1NzekVCVmo3ZzZYcWZLR2NESFk5N1hEd1ZRMElDWDJhd0J1cmdvTnVC?=
 =?utf-8?B?U0Z2WEhvVklOVGdzMVJtQkVvZ3Ayd1NaS3R2WkNheXlVUm1rM2dEbFYwdkJm?=
 =?utf-8?B?elFycUY5T2RIc3ZqZHVxTkJ4T3MzVkdXQW9tQTJTVkEweG5EM0J1elQ0cmVB?=
 =?utf-8?B?NXpoM2trQkRNb2pHdFdKSjBwb2dhcjZ3bUp5c1FLNjNyNGtXcVJPQyt6alQ3?=
 =?utf-8?B?TDV0WkpSRnBUVUJpU29uM1V5V1cyUTlSNUlPUVcreWtrT0oxUEk4TFo4VkhZ?=
 =?utf-8?B?S3llZUFOcHUyOHcvREZxalZyRmJQNDFDWGhKMUV1b3pDQjJKSFIzT3BwWHhY?=
 =?utf-8?B?SXA1QnNtbDhWc21FQkFDVi9xb0w5R3h3UEl0aGVod0w2ZkNZVnpJbG9YSDdi?=
 =?utf-8?B?dWZNbHhkdndSR0UxRC9EOFRLRjIxNFZJd1prL0V2STk5SWJEeUxCTVdrbXJy?=
 =?utf-8?B?dTRNNmRtNFBkYUNJM3hRcmkyQytnNGRybktaaGtZSlc2YW9VaGp1eU1mVUd2?=
 =?utf-8?B?Mm5sbWxBV2Q1aDZMbG1odFMvYW50SVg5Z1UxNGxSNUhYemZTN2Z2L0JPUDBJ?=
 =?utf-8?B?dHdrN0ZibXkrOUFybUg0eldSSDBCOGlHbDFPVmdWdUIzWEZFaXU0cytza2Vi?=
 =?utf-8?B?UjY2b2xIbWE1eVdqaXZjUTFpREtGbnZkczQ4czMyV0RRMGZlbkhPNnhRcjFo?=
 =?utf-8?B?TjZmeCtmNjRIY1NCY0JKMm5NZTB3RE95d2JBUFJOTVJUTTBabEU1THc1TXhP?=
 =?utf-8?B?NFNUTXF6OFhPTzM2aEZoaDFzbjMzbnpLb3ZqWm9mM2FiRTlqaTEzS2cxSlZQ?=
 =?utf-8?B?MFJ5VHNvMndISTVEcmFyVVNWZDRZWXZCbHA5Qjc1WUpKdXJFMFNSRFhMQ1VU?=
 =?utf-8?B?Sm5qTW9YK2ZjUDhxV1U3QU9nbU9Lem9LUlhSYytuU1EzU2NDR1lUemZDend5?=
 =?utf-8?B?dTduQkRETlZ6VVU0QkZlUGpRUGFzcGpTV2lGSE9ickRyN1o1RjFiS3BUak5u?=
 =?utf-8?B?dGRMK2JLNnRXRnZqMmE5aWpYVHhkRWVmejg0S0t2bUg4NTI5SEJFVmFYYUJn?=
 =?utf-8?B?UVRZOG9KSlpCWTd1cGltZ3BGc2hQeUg2OGRINUhlY3NiaGY5YTJ2RTBYNUVh?=
 =?utf-8?B?TmRtR050NlhWVEFsa2hhVU0zMUpLTjZ0SXlybjc5Vm5UUmQ1RnpoNVFOdFBS?=
 =?utf-8?B?MXlOS1krbWg1bytWWVpsRnVrY3ZYR3pZZ3VSdVc2NjgzN2xxQ3hvZ1BFbG80?=
 =?utf-8?B?UnpYOC9qM2luRnRhUHkwTFNrUFF1MnAwVUtvc01UZVhzSnlUdm8rVnpSTlAv?=
 =?utf-8?B?QW5HcDFaWW43TnBIb1l2anorLzlCRkFpd3Vta2V2VFU5dklRY2FoR3YxTTF3?=
 =?utf-8?B?VWd6dXFHSXljOE1ZbDNrTllJeGM3NTlHVm9zWE9DU3I1TjFzWkFSRll0QUIz?=
 =?utf-8?B?eTN5am8vZVVaNkwvMkszZmxpT0dtRDVxZEcrT3RPejZPUW9qNVVjcW9wVGtB?=
 =?utf-8?B?Mkl5ZitGaVNXQ3R1UFZiRDlyU1RVME9EdUl5WWxwdUttL1lRb0g3aFdXRHEr?=
 =?utf-8?B?SmNXUXFFZm5CRDFjdEl0eXRQMElvQ1BIaDJmdHNLa2RQSFNoYzhDTHRJcUFm?=
 =?utf-8?B?THFRcis3R1JwbHFEeTMzeDZWVEowMm1ka2xiTlZZOW5ZWWY2S2lEa2k5VVVu?=
 =?utf-8?B?dzZqOG1zQkF1VjlZcCtHSTQ4T1p1TlpEQWJtVDVVUU8xaWVjbTF0QisrL3kw?=
 =?utf-8?B?UFZnYlJ6YURhcmJNdHo1WmFjV2tDa29lMUlHejJ5Wkl1NVAvN3QrZUlRai9z?=
 =?utf-8?B?RXFrTkptQURET21nWkFzQWxUc0tpZjZmL1lkbzVWeTVkUFdZOU8zbFVSWnRi?=
 =?utf-8?B?WXRSbjhTa0FJa2RuMnZEcmp1WGpzejN1RW9BelVJZ29LL1h1QUJPdUpSdklP?=
 =?utf-8?B?MmdEcXJLdk5HUU5EMm9veVhoM2xsekdlb3RQM1puKzN5Rk5wWHVibk0yYUF3?=
 =?utf-8?B?SDdPeHB3VWdYTzhrRjlIdDhPTTQwa1l2R1lvMEEraFRzQnViUnlsVWxGakVm?=
 =?utf-8?B?WndXQjJZOEtObk5mQnovdThDUWVVOXhod2tFa3BpaW1BM0dZdzJlTWFJUWdW?=
 =?utf-8?Q?zme1FfRp6X1CbeOGCtFXOL1I4?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceaf123c-b199-4b9a-6d0f-08dc83cb9263
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 12:49:13.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SkHeCYFLtYjylFgdTu5Nc0leQ38VW6GhdHTWNMxAldlOZCjGuE4Dn79UnLOUfwFCBp5PEVuwJqkMgKAhpqCYcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9189



On 03/06/2024 10:24, Hannes Reinecke wrote:
> On 5/30/24 16:24, Ofir Gal wrote:
>> skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
>> data transfer failure. This warning leads to hanging IO.
>>
>> nvme-tcp using sendpage_ok() to check the first page of an iterator in
>> order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
>> contiguous pages.
>>
>> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
>> it requires all pages in the iterator to be sendable.
>> skb_splice_from_iter() checks each page with sendpage_ok().
>>
>> nvme_tcp_try_send_data() might allow MSG_SPLICE_PAGES when the first
>> page is sendable, but the next one are not. skb_splice_from_iter() will
>> attempt to send all the pages in the iterator. When reaching an
>> unsendable page the IO will hang.
>>
>> The patch introduces a helper sendpages_ok(), it returns true if all the
>> continuous pages are sendable.
>>
>> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
>> this helper to check whether the page list is OK. If the helper does not
>> return true, the driver should remove MSG_SPLICE_PAGES flag.
>>
>>
>> The bug is reproducible, in order to reproduce we need nvme-over-tcp
>> controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
>> with bitmap over those devices reproduces the bug.
>>
>> In order to simulate large optimal IO size you can use dm-stripe with a
>> single device.
>> Script to reproduce the issue on top of brd devices using dm-stripe is
>> attached below.
>>
>>
>> I have added 3 prints to test my theory. One in nvme_tcp_try_send_data()
>> and two others in skb_splice_from_iter() the first before sendpage_ok()
>> and the second on !sendpage_ok(), after the warning.
>> ...
>> nvme_tcp: sendpage_ok, page: 0x654eccd7 (pfn: 120755), len: 262144, offset: 0
>> skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
>> skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
>> skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
>> WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
>> skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1
>> ...
>>
>>
>> stack trace:
>> ...
>> WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x141/0x450
>> Workqueue: nvme_tcp_wq nvme_tcp_io_work
>> Call Trace:
>>   ? show_regs+0x6a/0x80
>>   ? skb_splice_from_iter+0x141/0x450
>>   ? __warn+0x8d/0x130
>>   ? skb_splice_from_iter+0x141/0x450
>>   ? report_bug+0x18c/0x1a0
>>   ? handle_bug+0x40/0x70
>>   ? exc_invalid_op+0x19/0x70
>>   ? asm_exc_invalid_op+0x1b/0x20
>>   ? skb_splice_from_iter+0x141/0x450
>>   tcp_sendmsg_locked+0x39e/0xee0
>>   ? _prb_read_valid+0x216/0x290
>>   tcp_sendmsg+0x2d/0x50
>>   inet_sendmsg+0x43/0x80
>>   sock_sendmsg+0x102/0x130
>>   ? vprintk_default+0x1d/0x30
>>   ? vprintk+0x3c/0x70
>>   ? _printk+0x58/0x80
>>   nvme_tcp_try_send_data+0x17d/0x530
>>   nvme_tcp_try_send+0x1b7/0x300
>>   nvme_tcp_io_work+0x3c/0xc0
>>   process_one_work+0x22e/0x420
>>   worker_thread+0x50/0x3f0
>>   ? __pfx_worker_thread+0x10/0x10
>>   kthread+0xd6/0x100
>>   ? __pfx_kthread+0x10/0x10
>>   ret_from_fork+0x3c/0x60
>>   ? __pfx_kthread+0x10/0x10
>>   ret_from_fork_asm+0x1b/0x30
>> ...
>>
>> ---
>> Changelog:
>> v2, fix typo in patch subject
>>
>> Ofir Gal (4):
>>    net: introduce helper sendpages_ok()
>>    nvme-tcp: use sendpages_ok() instead of sendpage_ok()
>>    drbd: use sendpages_ok() to instead of sendpage_ok()
>>    libceph: use sendpages_ok() to instead of sendpage_ok()
>>
>>   drivers/block/drbd/drbd_main.c |  2 +-
>>   drivers/nvme/host/tcp.c        |  2 +-
>>   include/linux/net.h            | 20 ++++++++++++++++++++
>>   net/ceph/messenger_v1.c        |  2 +-
>>   net/ceph/messenger_v2.c        |  2 +-
>>   5 files changed, 24 insertions(+), 4 deletions(-)
>>
>>   reproduce.sh | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 114 insertions(+)
>>   create mode 100755 reproduce.sh
>>
>> diff --git a/reproduce.sh b/reproduce.sh
>> new file mode 100755
>> index 000000000..8ae226b18
>> --- /dev/null
>> +++ b/reproduce.sh
>> @@ -0,0 +1,114 @@
>> +#!/usr/bin/env sh
>> +# SPDX-License-Identifier: MIT
>> +
>> +set -e
>> +
>> +load_modules() {
>> +    modprobe nvme
>> +    modprobe nvme-tcp
>> +    modprobe nvmet
>> +    modprobe nvmet-tcp
>> +}
>> +
>> +setup_ns() {
>> +    local dev=$1
>> +    local num=$2
>> +    local port=$3
>> +    ls $dev > /dev/null
>> +
>> +    mkdir -p /sys/kernel/config/nvmet/subsystems/$num
>> +    cd /sys/kernel/config/nvmet/subsystems/$num
>> +    echo 1 > attr_allow_any_host
>> +
>> +    mkdir -p namespaces/$num
>> +    cd namespaces/$num/
>> +    echo $dev > device_path
>> +    echo 1 > enable
>> +
>> +    ln -s /sys/kernel/config/nvmet/subsystems/$num \
>> +        /sys/kernel/config/nvmet/ports/$port/subsystems/
>> +}
>> +
>> +setup_port() {
>> +    local num=$1
>> +
>> +    mkdir -p /sys/kernel/config/nvmet/ports/$num
>> +    cd /sys/kernel/config/nvmet/ports/$num
>> +    echo "127.0.0.1" > addr_traddr
>> +    echo tcp > addr_trtype
>> +    echo 8009 > addr_trsvcid
>> +    echo ipv4 > addr_adrfam
>> +}
>> +
>> +setup_big_opt_io() {
>> +    local dev=$1
>> +    local name=$2
>> +
>> +    # Change optimal IO size by creating dm stripe
>> +    dmsetup create $name --table \
>> +        "0 `blockdev --getsz $dev` striped 1 512 $dev 0"
>> +}
>> +
>> +setup_targets() {
>> +    # Setup ram devices instead of using real nvme devices
>> +    modprobe brd rd_size=1048576 rd_nr=2 # 1GiB
>> +
>> +    setup_big_opt_io /dev/ram0 ram0_big_opt_io
>> +    setup_big_opt_io /dev/ram1 ram1_big_opt_io
>> +
>> +    setup_port 1
>> +    setup_ns /dev/mapper/ram0_big_opt_io 1 1
>> +    setup_ns /dev/mapper/ram1_big_opt_io 2 1
>> +}
>> +
>> +setup_initiators() {
>> +    nvme connect -t tcp -n 1 -a 127.0.0.1 -s 8009
>> +    nvme connect -t tcp -n 2 -a 127.0.0.1 -s 8009
>> +}
>> +
>> +reproduce_warn() {
>> +    local devs=$@
>> +
>> +    # Hangs here
>> +    mdadm --create /dev/md/test_md --level=1 --bitmap=internal \
>> +        --bitmap-chunk=1024K --assume-clean --run --raid-devices=2 $devs
>> +}
>> +
>> +echo "###################################
>> +
>> +The script creates 2 nvme initiators in order to reproduce the bug.
>> +The script doesn't know which controllers it created, choose the new nvme
>> +controllers when asked.
>> +
>> +###################################
>> +
>> +Press enter to continue.
>> +"
>> +
>> +read tmp
>> +
>> +echo "# Creating 2 nvme controllers for the reproduction. current nvme devices:"
>> +lsblk -s | grep nvme || true
>> +echo "---------------------------------
>> +"
>> +
>> +load_modules
>> +setup_targets
>> +setup_initiators
>> +
>> +sleep 0.1 # Wait for the new nvme ctrls to show up
>> +
>> +echo "# Created 2 nvme devices. nvme devices list:"
>> +
>> +lsblk -s | grep nvme
>> +echo "---------------------------------
>> +"
>> +
>> +echo "# Insert the new nvme devices as separated lines. both should be with size of 1G"
>> +read dev1
>> +read dev2
>> +
>> +ls /dev/$dev1 > /dev/null
>> +ls /dev/$dev2 > /dev/null
>> +
>> +reproduce_warn /dev/$dev1 /dev/$dev2
>
> Can you convert that into a blktest script?
Yes, will do.


