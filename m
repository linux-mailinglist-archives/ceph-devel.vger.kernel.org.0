Return-Path: <ceph-devel+bounces-1256-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C0C8D82A4
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 14:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 290DD1F26320
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 12:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1822312C481;
	Mon,  3 Jun 2024 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="Ewf77Bqf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2093.outbound.protection.outlook.com [40.107.13.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C61E491;
	Mon,  3 Jun 2024 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.13.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418787; cv=fail; b=Q0SN981Xb9WfQUYiZ/dmc79XbP2rF6fRdKliA4/NJxmxT7wGUQJsyR4TOMR9C5usRQdNS8AtVpsEYN1OT64m5wuS0J8WrdBPYlKStCbIEnoQPMTE0m5kJUWd6N6SzWGkO0hG/kR5FULgPUqHjXYMWR9LX/Q/XoHME9q7v65p0K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418787; c=relaxed/simple;
	bh=94fPuzV8P66EaP34/8y8Gk3j98BjVlJv4sSoqazvKGg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HZef0BdLcjgRH4F5TdlC/4gNfMi+WjReSt6yBhPyHloSLyX4340obBSuHJUlB3QrKj2oGGhv3ORozGpe1Uv1wz7EH9IoGqtNkf8uipmzcziBjsyo0DVfhKrD/eyFc6Cq8SxNSxAzEH4f5oakjoMgGtOIRBD8mCaV0mjKZ4Sthrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=Ewf77Bqf; arc=fail smtp.client-ip=40.107.13.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/9egwzOaQLP+GLNENVesCEoxNihg6ifjHy+qNYnpxfjjqCUBvtBtYfG1z26nE1re11ylhIvjZBSz/ZnwNszqzyYlC1alYBgFr89q5LyIS/U9DVCMU+bm9xh+QQpncl3UoTlPG0hwwqfWS7t7kFv4hldRpAfrcFzOGMN+TDiDCGC7r87KnBUiYxneyBir7UtLjqOjHoN8K+EsFoSBuWM0H4FaHnXM0IVXyWrBWfu32Xf6ictd8erYMQleYiJnJ+oYfOLqSjDKOVc6ApU0/Wnv5sDCmH8VP8iHCfgLAgn0xYFGZbrakRFV1COKH6ekTwA4PNAn9D6QY44KItinVUjtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94fPuzV8P66EaP34/8y8Gk3j98BjVlJv4sSoqazvKGg=;
 b=QEm0sc/NOubCJZqB9muycS6CXSaFw+hmrHQK6k0Rhsca+g2UbtxW0un3W6sGe87INpofFsS166FRyOoN0OWqtkpSS+YMTUedq1QlH+Eqgoigcy5hcK5hgEmZ4Xrj22+bcGVYjRUwvXYRMkLz/YdtN7Lizdco2OT1cle3/M+pDIGcT014CVs5JW9Q/QV0syZ3J54Pa5knSk8C+XT1ZmBJh+bvX5SZMFr1f9c+3+UO1rq8NF8COVCGeXqxs7HoccVg+KgRo71r3y+qmbyMXL8ODC0uqv3zFxEFEqkcBPBdzEzIc8izYhlgdsAEj3cX0VEMUR5aDXd1fPW7nAl7pjTpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94fPuzV8P66EaP34/8y8Gk3j98BjVlJv4sSoqazvKGg=;
 b=Ewf77Bqfy+WiXiESYyJAQSw028dsBisdtPoz6ANvfhVfTkchC+0fAKy0IK1g3TTGCzdR/wz6zD3SU6A2ROK73II62D3d6HrYRuQTQvxjIT635JmXUfZyfLFFdcceVcRVAODYF3SmlpoGWPgoKAgiCP45OIfO+AK2QXVJSYQRr+/nTArZAIWCUMskAa3OKyTssqLMTGjC8SXulW7Pbp9/6kKDqZKF+Zsr0R8OfYR7xayTfZrtrqlIjTTsg5Fb5r5kcsarOC0zhiYXuzhQLZLN1rsAj76hZJbJVXsDk8/Ft75jnV/NnKX7EceZrEQMxcqbMjF/ozfRxOVvPzIVIx/b0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS8PR04MB9189.eurprd04.prod.outlook.com (2603:10a6:20b:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 12:46:22 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 12:46:21 +0000
Message-ID: <359112e8-602b-4ac7-8326-c672276f0004@volumez.com>
Date: Mon, 3 Jun 2024 15:46:16 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Hannes Reinecke <hare@suse.de>, Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240601153430.19416989@kernel.org>
 <05d5fd1a-9295-4753-a201-c9a968ee7982@suse.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <05d5fd1a-9295-4753-a201-c9a968ee7982@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::18) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AS8PR04MB9189:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c03a35b-707d-4fef-ba9f-08dc83cb2b60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlE0elBIMEJJVzJGSGpZZ0pHZVplTGl6Z0h4dlVhRDRFb0V4ZEZkd2Z0anZL?=
 =?utf-8?B?TXViM1UvaEswSW94MWFvL0JQWjUxaDduU0NRSlMzNGdSYzRsUHpBZHFNV3hz?=
 =?utf-8?B?a3kzNVA1OXBpVFF1TElWWXBidnhocGhEcXN1ZGJMYjFXVTZ6UHFST091RW9H?=
 =?utf-8?B?Wi9YWDAyZ2hTRS9KeWJYOVBxbWgzQ2R0Y2VGYlJXYXMyNlIrcXE4OXd4NW15?=
 =?utf-8?B?RTlISFJ6c04yMjZ6R1hzd1ZuemRTNUJ2NEtOMUFCdWErdWRGWkh5SVJxUjVo?=
 =?utf-8?B?RkZsbStkbUhDbHAvZ2N2eDE1M2N5WFdqWndGc2ptNnRrTFMyVDMrcHhxelJP?=
 =?utf-8?B?dG42dExJSHBRS0dUSjUyQVF5dDlTNDAyN2xuVnZQdUtGOUJaMEhXNUtzem1p?=
 =?utf-8?B?ZFdzYXN4MTJPTTlRWDV1OGd3dThpOUY3N2MzWGNxR2ErQllKS0VnQlhpMlJZ?=
 =?utf-8?B?MnVVZXlyVHlhQk5BaVMzTFJHRFh5aXpoRjQweDJycmpXREJ3U1FkTTQrbngz?=
 =?utf-8?B?MUYweGp1ajNVK2xGVkNQZkYrVjdzSWlPYlJLaWdESnVRQVgxcUZCNktYdHg4?=
 =?utf-8?B?NGdSMkN0NUVyRnlrRlo4YWVuaUxxeXNqak92Z3lXMnJ6eXRGL012YmtnZW03?=
 =?utf-8?B?eDBlM3dIbThDdGJmSmx1TnlHdVZKb0Y1TytVQlp0WFRPajE5VjN2U3hNZjF6?=
 =?utf-8?B?bmhKSEYrRXFyU3FUT1Y4d3dBdkpZK0ZxZm0wbHJ6RzIvOGFmOXNZNENTNWJB?=
 =?utf-8?B?QTBCMU1SRERZd21Ra3V6YXlSaW15TzVRV1BlbEJodXJFdzQyVDJXNENuZEpU?=
 =?utf-8?B?d1YweUQ2bHExRlZhd0VMdmVSampXKzJnTUlvNFhqT09GRG5TUlVOeVQvQWY0?=
 =?utf-8?B?NW1TYzQveXlDNW9pZ2Y4R0VBOWVRZzVhTVlETnZpMzZQaGVPTkt6NzQvRHpy?=
 =?utf-8?B?YTg0QXNEZENVeFNSYmhhSWs3YnZpb2NpYURycnlqNmlqanNCUTI1c0FhZDJZ?=
 =?utf-8?B?ZTBRdzNMdyt0NlJ3b1VYd0dPbDN3NTJ4cUtUaDl1OHd2VGRYRzYxMVdqODJw?=
 =?utf-8?B?UjZxaUVCTS9QT0pRc3Q4Y0ViQVBYTVEvb1NLcVZCRmpjbER1ZitIVUllSm5K?=
 =?utf-8?B?UHNOR0NJNHRnempUNWdUQzFCY0xqOW5paktXQ3RRR1NiSFRsejFMeHRhc1dx?=
 =?utf-8?B?MDNqNFRZQWRTYWl3RC9HUzJleDV2cElZVHZwU2taMkdGRU9vM2hZVXhxcktz?=
 =?utf-8?B?aElXU0JRQkxBTFlPTDZsYjJpdW82V1lRcXdtK21tM1ErRm5Eck9LcHNnWWRW?=
 =?utf-8?B?RkJ4Ukh3L1lkZGJqY2xuSlBqKy9nbk4zNmdwYkVsOXhlRFVFSkJIbGwxY2ZI?=
 =?utf-8?B?T1JnRzhvRWk0cWJyV1ZWdjYycGs1ZUFDVU9NUDdaTHBtVmpWbUhnejZuSllT?=
 =?utf-8?B?eUwxWHhab3phYURhMlhySEg3K1J6bFo2R0I2T05UTHVBanRqbG1GWmdpdENE?=
 =?utf-8?B?OEJ3WVpqYkVMcEhIaTNQWFJkUHc2ZVhXN0I0Tll2aGVPV2pTQ0h3TktRSFMx?=
 =?utf-8?B?dy8yNDAwSG1oTnBBdUN0TjE3ckdDNjQ4TXVYTTZvNFFZRnlRU0FITldraHM3?=
 =?utf-8?B?R2dlRlNVUGdwTXpxektqUDRBSnNJOWFDWkVuN0lDUm1vOFRRd3BmSnJKd3pm?=
 =?utf-8?B?dzlxbXVEVDRVbnJPK2t3ZlU3Yk1zbXREYzc0NzR6d3VEcm0yemNFWUNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFJmUVRJNFBpZHFWSDlBMVl3YXVja1JneTcyTXVXcTFuZ2NGWSs1RmxaUlgr?=
 =?utf-8?B?V1dZZVBMQkJqc1k3RlRQRWpmSXVjaTRsL2NrOUVCd2NOL0p6bnZWUkVEcGRm?=
 =?utf-8?B?UTFROWh1UWZpYjB3V2xLeUZRVXd4RkQ1eCtpQWc0d3g1eWJjSDRqeExNTFhG?=
 =?utf-8?B?QW9KSWF6eENaYlM4OTJZZDh1WmFvbisrV3dPdGRlYzBJYkplaDRNVEMwLy9F?=
 =?utf-8?B?U3ZYK1hyaFZFcDdOSkpsZVQ2cG9vekJLcVF1ZjhZWHNUSDFrT2tOK2MzbXZW?=
 =?utf-8?B?TVFyWEMxdXM5N3F1VzRQa2JJdnY3SnlnanMzUHhOL2UrcWZmdUQzbGsyeW41?=
 =?utf-8?B?U2NJZU5PYktGaDZBbm8xajZqWWRwRUhnS1pYVWw2LzhOeSszc2VEdS9DK1E2?=
 =?utf-8?B?YmZLdFZSQkkveUtWUWpYZFZHZ0FYMUtpaEtzV0hsUTJVczZDeXNaQm5Gc1da?=
 =?utf-8?B?S2VmaU5TSXcxZit2THlYRzhHUFNMTEY1Y2RBdWYwN1dTa0VFTkE3emd6SEZs?=
 =?utf-8?B?a2EzQlJIdzBZenNhdEowanM4U3huczBOdG1GRnY3ZHkwZkpETWdNM2daM3ll?=
 =?utf-8?B?Y2NCM1hEaUtHRUk5TzlrSmYyWmVhSlRMMlFydFp0elZqRXVlc21rN0RaZ2Rm?=
 =?utf-8?B?czBUUmcxTHFGT1lKTzg5ZkFPcXpyejIvc1RncDFTcUkwWDVYNkk5TUlYZ1U4?=
 =?utf-8?B?L1RZUmJkcHYvd3Q2MCtXYlUrVytyTDhhaTJ1SGFyZ1JVWXd3RnFvR201c3Ru?=
 =?utf-8?B?bjVOUUh6Q3BEWTYrbno0WTltWTFncEp6NDhrRHZrSzdnSExzS2NpQUVXZTJ3?=
 =?utf-8?B?ZDMweHdKbFNBM0dDZ3FmN01pUExiMlZMSitqb3lRUXNIUHhLVjRBMENWSXpK?=
 =?utf-8?B?c3EzRE5EVVRONjBJZGhCcEVLUVpUY3dUSXNoWW1jeFZWci9ySVliV2FqanB5?=
 =?utf-8?B?eS8wSFVuVis2d0plNUZ6a2YvSlJsTHhmNE5hKzJXR0Vjd3JtUFJpb1pNR1pB?=
 =?utf-8?B?Y08zSjhMZ01zUWdRaUZtMC9JSDI1eWQxZThqeTlpd1J2YStEcTIybHl0dlBI?=
 =?utf-8?B?YUhQajZyT1pNR2FmL1lyYXYwUG9pS2p4Z2dQc2dTUTRmZHdyQUI1d1BGZk91?=
 =?utf-8?B?RW5EUDdRaWRyYVlhbzV0YzAxMTJpNWFIbmpEdTNrM2dicTBWaE5Ib0VGRDdO?=
 =?utf-8?B?a3ZTWmxwZEVxV0ZHVCs4VG9FbE1mc3FWUHhnOGxGOENHaUtxTnRsVTA4OGpR?=
 =?utf-8?B?TEY2N1UvcDdTTVFDSnR2MGwzeFFZU3JVcHFkWUh3N0g1UE5mMEpVSHJtNkMv?=
 =?utf-8?B?aC9GOUQ2UFd0cGJzc0F6cGJ3VXpyaXU5dUlzSmlQK3FNWG1ZVHRrOVRQd1Ft?=
 =?utf-8?B?NGxLZzJZRmhTeGxQaDVhVjFPcVljVm5GbUpENkV6VmVOb0ZQV2x6Y051R1ZE?=
 =?utf-8?B?REg4Rlc5dXR0MEl5Ykg1clRGOFdIU0p1WmNLWFcvUFQzSXp2VThyYmlBNFdr?=
 =?utf-8?B?dGY1NlNPb25laStLQWNDMnkxM1NmM3JiWVJBQ0RKWFBkRWNjdW5NcjZiY3hK?=
 =?utf-8?B?MW9IK0YwYWJYSGt2MWx1VlNQVXE3NkxQMGtpV1Fpd2JiQ3hvWExxL1JCeUN3?=
 =?utf-8?B?TTRxcE9hLytxVjYzRVl2Vk4xcTA1RU1Ya3RFU1NHOFBJMlEyZDlnZ1lhd3hs?=
 =?utf-8?B?ZWZEaWExM1M3RXg0UzlUcEsvZU5zYVZONmNUS3NOQ0h1bXVOOXdwMUFjZzdR?=
 =?utf-8?B?RkpwZTdhTzR2blQ1YnZieFJpeHhERFViN1VQRGY3V2d3MUpoSDg4MVhacGpy?=
 =?utf-8?B?c2JpTk91RmdvbTZEaGJCWVo2d2tLQzhwakxvM3ZTVjBCMng4V013b25EcFJq?=
 =?utf-8?B?UUpGWjhvRkUzUURwdnhzdFZpeGZhSWIvOEJhZEdYM0Zod1FlTHhKNlNJN0ZV?=
 =?utf-8?B?WTI3eWVhcnhjbFgyNmc1bG5FNlJKSHFhTWxsNGVlV0hYUlN0bFBtVXlRRHdj?=
 =?utf-8?B?UkcvTW1ncGVmMUdINzFhUjVtSEJOS05KbFhqTWdyTkc5VWZDQVRpTkxRRWlS?=
 =?utf-8?B?bEZZMW92YkhIZUNjYk9SMjR3WjJna3dJbHFSdmtidUJxdmd1WTBqNitWQ3k3?=
 =?utf-8?Q?+zg/+QpEabSRuVPcsPKTC6ZPF?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c03a35b-707d-4fef-ba9f-08dc83cb2b60
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 12:46:21.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxeqHRUuxwFX5Svh3PA94c6NljpbIEvopsDpUc65JHlaZ73jO+ae/LEYFAzKRvdQnhffHg/EQT6DF35QtRJPgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9189



