Return-Path: <ceph-devel+bounces-1537-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DB49349F4
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 10:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7470E283242
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 08:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8997D3E3;
	Thu, 18 Jul 2024 08:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="GYHR4OC6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11022084.outbound.protection.outlook.com [52.101.66.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0469574E26;
	Thu, 18 Jul 2024 08:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721291526; cv=fail; b=dQ1l7R/4PCE41SJBcn5vcOmkH3qvHfL9Q1a9Zcp7WaBn/t1q96XYknQZhBWdhreEheNjRPiGUaIYf9qTuvTbMTG/XuDtSiddWy3cwVU+JcG7YBPfWVlibySeANag0FbrAhnUTXK01ai7SGA4zrvI44UrlaNPpUVeVgnfq7M4taw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721291526; c=relaxed/simple;
	bh=4Qgq3ovQfW5LSFtnzokvepZi3YfCikXsMRGeTsiTd7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kjMDfoT93cYZoQOloSbk8H29XzSyDLKa5wnFx+NbtfPujUXrjjPhn+pfT2wlbn3SCRSkHcHFmNLqp4UdJtYp+rzoNx5hLslFi1dibrTAHy2GC5PPicXfe1YSRYmMWH3U1oIyc+6sUbix+La0/2+cyi6+3VFoVLVttthEcAJMGIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=GYHR4OC6; arc=fail smtp.client-ip=52.101.66.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kKZWBgcg/utyvVgZRwKAwhCfKrYeWJbnF8txCjwMIl6/hlpoTgHCQr/itWXQy9VS4xNIGbEGdCNMaS2yUuny18xfmroaCzsdPymuCZWKc2guc4VrMfFRqURfH/DnQoTDMdciQbwnJfb7a/655oA/1u/0kBNbi2OQjSpo+pOi3onlfdYAsNNCoxjPXNvCu3kvOqMShKz1jM846nzxxHDUVE5bCPefvnsTvCFx8hlZQjgDVeH+WigJPa6FS7PT3gwvOBoSx7wjOMbkTd0/8YMMSlOHP4ZRnvWscT3lS0HfKGJw8EGvSmt1T2+O30Owe7+GBQ2A/sLSJno9ZHl4qWgdQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Qgq3ovQfW5LSFtnzokvepZi3YfCikXsMRGeTsiTd7w=;
 b=rWYQcFxTgN0DduMbsbpby1yeCTuU1TqAZoGjPdQPTqAns8JChQ0ijOBpVMTMQ0hBckveAX3bAh9GLeiUNX0UTJRr3iimUrwrJ0yhGFwxFVlyC5QOeGOngD1AiF+9haTHVJOcUH+S5ZEHms/8CQC+//d07ddCmui5spRwYiiu8UIfE5KbI/FxCZXXUHHM0PbyUaQrvGP00QekX0IYekue9hkFA7Lf5v+fmEuCN1urLyR1O89G08vALGAu1IdNZqXMD87WqKrWJLErpqH4RwFOBVSk1TTg08+PTlmkO1PUEc5u0TkfSpZXypmHJHqaGviC0JtnNrap83OElnA234FUww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Qgq3ovQfW5LSFtnzokvepZi3YfCikXsMRGeTsiTd7w=;
 b=GYHR4OC6xDqSF7cqCM/L0sIJwKB3+QRREJ4ib1GStstqFbpvm21L6+6sNjtQOfz9vo3YkLrF0/SneQTsXnFdnjR1S/YXNDRvCe8XTDTpQzjP1lqtKVkWJ5F8qxVhJJQiXetO/HLLfunfik4f76FGuOImzrHYiNJ0E8qOam/hdfIYIQVjZt2AupMXPOFym5CrkkwaAoZzqtc142iNdkEkSCcUrX0mOkFm0GMPRuDCTAnmxt6d3ejx8vOzuHv2XULQ7SNQxvjz5mYQwykBLduHLuZfZuD7fTM5hPN82Odc3yLDFByDVHN33iuUna9KQwuNM9NVm0ToGSC7JWYldlzlYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by PR3PR04MB7321.eurprd04.prod.outlook.com (2603:10a6:102:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18; Thu, 18 Jul
 2024 08:32:00 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 08:31:59 +0000
Message-ID: <6ade063f-87fa-44a2-807d-915726c2c5a9@volumez.com>
Date: Thu, 18 Jul 2024 11:31:56 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] libceph: use sendpages_ok() instead of
 sendpage_ok()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, xiubli@redhat.com
