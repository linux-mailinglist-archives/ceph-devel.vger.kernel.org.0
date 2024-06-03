Return-Path: <ceph-devel+bounces-1255-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6573B8D825F
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 14:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88F9A1C23BFD
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 12:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7570012C475;
	Mon,  3 Jun 2024 12:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="Km2WvIqR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2124.outbound.protection.outlook.com [40.107.20.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A6764F;
	Mon,  3 Jun 2024 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418146; cv=fail; b=d+pmQNDY0JMhCS9ZBaeoo9xIwhmaE9FtfAZiqt8w/li87NoGopPKO4DV7NvTfVFJAdFq02hMU2RSAik0lOLIt2HkSxpnAw6k4cvkVVwt+0IR85r6OmHahsg/8zq7qaeRG7mP6l4Zib/AGxWi9QSJhhy4EytMwzMxC0TugSLsnKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418146; c=relaxed/simple;
	bh=BwmVlGPKUXTi+hEwysK2ukV84u9gj1Nxz1Tn61xNwHU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AbIlhA9dT5gxImwK8o+rKWUGVwOe/4qlaRe2rZGDzuwS6fWbLp7tIYmHxonGpMaGkP7LZDmnWeni2zL0dUnm0lRKlN7huNc54tEIDy2MeUBABsMcA9ZDg/c4omAqnqHlH3Hxals/zU1QITV+3szCqT3Is4S/mvfxvqZ4ll8i5jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=Km2WvIqR; arc=fail smtp.client-ip=40.107.20.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6YyiDJUB6tiHMY8mSA159DrS+wQlzGW5HDgfJz0DYcc5760zmlWhaTIWVmQZT49UWBJ0YhI6twAtOe7twO93bTdd85TzpKMObPNzl2YH5F1Db2sPENJUFL+bJdaMZtweGzJctVmc+cqX2SotlVw3FqRF/Kcu6qKI8VQpxWuWQmFdusYfLGB6QLz+TAGAfC9ZR0F4M3R3nTi3ciI7BbnE/bKusIVPkJosxQidr7o7qEfQkmlcFxDChX8YSYbI1qIkg3PSyxgsGvlOrefY/zlC8S/5c2uZJrURwg/ueOtyCElEL1zGeid52mCrCAndWBvccqfH9HZuWVbFmXcsU/6Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwmVlGPKUXTi+hEwysK2ukV84u9gj1Nxz1Tn61xNwHU=;
 b=CA2Jy544ZAD4mz9SrMwLXJHigQKJevZjVhtJxEhr3kzoYKmcZiSFONPZa8z4xB3huvGa6LBtwCvfHCgQvaefKPzazXOGDRB7q9Xac8iZ3ueekULabP5p+QdO3t5QRA408+I+EiZH4o5hfM+s+rMYtACjqdF+m9ULtzslQAGG+T+pTbxmFDnnHoRn1YvAds5yxmcpEIMDJCXq/X3iN4jxv8dTz0WIj2/gD1Rije2ptgSX4NLQNtvHuT83MZCAPMry5Xv5G/tVsSlktyi9m11hRkuXrM52tfDlDB+oxgfg9mwei6B6yIcG7LndfPlF2tS9aTramw9TOIDBlZ80u/aBfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwmVlGPKUXTi+hEwysK2ukV84u9gj1Nxz1Tn61xNwHU=;
 b=Km2WvIqR9+K6PWp7KhXcwoNQBUDTvrayI8ZPGDPtC5+mHodPWKdAjmUa3w/kra4Jeax7RqSHO1pffRKuiUNPpJNr8LhCc4/8GUKbQ/jqa+UGNS9ms8EL6JzIlECYFgVm5TrzvbRvxY9qM1kDWpPWteJUUpH98bbLPQ0UYeS/GKAPnW27lAL2qB/MIhhCQl7+3gw0EwNThzkN9ynjgQd/yTk6C5wZk91GkiaKvaHa3TX2KhzEi2xq40eqwu48ca0tVy7SV3yT26KnM6d1kH7clwZ8j72KxWdzKmf1yf9Pw7eK57CVkU0r3vl82SJ/lz+bED6u73jnQBkE3MlELjqrmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by PAWPR04MB9862.eurprd04.prod.outlook.com (2603:10a6:102:391::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Mon, 3 Jun
 2024 12:35:41 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 12:35:39 +0000
Message-ID: <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
Date: Mon, 3 Jun 2024 15:35:34 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
To: Sagi Grimberg <sagi@grimberg.me>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, philipp.reisner@linbit.com,
 lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
 idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240530142417.146696-2-ofir.gal@volumez.com>
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0010.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::14) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|PAWPR04MB9862:EE_
X-MS-Office365-Filtering-Correlation-Id: 287b9872-a436-41b9-cf93-08dc83c9acbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWVSQmRwb1FCaiszRGY1ZldMU00wOVlUcnpUVi9GRzI1eUFRTjZWQU9yU3l5?=
 =?utf-8?B?c2MwYXVuU3FLSkNXdy9Lc0NkREdzdnlkMVRvQlBSR2g5ZWZDOVZVOFRuZTZM?=
 =?utf-8?B?ek5uVjU3NGJZdmxOa29NZkVaUW5PV0luSUwwUS9DZm1HcngvREJlTkFTK1lw?=
 =?utf-8?B?ZVlTR1ZJVlczWDQ5bXN1bkRCMTVtWWtIc3VqV29Cd3dtbmJYS1VtUlVvK1BD?=
 =?utf-8?B?NUtCSTlxL1lxdGpIR3B0OURwM1ZqalhqMGYzM3ZTdk9hVlNoTGhJaXhLNzli?=
 =?utf-8?B?R0Y1TXZsdUpXMmd0SUsvemNDaUZVMHUrUzVHUHdldS9WOFR3K2tNcFVGTGtm?=
 =?utf-8?B?cUVDR1pseVlCajJXVEZ3Umk3dnE1RTlRZUI5R1RzQ290TTlaYXJrbzNlVlpy?=
 =?utf-8?B?aEhDZjVldU9RVlZhRks4dU4ra2tvSXloazVCVGtiSnVTY2JqZ1BFNjZyVGlN?=
 =?utf-8?B?OUVIL3hkbXhkMjkwODV2aHlweXdITmZpNC9EYkRGenJWUzNzTVRjeGRMRmcx?=
 =?utf-8?B?MkVEaUQ4WUFubldzeTJUS1IyTzZEZzlvZllOUGpoY0JyVkFsQ3BPYzRLZE9H?=
 =?utf-8?B?K1ZRcmh1QjNwOGFMNlhUZlJJOThmM2pKSVVwdTlwNGFvZ3FmU0c5ejdIL0pv?=
 =?utf-8?B?azRHRDdpQVhjbXVCWGwrU2NTZHgyMzhXcXVNdmhuVU43cGk0eXIrSUtISlgv?=
 =?utf-8?B?MFF1OS9kTjhpQUd2b0NWV05keGIvWDJRcWZJMXVQa2dUUzAxaWR2WlRmVU5z?=
 =?utf-8?B?ZHozTGI3YUZMNWdVd1huOGRCRTA3ZFdnSGRvSFZPQkZ3ZmpBL0l1ZmFKQTVv?=
 =?utf-8?B?cS8yT3FRWXJGMEcxVWVncFlWcHJiZVpBNkRWR1RBTmdFTHZJaWpOMDdxZytT?=
 =?utf-8?B?d3NzU1EvMUFxbERIVC9iVTZzTDVSZzBrQjRSREdVVUlwNmhad1VNQzZpTEZa?=
 =?utf-8?B?MU1VbVFCdUpJUWs1NEwwU3hTNmtJM202MEJVR054ZW91ZlVWTFZnUHVuVFls?=
 =?utf-8?B?bnR5VGdwdjIyNkt1SWtFSU9heEo5SWx6OGRBTCt2ais4RUs0a1dRWFRodVFY?=
 =?utf-8?B?STdJRXpFWGRQazhTaFVOV0RQNTZUS2QwMks3bTZDSDhUVUFyVGZpZS9iYWpT?=
 =?utf-8?B?c1daRjR2U3ZWSFU3WUdEbGFTK2tPZ25rZmRiSm1ZOGVIMHQzZHBFR1FSZHNU?=
 =?utf-8?B?RWtmRVpveDExdVhzL2JPK25ZaVlDc1kwNElWQTkrZkJ3Qk5rMFR0d29xSnAx?=
 =?utf-8?B?V2syUWYzQ3prTW5qN29VTDJjSzh4VEthcE9EWGZRRmdUMmgyR3pSbGdjeUxi?=
 =?utf-8?B?N1lINHBzeFFvZnplazFjdGRNSjN0N1hPNGt3aFAyRjJzS2RpK1JnendDc21T?=
 =?utf-8?B?Z0s5M0RHR3BzU0NWbkFTL2o4L1JWRWxDQUlPTktpa1NucUtKSnV3dURTNTZn?=
 =?utf-8?B?RDJjYzc1ZXZPVHhhb0FwSWJRV29JaXBNNkllR01ob0JIR3lxUUZoRWRYTmkw?=
 =?utf-8?B?V3BFemlUeURlU2h4WERRVWNTdEF3blB2c0MyWDlyN05qUEptNEw4MURQRUdr?=
 =?utf-8?B?bnphYktVaHBnYnV2bkpCYkQwTnVRcUdNQWFETXFSanRaUmRFT3hhSU50MmNC?=
 =?utf-8?B?czd2N0d0bXMrT045eTcycHdwdExKOWFCZ0FneDkzTjRRVmRkUW9yWUFRWmt5?=
 =?utf-8?B?Sk85VWRGbDhyV1JGSit5NWt1aXlncUd3TnBtL01EZVFUM0RzbytYd0RRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjhIVmtMQmt6aFMyY1NrM05UT01jSmJBWDZKTTgzVFdyUE5MMVNYVjFibXd1?=
 =?utf-8?B?R0hmckNVVGdjaW1EMzdLeXVIZjZjelBaQkZTaFVrMDFRVlo4Ui9SS1RwMFFV?=
 =?utf-8?B?MlFKMkNlSTJYelVVdXExOGdUNWpwSExRQ1JmemtJZ1Y4V2p1cFFiTWwvbkNk?=
 =?utf-8?B?Uit0dkVNTXhTVmt6R1B0SGp1cWVLYVZOSGFqNENtVFZYRzdjWTNyVzJqdTZQ?=
 =?utf-8?B?cHQrVktHeTZRSDA4c0haM1hxbWxOUFNkeGhsWXF5OXJZUEhUVEVoeHFCOVND?=
 =?utf-8?B?eGF2QU8yU0hwTm9ZRHZTL25OeFhKYTZZa1N2SUUzYnNQazRRNkpBQTdWOHMy?=
 =?utf-8?B?dnNWNXoxRGFLb0h6alNFZjYvQ0lXTlB3TUtFbkN2ajhxbUZ1ZmVJbGdTNGNW?=
 =?utf-8?B?N2Fya3VpTktSeFhVRU1vN3o1elVOOHRSbTRLWjFNUFRhOG9GcXpjekV6dVlv?=
 =?utf-8?B?NVN2aWpZQkNreDdyek81V3hiZnNDMUtZSTViY3BaRlBnRC8rN0ZBNno1djgv?=
 =?utf-8?B?aldHR1RabEdyY0pibWpHN0h1QlVtbW5FVGU3Sjh1VTRZeDVJaHVweFg5a3VY?=
 =?utf-8?B?R2QveFRyZ3YrbW5TZHl4TU1yS016WFhyYnBxK0E1QVlVWTJnalIwVWtQWG1i?=
 =?utf-8?B?T3h4djNUVWUrbTg4d1IwZnFRaENyZm1sS2JzanppOFhhVEp2eEtGN2U1cFdL?=
 =?utf-8?B?a3M4ZktkNVcyWEQ1QzVSRndwZElaZno4MEZLN2IzUlVUUDV0UGRUQ09IbVkr?=
 =?utf-8?B?WS9zWDk1dzloWExYMEpnVlFnaS9Cd1ZzOHhEeDJxdG5nSFY4akFQT0tjV2d1?=
 =?utf-8?B?M3oxWlZyaEcvVEpRS2lCS1F3emp0UTJXRmZpdkpZWTU0V2FuRTFnck40TWMv?=
 =?utf-8?B?czlTK2QzUEZkQXVxWmo0bGE2bWEyZDhCcGtmSC9wMFc1NlR1WHluMVIzZXpk?=
 =?utf-8?B?RDZIejFCV2xyMjdraGR0a3hZRUF6WHpWY0NZOWZoQkhCZndDMzNnRmRnK0lu?=
 =?utf-8?B?WXRCSm1wbGM2d0NTQmRVT2EyYmFyeUx0bVdlS0hQNnZ3b3pWU1VMWEo1WUd2?=
 =?utf-8?B?WmNQa1BFSm1EYXpVd21yalRLNHhZMm5LdE5oRXdsZzlRU0hEZzNERGp0QU9t?=
 =?utf-8?B?Z1U0MnNYanpqdFdDYUp4YVNQZHNBUDZBVVQ5T2krUTNteWRybXhSajJYSFlQ?=
 =?utf-8?B?ekgrMUE3UENnVzRScHJCbjlZQS9TTExHQWpIZklYSXJOVUdmNUpkNmtBZGVu?=
 =?utf-8?B?TzFYQ3pHK2lHTDRWd0FsUzN1R1hNK1plOERvNHhoRXZHZmdlRVUzaDBCemJX?=
 =?utf-8?B?OFQ5RjZlZFZ1ZTl0bld2Vm01MEdtRHpuM0NSdDBYTjAvQjdUaWpBMTROa1BU?=
 =?utf-8?B?NUxwc3N1VCsvZ0pCTlR3R1VhWmQ5MUEwOWkyRy9XOFVBOVJ0L3R3TjN2L21P?=
 =?utf-8?B?ZEFKemxiNjFMQXdKUHpTUnlmMmdRdHF2MnRBc0pxcndYR2pKcytxRWNJaUdR?=
 =?utf-8?B?Y3RBZi9rZ1RBbFpCTFpFR2s0dnVrWDc2MThpNzhtVk5Hd2doaUVmWjRWbnE5?=
 =?utf-8?B?eGgvMTNmM1R1VE0xZGdsT0Y1TGhxVEVxNDczVzk0ODBWQk9iOEk5VHFBV0Vy?=
 =?utf-8?B?NUMyK2lhR1BsZjVwRGwzbVR1RG81VGNTL3pQYUZQdkwxbzlPaDZEejV6NWtJ?=
 =?utf-8?B?N2M2eDFSeHowUUV0Rm4wR3ZIM0w5NVZWc2pIWitIVlRGeWRSNndRWUFhSjBX?=
 =?utf-8?B?TXFwMkFkRGpjMW5HVWFSRE5lQ0hLN3lady9WTnRBOHAwNWVVQjg3YmpIbVkz?=
 =?utf-8?B?U3F5bjVLdTVNc0RwdlduTXovUU1FdHIwSjB5eElQc2wrUS90ajhEczFFMXNK?=
 =?utf-8?B?WHJVWVphUll4MFZYQUQwOXZNMFJ0QXh1N1pDZ2Q0WithZnY0Tkw4R1VudlJu?=
 =?utf-8?B?SkE2RzFEcG1TVmxRbS8zYmlyWkw3RktkSkxMalV5QXIwSmZTWkY5dXFxRzVr?=
 =?utf-8?B?QU9LK29tSG5zdWV6OWNVMWtndUlueUNnRzY4OXljcThjLzlaV0JFbTE3Sm1I?=
 =?utf-8?B?R0ZoT0c1aEx6cnNGMEdSWnRzaUlYN0E0VXU3TnptS3o3QzRzYkR6TnB6M3B1?=
 =?utf-8?Q?ezwyNTVOj/xrx2xyg55yH2Pcg?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 287b9872-a436-41b9-cf93-08dc83c9acbe
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 12:35:39.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIr35Z0Fp84RA0cSFT2tg9BfbJy3oSELJOS2aOSDBKyOm4f0Kr+CsA/FPDjRa6QhzIAGpYDc1vbGVJU/4tuw7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9862



