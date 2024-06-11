Return-Path: <ceph-devel+bounces-1324-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E079032D4
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 08:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D8691C23E31
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 06:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5283C172BAD;
	Tue, 11 Jun 2024 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="ImVExr43"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2113.outbound.protection.outlook.com [40.107.247.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6961B17277F;
	Tue, 11 Jun 2024 06:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087801; cv=fail; b=uJ5BpeKTKDxTRSWxhvtx4RpnE4GjbyMaFZl0CKfj1NuO7/oLDPreV3NFEn2TroSeWaZ3NmZ0/xIIgVTvi3SDXjgB5Vd4vGbqOLW2aHvOHcVdHYtgNH35gYKJJXLQ7hiFTdnSIYXhbbFQsZhEurP7hHD6fUHus2X06jWJyMA6LEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087801; c=relaxed/simple;
	bh=hrXyDaUZD5O+KIuY6QI0GBnrWAENZW6x0xDSGwfPjoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RhVoz7FDQE76tc1rN6e1bgarJT/z412Hr9niHlQgq6AENlmyqcWOnd3jLwvRM7MNCCfBuxCpaE8bmnFWQ8hYcR04yx4VeXwHXQMp+GaLT6bpnSkKSHz+d2F6+KFopcBfD45RIcEYsShD+hwJ/t4POnTODzhJDNB3o1x38zDVcQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=ImVExr43; arc=fail smtp.client-ip=40.107.247.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcNM7otcTBlKBxAdidLgA1vqNV6pDlPZE0NtpZNci+I0GjSb47b2ugbdbPMOCHX7W1jUMB7KJvL8pGZti4oRGlgWvlTdGevABkr2FDnueA0uPM5caJPJ0EIDntgH/fbzZsAVptr/HIPqzB2xEj0oRd8Ada6ww3OwgPJBlTbegEws9OXvtP3qQdXsHAwkeG1QjHpFw9j+LrXfkZPVnFJ2iXp+uSrvgGo7qd1ZYaybrSaKZ6s2ZIOBnkALvU76wAXltzjrr8K/2cR3LMksRjY4kzNkIL5ekdNlb3pSogImC+9JtRINsjtZJu4uTTgdr2rMLT1H5atgygt39nNyjMWgfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=427ibjUET2vgiYD30TKQMjrgcTz1GT6EqH2o5uxTbbg=;
 b=VVutqMSI2D6d+ExjzqK5j187yA7ODtsw1FunRF8U7467Snjf1CH3GaaXyvb0mf5szgoDZj6t9TUBzEH+uqGjX/sfNwjsnDsb4kZOC11gYmwqWc+j5hwzrfGoTJKxnUD/gKWwO8DPr/yZolx+w2efsmHGVqvs4Pq5rptt49fR/uOQa3kJEZXe2J8taL4DT2I0NO3d/Te++7UOuvZdHlbldS0ZoYjvoNHIvrbBs4Ep7sWFvJFqaeboY/7WLFSgiXjLfjI7Ntg0Hi0f5H06CZvnQxH+1P7f35prZ2dRNG24WJcK7QFhNGMU3lNEsYfGDwD9fXEf77X5INUcZIURv/o8Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=427ibjUET2vgiYD30TKQMjrgcTz1GT6EqH2o5uxTbbg=;
 b=ImVExr430azNG615NNqknS59S5uJwPIl1q3c49TGFZ2vknbpdXt8S1lJoylZMr7viMCTy46M14N5isbSzbe5B5mRTArwwOr0aflxEdbLDeVOwXNIakApgR5uPh8QCbjkHFghI2esSRnaG8FbARlJnEDlcnADGTUjyFTpx1ISKDb4Mz/etPI6D+DPRcbYHHnexXsQJch7BxtEL6A8QSDsRzIzl5I7Ai1Hvg+bjA72VLNSxDf8wwut5xhBdtH4xp2I3dDkMzpDRey01C760U4APNgCsWDnmSIy3vfn+pDI8Yd/Gt/9bWEBhi9WFaYdVuJnx2bxRkwxtRnyZgYi+T+KDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com (2603:10a6:20b:8::21)
 by VI1PR04MB9977.eurprd04.prod.outlook.com (2603:10a6:800:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 06:36:32 +0000
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371]) by AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371%6]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 06:36:32 +0000
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
Subject: [PATCH v4 3/4] drbd: use sendpages_ok() instead of sendpage_ok()
Date: Tue, 11 Jun 2024 09:36:16 +0300
Message-ID: <20240611063618.106485-4-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240611063618.106485-1-ofir.gal@volumez.com>
References: <20240611063618.106485-1-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To AM6PR04MB5110.eurprd04.prod.outlook.com
 (2603:10a6:20b:8::21)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR04MB5110:EE_|VI1PR04MB9977:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d04b5f-1bdc-45ed-ee84-08dc89e0d52a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|52116005|1800799015|7416005|376005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjVZUWhJUks3VVJJTFBicXZDcGtrU1hoNFk0dElYQk9EaEd4SkJqRW9qRTJT?=
 =?utf-8?B?Q25BN29vbWpVWHYraDc1cHROc1NRYTdxSVBwY3Z0MDFBUEhRa1lNWTRNT21C?=
 =?utf-8?B?MTd6ajFCSXAyV1hFVHZ5KytvZCs4TXZoa1hFNHVwa2NZUWw0eG9Md1REeEZB?=
 =?utf-8?B?YUJoajEyeThHZFVEenJKQXFTdlJ4TnlVbmtITndLb21Jc09yMVRVaEFPVzZn?=
 =?utf-8?B?K0lpMVB5SDhWUzh2VnpjZnlidDNndExpaGE5WDRYdlFRTklSSDJnZlVRWmFY?=
 =?utf-8?B?Y2dISzQwbExoOTB2cFJOemFncE42UGJVUTluVE45Q20xWGwyQnNiY2J0emwy?=
 =?utf-8?B?akZVMWVBc05hVUwxYXJaOElkYkpNN0x5a1dLM1pZaDM2TXc1dGJ1Nk5OcHVC?=
 =?utf-8?B?TXdHTHVTYjloVEI1akJ6NmppYVBDUzA0cngzWUNFUkZ3aG0rK1VKV0s1WU9a?=
 =?utf-8?B?czM1K1BOWXcvSCtnT1lZVXVBYnRnM04xSjAwaWdIRjJXUU02eVUrM0lQNE5j?=
 =?utf-8?B?ZWhXTi95ZDlKeTR5b2VwTDJiNlNmVkJTdkp2Ulo5ZFZJdUt1bDJzWDgyY0dq?=
 =?utf-8?B?OUpTUUpXQnhBTi9FVjh4Q0EyNkI3KysyU21aT1puc0dtc2NUTnlpbEhtK3Vm?=
 =?utf-8?B?eHIxY3BWejk5QS9SSGJ5blhHajBubTl3bFU1Z0p3ZVVtaVRkQlBGLzAzcEVB?=
 =?utf-8?B?OUluUjlVanJsb2RONmRVUEo2b3l3Qy9hUmhTNzRERGluczJ2OG5FM014WnBO?=
 =?utf-8?B?dkJjR1A3Nk1tam1sdVNpdzducmZlbHpDMzVTcmFKZWgySzA2WUlqakFReGR0?=
 =?utf-8?B?TDZUdVhOSzgxNVduNjc2RUtKS3pzMldRVFJ3R3ZTd0x0SjBNWGE5dXBzbDdX?=
 =?utf-8?B?Q09aVVhHY2JKN0NJQ2VXZ09pZlArblVDQ0J6U2xDaDR3K0RLWldHWU1CUitm?=
 =?utf-8?B?YzJkNmp4WXBhWEVLTUhad0EvTDRpUG5uOTcyY0ZmRXNTWVcvaFlUV2tzYk1Z?=
 =?utf-8?B?NExKZDBEMnd6cFZvNVlzajh5cmZHSzhRN0xTb3dIU3RuQ21Gd2l2dUloWjdj?=
 =?utf-8?B?ZUhaVWp0NStrWmorb2lPYjZteVJpVmpGejVQNkRsVG91eGt0MlN4RjBVU1JD?=
 =?utf-8?B?MHpmQXlnYURqZTg4UGRMV29lWjU0NHRtcFJCOHZub2x0VGd1d3dGTmpmb2RL?=
 =?utf-8?B?aUNlNXdxYkR0Q05NREJ5K2k0djlJa1lkc09vSnVlL0tMenRJUUlFdDBpZFJs?=
 =?utf-8?B?UVZlTCtIbEVSKzZORVNrQ3BmSk5wUW9ZaVh6TVI4QUwyRDFtZTAwOWZSYXlR?=
 =?utf-8?B?K3NUQlVZblRKWEpCcnorUG5ESXp0a1hhTWhVOExpc0Yvc0VSKzBmQzNZUnFv?=
 =?utf-8?B?UFVEY29tYjN3anF4WVZjVUdpdTFVV0hrKytSZXVQOE9lam11d2V4UElpZFQw?=
 =?utf-8?B?SHdaZnFxMUpQRkZYU2lzelVUOTdNWlVHbHM0NUhUM1ZFaUxNblhFOENCY1dI?=
 =?utf-8?B?NUgwTjZmbFV2OHBBcGZvQUZiZzlGNlVWUFFWd3l1dnNTb0xtc3o0UEJhRUFp?=
 =?utf-8?B?dFlxOUhTSzArQjBPdTE0UW9qRFFQdDNOQU1PaFg4V012ODdyVWwrbVBwWlJx?=
 =?utf-8?B?d29MYUFidXdyenhjU2VCU0RtSkdRME9wT2QvVE0wZFFzTEFNUnhjVDVzWUF0?=
 =?utf-8?B?S05EWnVYV3lSNFJlamhzS1dsamE2alZtcUVPU0pjM1cwQ2UrSEJkcVVqQlJJ?=
 =?utf-8?B?YWlxZmxDaXhpTVk3Qmh2TDc5c05sSzVpaGlmZkI1TGpQRHdUU1VCRWlYclJl?=
 =?utf-8?Q?x93UpjyE1xAYzQZa5oBjlXSNDP/mbwfIILzdg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5110.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(52116005)(1800799015)(7416005)(376005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ciszeENWWDZFV0pDdHl6c0s4ald1VEE0Z1ZzL0Z1TE1YWlB4eXhRK1p5VDhS?=
 =?utf-8?B?c3l5a2dweGFWN1BoK211MGRBYldPVWo4ai91cHQ1empYVnNxa2RGZEpMd3Y4?=
 =?utf-8?B?Wk5nRk5VdkNSTzBsVXhCMVFxc0JzSkQ5U2dVSlpVaUMrejY4dG9iaCtQZW4r?=
 =?utf-8?B?bzByN29RN1R2ZG95ejN1VkF4R1dFd3FYSEhqbE9NaGJXWUpIejhyTU5MdlQw?=
 =?utf-8?B?cHU4Tlg5ang5K2lNaG1SWFpDUS9KTXN4QytMWGdPTkE2dXRtdDZvVDNmOXN1?=
 =?utf-8?B?b0hsTlp1ZU90bFB4Vk1mZE5mSURvRVFPVjVOMUIrbmk0MjRNQ2RmNWV5WDZq?=
 =?utf-8?B?SXNCbk93SUFXSktiWks2blpKc2tXL1g1T2Y5S0NvNXJBMkx5cHp1V2ZWUVkw?=
 =?utf-8?B?WWtoV0dseWRUakFFOXh3cVZpOTN6NFp3cTJDZ1NMMnBQanI5TWJkYlFWcGhP?=
 =?utf-8?B?RHBBSTNQRjJOSEpuaDhYKzR6TFhodFhtZGgrRnJYSVk1OEphNnEvOEhYeWpo?=
 =?utf-8?B?RXVXWW1TUEtzcUNnQ3pETVpickNTMkdWWnloTEV2MFgvTU1NbEZtYWtyVTFK?=
 =?utf-8?B?dURYQWttalBucWptUHd5OUFRekVLc3pjb0hieFVWaTJNVk5mYjI4d2VlMGZM?=
 =?utf-8?B?azZmaTZTQVRIVlJOdWk5YmltSU1jZXlFSHFsQ05rdnVWZU90STh1Q1g1dkk0?=
 =?utf-8?B?a0JMT1hpUnY0ZUVHWCtQcnl4SmxRMXA5Z05jSTVZamRYM1A2RzJQSHVUZVNE?=
 =?utf-8?B?bitqN2t1a0tPY3lxVnFBSDR3TldTYVBBZ2hVaS9FOWpKUldPTm02VFEzc2NJ?=
 =?utf-8?B?cXV4UmVxQ3JyVGFRcGQwQzNnNmVtbnpYbjVVcVRuOHNkVEJsNE5JalVDeGlP?=
 =?utf-8?B?ZnBMWktXRUIvKzQ3cWFINkRTeG5oZTdxVzZyQ2taemFnOUsvUjJ6ZStuNlVt?=
 =?utf-8?B?UFlUdTNJempLbk8rUk5XMU1mR0RiT211WFlacElvMkpzWUFtNXI1RVBabWF2?=
 =?utf-8?B?K0dOdHpra08zamJtWkQrcnNGb00rbHprTlJmNUJJNEFJcHlndXJrSjErNytz?=
 =?utf-8?B?U0p5VGJvZUFXUEhWVXJwaytHRk1RVS9OM2EyVXBTMHNSN3NwSzljTTFRQ2U2?=
 =?utf-8?B?M2l2dUZpMlJQci81WG5HbExBaUdEbENqYkpMbEQwdnNRZ0FoWnVRbGUySy9w?=
 =?utf-8?B?RDZlK3FQc1RJRUlKdCtpWWZZRXoxUFFPKzNoUnBQNWVzY1E5ekFqaHo0TzBq?=
 =?utf-8?B?cXdHN0RKckk3NjNPbWpIL2RxUTNaZ3JWQTZ5VlM3V1pkVnJadm5QZVJYTHpK?=
 =?utf-8?B?YUVBWWV0azE1TGlDeWFURjhVdkRGVkFNN2EwbytJaTIyK3d5Vk9VV3FWTWU3?=
 =?utf-8?B?bFJOQWFlQkROZ3k2dFNueTNJQXUyWEZvM0ZGbnJKT3dpdURuamRkRHZIL0FR?=
 =?utf-8?B?eXpOQ2QwTXZ1Um9rYXd3N0VIK0IxemJmY1FzS2FHWWFmajBsU0xST093K0FF?=
 =?utf-8?B?U1B1U0pndU1VWitvZndEYVJqRjFpZjhMdXU2Z1J1cWJkcnpNMm9YSWNCTGlR?=
 =?utf-8?B?WkcrbzVJdEZtak4vUEhXV2ZQZjAvdldQdmxSdG5xMk1ES2NDeTcvRkovbUtS?=
 =?utf-8?B?U0RyL0hDaUVDWk0wWkd6SGxFK0hobnVjZWRXYkIzU3hBT1d5K2ZqZlB4cU42?=
 =?utf-8?B?dmkrTUJiMi81aVZsTm9zMGloOU9UMThSaDNrQ1ZkR2w2bkxnRUF3WTdYQk5D?=
 =?utf-8?B?ZllkWnZBN0doMCtRK1dYYk9TK3hhZk5raDBiOU0yVXdpeHdHUkJpYXkyditl?=
 =?utf-8?B?ajZSeHR4Y0lHbkROUkNvS2lvalRwT1VuMUJFeTZOb3l1VGtzd3BnbnlBVmx1?=
 =?utf-8?B?Nm1PQkRTTWplc0JHbThBc3Jid2lubitBaG1xaTV1dHF5RjFGdWlOL3dVNHVS?=
 =?utf-8?B?U2UwZXc0RVdTZWRIWE5sQ2xySmh1Wm9zakxOQWpoamUzNmJkdHhJbEt6NFlV?=
 =?utf-8?B?NDdMbGJhZ2NHYjg0STFENVpja2lETmt4b3BZQ1huT2RVOUxLQldTOCtOcWsz?=
 =?utf-8?B?TTYyTEQzNlZGL0EzRzdmcEIxTzUwenlGNzk5azBXZXZhTCtKTlphVGp1QlRs?=
 =?utf-8?Q?ztwsoq236QoqjboIwveRAnyNn?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d04b5f-1bdc-45ed-ee84-08dc89e0d52a
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5110.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 06:36:32.3194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YpgsXZuFOPpQh/WzxeeAknxlL1D9RUqP672z+Akxu6Y0ZmrC7FmC29HKf+Per/OyEFmTyJyD/ymxAAwYDmMig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9977

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