References: <20240611063618.106485-1-ofir.gal@volumez.com>
 <20240611063618.106485-5-ofir.gal@volumez.com>
 <2695367b-8c67-47ab-aa2c-3529b50b1a83@volumez.com>
 <CAOi1vP96JtsP02hpsZpeknKN_dh3JdnQomO8aTbuH6Bz247rxA@mail.gmail.com>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <CAOi1vP96JtsP02hpsZpeknKN_dh3JdnQomO8aTbuH6Bz247rxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|PR3PR04MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: 47d0f173-3137-4370-8ac5-08dca7041772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wmh3cHNmeHlSTFBra3FHbzJzWkJXRW44dmFGWCtuVFRsS0VlMndWdGw0aldQ?=
 =?utf-8?B?cVhHSGpTQWF1M0QxTzBGZWlydkNxMXNrMy8yajZ0SkxySS9wTzBHUXFHcXlF?=
 =?utf-8?B?RjY4RUdORFFyc1lFOE92MHpTZFdpd0YyQW5HREtPNE8xSEhPSEVDZUJLTEl4?=
 =?utf-8?B?TnVUZUlCd3RzcW5YUHpBMHpUbkdISGE5c2tKL2hPekNqSnlHNG5BbERXQXdu?=
 =?utf-8?B?TkZEaHBOa213UVU5eXNpb1M4QTdSOW9MNFJEakltb3QrZXpFWHExVVNZU3U2?=
 =?utf-8?B?bDdiaU1MRTNYUm1pQ3gwbUw2VHp2a2NpckVPWnAvN0l1OUlWcGdrT29Kb2x5?=
 =?utf-8?B?dXJ5eUtiekMyS3BvVEQ3bytXaVZ2UHhKb1NuRU9kMzQzZGZ0UTF0K3d5akt0?=
 =?utf-8?B?WEhVZXdsY2lxd01FUjBiUWFXZUV4TmZ5Zk84UGluUHVocjZFblpndmlKdlFS?=
 =?utf-8?B?LzBUU25tRWJoSVpTZWdCMnh1QmZKUEl4Mk5iNW00K0x1MmVwaWRnYVhDVnR1?=
 =?utf-8?B?UmRzOWZwcytocm1TbTZYZCs3cXFsRk12bkZhWCtNUmU1UGFyTjRJREUxZVM5?=
 =?utf-8?B?SHY5ZGVQbTRIcEZZUm0xRGcrd25Ba0dzOUk5cE56aXpwa3dieGdDMDA0VzJN?=
 =?utf-8?B?a2dZWjBBSWtHV1hSclUvUWMrQXhiY1BUaUtEK1g0OTdrRXFLU2NmeXEzRG1X?=
 =?utf-8?B?UUZxR3AxYWtxSFZUSGVSRVBSWmxhMThFcGJ2Kzc5Qm1mTlMxYytNUUtEUFJO?=
 =?utf-8?B?MHArQ3Jud2tqbytDcXpBVkFHc0hkSGI5K2tpVmZ4WnRZbWdvbGw4YVJBWU1P?=
 =?utf-8?B?cFBqdWRFWEhYOVRpbStLWVYvMHB5Zy9IZVBaTjk5MWdkOHB5eW1hT2xLUnA3?=
 =?utf-8?B?M0cvaTc0SkttUkZBckFyV0E0QzlHcS85d1l0dXAwMGQyVWhvRDd0RnMxZlVr?=
 =?utf-8?B?eGNQbngyVFJBSFV0b3drV0xKMmhQUVdCVTFTZ0JLTVoyVlBINUNhbVVmZHlP?=
 =?utf-8?B?MmZqKzZGWFFpZDhQQnE2MWoycUZhK0s3OXNYUXNXYlg2d1piUWtGNkM3cWJr?=
 =?utf-8?B?TU45dEtxa1FMcnpjZmV5ampjRHBYNWlLNTZsSWtWcXZ6UWJSWk40c21QTW5x?=
 =?utf-8?B?Nmpuc3RhcjZTSUphdDlmbEdydk1zK3IzZFVPaFFueGl2ODkzN08xTElsQnEv?=
 =?utf-8?B?WURkWUhkSjZKMGsvRmEwc3FRaWs1cE1jVnNseFgxTHh6WW9WMERDMjd4aCtS?=
 =?utf-8?B?dmdJWEZBcmtmSGJ5Tk5zbVFsUEpDVlh0YVVKcXp3N09jdjRnNkM3cUFwTGVJ?=
 =?utf-8?B?RzAzRGh3TFBWYUU3Nk1ydm1KRXo2clZYczA1SnNLUm5YeGIxa1VpNHZkRnZ5?=
 =?utf-8?B?cktoVXZqcHdIQ3hLV0x6ZUxSa1dia2c5bWRHNi8wN3JHTDkwZjljcklra1VU?=
 =?utf-8?B?dmRjK0FqRlpkMkptWUdQVk5zVjRmemp6UzZJRGFSMUxWSC9xaXdNWGZMZ0Fz?=
 =?utf-8?B?WnV3K1hiZTc2c0xSTTN4c25JVlBhVDhZU3g3dURHMnEvZ0liQ3RjTmdtcDZo?=
 =?utf-8?B?OVNzTFpXUnlobC9xSVRhUnUxMGk1ZlZOMDNBWGJaVmRWRmF3QVRHUmI2bDJV?=
 =?utf-8?B?emZ5cWJhVHYweUQzUTJDMUF5NUhnNnJRU29UWlI5VVdyK3MveVBuWE96Mnkw?=
 =?utf-8?B?VWhiU2hYTDhzbFU5UW9DTnJvb2MzVVVMeGJxeWhoRWExOVVYYVlYRnVYRkE5?=
 =?utf-8?B?ekFiQ2NURy9yWHBCbVJSbjIxVUIrYlBzZnprS3Mzd0x3cWdRd3BhYjJrbFlw?=
 =?utf-8?B?YnplWkRKenVNaGcyUi9GQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3NlanppODNRTURVbENCbTFSMzZ4WUtuajllNjNGdjhsUjA2SFBnV1pzeFhP?=
 =?utf-8?B?ZjBuaU9IUnJzazZyUTIwcU1OU0dvdTZ4UHA2QTBwRlJaM3lReUVySWZxVXBW?=
 =?utf-8?B?WTkvbnhHTzE4OWEyR2FIRXJkN1pYaVFHL2xqRlIzeS9zWFNJbW1FcWRaWEht?=
 =?utf-8?B?ZUVMekhUOGZyeFBLcWw1REQvVGt0TVlFWkFiTGV6MW4weFRCS3pTMlpYVzlF?=
 =?utf-8?B?YU5zdmpEQzlQWVV4SWZVR1RTV082amNIRTdqOTNOMkRhdlJRWjQrUTdRMElY?=
 =?utf-8?B?dnB3ZE1aZmpHZTBSU3lDZHlyQnI0S280L3AwT1BFL0JjZy9zOFVoZ1RJME9W?=
 =?utf-8?B?Y0JVZFk0R0h3VDdoZGNuQWVvMkVMcXZuWTdsdHdxSmJhcDB2K05vNlBubVh5?=
 =?utf-8?B?MnY1anBmVnJvcTBXak5iWkRmV29vWTJPVHplcmFBcjBzODViSlppclpzclRi?=
 =?utf-8?B?cGpQejRpUWUrNlBraXpGeENNZnhpaWV1MEhNUU5zZFFySlVCMi9oMHVSZGE2?=
 =?utf-8?B?SElkUmV6Zm1ETFdtaWVlQkNEYnRnOE1jVC92OGpiK3JkVUlhYlduUzdYbnor?=
 =?utf-8?B?VEVmaG1nSnlrRFNielpzTzNyNTRsSEd1V3V6QkVhOGFXRnFWMVdCNklJV2U4?=
 =?utf-8?B?TVJXSFZvVHV0Wkg4OHdUSDFKcmxaWlJ5L29ERVJ1b2JLR040N3NyS1pXR09u?=
 =?utf-8?B?UnEyNklZOFVVbFV5c3Z4T2lJLzRqUUZUMXRORkVCMGlsb0F5OEpNVmlIaDRk?=
 =?utf-8?B?dWRsMVRMaFVwbGJ3b2h6WCtzVXhJVXVIdzRUTkh0UkE1RjEvdmRkaTIzemJn?=
 =?utf-8?B?dE9haHFHL0J0YkpGOHBQMEpET3owV0h5RW91TzBzczNKRWFCSmJKeWZ3bVZs?=
 =?utf-8?B?bVMzUGp4TituMWVvN1dYM2RIR1FPM3NUR3NRQklWRWRQRUViU29remw2TTd6?=
 =?utf-8?B?ckhEd3BRUXhxdEZlbVdza2ZqSWh2dUZOYTBEaWNqM1ZteGNWQ25rQzdKTWJW?=
 =?utf-8?B?dTY0dUkybjE3WDQzYXk3NFh6aGFIMEhDTjQ4TXFrR0tRWmdxUkphcmQwOGt4?=
 =?utf-8?B?Y3hYSTV4OTQ3ZGZGOUJmVHpWRlQ1OSs4Q2cxMEVPSWpvQnhBbVBiejBad1Bz?=
 =?utf-8?B?VW9Vc1NOSk5sdjgyQ3YwWmJtWDNTZWxEYjhkRDA1YzM0UFZaWnJ3QlRMcDZt?=
 =?utf-8?B?QStjcWZ3RVBCUGwzbXpsUjhYVjNwTW90NDBlREU1UzdRMVlhclR0N2JRRm8w?=
 =?utf-8?B?emVjZlY1R0srbGRJTnVtc3h5UG0wT2FGRDNXV3l1Z0pCVWNTbFY0aHdvbjZn?=
 =?utf-8?B?enFQMTJLelpVVE93dndYQjdHUU1XZlRjalBTZFdHK2pWSkYra0grMThmTzd4?=
 =?utf-8?B?V1pkN282dE5tR2dRbmtTUFFLZUZwYUZVRXdHSllkVTFQMFdJQjh6YWx2SWt5?=
 =?utf-8?B?enpWZDBOR1dack5lS2N6QjBrUFFwR0s4M1Q1MEIyaHQ1VFlJcXRvV05kcUx4?=
 =?utf-8?B?dlpRR2R1cCt1N09nUCtlaFVrK0dHd1FibER2YzdENGIvVm9pQmhTRjdRYWZV?=
 =?utf-8?B?UTRKM1FNSGJHRWJLM3JUaC9xUkxJZ0xXYzh5bEFjbDBRcm1MWCtpbGw3V1h3?=
 =?utf-8?B?elp1QmhCaEZlSUhSeDZnbmpLY1VUM2wwT2FVZzBYa2N4c0hyOEtPTEthUXVQ?=
 =?utf-8?B?ei9Qb3lyb2d5cWhmZkxrZ05kTEt0NndYbVIxT3l3Z09sN3BWcE1iUlpJckZE?=
 =?utf-8?B?aU96YU83cWpvSWErTUVycVpvT0NzbG5qT1RQci9zcmJZcG0vaTZES3cwTjVz?=
 =?utf-8?B?WVZDMXU1dTd4N3d1Qk1Ud2d0WlM1SEttYWhpUWlCZ3dpQzBCVTdGTGRDcnlk?=
 =?utf-8?B?M2tDUTVqemxoSGltU2ZiQjhYQmhBK1NBbUNWR0pyTFNpV2tHaXowMGlCMXhE?=
 =?utf-8?B?cGJETjRoalNUdnN3SlA1RVRNclBIUFhSUUxidGFGUHRhVVdpdjVPRGw0OEtK?=
 =?utf-8?B?dm9hSlRtL0kxejB6Nk9kenlPWVFJdmdlKzV2U0ZqbHVtb0s2VlVOdCthSkl4?=
 =?utf-8?B?VFlZdjQvSU5sZGw0V2NJaHo4ZlUySHVRNm0venRRbjlaVnJLZEJYUnV0UGdD?=
 =?utf-8?Q?0H7tlRG1Ea63P5A+p0Ld9LcZH?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d0f173-3137-4370-8ac5-08dca7041772
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 08:31:59.6284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKvfO9VTAMBuv1hpLqbcM7oYby9rFqWooM4YVmN/wvzQ+vbugduqo3186Jm7lm2x4DWg14KxXX4tSpOejiFv/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7321


