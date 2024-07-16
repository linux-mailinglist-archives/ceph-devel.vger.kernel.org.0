Return-Path: <ceph-devel+bounces-1533-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D74109326D2
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 14:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 620A91F2264F
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 12:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C699219AA74;
	Tue, 16 Jul 2024 12:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="AqrSCVRz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021093.outbound.protection.outlook.com [52.101.70.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762FC17D34A;
	Tue, 16 Jul 2024 12:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134012; cv=fail; b=f7OcdvzDEWamBS2nJhwfLnW4uPzvYLuJHBJma6uHs2Vh3aTaJqYKGSCOH9chATLwxLuKwSJIOJn/QLW8l1PCtYllDz2kRuwZJkT37bVOoTmWg+829FBMqQQ3s0QX2xicMshh6cn0mQtGNfFO8/awtnyTTvi8ysje+rmvm6/lkzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134012; c=relaxed/simple;
	bh=5t37/VeLczj9jtXSWqRH1uB/7TJHAjZHOza7Ik+J8Iw=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AO2cW9LODaCpXHHMZ+NQuOHIb1nVs0S+R5LTc8y+fXTKs85qe7J5pEyYZTF3CMocrlku+lbbpdknYMPd7jwbJy7EJ7DMHp35nBAVOhVQh/JdiFcFf3accFM24NmSGgFWuiOndm6hdg0YmqDLUsN6tUCdhEiN+Szt2TmIjN8BJm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=AqrSCVRz; arc=fail smtp.client-ip=52.101.70.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apIc3NMuub4Lb9IaTH615WC8z22knw2BF55wTcmoZzGbLPYkD+XFgmRELhSZz5+a6j7ourBuFr7ftQAN5dMvSsUw7oUkz9rceZ856pKmSpo6iGGkjvIxIaytAdzW38p3HLCfY2eb2ci/Lpv52If4p/pwe7ztT11Mgj5Z7bmjHZQRhU+qMwCsix113OqghzPNtGVvfyaHYux5zIq0/48/GQuyG3BwEE+hH14ItfI/NiFyE9jZzdqemtzg5aeVNygaNBIfZ6frdNzJXTWEN58k9yexi2dGjb/J8zR4KR3NfBANZSoBpUXFBHKyXbHhgXW2GFN27e2QEyc8VVwrfyWj3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2gl8a5qbuqPy7qnwsFA/eQn4bGit9LzOKtBMUKu3t8=;
 b=m2wgooQcFpt2lSpE/1Gp+7Kmt09dkVu7vJK6pzrLKggCeoIDY+CV84WXk2xjvMqC98GZ258ocptuNv42+cbU5QNE3xedfInuMOSE+MGEhq170fnCo017eD/3O9fQ1IrWEBNranyxZiwPNil087FvvNrg0/6vjoUjCkEZesyZGXmXTSQOvEVO/vRZzPlrR/R6TppOkyId2KpV2HTfzEWRrX+T/LJ2M+9c62aKejSCk8LuDkg+Y73xEYprrLKmRFW0+B1SPZgCfYdZtFcTDxwGemWtxR1t0mfq4MPGknURNw/y4wHur3eUt3EX84rw59a4Rmzk+uuR8j7CBdVQfBQwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2gl8a5qbuqPy7qnwsFA/eQn4bGit9LzOKtBMUKu3t8=;
 b=AqrSCVRzmTuhp6MSi5AfxVdRdy0yefZoTdGLMR8ARrSueirwsR7NBd+uYoWwwW3wFS3ugMW6DDksRb5XJpyOa1fhHHTg4nHMvMNgZBl3VD60BK72rjDl8yZ7lV+52TdsJ8wxX63KGx/Jh8wxyUddoy54yDG/TJYd7GAICWuMnBQEzHJrcQvmsEi6wS6vyiB6oVCXXG44ophHIqlCi9KfWcCS4NxegioHclAcgi88/02GEy1me/TSy2LmLtZIbx6JcJ05zbRMgoyZuh6KfeXwwbkQj4gmwhuUhZGukunpjS0EuCuPW+nNfcLhnd5k0OwRUT1+pCXR0W5NgLoB7GFxTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by VI1PR04MB6863.eurprd04.prod.outlook.com (2603:10a6:803:12f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 12:46:46 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 12:46:45 +0000
Message-ID: <2695367b-8c67-47ab-aa2c-3529b50b1a83@volumez.com>
Date: Tue, 16 Jul 2024 15:46:42 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] libceph: use sendpages_ok() instead of
 sendpage_ok()
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, idryomov@gmail.com, xiubli@redhat.com
References: <20240611063618.106485-1-ofir.gal@volumez.com>
 <20240611063618.106485-5-ofir.gal@volumez.com>