On 31/05/2024 11:51, Sagi Grimberg wrote:
>
>
> On 30/05/2024 17:24, Ofir Gal wrote:
>> Network drivers are using sendpage_ok() to check the first page of an
>> iterator in order to disable MSG_SPLICE_PAGES. The iterator can
>> represent list of contiguous pages.
>>
>> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
>> it requires all pages in the iterator to be sendable. Therefore it needs
>> to check that each page is sendable.
>>
>> The patch introduces a helper sendpages_ok(), it returns true if all the
>> contiguous pages are sendable.
>>
>> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
>> this helper to check whether the page list is OK. If the helper does not
>> return true, the driver should remove MSG_SPLICE_PAGES flag.
>>
>> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
>> ---
>>   include/linux/net.h | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/include/linux/net.h b/include/linux/net.h
>> index 688320b79fcc..b33bdc3e2031 100644
>> --- a/include/linux/net.h
>> +++ b/include/linux/net.h
>> @@ -322,6 +322,26 @@ static inline bool sendpage_ok(struct page *page)
>>       return !PageSlab(page) && page_count(page) >= 1;
>>   }
>>   +/*
>> + * Check sendpage_ok on contiguous pages.
>> + */
>> +static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
>> +{
>> +    unsigned int pagecount;
>> +    size_t page_offset;
>> +    int k;
>> +
>> +    page = page + offset / PAGE_SIZE;
>> +    page_offset = offset % PAGE_SIZE;
>
> lets not modify the input page variable.
>
> p = page + offset >> PAGE_SHIFT;
> poffset = offset & PAGE_MASK;
Ok, will be applied in the next patch set.

>> +    pagecount = DIV_ROUND_UP(len + page_offset, PAGE_SIZE);
>> +
>> +    for (k = 0; k < pagecount; k++)
>> +        if (!sendpage_ok(page + k))
>> +            return false;
>
> perhaps instead of doing a costly DIV_ROUND_UP for every network send we can do:
>
>         count = 0;
>         while (count < len) {
>                 if (!sendpage_ok(p))
>                         return false;
>                 page++;
>                 count += PAGE_SIZE;
>         }
>
> And we can lose page_offset.
>
> It can be done in a number of ways, but we should be able to do it
> without the DIV_ROUND_UP...
Ok, will be applied in the next patch set.

> I still don't understand how a page in the middle of a contiguous range ends
> up coming from the slab while others don't.
I haven't investigate the origin of the IO
yet. I suspect the first 2 pages are the superblocks of the raid
(mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the bitmap.

> Ofir, can you please check which condition in sendpage_ok actually fails?
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



