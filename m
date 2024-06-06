Return-Path: <ceph-devel+bounces-1275-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C26A38FF204
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 18:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47D281F2656E
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 16:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7C819922F;
	Thu,  6 Jun 2024 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="guqWz5Sp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2115.outbound.protection.outlook.com [40.107.22.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005631991C5;
	Thu,  6 Jun 2024 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690365; cv=fail; b=WFCbQJniEEYoq4q4VZWDU7BZXKPnz7+BjgSe5ImsUuyY3fZ+RWC6Y3XPJZX+jS/1mpRcoMP5njg7JmuNdunu4U1cxHAPTCUUKAEB6OrWO4COQuCDfg0rnHxo05xu0XCsnFQqd6oHMAIaKMic92O58Ag0f0MBSXuTTIPUXuNAOpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690365; c=relaxed/simple;
	bh=hrXyDaUZD5O+KIuY6QI0GBnrWAENZW6x0xDSGwfPjoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q8LSN1WJga4iPfZHN9VRyyDNi9RjBGW1H6A4zwzusPVyfqRfNSkQukJod+kRq1gi5TXPyAO+7Uz9/Mc4qxwerBMcvf13qbH5UaeXRW3FZ8ff1Y6ub2rErZA7Att6b+/Sfh7pKwJTFjRrDUiBZLJn2vddGxzhBH+d0z9YjfxQWog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=guqWz5Sp; arc=fail smtp.client-ip=40.107.22.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuwTf7whzjLoquvu9+o8QKauz8MH5WV9dH70wB1gIAMbBgO1hjw5kPi3KGXkK1TsPG3p4qYpGcRwDiQ3jCobLRJR1k6TC+qWzjygG0pXcCcvpS3eQEu6QFugEC3DXwsRB0dpbeNpKAWVNVc3o0PrZA+LqOQ5LtUdYOI/JyeL0sNDAl06wp2IYyEdsumKrieG3FU8WlUY4JcqZUWygAcrmLvU9q8RNyfwq80UMvRq8CDkEACtadbGTMzAlZDTajNrORh7JlVzjAfJZfKnN+aKuie5q39GFIK4twujvt9ySgF2TZbKbFedqG1jnWbhOohOYMaO40DyqDqMDhhBB18Qlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=427ibjUET2vgiYD30TKQMjrgcTz1GT6EqH2o5uxTbbg=;
 b=dLAFRpUlNHUMLrQ1i1dNl0at0kVgaFBLdy+yPnJ0TcIXDAxA+oojD/ZFMrdb1k584/ynG1zlooFGAC2cZ78YWXF8jKvhMyjGz4MvDzPV2Y/gOITd8Xh5s6hfwl7Prpext3yzo4Zd+/dGRIn3TcjtlzBG87bgJdQDmCAGscZO2yiGMcrxGxIalBLn9POI/9YGHWt7SuWHVbEJWdQzmK00kjM+6t+HP04wKTF106DBitAARM3BhZHOzTW2q264WYCPcypRX+0Om0wvVz33LiQs3aQuamAVvElozZmwU1ipufxoLHHW1touWMOrSOtcqDaedDOEGcNECbGLsBCn1io2+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=427ibjUET2vgiYD30TKQMjrgcTz1GT6EqH2o5uxTbbg=;
 b=guqWz5SpW0uhbmxgZMNSJ8WrbQlOpJEye/vNy1PTu2bRw7Qyc5U46te1G9Qw/AV3MkSGagw/PIEjo1FCOOTWh/43kKpcobyHrxJhk6nBN1ZBfoRYMMtU90ObYquFre8ydCsaUrWhUfyNshimwSzjjeWbjTC6VP1Wx1nDxhOT1bOLagUOijQ/+4hSCpNXkP3GAKPOAcg9eaww7hobczDMkg85hFFdTs4R0s5hX3h6x1WLfcflR8fZk+2mvXm4659lVZMJF13tnm67H3+lP81d89FniWqqKC6+SbflzeQC7MApI2Km5kO6abCkROxCSf6ndOgLypYssLD3rUTi9crCYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 16:12:42 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:12:42 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	pabeni@redhat.com,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com