Content-Language: en-US
In-Reply-To: <20240611063618.106485-5-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|VI1PR04MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: fd44f3f2-6302-4fc1-19e9-08dca59559cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmdJVVIvODhKTVNQMnYxaG43UFJlMGh3dU10Mng4S2tESnpjdzdiUnRnZld0?=
 =?utf-8?B?cG9CanlPRlpoZWxBbld2UDdyRGdlbC9FbVowbTBhc244bjVoalZKZDd4L3Q4?=
 =?utf-8?B?blhQdEp0VWdSekdVVE9BNzViQ2dmNHFNR3d1UklhQUlxTk12SCszOG9EVjcx?=
 =?utf-8?B?YmlSUWV5dkNKM3hIVm9VVkpZbkZPVHBJK2daUmxYbUxZd1JTNlFlRDNZR2xO?=
 =?utf-8?B?NnFDbFkwUSs5a2RRZUE0SGdPMUEvMHFFalM4R3BzRE1vL3hDS1NoNEwvRXM0?=
 =?utf-8?B?cmpUOG90eXMzWGlhQ0c3TVBDU1E4OHYvRCtWdzkxN3VTNmtVZ3dHaWo5Y3Iz?=
 =?utf-8?B?eENFaHpPREdlSEIwakltbkE1L25PODRlank2UUZTajNxUUtjVWttVXdIL0cx?=
 =?utf-8?B?aDh6dkVXdFIrZkE4SjdtUDR6YUdOeXZqODB3MWd0bkY1L3FKcitJYUhjVlFq?=
 =?utf-8?B?aFVzOEoyTkxuRERYQ1ZJd3VYdWNIQmVlbHZvM2F3TkZkYjlUYzVVMEVrOE1V?=
 =?utf-8?B?czNOdXNWZVZJdFpGYVprdm9hUUd5V2tjQnY0YS9Dai9xNGRyMkVXM3l3cUxM?=
 =?utf-8?B?UlVkSGxoUk9iR2VDaGZ4TVE3cXNlL1duL2RKVGZKMGZFR1NVbWFTMEZrZThV?=
 =?utf-8?B?NXV4VFBpbWh6dHA0SmtYeEtGcTJjSEJUa2t4bVQwdURVN3FiUi8vRkZBNFdS?=
 =?utf-8?B?WGVkR3FETHFFeE9oRzRqR0h5S2VjUDloakhrV3Z3L0E4ZjVJdGpLV2kyRk4r?=
 =?utf-8?B?SGNnNjdWSjczVmorbjh4SWFtNUNGOUxLK1IyRWZUTmxkcnFRWGt2dy9zVHhK?=
 =?utf-8?B?UDkwRjk3T0tTL1FqUmFuaWJSU0hUQmlMdU44N3FtMjZZK3ZkempVL1IxWlB2?=
 =?utf-8?B?d0RaRlVUN3dPLzlUTm5nREU5NVdZaFVRVXg5dEZJMUxrUE42V0c0OFc1RWNW?=
 =?utf-8?B?RWZUVm5XRWFRUGN0NHN6VERZSEFXMm52bXMxb08zQmZRcktWWC93Q0JYSlNk?=
 =?utf-8?B?Z0ppdmFGTUJMdTNmbDBWYnYzN2tWaWx6Wmlsa3M1OVc0Z2VZUXVmcXdJWlRG?=
 =?utf-8?B?NWg1Z3E0d0c5VUdlUzNsbFJTa1M2L0Q5czBxZnVBaWhnNnFvMlE2dXVVYWs5?=
 =?utf-8?B?WDBUNlR0eHZSU0NOSXhMUmZ2dno5Z3FPbXpGNGtCa0Vnd0MwZEVaR3JUaUla?=
 =?utf-8?B?MUN2b3M0L3JUUUdmUW1lV2hwVEt6SHM0dndpayt6YUtCVTVlZmt1Q0syQ0li?=
 =?utf-8?B?OXlXTzVWcTVTMEcvS1ZxRndNVzNvSnZCK3QrMVBGRWpaZVZiNzBESUpocnp3?=
 =?utf-8?B?aVlPeHErc1Q1UWxLVk5BMy9nek4rRmpYN1IrU2dpS3RzOGpYZzBrT1hYNmxL?=
 =?utf-8?B?TXZ5cFg0TmpMTEdXZUFtRmkwdTRBbjl2TjdlZXBJYUE4L0hOZDhtMWV1c3Zs?=
 =?utf-8?B?NjdLMnplb01ZM2lIVUU1Y1BNK2h5bFdjWnkyMmhibjh3dDRNbHRIVklkNFJ4?=
 =?utf-8?B?Rk1PUWNWc2ZZdUd0dDM5byszWEs3NnBsNzhIWGh5NkNVQTdBazZXRFNTSm9P?=
 =?utf-8?B?S3dUSTBWMElOaTVsNGZxQlF3a0RSRVRibkJkWjltbW5MU3l5TTJoZGZQNTVB?=
 =?utf-8?B?RURkcHlyN0c0aXc3NUs4bWFhQVRML3hsTVVlSE8zZmkxOTdVZ2xVbkdNNW5K?=
 =?utf-8?B?TlR4UjUxbFEvZ1UyTFlEUEtZYUVldjFxVGpNVHVGcG5ZTWhPTzNCMHpUWEFr?=
 =?utf-8?B?Tk1rTTRua1Y3NmNadTEvYnIyRXMreEVXVkJrM0VCbG1KNDdHTEczL0MyaUp6?=
 =?utf-8?B?QytxYW1mVWowWlhMZkptZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXpSdVdra00xRnlqNVdkWUdJd0lUY0lVa0JMZTd3dlRVeFIyVWprYWlvSnRN?=
 =?utf-8?B?eTJOb3hQOU0vVUNhdlN2STdHOGpKQ084U052NkRjcC9ibDZnSnc2MGlQVDIv?=
 =?utf-8?B?S3RDNGVUTm9CUWZKaWRpN0x0Q3Zlc0t1YUduNWV6dS9jSWp0THRCMlhtamt3?=
 =?utf-8?B?N3BxTkZvN3oxNG1KUWNVWWdUMnFaUVJyWllqZVNodjNGdUxDaUZwbmcvRTcz?=
 =?utf-8?B?alFidU1KUG4wdU5zcVI2K29qVDZMMDR2NTNMTk4vSVliUWdQRmpGOENydlRM?=
 =?utf-8?B?Ny8wbThXZVJMd1Z3dkN3a3pwS2ZmeGVSOW5QckZYeGtVNEZIV0hON1diaERZ?=
 =?utf-8?B?WGczRzJOdEY4ckI0K3BzQ1VodmUzY3JPTDNKeWs0UiszbmE3NUh3UHBldTdY?=
 =?utf-8?B?VmQyVTN2TEMwMytBRWpOWlNFUUZhdG5lazdBNjhHWlhHcmx3SG9DUm1MUlE2?=
 =?utf-8?B?RnlKa0RKUTdoZkRIUWE0NjlVbE41OTlZTDBnUHBLdzQ4UnQrQmpjdUd4REUy?=
 =?utf-8?B?cy9UYXJTeHFtWVVWUGR5a1JaeVU5MElYZzN0Y3BIWWIxWjFnWXlaODFKQVc4?=
 =?utf-8?B?WDg3RU00U3FtVnI0OUF0QmVnYUQweTMvcTBMdFY3RUc0Q3YvSmd3M3RoY1ph?=
 =?utf-8?B?MXJRb3ZTQ3N2TXZFVUVvTnhRMFhwbTU0RGhBN0xQdU01bGtwSUVZWlBNSWdP?=
 =?utf-8?B?MTZ2bEtQMGhtbXV2b0NvdEpBSnc2eDhZN09Ld0VkUHRsS3hUWGY5czBma0tr?=
 =?utf-8?B?ODEvdHhyL2lhczQ0ZGZ2YnN5My9Qdml2Mmo0TWllc0k0T3NQemNyTW5TN0tE?=
 =?utf-8?B?ekpLODcrdHAwdnZZOS9EVGJLQlZxSkZiVk02VGh3a2xjaVI4eXJxSHVzbVY2?=
 =?utf-8?B?WWo3enFkTkRWR3hRMmhTdVo5YisvMG4vYmdZendQR3pIWERkUDFvZ3pPZU8r?=
 =?utf-8?B?dDRrTVl1Q2E1Q1I3V0k1ODlOSTcrS1Vjd3ovS011akY3MitTZWgrOWZQbUIx?=
 =?utf-8?B?M2g2L3VwYSszenpwdUthWGtXQmh2UURTVFVtZkRvOEQ4ZkRuRUhiVVVERFEy?=
 =?utf-8?B?U0lvODdxb2ExNmQrcFkvdUNieVN5ZEhveW9FcFpBeFV0WGdDU0RCWGl5K0Vl?=
 =?utf-8?B?dDhEUmd4aWorTVBWbm5GdjlUeGNEUWY2ZHZEaUJuY05tRHh5TnIxeCt2ZjhZ?=
 =?utf-8?B?Z2xHQXdUMjJOcUFjNVMzMW5rbExhLytaenFscmlqWENYMWlLTGZhTE40MWZN?=
 =?utf-8?B?WFhGZE9jOS9hZDE4cnVIMGNLL1N3OUtHU0hwWkVGSUhYbTBDV29JVjhqd3Jp?=
 =?utf-8?B?UHdKMVE2OGloaG56ODcxQVh2djRnZGtHbDRFTzViSzNvamFQYXAzNERKdE51?=
 =?utf-8?B?ekVJWG1rN1UvcUJ0a2lyNTlQZGJzY0hhRWtLd3l3cksraThMTEtaYjdRNUxa?=
 =?utf-8?B?UmRDVFdOS0YvbncwL0RkNTQydjdoa0dTRDVLaEtGdlo2cEVMY3JiOVFNWlpQ?=
 =?utf-8?B?Z1Z1emgvWXFzdXZRc05kd1BZc2dUYUZpcTMwdVRRN1VvL24rRFVhQjJpSThu?=
 =?utf-8?B?SWtFKzE1T2VCc2NJdVRHaVd3d21pYTlQa0U2M3JDVDQ1Nzk4bEtxbGllUy96?=
 =?utf-8?B?V0wzNHlVUVU1VGRRcFZ2UUVYem1QZ2F5YnQxUTdzQ0RmSVNUUkFGekp5OVBP?=
 =?utf-8?B?T3ltYUFhNG14UGZEcHYvQWVHVytDd1hiVksvNGtoRlp1Um9iYTZYc1VZZkVN?=
 =?utf-8?B?TVVJVWc3ZnJwRDJxOWdFYXdJOHpIWU8vcFp4S2xPaXBKNnoxSzVhTnZHM09a?=
 =?utf-8?B?WFdJM3RJZWx0WS93SXh1OFdzek1NVmRUY1E3QytJV3Y1QXdhQ3VPREVqa044?=
 =?utf-8?B?VFp4ZjN6Z25oNTkxRVlpS1NWS3pGMk9RQ2VTRHhTdlBxRGdvd1BRbGpBdlNh?=
 =?utf-8?B?S3ZZVGd5Q0F2NDVsSjVYbERqQ1lXNldtbFJKNnVUWDdVNis5MmhxVVJyQ29G?=
 =?utf-8?B?OHVLUXdTTlNJdVVKbHRtUXc4VFpKVjhDUktxa1gxemQwaVRPOE0zZ05wdjl3?=
 =?utf-8?B?WklHNnk2ZmlFTXgwQXhHNysxLzF2YTAzajdMVXU0bmZ0K0N4dFdjZDdvN1Fr?=
 =?utf-8?Q?bxOs0Obz9f/5OADzH6ABxGD/v?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd44f3f2-6302-4fc1-19e9-08dca59559cb
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 12:46:45.6469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyrBjXyprysP27PHT/M+ukmSH1vJsEY49LTku+0itSBoHoJmJxxPO63x5zmSAs6flEsbl8caFlGdy/vnEw/BWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6863