On 03/06/2024 12:07, Hannes Reinecke wrote:
> On 6/2/24 00:34, Jakub Kicinski wrote:
>> On Thu, 30 May 2024 17:24:10 +0300 Ofir Gal wrote:
>>> skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
>>> skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
>>> skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
>>
>> noob question, how do you get 3 contiguous pages, the third of which
>> is slab? is_slab doesn't mean what I think it does, or we got extremely
>> lucky with kmalloc?
>>
> I guess it's not slab which triggered; the actual code is:
>
> static inline bool sendpage_ok(struct page *page)
> {
>         return !PageSlab(page) && page_count(page) >= 1;
> }
>
> My bet is on 'page_count()' triggering.
It failed because the page has slab, page count is 1. Sorry for not
clarifying this.

"skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1"
                                                                 ^
The print I used:
pr_info(
    "!sendpage_ok - page: 0x%p (pfn: %lx). is_slab: %u, page_count: %u\n",
    (void *)page,
    page_to_pfn(page),
    page_address(page),
    !!PageSlab(page),
    page_count(page)
);


Regarding the origin of the IO, I haven't investigated it yet. I suspect
the first 2 pages are the superblocks of the raid (mdp_superblock_1 and
bitmap_super_s) and the rest of the IO is the bitmap.


