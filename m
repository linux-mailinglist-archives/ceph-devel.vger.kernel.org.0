Return-Path: <ceph-devel+bounces-1320-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACEFD9032B3
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 08:33:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B5C1289A37
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 06:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168F217167D;
	Tue, 11 Jun 2024 06:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="IDPJ2uW2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2105.outbound.protection.outlook.com [40.107.7.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87E313F43E;
	Tue, 11 Jun 2024 06:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087593; cv=fail; b=AigtYdSxfbF/nC9OdsEjhczMXijfrnJy6DYKSzeX3JIPPn3fPBWpUi+Z1b46bt87+7misCA/QIetVyARxO0Zi16Uzop8ENTvwwKVK/B/spA4udgCfqGYZpynH5KJ4PjDSVacNkhkTR8O5/rZPYpPGiuUboCJlLLCO06FJVurihU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087593; c=relaxed/simple;
	bh=crvBOYnwFRqLY1kLvj45Rhp/R4qFsBziSqcCNgp4u6I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p6voHLlnw6V75n6/jV/orjRjtWjok416WmKqwJ9u67cg9iUvA0q58chLmq8QEm//5rI9T6zGzQWg332yhuM/xpw2GsbLe0hf4zyVEBUwYVGjQktuVNik8ex8qDtOsHbws6t3s8jHdurSqyBPlfRQaxuC8W+rE9ko95UEzSewQ+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=IDPJ2uW2; arc=fail smtp.client-ip=40.107.7.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQqs2M8P1U5MQtPVsKMvvLq4crp/sjNYoUDHMWA9ugtqFUIUTBT3qiusWk/HVZaIsgZB58cNHlDwIKoAsFkZlFj2d22eL/yVJM5OB+VbVqmx2CYTgeM87IKOZLhLuQGLWRWXs8g0QmOucSLGZqHpUPYv/3ofpGR6+b/0mjNdwU4Vse0GgbE9KPTNhhfmeZSD9usf6GRXrvNxsLunrxXJOnSrXQZMKWdgw5MiRVxINFxhz52PfaHgdMHPHIyW092rvuLIuIQR5XhXg+dqeRGUZOiQx6oMVeQ8Xh/Mx62I85uBQbHNC49KssLu9urwkhvzbESm3yYh3DEUszr0eF1mHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crvBOYnwFRqLY1kLvj45Rhp/R4qFsBziSqcCNgp4u6I=;
 b=AxR6Jye/+zWo62fWWo5dvDbaP8/CFfzu0sH4zstu/tw590LlQzj+p6i/D8GkgR1YNHXlp7ditCOTdCCWTnMLdJLrEg+WZsrfEz5mo+c5hONPGOb7d77YtJ6/IlZTUXoLP4mUelWHIMf3hniGKmjf3omzq5HaLnT1V9r8S3u6IX5ifVEwbz9XFuA6tdD021Q8v4IMA9yW/arkIt0c4UCQmdO3u4XCIGRg48yaBuRATqx0PG8+P10s03QPSUZMhmMxU6YowPyK8qQH+e+kLtOCbfoqqeA9QkqCv2UmU9V7CYYRwfWDpDBMTV2wliFTvP/aIkxVIRHorzWUSXe7EMwlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crvBOYnwFRqLY1kLvj45Rhp/R4qFsBziSqcCNgp4u6I=;
 b=IDPJ2uW2GUO5Dx5YSNOtBbY9KhcoJ18WigPZGwlR+llbFKeJXEbG7jD90vT05jiXxvee8GI9FfQNKqHaTLlDP1zqcSwNlZ0aktm+rcpCaMt4ejuSx0KFFYu0xu4FT50+JOvDl52IvhDTvGge/vEehF/WG2IwjSdK3gVJHHN4R04+8b/hcVbFXJxXXQTBvGLuzpEuFvtLfEMmYy/d4SOlwBwiyzFyi/atQC6W6BQeTt3xCdkCoos336+NtqYqTae/spjYTncoCwmwSqF92QGf2uOVXASHQCwKjDOaHc9N7lyHb5ojed9s77cI0S9CIYHIprv7C6I2VhLDHjyTdtcnqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com (2603:10a6:20b:8::21)
 by AS8PR04MB7974.eurprd04.prod.outlook.com (2603:10a6:20b:2a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 06:33:08 +0000
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371]) by AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371%6]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 06:33:07 +0000
Message-ID: <4ec59dbf-8be1-446a-89b7-ae3f352fa2a9@volumez.com>
Date: Tue, 11 Jun 2024 09:33:05 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] net: introduce helper sendpages_ok()
To: Sagi Grimberg <sagi@grimberg.me>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240606161219.2745817-1-ofir.gal@volumez.com>
 <20240606161219.2745817-2-ofir.gal@volumez.com>
 <5efdb532-2589-4327-9eb7-cfa0a40ed000@grimberg.me>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <5efdb532-2589-4327-9eb7-cfa0a40ed000@grimberg.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0023.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::12) To AM6PR04MB5110.eurprd04.prod.outlook.com
 (2603:10a6:20b:8::21)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR04MB5110:EE_|AS8PR04MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d525ff-da4b-4911-a3ad-08dc89e05b1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWtxNDJjK1MvUWhkSTNlZGdNTHUyak10QWlGUW04TFZUL1drOVVYUDVrVW9m?=
 =?utf-8?B?alF1Wm5vM1F2U29ydmd6YXlhNmdxNmQwaEVyY3JMWGpZTDhubEdhcm5qd3Yy?=
 =?utf-8?B?VDJnTndkdWRyOUFtU2Z5R3c3ZkFucmxURHJsWW00cW81NUt1Y0VKZkdGKzZ0?=
 =?utf-8?B?TGx4Sk9EdzZjVDNXMUlnWDNIY0szbDNVVWo5bU5NeHprZDh3UHNhd2NmSS9m?=
 =?utf-8?B?cXpLci9kYThZSWVOMzFOdENRNXp3MkdvYXNSSTJXUVUzUW9vSTQwaFo3ckt0?=
 =?utf-8?B?ZmdpVzNPWlE1Nmp0aTJDRktTdG1ySlVDZnNRS1ppUncwSVU1MUVqZFpqR2hv?=
 =?utf-8?B?WGJDYUNUdWdlQmd5ZFhqd2FLUnNiRXRBUWZwN24wNzN3NDlEeCszbjhEWThW?=
 =?utf-8?B?QTM1R1JtRTFBY2ZmaE9qT0JrZEhnOXJHam53d1RwaFNOdUdBK0d2aTJSSWcy?=
 =?utf-8?B?bm9UVUU4RzROVlgwejJ2cGluODlmeDB2cFVJMFdpV2N1TldUMEFtM0dWRTFS?=
 =?utf-8?B?YnVvL215TTJDTjhCdEVkakFiaGhVT2lTVlBwTy83ejdSNk92UStVWEZaaEpE?=
 =?utf-8?B?Z3B6UUZ5Z0RTbWVJVzZ5SGJFSmRTNy9OR0V5UUdjeVEvTlc4bXB4SjcyL2J6?=
 =?utf-8?B?RVNUbVo3OGhFVWt0L3ZuTFVoaTF1c2lGTXJKZ3JMSys1cE92ZWtZTFB4S0ll?=
 =?utf-8?B?dlAwc3MrRlE0ZzUwaWFKTCtYcTBTTFg1dmxvYVo0Qm0yb2pkeWNsLzNkVklH?=
 =?utf-8?B?dERjWTZic2tFUmN6V1hhZGFjMGJ5YkVKWVo3Q1FNYlRoT24wZWtEK210QllC?=
 =?utf-8?B?bElldS9EQkVaWVZISGMyaXdnQWVTTWd6V0l5M21wVzkzbUpXdVhBOGpNeEJw?=
 =?utf-8?B?cXBiT01mbm52UDNTc1VUVW5rSUFGNnFWYW9hdDR6REJ4cmxPdXVCSGZmdkVw?=
 =?utf-8?B?bkFOSktYaU4wUUJLb1Rlc3hyajE1QWN0WXIya3ZkVjFLS2dnVXZ4Z0RmTjdG?=
 =?utf-8?B?ek9ocnkzWnZQQk1mRThUc1VwQ2pDcDVSeEVtcVFxQ2hGbDhGUG9FYW9sMHk1?=
 =?utf-8?B?MEY4eVdtbzBkdWVoZmhnWUJuSWhWRkhZVk9TYjFJcmw4UEdldnJuY3ZTbStU?=
 =?utf-8?B?ZmQwQ2d4dWdRZXRiS3lRY0ZTa1pXajlwMFRmUk1vVWJSc1FHRmRYNGtrYzVl?=
 =?utf-8?B?THFEbDNWemY3YmcwbFZaZGVTWXV3SjczTlZlU2piaDBhazB0S3U1Nk5RMzVS?=
 =?utf-8?B?eUU3WEo4YnIyWURXZDdZU05yS1hrWEFwa2ZCd3p0cnRMdzM2T09hTGhpbFhX?=
 =?utf-8?B?OFIyOTg0Yk5Lck14NTlFOUd6ay9UVzJYT3Z1WjJDaER6K1RlSDcxTkZ3OENG?=
 =?utf-8?B?VTZuOTlOQUI4b3pnaUlRMmkwc1EzK0ZPT0g5K09yeXR0RWNESnh6cDc5aitM?=
 =?utf-8?B?MHZPRjIwa1N4NEYwQi9TM3ZjMVA4eExjYWhRNFdjZkJjRTRzd1I1SVBNQlMz?=
 =?utf-8?B?MmJsaFFRSklUVHZ3TmRMdTV6K3BUMGk1LzNNOE1DeDI5ZzZqNytLbHQzZ0Rv?=
 =?utf-8?B?RFpiRjREbkZxYjhRL1pOZkp3RmF3OThEdDBpUW1VZmExL1pZZEd0YTBZTVhN?=
 =?utf-8?B?azVlMHJJeGQzY1Mzd0VyOGRIRlRqeCtRaTE5MWtHT2tROERWRUlEVlVJK1Nz?=
 =?utf-8?B?eWhIaHpkS2FPTzFIQlRKQUNsbHVpQkZ3ME1BbTNTWjB2dXp2K0RmaktsVUZS?=
 =?utf-8?Q?wuJRlS4rkRPBP1hyNAy+GN2uMj8tIHjW8b15Ser?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5110.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTBZTlBXZjZ5MjRIMDdsNzlIWEZSb0dvWmFJOXl1L0ZQa1NBMlhBVDhLaFJ5?=
 =?utf-8?B?WHlVVE1TM3FlMjVRWDNndGI3NmJURXJYSkdYUkZrc0Rrc0c4Q2UzRllnOFJn?=
 =?utf-8?B?UEdwSXhTK21hazhpQmxaZUdDYWdOWUZIZVFPKzhYK0F3ZFJLK2xzdHNMclV0?=
 =?utf-8?B?STV0aTNQWFh5UUFOeTFWR1owbEF6dkN6MTZGamNacHduV0gzelNsMG1DWjkz?=
 =?utf-8?B?V3NnQUZBRGFyWTg3R0p3YlB0bXVXYStXS3c3ZEFlRGVONmxYcU55ZGhrWXpU?=
 =?utf-8?B?cHFPUFhUd1pNeEVQckViZExncnVURHdFd0dPYzNvVWl5NDdkZ1UxdFRIVXZ2?=
 =?utf-8?B?azBLMXFpNkpZWC9lYnp0WCs5WXRSR1RDaVQyQU9Zc3NuSXlaMXZMNk80OWdt?=
 =?utf-8?B?bm93aDlYcmhtbE5nTVQvdW9VRzJHUXdZUDU5ZVU1ak1Rc25ESXRleTRmdGFx?=
 =?utf-8?B?L1RRQzNkblo1L2tpQmNKMmtFQ2lxT0duTUZmdE1NMndIS1JEQ0Qxd3VFak5j?=
 =?utf-8?B?T3RjMVZ2eGZmcmNaUWxMRzVxRDB5TTBEOU9LQit6S2VRZllYT3JXbVc2V1JY?=
 =?utf-8?B?cEYyNVZTTStMWXp1NWNnamZEblRzNlZ6cVBaZVZ6Q1VkQk14YmxDZHZEVVp1?=
 =?utf-8?B?S09xeS9DWEcvZlhhZ0dzNm91SG4yVk9Bb24vZTFWSHZtcG9HWWxNdUg5cDJW?=
 =?utf-8?B?ak1DTUVWRlJnaTZoTGpBNXRXQ21oK3BkZFM1bUhkcytYNmJpelY0c0FteThE?=
 =?utf-8?B?VHdocGpPWHpUeis5c3JRSFEzUzFwOEhnQ0k0WDg2ODdNYlBmSkpjbDdVUDZK?=
 =?utf-8?B?a1Q4SnVFNU1UV3paaUpvS1lwNWhkUHk2V2lEM2RlOEVUeGQxVlhRWCt2R1NQ?=
 =?utf-8?B?S1hIek1FdExSMzRSZEFkNXYwa2VtUldxQmxZY2hsTDltUHNjeW1mQ3ZmK29j?=
 =?utf-8?B?ZXA2S0hmeG9uK2dFVEpSaXE5bmN3dzQxTW1TY0Z4c1liZkRiSkJ4a1lIOUVn?=
 =?utf-8?B?S0phVDhKVXZSU2pGZU9BNUZuY0JxTlFrZ2lqREVzYVpKZ0ltemsrb24zWEk3?=
 =?utf-8?B?ZHVEaHhaYkNiYUY0cmwwZGlRVmh1NDd4QXI2Y3pWQkRzSkVuc1VVVVpObThP?=
 =?utf-8?B?bVM3bDN4YVU5dnp4Wi8wd3FrRnNkNnhQUnJQWDJycWs0WWZzUmZ0ZWdydzhN?=
 =?utf-8?B?NFRJNUNybW51OExGWmFWSUtlT3ZMTTRUUmVwMENvT3VBM1ZpUlBLV0NSaE1Z?=
 =?utf-8?B?b0NzanQyMW4vbThHY251Q04xZWl1cHJlRjY5K1Q0QW9XY0duWGJnZk8zMG1i?=
 =?utf-8?B?SDNEUUQ3MC9TaTNkckxwajVBbXZLVXRLSkpIdk9tRWZIc2pycDNGbmtPSE1H?=
 =?utf-8?B?TUdIYkVRaFpsZEYyM3ZHQmhZa0k5TWhVVzdoaHhiMHRwR1k1NGxZbWZVSXNt?=
 =?utf-8?B?cXlDclFkRi9nYjZ0UlB4RFFtTndxRk50SWpoNWxSdk5kWk5oK2ZJcUFYcXF6?=
 =?utf-8?B?eUxrRlJQaHRwa2R3TVVWZlRQelhSM2dVSE03blZLcyswZGVlU2hoODI1SXBs?=
 =?utf-8?B?TDJPNmNzVkRNdExOZEJrb0RrYXgvQXlHUWxzSC9YZkJhTDdWT1VJV0NaNlh5?=
 =?utf-8?B?UjI4M3NmK3B0UiswWjBEZXZQR0VNWFJqUWtTekNwWHVWN3dCUlJVU0c4L1Vm?=
 =?utf-8?B?Uk9VTzRoaU9QTWJDMVNWQ2ZveW55QXQwSTlXYUFMemYza1VlcmlTN1I1alk5?=
 =?utf-8?B?ZFFEMG1OQVE2Y2lBaFcrek5VenR5eHVIL1V0RUFqTllLRjU1VmxiN2N3MVlz?=
 =?utf-8?B?ZVMrSHoyL1BhSnFxNS9lT0xsaWtuV3FPbjhpbkE3RTRpRk1SanR6dE9wWGRM?=
 =?utf-8?B?a3hxbzg4c3Ftc29Ob3laVEJwU0pyTnVRdkNyQjd1TjJJY1ZsT01UQkR0NmJD?=
 =?utf-8?B?aTFiYm5wRnZoWVlxNW4rd0FzNEQ2MSthb09EUEFPNXhsMlp2bjFFRWZacE1L?=
 =?utf-8?B?enMrS0NqQW9ZU01mQzFFN2lFRTY0a044Ly9yMVoxcFVkMlVQL3V3SHZ3Q1NC?=
 =?utf-8?B?U0J5eEdrYnVZS1RCakVEcUpkZkVYUFVyNllVVHZubU9iRlc4MFhTbzIvWWRn?=
 =?utf-8?Q?ez6/ie6j8eWhr0MF2KtB6gw0F?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d525ff-da4b-4911-a3ad-08dc89e05b1d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5110.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 06:33:07.6263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sV4yIvq6sn2HY24rGQfFg7/efOTp5qwQm4hm35L64wwN3CgQVwOnr78+DOqdAUr6Rbm8fzhWNW4P5T9XBleolw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7974



On 10/06/2024 13:05, Sagi Grimberg wrote:
>
>
> On 06/06/2024 19:12, Ofir Gal wrote:
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
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
>> ---
>>   include/linux/net.h | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/include/linux/net.h b/include/linux/net.h
>> index 688320b79fcc..421a6b5b9ad1 100644
>> --- a/include/linux/net.h
>> +++ b/include/linux/net.h
>> @@ -322,6 +322,28 @@ static inline bool sendpage_ok(struct page *page)
>>       return !PageSlab(page) && page_count(page) >= 1;
>>   }
>>   +/*
>> + * Check sendpage_ok on contiguous pages.
>> + */
>> +static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
>> +{
>> +    struct page *p;
>> +    size_t count;
>> +
>> +    p = page + (offset >> PAGE_SHIFT);
>> +
>> +    count = 0;
>
> Assignment can move to the declaration.
Applying to v4.

>
>
>> +    while (count < len) {
>> +        if (!sendpage_ok(p))
>> +            return false;
>> +
>> +        p++;
>> +        count += PAGE_SIZE;
>> +    }
>> +
>> +    return true;
>> +}
>> +
>>   int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
>>              size_t num, size_t len);
>>   int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
>
> Other than that,
>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Thanks for the review.