Subject: [PATCH v3 3/4] drbd: use sendpages_ok() instead of sendpage_ok()
Date: Thu,  6 Jun 2024 19:12:15 +0300
Message-ID: <20240606161219.2745817-4-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240606161219.2745817-1-ofir.gal@volumez.com>
References: <20240606161219.2745817-1-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0009.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::6)
 To AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: ffa8393e-b4d0-4f63-5a28-08dc86437e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlA0emxmZjZkOFA0UThjZmZBZjFYeEk0Z24rQXl0SWJLZjI3bFBGTW1mVTdH?=
 =?utf-8?B?NGxIUU12RDdXY0ZVSVF3YUNVVTVjU1dpVkZKMXBIYXNScncwZjByMDV6Slkr?=
 =?utf-8?B?QWlOdUt0alZoMTdJZGw0VENGOERaYmRZZmhYdkwvWEgrcFFmQlRKVjd1bUpJ?=
 =?utf-8?B?US9UYTFHaTVZQkU2b25OWHlXdUxNSHRXNzB2VFpYTWttQ3lURUd1UXBTUXNk?=
 =?utf-8?B?M2tqenpPeHhCU1J6bzQ5SVhYL2lOWm50cnV4ZW4xakFIdWZlcDBkSUh1NWNX?=
 =?utf-8?B?b1JLYzN1aVdDMlcweVNZK2dyODVWbUZmc2xLWEVRSThzYmI1ZG9qcmV0dlBn?=
 =?utf-8?B?ZFRIVmtOWks3TWJ6SzdWcmczelJXcmxCYm03NkowOWdVekZhVklORkVwbkpv?=
 =?utf-8?B?eFVzMWdyaUY2bzZKRDRMSWNTRDdyejVCcGR1S3NTTGVUMTRqWDdYT3UvWUl3?=
 =?utf-8?B?ckNkL25TaHVXcWtlbHloTk5Ec2RzTWd5TUhiWkhwVFVaU2V4ek5DL3AzakZL?=
 =?utf-8?B?akExdFpSS0lDTTAwY3BQdk9hc1VtZTEwakc2TjdaQUczUUthWUw3TlRWS1lY?=
 =?utf-8?B?dnA5OVVvMm56VXZYU0M5WktpQjFXd0NmTzVQV1E4Wll2UzAyRm9yN0xhOTdk?=
 =?utf-8?B?a2FiRWZGZjFlbVpQdVBsVGdDeDM5NUM4bGhVcHZ5K3hBUWdTZERINURPSVgw?=
 =?utf-8?B?WTU4ZnNmWTFHbXBraENpc3ZJeFI1SFhqRW9oSFllclduOVM2STNJWkQ5V0xl?=
 =?utf-8?B?NUNLMkhWV0gzazZrWTY2NFhxamQ0OVo4MjFSd00xVzFXSUFZM25uZ1YwU3dk?=
 =?utf-8?B?dVhXMThRUjdrd3ZXenNvTDUwTkZ3M1FJeXFBZnNDZTBJQys3SldkajFpeE16?=
 =?utf-8?B?ZDNvNDU1Q1pnVVVMNUdZbGNUR2dLQnd5RkZCWDYxa0NoaC9QdjlCZlh1SVdP?=
 =?utf-8?B?enQveU5OZVBseFE2elFESG10MWZGWmRMc29BZGM3emdVUnoraU43QytldVEr?=
 =?utf-8?B?b2pXT01hb0tnbmZlVy9DaVVTcDk5ckpBZDM3NW9GeGFocTdKMU9KajFPcVFk?=
 =?utf-8?B?bU9tZ2wxUERlU2J0TUVIakxRSzZsaXVoNjQ0SDVGU1d3MUlXSkRYKzV2QnRy?=
 =?utf-8?B?Z1FzaWo1a1Q5cnBPN1pJODNHUWMvWVFEeExieW1oTElodTcvdXVKWGdoVDhW?=
 =?utf-8?B?Q3NDcGlsQ004bW9xRVBYMTNsTGY2bWxHRVQxb0Y0aEdTSlg3ZGEyTDJxOG5p?=
 =?utf-8?B?ZmtjTHQ2UEdYN1NUQ2FCaFU5RFJaSVBrRU5qb1VTKzVzN2hVUSt2dUpxRk51?=
 =?utf-8?B?M2U2M2YwNGV5bWlNem90RW51dkpJVCt0eFdRTmVtdHJsSUFNQ3VGQzR1b3Zz?=
 =?utf-8?B?S3pqNE1UdGE0NWttNkZlcTQ1dUExZW1GQjVjNEg0VncxMUE2Z0hzejI4QWpy?=
 =?utf-8?B?UGpuUUd5NEZHSGJ6VWdONGRkTUJCK3VWczZjMjdKTGxyb24zYk55QkdZWWg3?=
 =?utf-8?B?K0s3eW5VZUVwL2NvbDJsZ1JTT1QrUmUzQWRZd1Q4UDBkUXVTMXdMMUg1amhl?=
 =?utf-8?B?Vjc4WmRzQkFxdzNFZk5LMXM2dFFFcCs2SzFxQU80VUxCaXphajlqK0tNUGM1?=
 =?utf-8?B?dXRvVThhNjIxNkpSNXpHYUVFTDhINVB4QTFMVFFHb2ZMVEh5WDhMQzdFbThn?=
 =?utf-8?B?dVVJN2FrSkdxVjlLcWYzQVRQSFBrdmFjOWpJUTA4VUdzcWdXR0Z1UkVyYVpE?=
 =?utf-8?B?SnZVeXhzVHYvUGxuSHRBcjJpUzlhdXpIMzRybnM3cXNzbHYvMi9MWklOSWU5?=
 =?utf-8?Q?3ASlVC+P4AQjYVjDmnX5njNxKxCBDIsAkhdts=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjFOMTY5MjF5OHYweDJYcTkzZzhFck4veXcyUHNBTmdhQU5YV3RUcGdqK1dY?=
 =?utf-8?B?L3RoQ1ZLNUZtMzJjdHg3SWZxSUhJa0RSMHUxalNUSUlBbUllSHg3WWIrdUMw?=
 =?utf-8?B?NFpuVmlvTU5SRm9vRWR4V2ZsazdudXRyVUREaUhwN250c2pQREtKUGN5bjVZ?=
 =?utf-8?B?UTJJd3ZyQkVCdStzUUxkMCtLWFhMMy9UTmFiRlViUWQzaTNUL0RLNCtqY3NE?=
 =?utf-8?B?UGxWbGpFdWF4dUJueGlmZk9ncjRIUUYzdGpBOFFQUEVGSzB2M2xTa3JmYW4x?=
 =?utf-8?B?OGxaMjRvVm1QM3MzbHFBZ1JuZkFBQnRQQVVxTXd2S094YkVTemFML0tTaVNU?=
 =?utf-8?B?eG1TdmtNalFteWIxVThGRVQrWGgvUi9FUURqYlpQeldYcm11VlRDajR5SHZh?=
 =?utf-8?B?UWJHclRGYnJNRVgyQkc1a3QvZzJBMG1mTXJNQjlhMlRyaDRNY2F1REcySXZr?=
 =?utf-8?B?am9tZVZCVkQ5Z3B6dFlKUlJycVlkOHlQVmx3RVo3SEtQc2duZkxqbTU2eVJi?=
 =?utf-8?B?VERkV0g1MnhJQmd4NU1SemFIUG45TEhwNGhhSGRVbkVrcWMzR1hUTG1mTzhu?=
 =?utf-8?B?NTI4YzEwMDRsVFJhWkRRcVZpRWp6M1p5Y3FLY1QxYVgyODVBOFIzbDRJdUxa?=
 =?utf-8?B?MVNtVFhRVE5KclJzYmlXb1ZnK05ickRYT2hDT21PYVlOUktwc25sTlFnUENG?=
 =?utf-8?B?dkxMYTYxNU40cW9jb253MmhZYldOcEpKOTk5Yms5TEtyUE1ESUcyQ3hrTTB0?=
 =?utf-8?B?UEg5dUxFN2lxbVJFbzdPODE4b2NPWk1KS0J3V0NEWWMvaTMxS005MlFoM0Vm?=
 =?utf-8?B?dkkva1Jna3VtZHNJQkFaRGIzSE81bXRTeE1IM2xJSkJrczZHQ09FTi9DcnA1?=
 =?utf-8?B?L1dLQnFqcWdQZXdHdmhQVmJrL2Y0TEMxc2hzZ3g4NFZSRGkyU0QwbzFFcENu?=
 =?utf-8?B?Z2x4akRscFZBajcrMytheWI5NkdoaWlSTVFmNlY4MU5hQjZxVHN3bml2Rkow?=
 =?utf-8?B?VHQ2OEg1OUY2TEtEdEJPNERZNDJZRUZaRnU3WnMwQ0dtb2Ywa3dBZFk4Y2tP?=
 =?utf-8?B?ZS9UZDZabEdBNEN4elhyMnhUbVBtT29hank4TGZHckhVdGhraG91My9vZ3Jm?=
 =?utf-8?B?RlZpL2F4ck1vd1RHQTFLU2Z4Y1I0NE9YTFVTUEZsM1M0RDZSc0hCZzdha3da?=
 =?utf-8?B?Z2NoL3NPbGY2OEJscDJ4aUNYaUIwZzFBT01GbU5vTVcreXdUTTRXNDFyekp3?=
 =?utf-8?B?LzRnd1VzaGJ6dFYvVTNieUZkQ3ZQMGJCWUJwdFhyVHo4ZDBMKzgxT1l6ajJU?=
 =?utf-8?B?YlZIczNuSERtVnZKT3ZuYVdkakVaMFVwdE0vKzhCaUkzZlBwQWRGc1UyZEtR?=
 =?utf-8?B?cVNNRGhTaUoydCticytDaEx3OW16VnBBNTlxVEVud01ZYWYyOEo2bFlRZnda?=
 =?utf-8?B?Zzd5OUE5dDlyVEVhcVRQSCtHYUs2a2FISFhsVnJKN1U5RzlYY29BaU9pUFkw?=
 =?utf-8?B?NEhsRGNYZGJLQUJkNXdaU3ZwbVIvRFQ0dDlkK1RidWVwbDR6YWRlUlBqb0ov?=
 =?utf-8?B?Y0YxbDkzUmxTVzR4K0VYTERDb2pTNzlHS0orOEluWEpwYVRxamZTN3Q5OXp4?=
 =?utf-8?B?SzBsLy9EYlFpWmIwR3k3YUZGcTJWRTZUNWNXQy9aNEdMQ1U4NXYwUitrNFBR?=
 =?utf-8?B?eFNFV1ZWQm02MTQ3YUJSNE5OSU9nejBRN2dETXAyNm1wUWNIbXYzK2psdEEr?=
 =?utf-8?B?Z3ZuQU4yaXdTb3RMWnlaek5NWjdHSnQ5NjMrME1aQ0NzWW5vQWpXM3pKWHhD?=
 =?utf-8?B?ZnRwcTlmOVZHeXNEZEd0dHNTbEpNQzVCVTlnQnRuYTRHU1laRHlwalhiZ2My?=
 =?utf-8?B?d2ZOT0ZqbmxjUWYyZnJSTitSd2VaelFnbUFNQkUzRjRzaFBQa2VkM0F0eUlX?=
 =?utf-8?B?YnZ0d3ppV0pLS3BVbS82Q2grNmg2dTd0Vm5EYmVGQUtHdlZSbTJYSUNKc0M2?=
 =?utf-8?B?WVpNT2s2U2Zlb1NrVVh6eTNMS0swVFVIZHZsQUF5Y0NTOW1Qd3pyRWlCTm1H?=
 =?utf-8?B?MWhDSHpKd2ZSK0c2d3N5ZDc4QlJiek9DWndLQ3dhZmNaZ2JCL2tjNXV4ZEE1?=
 =?utf-8?Q?/Q/f0qjRS2/i1sesVXJaZRlKR?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa8393e-b4d0-4f63-5a28-08dc86437e65
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 16:12:42.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/nynYWVLoUjrKCZcZ7u3RHje+ZSei8NpzfFLlsaajGhOYnEDZlNBFFl1UW7QbMkotqeJSsowmEHjQhAHGAV+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815

Currently _drbd_send_page() use sendpage_ok() in order to enable
MSG_SPLICE_PAGES, it check the first page of the iterator, the iterator
may represent contiguous pages.

MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
pages it sends with sendpage_ok().

When _drbd_send_page() sends an iterator that the first page is
sendable, but one of the other pages isn't skb_splice_from_iter() warns
and aborts the data transfer.

Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
solves the issue.

Acked-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 113b441d4d36..a5dbbf6cce23 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1550,7 +1550,7 @@ static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *pa
 	 * put_page(); and would cause either a VM_BUG directly, or
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
-	if (!drbd_disable_sendpage && sendpage_ok(page))
+	if (!drbd_disable_sendpage && sendpages_ok(page, len, offset))
 		msg.msg_flags |= MSG_NOSIGNAL | MSG_SPLICE_PAGES;
 
 	drbd_update_congested(peer_device->connection);
-- 
2.45.1


