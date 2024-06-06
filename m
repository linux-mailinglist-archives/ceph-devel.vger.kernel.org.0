Return-Path: <ceph-devel+bounces-1272-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 649268FF1F5
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 18:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBD4E1F26701
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 16:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47503198A3C;
	Thu,  6 Jun 2024 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="abEI+9vx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2104.outbound.protection.outlook.com [40.107.7.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19FD947A;
	Thu,  6 Jun 2024 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690357; cv=fail; b=mzhQGYBtr+eBM0bW1Xsij+XEsr2HVttYsMUE8c04WB8hSfXDoRr7gk4kBQQjAO75EaNxAUcyqd4/xk2NbBKxOJb5J4f2o/7q+TlNH9MDTUXsZZbAl38iUsIh+xHMYqGPlk6gAm7cjzPnflrDN3ACP/9tjE/G7vYCZU+IBsY7p08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690357; c=relaxed/simple;
	bh=HCroDG5itaNt1moOR85LhTsQHE1o7zA0xUTZBHyhrEs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tGNcaRMEAxFY6yoGNd1f6JRsSqt8sad6SK1ZmOF/BZz7YeL0EajMlAlKESrorcvCR95zwdeSCygmDjMQcbyFI5zDwmRp2Gh0J+anibpetrEZy62DcFqzxmX/EqBqAsQGGYCmjWk0/U1TXZ/Wg7qX8M3qMJ+41wgcp1S5q3fcaZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=abEI+9vx; arc=fail smtp.client-ip=40.107.7.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKWXPxuKiVfNGkpgyQKWSDOruvn0lKqQTSTnsrJ0vGsPDTZbsX/AiH6aukepDb4Jns/plF7Os+kQZSNDGy0tKNDJrAqr0iC0AKXmCveVN3rZuzOJSnmQYLIfST9njLDgRVBLlSoXJgHE05PGrsc0CilPWD3v5D3Rthz7R7BE+wlWZlpYi/dLWUO8ZbZwefX3kdgnb6x03apPoDuz7y6h4Wt64tfVZT0eEDwgeQ9RnHUqQM+tLU4Cp9TNTCMWRWCBC6nRigH54NvPcKZc/qBC5Qf0nDL94AJKBzYX5gZ7tMvR5ijHn6cUcxFPNdq37EUP1mY8rT2LX8Qgc9kGgjGDqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFIG2PIf+zrG95p1W83U82nH4ppR/MDBZY9tN1VXlNs=;
 b=XRgsZB6X92DF7WPTJgR/M8xeIZwqA8Bx8f3nLK0Q45EVaeyQ6nL0AfUJeG2Ebwy+ZYnSQZ2NkFVYa0DtY1HaEM7H16R/tjriiQUnTlXFRkhyXfJKOH0yGw/xxG4pfy19sReyvEzXsYTxEo7M/GR2xtmpY00fIJO7mFGs8qnupU8au08lLFhtAjPzVgJKwpgH6WwVwSfqnqHZBAo8L8jR6oU/sJe44AIn7NjwTwfGNYPbfwcotBV4j9exYkwhZmrxHitvi38/tN4P0Ab/MIv8fwf8EMck1XCDpzPxO3CR2Y/LhTxoQKAxU5eAflIqpMT0NlzLOUdtekQ2CCF5LlF+/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFIG2PIf+zrG95p1W83U82nH4ppR/MDBZY9tN1VXlNs=;
 b=abEI+9vxzlifdvI8uoiOaRjbu/eFRGyN2vZoVC12zx4vdFEtprSey01YfXy9yoJR2AlhXlbQXiobtYEc7Z53TCSN4XyQbGJX1Mwsc1My1y+4WxIUWD43JSm7OfmR6jMPMzRPQJx02rq7RceTnuqMe+ykuapJAae7826d0vVhPMcROMYfQz0mIDtKJXuFymB0g6hqmB3q4WhuRIEW6B188b012s4niiyxonOd3dyhOxnORsjwHW3JZy2nSMbTmbM4bdipQ+hoDnAryi6JGFgDpcCSAWUKRHHnd/6NQrDLS+y1Cr7v2aRJsdn6QiSLUHQ+9JkouFnReJV71dKxFORvaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 16:12:31 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:12:31 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v3 0/4] bugfix: Introduce sendpages_ok() to check sendpage_ok() on contiguous pages