Xiubo/Ilya please take a look

On 6/11/24 09:36, Ofir Gal wrote:
> Currently ceph_tcp_sendpage() and do_try_sendpage() use sendpage_ok() in
> order to enable MSG_SPLICE_PAGES, it check the first page of the
> iterator, the iterator may represent contiguous pages.
>
> MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
> pages it sends with sendpage_ok().
>
> When ceph_tcp_sendpage() or do_try_sendpage() send an iterator that the
> first page is sendable, but one of the other pages isn't
> skb_splice_from_iter() warns and aborts the data transfer.
>
> Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
> solves the issue.
>
> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> ---
>  net/ceph/messenger_v1.c | 2 +-
>  net/ceph/messenger_v2.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 0cb61c76b9b8..a6788f284cd7 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -94,7 +94,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
>  	 * coalescing neighboring slab objects into a single frag which
>  	 * triggers one of hardened usercopy checks.
>  	 */
> -	if (sendpage_ok(page))
> +	if (sendpages_ok(page, size, offset))
>  		msg.msg_flags |= MSG_SPLICE_PAGES;
>  
>  	bvec_set_page(&bvec, page, size, offset);
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index bd608ffa0627..27f8f6c8eb60 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -165,7 +165,7 @@ static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
>  		 * coalescing neighboring slab objects into a single frag
>  		 * which triggers one of hardened usercopy checks.
>  		 */
> -		if (sendpage_ok(bv.bv_page))
> +		if (sendpages_ok(bv.bv_page, bv.bv_len, bv.bv_offset))
>  			msg.msg_flags |= MSG_SPLICE_PAGES;
>  		else
>  			msg.msg_flags &= ~MSG_SPLICE_PAGES;


