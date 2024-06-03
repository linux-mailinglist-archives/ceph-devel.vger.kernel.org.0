Return-Path: <ceph-devel+bounces-1253-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6B78D800D
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 12:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD8E51C23760
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 10:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4002682D90;
	Mon,  3 Jun 2024 10:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="ZG/Ta+JY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2124.outbound.protection.outlook.com [40.107.105.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C1107A8;
	Mon,  3 Jun 2024 10:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717410783; cv=fail; b=QY57LY3Z4wNNBWAfzHg2uS7j/FdIlz8UKuTqZU1SMSMWzWnnwLoT1eCR7+2Bd+mI5lythoL4ypLrUoLfd/H4ttDQk5xNt+9RLPB8TZGGVZIhNwIwwNItpjBAGhO0nI1mg5wbffte7zNmeaOzZzexcZHLBJBRfcyeiNBAlyT/bTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717410783; c=relaxed/simple;
	bh=XFdksna1Kd5K+wXvr50fpAeA/8p5banMyLKhv8Bc8dU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tjOxAOpNP9mDwvc70bIxxNFm/9AevCNY5EHLtLV5VciuUC52Vq/azo222vmrNEqzxhVQcuopwuYjXvDKkvm0V+ocUzNPK3AEcNmJO3BtEohyVhjVd0N2aMXmqDHNcUMTPuBbBhDNTEPs25z5DI5+d24+gMMswRH+OyCIqjACL9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=ZG/Ta+JY; arc=fail smtp.client-ip=40.107.105.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2YY2cKmcV8l7OKwHYlP2cP9bymYKH0AOQqlJJl4pGMYv5YdFNGJzW+0K0Uo4rNMOcmtLSqpAnZv8f0zt68pXOyeEFHdgrgE31a4hxj9IiP1l7AP/CWwK1Ky1kP1aWXQio5zWxLzKNoJi4tX5quyZ9KrybZSrZt9Bk0JoYueSO6rXM2AZRiNRToB6Tno6BHZHOmmGZg+Nbkyw2zMHKNU9890PrnD6UcAipmEG99MJ722Enuc/Hja7en54vbDREh0nf0vA/AF8ve5S1sJ37Is9+wiD14/80P8IRflCITOHKnc6OznC9rA7YmziLBwETxuzS+jbn78tOS2LGHHBRLFNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFdksna1Kd5K+wXvr50fpAeA/8p5banMyLKhv8Bc8dU=;
 b=YEKN6smNaEKaGuExuLtSV/iMnovn423axtzqTel6wrhtgT9GNX9OghvlW3L0DBPE677XDleiLLE3Wa34vY3++UD0SPpf68Fxf2BYxgBbxN955WFLgVLKEovduE9zKCJYh8UPsE/pHT57w882Woop4uermEN9aQ4vhpERROkN6qxfvlyh2i4cy8ym3QJyAUOZtkjVazA8MD8+80hEBJvu8Bs4WRRvl4EsAwdjqvY53G4Kij1rHW0s8FrjWSbkvAOcE0vLgbTcJg/Bu1LWwxjzKsA0qNmzayxja8egRgQpRY6JlVlqMDERcCoXwEzAlQ0J39yLAzEsOVDlfNrkKSeQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFdksna1Kd5K+wXvr50fpAeA/8p5banMyLKhv8Bc8dU=;
 b=ZG/Ta+JYhLXgGqNHVHCLHSwSpGFi9ONPgt2/QMBJc7+0Fxa20QT+gbS6ASClGewH4HWJ1rM5FN9YB5CPLUgDNj/rYfMjGuuaGYethgDRC6hBnTq3iWd3uYsdD4SGBBOMYnorbJ7fo+XHOS8Hr1Y93WjjQju7k6Utd8xjQ1uOduu+zYFkP61EqJusy0sn9awW54EB3Nr5vG+/DVy4yvSArY3XpV5PFRpwKDSJdIe1KvsD+KHIoJgoM1YT8DXn2i7dNf0PZw1iw2eJ5W7vmv7mbhz3HQd5hMSNC6nl1LqzM5MUe3hKIcN1B49ifJIUKsbU4WqgflHDhqBlLMY9+rhmDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by DU4PR04MB11029.eurprd04.prod.outlook.com (2603:10a6:10:590::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Mon, 3 Jun
 2024 10:32:59 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 10:32:58 +0000
Message-ID: <bca1947a-4826-472d-a62c-5ca5ad724939@volumez.com>
Date: Mon, 3 Jun 2024 13:32:54 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Sagi Grimberg <sagi@grimberg.me>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, philipp.reisner@linbit.com,
 lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
 idryomov@gmail.com, xiubli@redhat.com
References: <20240530132629.4180932-1-ofir.gal@volumez.com>
 <d6b2c19b-c2a6-400c-bbf1-bf0469138777@grimberg.me>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <d6b2c19b-c2a6-400c-bbf1-bf0469138777@grimberg.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::19) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|DU4PR04MB11029:EE_