Date: Thu,  6 Jun 2024 19:12:12 +0300
Message-ID: <20240606161219.2745817-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
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
X-MS-Office365-Filtering-Correlation-Id: d5b66dfa-8c9a-46cf-5f3c-08dc864377f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|1800799015|52116005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NTNleVVheVNXL2RNUkxNTkZycHBRc0puY1BRRDQvUnV6UHh2TzBaNzRKckVr?=
 =?utf-8?B?SWpCYStoSWtWQXV1N3lYZVRXNFRQb2FwQzRKSHdtMVBrZGs0QzVYNXRCWlhi?=
 =?utf-8?B?UXJ5czNGWFFHeTk3c0I2WXQrVWQreHdna040N2Nzbm5pbTYxanVaSUdkUFV4?=
 =?utf-8?B?Zk4xdTkwV3cxcURQNVpQSDlnZFEyZnQ0Mko5bzBoZFNHdnd2R3pvYVFGUGZT?=
 =?utf-8?B?aVVJQUYvMUthSVRTTS9hVTEyT3J0L3M3UTg2QStXb2VTdkRlNGxqaG5SWnhD?=
 =?utf-8?B?a1BGdkhnWWJLOUhoTFZvUWF5eU9sQjJ2MGxKQ2VDbnhYYVBRakVtQlVJaUV1?=
 =?utf-8?B?WXZVK2hNWXE3ekRsSk5TeVBwdU9XaEFGdUxXTDhwNGZNT1ZCU2tGQjY5UFk0?=
 =?utf-8?B?SXg1d1pKdTZIQ3pKZ1RUeXllWVh5Qm9OKytuOHFWYUxsWjNlalFPcmRRenJa?=
 =?utf-8?B?bFJ3MmVVSzBqTXR3SDkyYXZuaVVndGFEd25TaEcrRmJlalNacVo1VGJNRThO?=
 =?utf-8?B?TDNWMU1tTWNDb2FZQkNqL2ZnUWR5V0xBWXFzcC95RUd0SkZKQmdaQUcyU1lw?=
 =?utf-8?B?R0RoSVAyRlkwZ21nTTVqV3NCRGg3TUNTbEZhZEFRSitBQjlzWEZadVgzVlE4?=
 =?utf-8?B?Zk1WTlF5VEtXSXdlTEdjRTNleG1MV1l5TWI1bXJZU2NVYzdtb2JiYmJmUFdo?=
 =?utf-8?B?eHpxa253ZWtmbDhHM080TysrOXFweFdRR05OTHVUeDZUNWZzRXJBN2EvQzVk?=
 =?utf-8?B?N2VGd05FZFl3SUEzaWNTRjRyVE1qbGJwVXdUMTk4SHNUQWJGOHNBRHZmN2JR?=
 =?utf-8?B?WmJJNFJuc253WWhKamVoai8rdU81SG1jTzNnUk85UDZmNlhKb0M3bkNiUnBN?=
 =?utf-8?B?ckExMnR3Y2JlblhTK3BlN1lMalB1MTdzUVNwT01WUEpsalcyWTlSajRycjZV?=
 =?utf-8?B?cVFNTzZYUmtKNzhCOVJXR1NxVmFsTjZTZVVMYXdiaGt6a1lzUGN6Z1Iwdmpy?=
 =?utf-8?B?ZXVyK3VQUmtCWmd4ZWFIdHBMbGNmZ0EzTTNxWlkzd0JaMTI2L0M2SnJUTElF?=
 =?utf-8?B?eS9HZzRmZGN1Ylk1enVES0RTa05OMk9sekZ6Tk81MDVjak1XMzhSck5Oc2x2?=
 =?utf-8?B?QzhsUXZRNHViM3NEZFh2SGNPWEpxMFFmVjBwblNyZkowVjBZbnlOM1EvK29R?=
 =?utf-8?B?ZzBXVHlHNTFmNjRTUkhLUVlWY3g4ZkdZN2ZaZWJlVVZDMDdJanZ1MzFDcXJJ?=
 =?utf-8?B?QXVheTVDUExMckVTb0JkdjZLZkZmbDYwcE1mZjd6NytDWWorUWljSWRncmVn?=
 =?utf-8?B?U1lSd3I3TlJrMGJ6ZGl6RVpwd2hhZ282aTNGTUY4RTI5T0RQS1dWN1R6Y01B?=
 =?utf-8?B?ZVkyVXFRL2pMbGl0WVljeXJFWGRqeEZuajFmNWJHVjhTbUZwV2xjM0FqbGc0?=
 =?utf-8?B?R250MTZuSnE1VFlpVHV6dkRCbFVuZlZ3MFRXakNraWhLZmNHTWNhck9mTEhM?=
 =?utf-8?B?eHB4bTFsdXlkYmR0WU1qUUc1WVhqWVJDSW12WitSenNCU1VTSkNqM1k2STRP?=
 =?utf-8?B?Q2o5a2dJS1JYbEVSOGhCZWd0OVE1elRKS2lKZVdCVW1IblZNNFdsQnp2Q1ds?=
 =?utf-8?B?T1g0RGthbDVreitxUlRVeENiUjMxVitFUytQSWJUNjBsSXV0TTF2VHRuM2p4?=
 =?utf-8?B?LzBwKzcxeEhpZkplZ2M4cWxPMG13WkNQazJJcThZUEoySk5SdVFpazI3RG9z?=
 =?utf-8?B?OXhQWnRORTd3MUtZM3BxbXNsTUR2ak5qZGNESkxzOXI4ejJYOTZYWDRlU2lW?=
 =?utf-8?Q?GGR1NA4zFiOQFEt/YQeVZjdsZtHCC07TN2uLY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(52116005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blpGWlN5M3NXdEk0QitQWE5sNjMvMzdKVWNFeDRHaU5ieXM3WHZUYkY1S2R6?=
 =?utf-8?B?V1dmV2laZjdGbmQxdC9DTERrRG5pZzIyL0lwRXdLRWgvZjF0U2paemZTR0Vh?=
 =?utf-8?B?c1RKLzIvTFpiN1BaZG0rL2ZHMVpCVW4yZnNaNTcyMU5GVmYxTFQvSXpNMFE2?=
 =?utf-8?B?N29aUFZmWkNDSFYrcUo1ZHdlVkZRbXhNMTJVTmt2SjFYZkRMSzBCS2tOVDRj?=
 =?utf-8?B?R3BrMjZ2WFFJSmVLc1pkOFEwR2FROW93aDRIRjUrN0IzQVB6MG1Oc1QyV3pZ?=
 =?utf-8?B?cWtmWEhQMmlkelNJemNKQnNnNUEraHduVXFKYzNack1qcDVrVytWcHo0ZEov?=
 =?utf-8?B?R1BPbXF5Y1o4cGpTODAxS2xjUDJGZEdHTEVOQTBwQXFQaDNsTWc2cFpFNTVu?=
 =?utf-8?B?NWxaVHR6Yk5vdkFRem9YUnJ6OEd3SE9MY3FJRDJObVF4ZG5JVGg5RW90VUdP?=
 =?utf-8?B?R1NoREg3MmtaYmp1MEtIU1ZTNzNpZ0hnb1FLMFgvZ1diWkhQK3IxZWRQdURs?=
 =?utf-8?B?N1p0YTcvZTJGeHNjRDFnVVlZcEdJbm5zbmsxdm5JUzBDUjRiSUd1SXNqc3kx?=
 =?utf-8?B?TUdZTUFRdkJsT3hTUUphRmpEblo0K3pGeUpScjlQUHA0aXNFZ1RpazJMMVRr?=
 =?utf-8?B?c1MrYkdpQU8zWVNhVnM1ZUxJMUFQa21ORmEya3dBVzUvUjFzTTRCTC9uZnpm?=
 =?utf-8?B?RGdYT1hPVDErY0FmeHVBNnNIK09pU21lRHlzQW9LS2c3RXJ4ZnNVSm5EVGtF?=
 =?utf-8?B?OENyL3BGUm9OZkF5bWJEVkNnQ21WbkhkM3Q2SmU2TGNmY3pFV0pUdnMvWUpL?=
 =?utf-8?B?WFJQRjF3dml2NmJKOXVmT05JRWhTTUlDTGZzVEdkUTh1Y2x2cFJINHBlcVVE?=
 =?utf-8?B?LzZCeE5ZanIrNnBmYTc2RUkxRU5qKzBsaC9ML0JuL29PT0M5R2lnd2RPNDA4?=
 =?utf-8?B?NTRqVHkyV2tTaXR5Q2pBMlZjczYrek4rNVhaR05TOUh1UmFiT1lFUURLTHYw?=
 =?utf-8?B?V1pJeU9CTVVwYzFpZ04zMjR6Qjl6QWxBbGtuR0FNS0draFAvblNUUjhlLzdt?=
 =?utf-8?B?eUtHbk5xSE5oVm03Rml5eGxFMjNWaEFZWFNPREwvREpJc202bUxkblh2UkQ3?=
 =?utf-8?B?YTlKODYvVUpBOGc5REtxc3RzYUw4SnNRTzQyMXp3SS8ydGZYV3cxbkxSbmxJ?=
 =?utf-8?B?QWVMYUlnUEVZTTJucVBlbWV1VWU5M1U2Q1BRYldJQVBsczRqREdMd3dPWkhL?=
 =?utf-8?B?eDMrNVA3bHZZSTA2ekZPSUluOWhkTDRjVkV2eDF3R2tCbEVmOTV4U2l6bG43?=
 =?utf-8?B?ZDE5WU1WQktweWZuZEppK1FNMWJRSlAwQ055QUtjdUYvMlFaL2Q4eTA4MTA2?=
 =?utf-8?B?Q2xyZ2ZBVjJQRUJRbTRnTWRjRW0xc3VjWlM5S0N6VWRQT0s0Nis4OHBSKytV?=
 =?utf-8?B?OUJiQjdUek10cXdQRzk5aEhtZFpMQ0tld21ObzlXazEyRXNSM0p6cWVLNWJO?=
 =?utf-8?B?MXVIeHZ1cWl1bWxnRFpGRGNjNGlmRWdZMG53YlJCWWtsZHo5RG94NkRDY0Rx?=
 =?utf-8?B?NFZjSkNSZk9DS01ZZUwxbHhXNWdtbDVleDllTlRaWnI5V3htUWsxOXF1Q3Mx?=
 =?utf-8?B?WHgwTlBzRExCT0pPQVN0MU13ZUx3czg2bzllRE80L1RhTHRkM2gzR0FJaXZO?=
 =?utf-8?B?Z1I3ZFZrVVhQUEdlOE9vd1BlZndmRDVsRCtRS3hXM0hoeExPNkxyaUJNRkE5?=
 =?utf-8?B?SzU0dElnUGlVdHphQjFkb3I5SHg3RE56aTFSS1FzdzJnZHlwWjJBU2src3Z4?=
 =?utf-8?B?bDlmaDhsdkNNNHhDc0xkY2dOblpZOVZ6bEROOHdZVngrR3FkY0QwVEdlb0FE?=
 =?utf-8?B?ZWtxaEt5Z2JUbFgwbFhyM3VqQVFLSm9SZHJZWDNBZE1GY1BHUXpDK0VWTklU?=
 =?utf-8?B?TVQrNm9icFd0MkU4Q2NrNmI0OGxXdTBFdHNweHFPeDBwRGFLWjNqVThWUTl6?=
 =?utf-8?B?Ykt3bnJlOHVIa2NJZjJ2elFNZHlEbjNpOEN1b21ZbEEzOGZBRm4ra0s1dzRo?=
 =?utf-8?B?L2NlMmF1YkxVWUdyeml0bm5NTlFmeUR2QUFEdFZadThSVXdEUjdBNVBIcFZy?=
 =?utf-8?Q?glVhtxc3OBMFnTORPkHyuW9Db?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b66dfa-8c9a-46cf-5f3c-08dc864377f9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 16:12:31.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /L1tenLMGjnGtRlyogkI7rZ2pbMsA5DpGSubu0MwPymAZMhZxzYa34gDylYgYdr8OFvWRCB83IkM1FikHaMUnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815

skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
data transfer failure. This warning leads to hanging IO.

nvme-tcp using sendpage_ok() to check the first page of an iterator in
order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
contiguous pages.

When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
it requires all pages in the iterator to be sendable.
skb_splice_from_iter() checks each page with sendpage_ok().

nvme_tcp_try_send_data() might allow MSG_SPLICE_PAGES when the first
page is sendable, but the next one are not. skb_splice_from_iter() will
attempt to send all the pages in the iterator. When reaching an
unsendable page the IO will hang.

The patch introduces a helper sendpages_ok(), it returns true if all the
continuous pages are sendable.

Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
this helper to check whether the page list is OK. If the helper does not
return true, the driver should remove MSG_SPLICE_PAGES flag.

The root cause of the bug is a bug in md-bitmap, it sends a pages that
wasn't allocated for the bitmap. This cause the IO to be a mixture of
slab and non slab pages.
As Christoph Hellwig said in the v2, the issue can occur in similar
cases due to IO merges.


The bug is reproducible, in order to reproduce we need nvme-over-tcp
controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
with bitmap over those devices reproduces the bug.

In order to simulate large optimal IO size you can use dm-stripe with a
single device.
Script to reproduce the issue on top of brd devices using dm-stripe is
attached below (will be added as blktest).


I have added 3 prints to test my theory. One in nvme_tcp_try_send_data()
and two others in skb_splice_from_iter() the first before sendpage_ok()
and the second on !sendpage_ok(), after the warning.
...
nvme_tcp: sendpage_ok, page: 0x654eccd7 (pfn: 120755), len: 262144, offset: 0
skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1
...


stack trace:
...
WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x141/0x450
Workqueue: nvme_tcp_wq nvme_tcp_io_work
Call Trace:
 ? show_regs+0x6a/0x80
 ? skb_splice_from_iter+0x141/0x450
 ? __warn+0x8d/0x130
 ? skb_splice_from_iter+0x141/0x450
 ? report_bug+0x18c/0x1a0
 ? handle_bug+0x40/0x70
 ? exc_invalid_op+0x19/0x70
 ? asm_exc_invalid_op+0x1b/0x20
 ? skb_splice_from_iter+0x141/0x450
 tcp_sendmsg_locked+0x39e/0xee0
 ? _prb_read_valid+0x216/0x290
 tcp_sendmsg+0x2d/0x50
 inet_sendmsg+0x43/0x80
 sock_sendmsg+0x102/0x130
 ? vprintk_default+0x1d/0x30
 ? vprintk+0x3c/0x70
 ? _printk+0x58/0x80
 nvme_tcp_try_send_data+0x17d/0x530
 nvme_tcp_try_send+0x1b7/0x300
 nvme_tcp_io_work+0x3c/0xc0
 process_one_work+0x22e/0x420
 worker_thread+0x50/0x3f0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xd6/0x100
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3c/0x60
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
...

---
Changelog:
v3, removed the ROUND_DIV_UP as sagi suggested. add reviewed tags from
    Christoph Hellwig, Hannes Reinecke and Christoph Böhmwalder.
    Add explanation to the root cause issue in the cover letter.
v2, fix typo in patch subject

Ofir Gal (4):
  net: introduce helper sendpages_ok()
  nvme-tcp: use sendpages_ok() instead of sendpage_ok()
  drbd: use sendpages_ok() instead of sendpage_ok()
  libceph: use sendpages_ok() instead of sendpage_ok()

 drivers/block/drbd/drbd_main.c |  2 +-
 drivers/nvme/host/tcp.c        |  2 +-
 include/linux/net.h            | 22 ++++++++++++++++++++++
 net/ceph/messenger_v1.c        |  2 +-
 net/ceph/messenger_v2.c        |  2 +-
 5 files changed, 26 insertions(+), 4 deletions(-)

 reproduce.sh | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100755 reproduce.sh

diff --git a/reproduce.sh b/reproduce.sh
new file mode 100755
index 000000000..8ae226b18
--- /dev/null
+++ b/reproduce.sh
@@ -0,0 +1,114 @@
+#!/usr/bin/env sh
+# SPDX-License-Identifier: MIT
+
+set -e
+
+load_modules() {
+    modprobe nvme
+    modprobe nvme-tcp
+    modprobe nvmet
+    modprobe nvmet-tcp
+}
+
+setup_ns() {
+    local dev=$1
+    local num=$2
+    local port=$3
+    ls $dev > /dev/null
+
+    mkdir -p /sys/kernel/config/nvmet/subsystems/$num
+    cd /sys/kernel/config/nvmet/subsystems/$num
+    echo 1 > attr_allow_any_host
+
+    mkdir -p namespaces/$num
+    cd namespaces/$num/
+    echo $dev > device_path
+    echo 1 > enable
+
+    ln -s /sys/kernel/config/nvmet/subsystems/$num \
+        /sys/kernel/config/nvmet/ports/$port/subsystems/
+}
+
+setup_port() {
+    local num=$1
+
+    mkdir -p /sys/kernel/config/nvmet/ports/$num
+    cd /sys/kernel/config/nvmet/ports/$num
+    echo "127.0.0.1" > addr_traddr
+    echo tcp > addr_trtype
+    echo 8009 > addr_trsvcid
+    echo ipv4 > addr_adrfam
+}
+
+setup_big_opt_io() {
+    local dev=$1
+    local name=$2
+
+    # Change optimal IO size by creating dm stripe
+    dmsetup create $name --table \
+        "0 `blockdev --getsz $dev` striped 1 512 $dev 0"
+}
+
+setup_targets() {
+    # Setup ram devices instead of using real nvme devices
+    modprobe brd rd_size=1048576 rd_nr=2 # 1GiB
+
+    setup_big_opt_io /dev/ram0 ram0_big_opt_io
+    setup_big_opt_io /dev/ram1 ram1_big_opt_io
+
+    setup_port 1
+    setup_ns /dev/mapper/ram0_big_opt_io 1 1
+    setup_ns /dev/mapper/ram1_big_opt_io 2 1
+}
+
+setup_initiators() {
+    nvme connect -t tcp -n 1 -a 127.0.0.1 -s 8009
+    nvme connect -t tcp -n 2 -a 127.0.0.1 -s 8009
+}
+
+reproduce_warn() {
+    local devs=$@
+
+    # Hangs here
+    mdadm --create /dev/md/test_md --level=1 --bitmap=internal \
+        --bitmap-chunk=1024K --assume-clean --run --raid-devices=2 $devs
+}
+
+echo "###################################
+
+The script creates 2 nvme initiators in order to reproduce the bug.
+The script doesn't know which controllers it created, choose the new nvme
+controllers when asked.
+
+###################################
+
+Press enter to continue.
+"
+
+read tmp
+
+echo "# Creating 2 nvme controllers for the reproduction. current nvme devices:"
+lsblk -s | grep nvme || true
+echo "---------------------------------
+"
+
+load_modules
+setup_targets
+setup_initiators
+
+sleep 0.1 # Wait for the new nvme ctrls to show up
+
+echo "# Created 2 nvme devices. nvme devices list:"
+
+lsblk -s | grep nvme
+echo "---------------------------------
+"
+
+echo "# Insert the new nvme devices as separated lines. both should be with size of 1G"
+read dev1
+read dev2
+
+ls /dev/$dev1 > /dev/null
+ls /dev/$dev2 > /dev/null
+
+reproduce_warn /dev/$dev1 /dev/$dev2
-- 
2.45.1


