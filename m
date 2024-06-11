Return-Path: <ceph-devel+bounces-1322-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E47F49032CD
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 08:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2F531C25585
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2024 06:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9764A171E66;
	Tue, 11 Jun 2024 06:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="Qj6BMw1h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2113.outbound.protection.outlook.com [40.107.247.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F22B171E40;
	Tue, 11 Jun 2024 06:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718087797; cv=fail; b=Y8H1vcve4AEpcrhrA8Yi9gIX6tiewyzZxeS6AnLObjhtEcUPdtQg/MEyATv0KCRpRxtCHKdeH5BW0hoaUiOxDPatFbbz6G5pdV3uIwNvO9vsn8yofXMhZLF+Btw9ZT/r3esqhwJW/i+YZRZb8Jh1ESAKNLZAWho/TFeUbOxth3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718087797; c=relaxed/simple;
	bh=9nhHLT+j58HKtaJq5DVQN+7xqTN/grgX0bIb75nw/cM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hPjKhXvoKvDYs9aPVL0DHsv/rLFxm57MO5DaJgAEzyt3oPdHab60u1op/I5dUhXKXynH02fagBfI8UwOa187rdXFoHkG+lmRGKCVmHcpqvB1GHJwV3TeO8wnFF4gEByAhxYml78BXasK2skYycpFYi9ZJhPOz9v5bDQTtoqgKUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=Qj6BMw1h; arc=fail smtp.client-ip=40.107.247.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWHJFDZ5wTHCPYl29Sc0QujG7CCbedX66gnFWDc2WIx4b7dzSg7dR5E7D5eld9fvmPdDMfit+IX6GlVdV2yoERYMRcDqm3YNShhl6c3rFmkA976/kBz9ZWkposIKXlDt/JQS1sWYb6RGsLEAwgOBLm9JiGbzl/JhvKkPKARaZTrqRCmIv/gMHXNSI7hzP4PnZTPmJCZCWSkmxxG5GIHtpl0wo/ppzmb51lJwH8uA8Ga6BDOdlJdPPLwzQ/rVmOaC7u8zsk3xW1g7iEGj8wjmhpahGC3TK8s7Grl/oSf4o9OvEx7T31rANHczBAzzqfLbXOp3PjMpwU6a8310wp2k3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N99fmXwvLDfV3J1WxXrSj/Ue4CENUDEw6DZGSCi41AI=;
 b=I7+r7oQgHEmovbzh9JKKimfSayKAdBfY0cFJFNblGA/x6/OAazcPlupHkVa/L6MSEzEMLnyW12Jd7wBYkOPGmh8z+JjN+lIKcwGYM+OQF74YsXgTSUkYKV+98pb5Gy6bTyIKLkb1lvOz25Z9J6Gkp6RysdOr6x6gxoDxEviA2nYhrEj/N3PYak4gxjBF9XD3ZruJcvnq0paMT8iv/0YdB83tuqRbF0Zfus/Yaqbo68qbx5ZlWyMWvtcvgH2Er5oiq5gc3tpEEdaw13LNJb8HRmryz+gLVZoCl5xYdevz6yBe6oiWd0WEEBzFHv+yOC0pnixcljl8WOtaaRWuTf2K3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N99fmXwvLDfV3J1WxXrSj/Ue4CENUDEw6DZGSCi41AI=;
 b=Qj6BMw1huO/x5qk8BCVgIgyaYLfCbGzNLrUmuCznadGcUQrOMg9YSgpCOLLwIKXqevSP4lYK+GzJbXtbeHca0NX+kXaJhF9Qn6ifVJ+sImIk0OHjJ/tD13j6QIYu/ajO6pSQ/XlkI8/ItHL6+aJdfryxDiFeLWSNznSqi5+WAnkkbyl9nBUrm9/S33Ijb1CGvkbL7nQuqMEp3cs3oOVAoEbqNZI17+a+7lObIuWm/USU3sLhjvacY3XzJ7rz+bGPXRj6JUv8DG8qHnXp01IwKDrpIXOrSk48/i+SDjyiPZ+mgAuH/touwhuSArVOTAPXHlocsEjhP0pm49RxDlNCFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com (2603:10a6:20b:8::21)
 by VI1PR04MB9977.eurprd04.prod.outlook.com (2603:10a6:800:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 06:36:28 +0000
Received: from AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371]) by AM6PR04MB5110.eurprd04.prod.outlook.com
 ([fe80::4077:a101:3fd3:3371%6]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 06:36:28 +0000
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
Subject: [PATCH v4 0/4] bugfix: Introduce sendpages_ok() to check sendpage_ok() on contiguous pages
Date: Tue, 11 Jun 2024 09:36:13 +0300
Message-ID: <20240611063618.106485-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
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
X-MS-Office365-Filtering-Correlation-Id: 01a9aa8c-ca71-43ba-9c19-08dc89e0d2b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|52116005|1800799015|7416005|376005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUZaQ3dnVVFibnBTYnJRYmJYaFRNdkZ6Y1JwMXBSc1FQc2lYdUVXcGE5c0Mr?=
 =?utf-8?B?Rm5nSFN6Y3FRTGxlWEVxQkdVUG8vSEFEUitNN29oRTI4K3BWdjFETVMvSklF?=
 =?utf-8?B?MDFpUGgwTWhnNG1UWTA2Tld5UCtsYUJDWEJucnVIazN6ZXYwSVFORTF5ZWVG?=
 =?utf-8?B?Rm1zeWVtSy9WU3MzK0g4aU1KV2szMHg1TWpxWWk0ZDk5czE2V1p6MEFoRnZv?=
 =?utf-8?B?cDg4d2dnNDF6TWpFWnYrekZYR0R2WE1NOGlhSFJQWmp4QU5mSGhCR295TzdX?=
 =?utf-8?B?ODAreW9NUnVUSE54ckxKZWYvM3hSNUpoQUNQaGcrZHpHNmhEejRZTGpSbHVM?=
 =?utf-8?B?WWlPb040QitLODZGL2hobTdVakZ6dzlQQnVVTWJnVmx2MzlxcGEzdHBkRWtw?=
 =?utf-8?B?SXBMRDdQODFsQXkzZlo3VnVNM3Z6SWZzZ2psSEovbWQ4R2NqWnViZHg1ZzN6?=
 =?utf-8?B?SnJlQTUvSndRNmRydmhOUGE2QXZBUWR0NTloUHk1MXNvdVBRS1V4M1V3Z1dB?=
 =?utf-8?B?NjlrTkxUeW5jQWZyWHRSWFEwSG9LSnpqNERBenJQbENVY2RSTXIzaVoycDQw?=
 =?utf-8?B?eGNhWU8wOUd0M29aZmRBaEZjVllMY3A2SU91aWVLWXFxaUlUK2w5R2xXak9D?=
 =?utf-8?B?NEpsTkFMcG5uWUlXTXNXZ1NDYWdHNUt2ckhpbXhxWmQyOEgvSVY3QmRJUC9n?=
 =?utf-8?B?UFkxQi96bnFNWlF0bXFBNDhvNENoY0I0RmxDSHRiVWQvVC9Vcm5wQnlpdGt6?=
 =?utf-8?B?cGMwLzNqYzY4L1NHd1lQd3FKZ1ZZeVZSUkJ2UXBONERReWFRRWZISEd0cDdo?=
 =?utf-8?B?czdueDk4MGk3dHhhdHVSYmJZZ3I1RVlVU1pFREdDRTBNTXB2UERndSs1MGVW?=
 =?utf-8?B?ckNVajRjcTQzLytFN1JrUjliNzhuUGVXbmpraGxGMkFBT1NIbmN6VklOekZW?=
 =?utf-8?B?YWpOdnEvSzcwZHlLNU1iU0g3MzJZdWc4ZFFkVlBZR3dWaEg0azl6aUJRREdY?=
 =?utf-8?B?dHB1L3QvY1RWcGs3em8xdlRBalJCSmh3a2YzWU8wVStmTUlQNE82TTMrcFdW?=
 =?utf-8?B?M2lVb3cxUXBoUUpoYnAzYnVzZUFsa0xUT0xEZTNwbnRBK0JHQ2VHTFBwanBh?=
 =?utf-8?B?dTVsNGlLQUtZdTZ0VFpON0xFbzNUeDZZUitkVFp4cVl5ZFRuRDByV0VqUnNB?=
 =?utf-8?B?bjhTb0J3Z0EwTjVWSmFvbDVjM1BseEVUOUJHdXFVTXgyTjVKYjVHTjc2WHhO?=
 =?utf-8?B?aVl6ZWFPNHYzRjJxRUpsVXRKV055ejdBb2VhdGpTRmdlbFYyODBXN21LZ2ZN?=
 =?utf-8?B?dWladVN5bHZ4WjNQVnlOTlJjT1V4Q0djdmNJS3ZvNlY5NGQ0bThKUEpRdmtO?=
 =?utf-8?B?ZFpXcUtockVUU2dWOW5rL2pjY0hyMDM1aWo1VnpZZ2UyQUdkQzJSZDBITGk3?=
 =?utf-8?B?V3JDaTB1Q3lzZ2RNeFpEQ2huQWMrMnZrTkhWRjVFbjh0Tkh3enFnZzEwSFRu?=
 =?utf-8?B?WDk1MTk0K1NqRmxRKzFhemNNQ0lvRStxRW5WZWNlRWsxRjNVbUt6dXRRYVkr?=
 =?utf-8?B?anIxY0VtR3BqNjhBYUV4Ym5RWWRzN2tFVnNDRHdSM1hIL0xiSG9FTXRjT0NR?=
 =?utf-8?B?ZmF6WE4yTURRNW9aL05BOE1oMjFpSktmMlRPTStPVUNUWlB0NmhKaUFHRXk0?=
 =?utf-8?B?QTFENGNtTUVYUXd4d3kvWnlrVHlSeGp2MWsrSmpnVnVaVGdUaTBzaGUwdG5v?=
 =?utf-8?B?Y1RMUkp2Z1NyRTBsYWJMaldEeVlIcVcxRXY4Y052MXlzVnYvMzJkV3Exd3hC?=
 =?utf-8?Q?I8qiXl7Y7dk6f0hLKvZU3+IzD0O+7nOcfqMsY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5110.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(52116005)(1800799015)(7416005)(376005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmpIQVdReDdnYWNWeUNGV1BFOS9QMkZZMTFUMWl3OENqS0Z5YjBzRGxmdUVu?=
 =?utf-8?B?U1NRQVFQWlJGNlRleWwzR2lhVlZOYWsxaFZ1SWJoeG1XVEJLTTBwMnlHUUN2?=
 =?utf-8?B?TXlOR3VsY2draGR1M2YzY0k4YndTdWFYV1JuRFBIdnNnVTFib2FmS0NrZ3JS?=
 =?utf-8?B?Y3c3Y0pYd3plZXZFMHI0blhZVndxS1NrcFJzdWVsaDgyOGtBRnVXM0hpbTJO?=
 =?utf-8?B?ajFjbllvTnZHWVFMVXpBOXQ2Mk83NUV0aDJIWWc5U2x6T1VtNFhjYlJOUldw?=
 =?utf-8?B?UElvOHVaRVpQNUVSUGRCRU9tb3ZrOFhjOVNqRjlSOGhiamc3QkVKZW5tazRq?=
 =?utf-8?B?ekwzbXlidDZZRlRCWkxqZjQza0VXcjZES3IxQ1FMNVBnclpXKzhiV1lOY21E?=
 =?utf-8?B?Rk8zSEpabDhtK3JEZTRMYWpaWHhiN21QT28wOXM0OGdpTktyeXRYUW5xREJv?=
 =?utf-8?B?WWtmWG9rTkxLK0ZXVzU0RXJxeEZFc2x6aENnSTYzUlpPeWV2UkFEeVFWVWkx?=
 =?utf-8?B?dkpsRm1IWFNtMEUzcFZtUU5JWGdkemh4eXRMbk9SbWNVaUsyWlR1Q3hGNHc0?=
 =?utf-8?B?TlFrWDc5SEoyUCtMSEQvTjEwQVdRTjh6d1pyRGRnbkVzVEpZVHZEdDhYbVNJ?=
 =?utf-8?B?Q0hqQW5MM0J0eUxHNmptVXd4S1hZd3N5bG9RS210emFtbWkzamcyanVmSEZX?=
 =?utf-8?B?b3I0YTduZVN4Z0pOYVJWUzRyeTJta1BXVzhSNVJWaGorQkZkc1c3UTIwaWJT?=
 =?utf-8?B?ZXkvRUZtRHZjV2NBNTZpQXI2ajB3VDZ4SXpoVTJZeEp5eFVHbmcxaGhSTzV5?=
 =?utf-8?B?dUFTcjY5bktmNWJoczJEZUE2TVdtYVJBM2ZZRTI4VlhNaDhWN1o1alBqYTdQ?=
 =?utf-8?B?ZzVkQWlMWEd1dlpyaHJFb2ZLRVZDN2tOanlnZmxGWVFkY1pkbFhYRmhFYTVz?=
 =?utf-8?B?UFRvK0Z6MnBNZ0ptTXhGOGtYa1VrN0FEM1ovbHIvakhFamdlckpDZUF0RGh4?=
 =?utf-8?B?V0M3V3o4MlM3dE5JTVR6SnNWdnlqSUcrd2ZYWGNaVTNQcjFkcUNvRXk1VFFl?=
 =?utf-8?B?VVF3VnBab3ZnUE1TYlVMZzBIQ0FNVFRROThQNk9xWW4wYnc4QzcvVnFKWXhL?=
 =?utf-8?B?OXkxVWRBRUorU2ZHaFFsTlJ4Y0tkOGdsbjBxSXV1amp6ZHkxM1NCVFdhUHVF?=
 =?utf-8?B?Z0dCb2FpK0R0Z0VvVWl3aVVrdlBiQ0F6cmlZcEJDcHk5MVlzZHFTcHRXMTly?=
 =?utf-8?B?MjVkMmJKT2kxb3IvMnBwMmxhbHUvWk5vS2IrZWpxaU9pV0Z4RjFKdE1acUdZ?=
 =?utf-8?B?NnY2VXlxeXRKbnRyN05PTnBuZnVrMnBBN1FVTWtrTTNXYjRHaENmS0pLRTNr?=
 =?utf-8?B?V3p3WlA5UTdjSjZrQmhsVkp0M0Q0Q1FEUUcvYVV6TlBYNzJLb0l3UWN0OS9E?=
 =?utf-8?B?U1liY2NxYXY2dk5UOWgzb3hCdGZ2L0ZQRzA2S0tyZG16N0ZURU5KZGRJTW0r?=
 =?utf-8?B?NDlIaXBxeHBScStJN1RsK0d2YWF1VUd3dXlsdXJDVHFWSm1DTUduU2FoY2o5?=
 =?utf-8?B?djdMMld4ODAzYXd1NzN4eGl6YWJIV3drcjd5bWtwSTkyM0ZNVng4N2FlU1hG?=
 =?utf-8?B?OU9HNHdsOUwzcHlVYzZieWNJbFpSR251bUVwYVhYYmJDM29wRGloQ3BTZ1J3?=
 =?utf-8?B?dXczWkp5QTZNKzV2OE1uZFpKUVN5dU1YbmJ1UGxyU3M2a1pPNzc5RmN2Wlcr?=
 =?utf-8?B?STB0bTE0cGV6c3J3eC94V3lJV2V6OVhQR0MrbHVKRkljcFFpVDU5dFJod3Uv?=
 =?utf-8?B?U2EyajRFcjFHSlg0VSsvZ3d5YXlKRStoWXIvcWxxbVJsRmhqSU0xdFNDcFYy?=
 =?utf-8?B?aW1OQ1l2RkNDeDg2UW5NTzFNZDFyU2RkeGFCY29UVWxnRStEaEpxc3RnMit4?=
 =?utf-8?B?bkNnQkU1cTlzbXNvUHJpV3hVcW5ib1JqdTdhVGh0Yi92YkVMcVA2L0tXMG9m?=
 =?utf-8?B?NUNHY3F3VnRnczZJa2FSaGFNQVhUUkgza3RPeUJUVGtIU3A5VWhGcGl6bFhP?=
 =?utf-8?B?cm1OUWZoVnFwZkVteXFBSFlrQWF3YkNwQnp1VnBQaXVZaXZDUlZnaDJqZktF?=
 =?utf-8?Q?IvFIyoo3ZeqD0oJFPK7v415op?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a9aa8c-ca71-43ba-9c19-08dc89e0d2b7
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5110.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 06:36:28.2029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6/Prx2/NHBr+oeK9skDT6AARHg9aM5q2gSIWPijDGCKqrkMCl1+MTOKZC6j1k8PGFyeT4PcUmUk7PNXzS5wfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9977

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
v4, move assigment to declaration at sendpages_ok(), add review tags
    from Sagi Grimberg
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
 include/linux/net.h            | 19 +++++++++++++++++++
 net/ceph/messenger_v1.c        |  2 +-
 net/ceph/messenger_v2.c        |  2 +-
 5 files changed, 23 insertions(+), 4 deletions(-)

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