On 7/17/24 23:26, Ilya Dryomov wrote:
> On Tue, Jul 16, 2024 at 2:46 PM Ofir Gal <ofir.gal@volumez.com> wrote:
>>
>> Xiubo/Ilya please take a look
>>
>> On 6/11/24 09:36, Ofir Gal wrote:
>>> Currently ceph_tcp_sendpage() and do_try_sendpage() use sendpage_ok() in
>>> order to enable MSG_SPLICE_PAGES, it check the first page of the
>>> iterator, the iterator may represent contiguous pages.
>>>
>>> MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
>>> pages it sends with sendpage_ok().
>>>
>>> When ceph_tcp_sendpage() or do_try_sendpage() send an iterator that the
>>> first page is sendable, but one of the other pages isn't
>>> skb_splice_from_iter() warns and aborts the data transfer.
>>>
>>> Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
>>> solves the issue.
>>>
>>> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
>>> ---
>>>  net/ceph/messenger_v1.c | 2 +-
>>>  net/ceph/messenger_v2.c | 2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>>> index 0cb61c76b9b8..a6788f284cd7 100644
>>> --- a/net/ceph/messenger_v1.c
>>> +++ b/net/ceph/messenger_v1.c
>>> @@ -94,7 +94,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
>>>        * coalescing neighboring slab objects into a single frag which
>>>        * triggers one of hardened usercopy checks.
>>>        */
>>> -     if (sendpage_ok(page))
>>> +     if (sendpages_ok(page, size, offset))
>>>               msg.msg_flags |= MSG_SPLICE_PAGES;
>>>
>>>       bvec_set_page(&bvec, page, size, offset);
>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>> index bd608ffa0627..27f8f6c8eb60 100644
>>> --- a/net/ceph/messenger_v2.c
>>> +++ b/net/ceph/messenger_v2.c
>>> @@ -165,7 +165,7 @@ static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
>>>                * coalescing neighboring slab objects into a single frag
>>>                * which triggers one of hardened usercopy checks.
>>>                */
>>> -             if (sendpage_ok(bv.bv_page))
>>> +             if (sendpages_ok(bv.bv_page, bv.bv_len, bv.bv_offset))
>>>                       msg.msg_flags |= MSG_SPLICE_PAGES;
>>>               else
>>>                       msg.msg_flags &= ~MSG_SPLICE_PAGES;
>>
>
> Hi Ofir,
>
> Ceph should be fine as is -- there is an internal "cursor" abstraction
> that that is limited to PAGE_SIZE chunks, using bvec_iter_bvec() instead
> of mp_bvec_iter_bvec(), etc.  This means that both do_try_sendpage() and
> ceph_tcp_sendpage() should be called only with
>
>   page_off + len <= PAGE_SIZE
>
> being true even if the page is contiguous (and that we lose out on the
> potential performance benefit, of course...).
>
> That said, if the plan is to remove sendpage_ok() so that it doesn't
> accidentally grow new users who are unaware of this pitfall, consider
> this
>
> Acked-by: Ilya Dryomov <idryomov@gmail.com>
>
> Thanks,
>
>                 Ilya
I dont think the plan is to remove sendpage_ok() (unless someone says
otherwise). Im sending v5 without the libceph patch.

Thanks