X-MS-Office365-Filtering-Correlation-Id: dac32f5c-7002-4d7a-f21f-08dc83b8898c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amN5eloyN2JsanI0VDh6Wkp5ejFva1NTTnZGS2VKR0VnRVZPOXdpZmdScmFM?=
 =?utf-8?B?bzR1VnhWcGY5QUg2RmFkRnNkdWt5M2F3R1duRzNKZGFaRmk2Z0JrNVNveEE3?=
 =?utf-8?B?Vk9OeUc4SVk2R0xFQ2hPSkxNL3hnZTdwZThTYWttMy80YVcxZENqb0Qzb2xF?=
 =?utf-8?B?b2ZqOStZUzVVU2hEWklhSmdyUElKZzA1QkhpYy9JTXdpc3hxOWVEQjNlam1W?=
 =?utf-8?B?UFRLWHh0dXNtcXBRcmxyNXgvVUF5c0k4Y2tQSkFPMlFJZ3NXQm5RNnpwdHh2?=
 =?utf-8?B?Q2g4dzRraU5ZQ21JMTN0UnVoZDl5Zy9PMUVFTHJpUjhLWW8zbGpmaDJMNWN0?=
 =?utf-8?B?WXo3NU9rNEgvU2R6ZEZhdmgvM0RBR1hIc1dydmw3YjErbVFWV25aVno5ZERD?=
 =?utf-8?B?V2hPUVRVZW1ncHRId1JWV2Q2UW9SWU9ncXVlcjBnNGJEY0c1M1RtcjBGY24w?=
 =?utf-8?B?Z3RRdWE5bWh2NHltakEyWFdGSXltVytITlpWNCswNDFVWUMycUV3S05qVmtZ?=
 =?utf-8?B?R0ttdG5BTzM5Mk4wV2V3RUVmc1ZqMTFDcXhHT3pCbkFSamM1L250QTMwQW00?=
 =?utf-8?B?cHRsOUo5YlpnTi9CRTl5a2pCbldLZkVpcy9VYVVlYUFSMExNL2VrYWkxaHJr?=
 =?utf-8?B?VGRUeDlFV2orTTk4b1kzYzIxZEl3TW13Vll1NDFJajRXOERSUURmMXpnZjVW?=
 =?utf-8?B?M1B0VGFQWlZrVGZ0aGYvcE9KZitYTHp3RCtXbWpLcGpRVGllRTM4UUZEMFNC?=
 =?utf-8?B?S3hWbkNmaG9BZ2tFeW5oaU5zcUpiTmV4M3JrblNMUkxHZEVtUmlFbTFNMHBZ?=
 =?utf-8?B?N1FBdE5tZVNoTEppSmdjaUdnU0ZBcTlZOTBFZlUzSHg3N0M0QUovNFFzS2dR?=
 =?utf-8?B?UHF2dFgxcENwZHNieldXUkhETHdGdmpFSXJ6NmxLTG9EMDZYNHhFSS9Lbzl6?=
 =?utf-8?B?bzQzMSsrVE0yajY5b1ZMaCttVHc2bnJqWlFERGhEbTB6ZkRmbU15MHYwdDg5?=
 =?utf-8?B?ZDRWbGUzNm5wQU82anYrcU41eXJvMVVsa3dIeitZVUk2U0k4bVBRYTN5QUUy?=
 =?utf-8?B?Q0lzdWFBUUVGdjhkb282aTYvekhGcmtENVpGbHpqaVpkSXFLa1dUS1g5V0x6?=
 =?utf-8?B?Z204MHdOZjlpaWMwazNFaUgyeFo4Uk15Y2JtWXViK3V0cFo5MG1LbndFUXd6?=
 =?utf-8?B?dXB5eHF0aFBBaXlrdlMwWGMvaVBEdTU2TXZjS09OZmdyUHdhU2hHZWlwRzg0?=
 =?utf-8?B?WlgrcHJhOHRnei9CanQ0TVd3YUpqb1pRa3JOMWF3UWFlZzJDZ1J3OW5rSVpE?=
 =?utf-8?B?T2lTc2ZlN3ZHVkp0WTRKU0NGNzJwTjRoMUNvSDYzRkdCNHcwcmx4VUpsTmZ5?=
 =?utf-8?B?S0tUTVR4cDk5RE9WRHo2WmsyVlJZVHpjanpJVnlUbk9ralN6YmNPeFdUOCtV?=
 =?utf-8?B?MVZQcGVkR2dlSzFTYk5tN21aaWQvaDB6dmdGRzZYdXJXSEY3ZHFyK2ZWNzZ5?=
 =?utf-8?B?MUl2em13QVhmMHJTdnAzU1JIQmt6aCthc3paT1B4bG9uVEowZDZIbVg3cG9r?=
 =?utf-8?B?NEZnNHlWckp3bjhiblZ0ZVZVaTlobWhFWjkwUFU3THIzdWV6TS96bnp2TElk?=
 =?utf-8?B?aUZzZ1JCcEQ3ZG9rL2hEd0JUUUR3cXl4OGd4N0FucVlFMUt1TkhaaEhRTnYy?=
 =?utf-8?B?ZFJxUWtwR3o4Mk5Rd29mZ3NYMzhNc0hsTW00V1ZJdUR2U2pCaEFxK09nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1dJZ2tBcE55Y2EwcnNXSjNjSEhBeGprREZMUENmaDYvTWxLZEFYRnBWYjZz?=
 =?utf-8?B?cjZxM0F0Z2dROE1OVURIN2RVK0s2ZFRobTNyRnA1cFppWDU2bXJPNE53WFgv?=
 =?utf-8?B?M2VCOVowZkwvQUZhTi83YXBzMWdLYmJuakdKZndaczI3L2pYeHFFOWlEaTRV?=
 =?utf-8?B?TlVFMVhvL01jZlNnL3RQaHVRYnZlbFg2YjhtYlYyWGV4bi9ZZ3lPdHRHM3Az?=
 =?utf-8?B?QWs3WnVrajNDeXEzdUtqRXU3Yms5bTd1azJmVk81QW5nSTAzRDNDeWhwMWRM?=
 =?utf-8?B?bUlVcWVsUWlpSWI0dTcrWkNUR0hYSXpSajJ3MFJqc3gxeXBhdHp6R2R3bjdC?=
 =?utf-8?B?OVNiUDVKYk5XbEVQZHZsaGlyTTgzZjlzMlNrWHhIb1NaWEVMUFZRT1pPTkxo?=
 =?utf-8?B?RG9IUzE4aURnR1RyeXNHdVVCNzg1MXhIMWh6anhHdW82WHMrMXFma0hjNDhQ?=
 =?utf-8?B?TDYwNXIrbWVZL0JWM3phWHlGTkl5czVzWUlQajlzVHg3OWJBc01BZzNxNUpD?=
 =?utf-8?B?RERPWmxTNzRVc0VqNFd1TDUxVEt3YWJCU3pvOUxkbUxCWFRWb1B4WHZaeVRH?=
 =?utf-8?B?MmxOS2U0aGFSVFRpVDQyaWxPb1p4ODdoK0EwNWxQUHRHMmlyM05SdzB0b3Vo?=
 =?utf-8?B?dHVCVEdPMVptOTBpSGtYcWhaUXR1aFI0S2NlOExmVVQxVFRBUVY0V0dXSGNQ?=
 =?utf-8?B?ZG9GaHRhYWhpeExVck40UXZmL1Q1cTZUbUowUW16TnRacDYreCs4anNTRXF4?=
 =?utf-8?B?R0RBQVc0bUNqZTV6bkRQSFNlOUE0bkJTaXEwb21xSlZpRWVmWlF4NWRpL3k0?=
 =?utf-8?B?VDR5QWZ2KzhnbnlBYU1XUHpLYWc2NFEwOFIxWVhmZE8zOTR6SFV4UEJMWHFL?=
 =?utf-8?B?aHhmdTFncUN4OXVWbzNqMkE2QTNQQ01NSEJGQlVPMjN5R3JBaHMxZXdlSVA4?=
 =?utf-8?B?R3YvRVNoOHJSdk8rakR0QWdrTXd0TWRoSjQ1djRvV0gzY2JMbTZFRVRub01u?=
 =?utf-8?B?NlVKaW9veGEraDZaenJ5TFRzUmpvNS8rUWhLNitEMXhwSjRZNTRGSmZzZEtq?=
 =?utf-8?B?akxjTTBEa1paZXcwL2VBaDE2d0ZiN2NBQ3lBZ3VOMzFBM1huMGRQVGlyclJK?=
 =?utf-8?B?VHJwbDdpNWhpOTdMSXJraFU4SXJnSWdjZGp1OVo5MDdnYnlkRGllRFNtK3Nl?=
 =?utf-8?B?UVBmVU9GcS9nbENEMnJMUkd5OTJYMUcwQkVWd284aHNSYmNmVGo3WDJBdktj?=
 =?utf-8?B?R1JKcnoxNXBvektsalJtYm9qWE9JaTh4cUpFM0taem15dk9uRHNCSjg1YkRK?=
 =?utf-8?B?N3ZFem5pSkZzTHdYbmhiY3ZFcXg4dEZENVgyR3FWdFJyTE5rZU9EOCs5c2x6?=
 =?utf-8?B?RnhHa3R3WHByT2ZUYTA2VW5idVhDSmFLbTMvcDRIa2RpNVZUM1RkREVTZElu?=
 =?utf-8?B?UVpPaWhhNjV4ZmhQM0dKMzBJVTB0NFFwemNRSnh1WDhoSy9JNENnb1VXaHJK?=
 =?utf-8?B?Y2FqcER3WWticE85Y2VIaTRxL29XbU1VTHNrZTVkVDc1ZllqY2U4SCtyOGtp?=
 =?utf-8?B?K0RlK1BveVBtOFJyUEliSW1TVUVEamNsUlVZa3R0T080TGRwZ3FiNXEyVVA3?=
 =?utf-8?B?TVAwQjcxMXJhY2MraEdFL1NObTlyREI1WVA4VlVnWXdLR1hKaEVuK01PZGF0?=
 =?utf-8?B?T25Ub2g0L3ltcU9XOTFvdVNYdTYwMHNxY3BaeDV5b2FOdExwZ1FiNjRNVXY2?=
 =?utf-8?B?RVd1Nmk3b2pTclY4eVdMbERvajFRWTQvMytNTEx5Nks5OEMxcGJIODhsRFNo?=
 =?utf-8?B?bTJDb21pVUNMV1BDTWlIcENNVG1pUlFVU2F1UjVNQnM5VTZsK3VQVi92dkx2?=
 =?utf-8?B?QnlULzJhQnFVd3RQQTUvUWkwa1lCQ3dqVTdwRkdiWDg2SDZnUWkwRzZRaDV2?=
 =?utf-8?B?TXd1NXdXY0k0R0FvNVdsVDIxalhhNzlmYUJIZWl3b1k5V2NndXVHY1VyWm9O?=
 =?utf-8?B?Tjk5bUZlNzFOTmJxMnFFbnV6OGF1ZGg0SkpPNkdDTUNidnRjdnJsbVlOWGNK?=
 =?utf-8?B?TG9UNXBwS1o4SEdCYndib2EwZU55ekJqSFlkeitrY2xWeXVZMDhoRTRDcTUv?=
 =?utf-8?Q?9Qo6Kb1+stuDKZxGQX95I0I9O?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac32f5c-7002-4d7a-f21f-08dc83b8898c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 10:32:58.7866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zoYqfuv7pPX2JrRW+1eokv4dxkwZ1hBMS2yct+zzmfhasAzYM4Y/XtTENQsmKbBWAHDaADjyGy28pXDqE47Zlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB11029



On 30/05/2024 20:58, Sagi Grimberg wrote:
> Hey Ofir,
>
> On 30/05/2024 16:26, Ofir Gal wrote:
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
>
> Interesting. Do you know where this buffer came from? I find it strange
> that a we get a bvec with a contiguous segment which consists of non slab
> originated pages together with slab originated pages... it is surprising to see
> a mix of the two.

I find it strange as well, I haven't investigate the origin of the IO
yet. I suspect the first 2 pages are the superblocks of the raid
(mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the
bitmap.

I have stumbled with the same issue when running xfs_format (couldn't
reproduce it from scratch). I suspect there are others cases that mix
the slab pages and non-slab pages.

> I'm wandering if this is something that happened before david's splice_pages
> changes. Maybe before that with multipage bvecs? Anyways it is strange, never
> seen that.
I haven't bisect the commit that caused the behavior but I have tested
ubuntu with 6.2.0 kernel, the bug didn't occur. (6.2.0 doesn't contain
david's splice_pages changes).

I'm not familiar with "multipage bvecs" patch, which patch do you refer
to?

> David,  strange that nvme-tcp is setting a single contiguous element bvec but it
> is broken up into PAGE_SIZE increments in skb_splice_from_iter...
>
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
>
> This is a great candidate for blktests. would be very beneficial to have it added there.
Good idea, will do!

