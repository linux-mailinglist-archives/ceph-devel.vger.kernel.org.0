Return-Path: <ceph-devel+bounces-4199-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 397D4CCD58F
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 20:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 317A03016ECD
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 19:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE71E29DB88;
	Thu, 18 Dec 2025 19:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="diD4WzTl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1547323314B;
	Thu, 18 Dec 2025 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766085098; cv=fail; b=EOKshEMSk5kvs2vDm+qpT/xGRFhVOybfPbnf2ChzRXnAzQWOiLLf8SZgKx/8v5euUP4CtPpmiEFEJiZQVhjs9Ep8kOKMUIJvN3atLUZ9Kg9Ob42SVSLIoiHS1MiiEAxHCkCv2YkysBAvIuGU7ucSRzBbNTjJ/ailRUguQgjqdRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766085098; c=relaxed/simple;
	bh=xN52E8RDVina6O0oht/8k3n4WQNzRnyAqudBmtsa9CI=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=A9E8GH3TlMPlpJZhdzBIQkNQrWP9rB4/1GAG0PHG5kj6ENs+o1Fekd1ebo7Sv7Hdx0sAXWP2y05JTIhg68dRUdyVRJMLuB5zp3kw5QfY77Wf3JFkZK9x9B1gKFv+jEL7aqz3swGmMi4+1FS9klLyX8QPzbX8pHMi/nyWD/92uj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=diD4WzTl; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIBUIls028126;
	Thu, 18 Dec 2025 19:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=xN52E8RDVina6O0oht/8k3n4WQNzRnyAqudBmtsa9CI=; b=diD4WzTl
	siO0Zf6t2ynaPwdNy3h+zkh506EN9PJiGXr52e3ZP+mLNLySWWye9nNtaLBA0WMD
	8oBz0QJjG+MbWdZx8zobOqpIB24DvBTaRUoYl7oLFOtCswLpGCjcBUQT6Vlw4cNB
	ZzRYdTYpKWAjgWDIjUteIM74PzsktJl93+SoIOjIR+wLXXqcE8ojRWeLL7Z0LVWo
	1HyQvTdxKEo4mHnRvllmFwODgB/euwGUfPnKyZU9l/u+ptlUKvslxDGB3g9j33z4
	dTuAUZwd4MzRRdQKuP0NXySrJJ9EBrs0HRM4q7y0LXlb2YCAKRHCSgOjDQ+lvivI
	rZfCC86ayt15Pw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yvbmcp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:11:34 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIJ0emO029514;
	Thu, 18 Dec 2025 19:11:33 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yvbmcp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:11:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNaswkt9h4cmfKgGvEJTG9xeybVbqF4M5sbmhGFDTAjYSY8cMjbmcAZIv0JZvoa5Pp+Mpymro/hhFvL+tZRCWwc1Y7N5nEwszCVmSJ4FVrnhOKs3tKlR7OnYh8tqmFZ/R2Qpl9qsx4bTOD0Aavxvv1QLLD6hNdjAjF8sQHcIF3nIXkjym12a5etfGTNRhBD4dlGB1GIpZ5bIMcMpsDshDagpnViOrry6XfN/Xo+8e+YDcf+cuIjcm1uOKDpB76aO1BJOEir6HZ2X3sng1GchT1nMdhc/jE94Lqa1nF4evo4hRyxgwbujnCv0A94L7dcQLgcUROEx/IJwYCOgZVpfGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN52E8RDVina6O0oht/8k3n4WQNzRnyAqudBmtsa9CI=;
 b=kPU0vAEJ5tqwyYoYe61RdNcBuibQR+AjJVtkThQOgvBS8ADTNZ8YWEl3Ubq4qYVIfez+UBdDI0YYgbJQQVNJrNQCcM9s0eK8rR+bo9Avej1siSfPNyiYrEoDwdCcPgLLU4gtMeBZKPAhDrV87a1wqGyL25JxLUxk8h2IyFtzs8HVNz7i+3I78wxxfTWSzRqKE/mR4x0YxQODsktwCsL+LpwHfLqoLXmU07TlzTepDj9YJlzkd53jBrVhSIOUhzUQ+U8IT2RV01dJXU7dVbfeN3YwgeacccFN5C9RSUvH/t94EHrf7B4RIY7H0x0zGe9EuNJzcRShcZ5q5DttbS5maw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB6763.namprd15.prod.outlook.com (2603:10b6:806:4ba::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Thu, 18 Dec
 2025 19:11:32 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 19:11:32 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "islituo@gmail.com" <islituo@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] net: ceph: Fix a possible null-pointer
 dereference in decode_choose_args()
Thread-Index: AQHcb/PZ2i2CvwJg0EiOPMKsCgqtDbUnxFSA
Date: Thu, 18 Dec 2025 19:11:31 +0000
Message-ID: <f9f2ef979100a8809d7e3ac6106362f7a273e1e0.camel@ibm.com>
References: <20251218075603.8797-1-islituo@gmail.com>
In-Reply-To: <20251218075603.8797-1-islituo@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB6763:EE_
x-ms-office365-filtering-correlation-id: e521549b-8c1d-4030-0a7b-08de3e694136
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bnpaay9nUXlSSzB4S2lMN3ZyK2Q3TWFXYTNyb0dxWW94cmNWaXI1M3ovZHRM?=
 =?utf-8?B?VWE4TVFwNHY2bHJ6WTVlL05HWGFKMWNDcEh5VXVKQzJvR09oditKcTFxbStX?=
 =?utf-8?B?OUgwdXlENjhkMXNTNkdmeXREUFUwcCs1cU8zZjU4WTV2ZWt6bEFkazFuMGNW?=
 =?utf-8?B?cVdqNmF0cHhnZHEyOFA1K3dNb295a3Y4S2R0amVocEdDRGw4VGJ2ZlJyNmts?=
 =?utf-8?B?YjZDd0dhRExKOVJFdTRCcnZMWWxGSHp5MDVIczd6NnEyZTRadC9NNmlRMHFz?=
 =?utf-8?B?OXJENHhFMkEva3Q0Zm5rWHpBVSs1RjVoQXlmWXNNMWFkaFhRMm1pZUs0QzFx?=
 =?utf-8?B?Ui9mWmJLMW45Wi9HYWF3Y0N2RVhuUFFjdkcvcXlRcGUrQVJWZW5TL3FOZUxz?=
 =?utf-8?B?M1R5NjdhTmNibVpKblJuZGUwVkpoRGIrSkJaUmV0emVkTmZTekMwM0d3U0JM?=
 =?utf-8?B?USszeWplRHhpQ3JBVE1tVXVUSDFHN21yMnpGenUvVGZva0x6aktkWUtUOWc4?=
 =?utf-8?B?bDZCK0FFTVJvaWY4cHVBQjZidTRUWEFzMlhKV0VoQTh1d1VoeTZjMUx0a0Jv?=
 =?utf-8?B?NUErSnpsSTZFUDVXVStLTXluQm5OZnRVZDZVK2lWaS9WRVl3a256WjZ4aEE3?=
 =?utf-8?B?dWlkaGN0SHhuTkZXak85YU5BV09CL0ZBb2U2ZXJzck1zbWFkUjA5R252NjQ3?=
 =?utf-8?B?bEk5aStGalhwOHdzSXJIVXBxYXJTM2o3ZkE3QTFrVXc4Nm9KTFBDanVrS2Mr?=
 =?utf-8?B?eWIrWEVwNm5kMDBwMExIdWRsNXRBWTRicFJtR0U5QlUrWXc1RzU3Y1RGa0wr?=
 =?utf-8?B?ZnNodWxQbHBpSVJySi9NSlI0TDB1b2l1QmJNQmUyVW9hWG1vM1V6SGZxVDhk?=
 =?utf-8?B?WVNqSlFjUDRmazl1WnR2MEFJNlkrTElVV1lVQmdGa1QxQlRMQi9lWUtHTWZB?=
 =?utf-8?B?OEZiMEl3MXN1NUdCakVWZEswUGhJMGkyUTdxQ25xN01WdWZjYi9mUzF2QklM?=
 =?utf-8?B?a05LYmI5TGNSYW9LZzN1dmpmODlaR2k3cDI3WE9ZSTU4czc3MllOYjQ0NFFs?=
 =?utf-8?B?cGFiZHQ5cXdZaThKNjUyYktZMS9Cdlp3UmtZN3h4eXRKUGFqMUFXZjJVUkxr?=
 =?utf-8?B?U2p5N3NiSkZyQXVsbEsyeWR0TlJ3WDBzdTgySEhkUmVPQVdUMmlGWlQyYVov?=
 =?utf-8?B?eGs0a2FHODd6MGNZeEJpVkloQmNGRzVaL2dPd1BZanVEL29Xa3p0RVNqTC9Q?=
 =?utf-8?B?c1JxZlVxYitoRTRwejlCcHUxaXZhR21xY0ZsRWc4VG12YVpvaG44NG9pd0FN?=
 =?utf-8?B?a0RsZ0Y5MXVjM1lwOE5Nbm1kdU52VVA3MkJFWjZrRnZQbGpFaTh0V2FjdmF5?=
 =?utf-8?B?MXFpbnlDYWF2ejVaS2E2L0ZiMlo1VnJyNWtjU0E2R2pGMWJyVWRzT1FVSXVv?=
 =?utf-8?B?T05HbCt4cjNqMjFwdkZQWis1YWdUU0tYVnFuT0p5MWFQWkpTMUUrN3JIQlRt?=
 =?utf-8?B?ZTVqcmRzMFgwdzZSamtTcXRPc2x1aE9iTEU2bnZtSXB4MlBBTlFndzBDVThn?=
 =?utf-8?B?VVNnajdUTHVpZ2M3ODI1cUdSWFZOQkE4UXIyRUMwcUtra0p0Y21PdDY3Wk5k?=
 =?utf-8?B?d1JvWTArQTBrOFp1cWxmTm84NFUvbC9QUHNodWNCd3FKaUJSaVVnT0didDlu?=
 =?utf-8?B?bzZ4cGR4ZUR1YnBCWG0reDhibkh0aGFNTWY5YmFSL1VxSnJNT0E4Q2JMeGZk?=
 =?utf-8?B?cmJDOWlESWJReU02TStjcFJkN2dRMk5VUWM4RjBTZkJtZFBqMlh2WitRQmZW?=
 =?utf-8?B?V1ZBcE9IZWpZa0NWVUI4bUFHd09QZEVvUHpQaHFYRWJtbm1XTlZiKzVhRTJ2?=
 =?utf-8?B?NFVxSkN2S2RXZVhBdUNXVWNxaGk4eW9ubjBNUy9nb05YRGNpMm1mMWwrUFpk?=
 =?utf-8?B?ZEd2c3FOSGlTYUZzQzh4V2ExTlBWK3pRWkxVcGJ2QnlWdUQ3b2tjR0hBdkJW?=
 =?utf-8?B?cTJZVWlXWVRVeG1nejltV2I0ekpsOTFZQ1hPdWFOdXFiVldIdDU2cVR4UHdw?=
 =?utf-8?Q?s6XKZw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkdaWlFRR1NJUS9sa2dpcGpLQ09WOFFJeUw3bEg4RXEwYnhxUW93M0gyY3NO?=
 =?utf-8?B?aUptcERna21MbWFHMGN2TFdxVE1HakNMRXc0SWNBS0dzSDI3Sy9Zc2dZTlFH?=
 =?utf-8?B?RUp3WXBldk1TQ0ptRzh6ZmRYUitEZjZacUpBVlZlSzhTNXZnN2tQbVR3T2lS?=
 =?utf-8?B?Yi9oT3JEQWNIVkxYMWt5QjlmU0VKUVd3RDduQmtnZUVkVXM4d1NpcWlRaEtU?=
 =?utf-8?B?R0hDaklQemtPOWNGZms3Vkl2RDNnNXh3eWt5M2FUV040aXJ0T0VGNWVEK1FI?=
 =?utf-8?B?R0VDYXdjUFdYWjNFZ2pLMzdiR1d0ajlwdGYxYUdFay9ZNGJ6V25lQUdzaXdE?=
 =?utf-8?B?VkszbVVpNk16SHNxTzFpdXFlMDV1eUdOSGlDcG01TDlWV2RwWGdQS3grTFNa?=
 =?utf-8?B?b2t6UTQ1TTlMUVlKU1BjTWk4VmFGdmJZWnNnNVErQUFjR0JIQ0ltcGJMTkRu?=
 =?utf-8?B?YWxiTUhOdXhSY3k3VStVeFNFQUZnRDNSY21malV1OUcvdUQyVnRwMWw5OW9E?=
 =?utf-8?B?S1AzWUdZaUN3TzBxUGpHdllrU1hPQjJyemRzQnRIclF4VStLSGx1Nk1jdDRm?=
 =?utf-8?B?SVN5OFI3VmtEaGF2V0o3cGs5bitMem9RYVBVV3BITE5tNWpOby82MENKZ01r?=
 =?utf-8?B?aGtMdUs1Q1pSM2tPalBScmNrdno1RDFxMDBCNmg5UE5PS21RL2FCWmxQb3Uv?=
 =?utf-8?B?Y1BvdkZVeVh0RUI4UjBoODJnNzNHc2Y4WHVsQjc0ZmI2KzlBbWtBc3I0Rzlz?=
 =?utf-8?B?bWc3MVFCTlJKdGlJSXY1Vm1uYUJ1SVdlaDJjZU1hVy9zTFU1SVdrZVIvdGJW?=
 =?utf-8?B?NGZNenY4cDI0ODZqS0cvVk5UcHhzV2dOMzVCNWNJRW1ZQVpyTkpUL3JSOEhk?=
 =?utf-8?B?MWpuRlVmSXlWaWFmQW5tbis1cjgvOTVNOUJLVkRKeWpTdFZHalVmRUhpcFIv?=
 =?utf-8?B?cy93bURSOXFRdC9oUGlQeHh3YkZsaE9ZVmhnZVcxWnFkazZJWnlGS2N6VmZI?=
 =?utf-8?B?MDFHQkFQSjhpSHVLU2RVMEhGTmZaaFY0THJoMTBQdDZNNUFxQnZ6Zkx0dUJi?=
 =?utf-8?B?T2tERzNqdGk5OVdZTXJUeENLZGgrZVJrOFRGTVF1VDRWUEJ2Vll1eENOMEpP?=
 =?utf-8?B?WTB1VlJ1Vm5SRmlzcmVXa1d2azdGWHNNSWNJcFR2NXBmYVRWSmN6RFFUZkIw?=
 =?utf-8?B?aHFRSE92WmEwL1Ftc2ZXV2c3RDk1L0VuckFFanpUSFFzZ1ljYUQyMDFlQjIy?=
 =?utf-8?B?ZG16T2l0eG1VV3cxckg3eTloV2plVjlEZUtMY29nUnhHZzVaVDhHempUNjNT?=
 =?utf-8?B?Q243VitZR1dBZUVjTEhRdVpZYVlzdklZRXdqU1VHTDBLWDVScUY2ZkRjVGxU?=
 =?utf-8?B?VFZUUE9HOGdsbGp0bFVmbHErTzBVTnB2c09hMTlTLzZ4S2VwMnVDbVVxL0tM?=
 =?utf-8?B?anFoUS8wSHA0MHZjcUNiRVBEd2l2bDgweEdkWC9xNll6UXB6bEU1OHpZaVlO?=
 =?utf-8?B?b05nL2I2WWgvNU82RmRoT2c0c2RRZjRiRFZuNkJUdG9EZFBaTUJGUGN1NGNW?=
 =?utf-8?B?a3cyR3BOS1dyaTdhU1M1WG9HTDBhNmVZRDVSQXZyUzZHTWs4UEIyakpyT0d2?=
 =?utf-8?B?Yk1QbUFMd3ZRRWVmb2dWdU44UURTZ0xodkhwckYyREZiaTFrQ1pWc1VNUTg3?=
 =?utf-8?B?eDFFamFMdGR1d0FsMlh0OGNaSFQ5L0xMSGUrMENlQXd1NzVaNEhuVE9EQnJQ?=
 =?utf-8?B?K09kV0Q3K1k3dEw4dVR0ZjB2aCs0bmJWa3FZeXIxR0UyOG9Tby9sT1V6WG9r?=
 =?utf-8?B?aUd5NzJLUUF2Y0c2clJHaFdnTVdKN1pqOHZ4Ny8wME9RbFA4Ujl5L255Nzk1?=
 =?utf-8?B?UEV4V1lncGdJMkpyanZybU9JTHU3VkorbkJ4clY5TVRmOU84ZkJHak5QcXVN?=
 =?utf-8?B?SDU4SXhTSmw5WXJCUXBMNlFETXUwMGpVTEhLVll0enJlVm1yMWlWS0kwS2lm?=
 =?utf-8?B?UG5KdGtNZm1KYUlqTW8zWFVXWWNCNjR3OEZVVGpTdGZxbmNsOE4xcXJ4VmQz?=
 =?utf-8?B?ci9nU081L2tsaDRjUWhPQVc0My80NEZrYy9jZXJTQTFkeUlRUXQ2aGtpRFF2?=
 =?utf-8?B?bkcveFhvaUMySEVyU1c1d2Vya0JuSDJwUzAvWDdYTWh1OW91eU5qSStPUkxq?=
 =?utf-8?Q?yCFGHi5IlNrK9CYl1UXnqss=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D42528FA7F0186408BC97C818DD63C26@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e521549b-8c1d-4030-0a7b-08de3e694136
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 19:11:31.9095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ecdDeuQ42/6DgFCW12DQMlRXkYISyC2SD5UHUe8H3gB2Q+MoXOFbkZ+XOWWuVe9sp0KhEswq10nJJZ5e7nPlJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB6763
X-Authority-Analysis: v=2.4 cv=V/JwEOni c=1 sm=1 tr=0 ts=694451e6 cx=c_pps
 a=kXeBnfu3JcJF6EwF0J+eVg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=3QbmFkfu_qU83sWTfK4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mQ6maAJqk0iwaWyx_sUhBpDAatcPWrp-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfX8yJn+R1g9pIf
 IhsA6CKPxbdx1sFzidVBg+4fnErgL9pFSPrDRIB0dY7PLp76JdzdAulFCQb5Qrj1Yl9LqFVV6wG
 6FJQb+nh8jJcabEkFSVtINY+9+xfvwRMriLMnR0RZ+/9efJauh6yGGzPeIbcSx/DD1hjs5n551T
 yUIv/3R3jCTykgShIaylpn8RaPMYpE/5Lm6ITNQGE8HwICQEQLBTnQ4wKFlTjz66MOnfTFNxw1F
 +NM7WYlC+dNsHc4U3BAIOsnOxVvTF0xkD+S7jAz2+V4c0w2bNUkNdubvLARGOtoZn4UTFIvuhyE
 Ds7ZdoEVYjXx8G0TAc1D6K/GaHLjg0dB8xHGbyblhQa8kPuwwTvqpVhtStDkVYGAk1SIIR7g/WD
 l21zfvx82LHuA9P2AYgbEnSU4DZARQ==
X-Proofpoint-ORIG-GUID: FfRk6MTS5_USMMwQQ8bXBYu6JFSFjOAS
Subject: Re:  [PATCH] net: ceph: Fix a possible null-pointer dereference in
 decode_choose_args()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDE1OjU2ICswODAwLCBUdW8gTGkgd3JvdGU6DQo+IEluIGRl
Y29kZV9jaG9vc2VfYXJncygpLCBhcmdfbWFwLT5zaXplIGlzIHVwZGF0ZWQgYmVmb3JlIG1lbW9y
eSBpcw0KPiBhbGxvY2F0ZWQgZm9yIGFyZ19tYXAtPmFyZ3MgdXNpbmcga2NhbGxvYygpLiBJZiBr
Y2FsbG9jKCkgZmFpbHMsIGV4ZWN1dGlvbg0KPiBqdW1wcyB0byB0aGUgZmFpbCBsYWJlbCwgd2hl
cmUgZnJlZV9jaG9vc2VfYXJnX21hcCgpIGlzIGNhbGxlZCB0byByZWxlYXNlDQo+IHJlc291cmNl
cy4gSG93ZXZlciwgZnJlZV9jaG9vc2VfYXJnX21hcCgpIHVuY29uZGl0aW9uYWxseSBpdGVyYXRl
cyBvdmVyDQo+IGFyZ19tYXAtPmFyZ3MgdXNpbmcgYXJnX21hcC0+c2l6ZSwgd2hpY2ggY2FuIGxl
YWQgdG8gYSBOVUxMIHBvaW50ZXINCj4gZGVyZWZlcmVuY2Ugd2hlbiBhcmdfbWFwLT5hcmdzIGlz
IE5VTEw6DQo+IA0KPiAgIGZvciAoaSA9IDA7IGkgPCBhcmdfbWFwLT5zaXplOyBpKyspIHsNCj4g
ICAgIHN0cnVjdCBjcnVzaF9jaG9vc2VfYXJnICphcmcgPSAmYXJnX21hcC0+YXJnc1tpXTsNCj4g
DQo+IAlmb3IgKGogPSAwOyBqIDwgYXJnLT53ZWlnaHRfc2V0X3NpemU7IGorKykNCj4gCSAga2Zy
ZWUoYXJnLT53ZWlnaHRfc2V0W2pdLndlaWdodHMpOw0KPiAgICAga2ZyZWUoYXJnLT53ZWlnaHRf
c2V0KTsNCj4gCWtmcmVlKGFyZy0+aWRzKTsNCj4gICB9DQo+IA0KPiBUbyBwcmV2ZW50IHRoaXMg
cG90ZW50aWFsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwgbW92ZSB0aGUgYXNzaWdubWVudCB0
bw0KPiBhcmdfbWFwLT5zaXplIHRvIGFmdGVyIHN1Y2Nlc3NmdWwgYWxsb2NhdGlvbiBvZiBhcmdf
bWFwLT5hcmdzLiBUaGlzIGVuc3VyZXMNCj4gdGhhdCB3aGVuIGFsbG9jYXRpb24gZmFpbHMsIGFy
Z19tYXAtPnNpemUgcmVtYWlucyB6ZXJvIGFuZCB0aGUgbG9vcCBpbiANCj4gZnJlZV9jaG9vc2Vf
YXJnX21hcCgpIGlzIG5vdCBleGVjdXRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFR1byBMaSA8
aXNsaXR1b0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgbmV0L2NlcGgvb3NkbWFwLmMgfCAyICstDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9uZXQvY2VwaC9vc2RtYXAuYyBiL25ldC9jZXBoL29zZG1hcC5jDQo+IGluZGV4
IGQyNDVmYTUwOGUxYy4uZjY3YTg3YjNhN2M4IDEwMDY0NA0KPiAtLS0gYS9uZXQvY2VwaC9vc2Rt
YXAuYw0KPiArKysgYi9uZXQvY2VwaC9vc2RtYXAuYw0KPiBAQCAtMzYzLDEzICszNjMsMTMgQEAg
c3RhdGljIGludCBkZWNvZGVfY2hvb3NlX2FyZ3Modm9pZCAqKnAsIHZvaWQgKmVuZCwgc3RydWN0
IGNydXNoX21hcCAqYykNCj4gIA0KPiAgCQljZXBoX2RlY29kZV82NF9zYWZlKHAsIGVuZCwgYXJn
X21hcC0+Y2hvb3NlX2FyZ3NfaW5kZXgsDQo+ICAJCQkJICAgIGVfaW52YWwpOw0KPiAtCQlhcmdf
bWFwLT5zaXplID0gYy0+bWF4X2J1Y2tldHM7DQoNClRoZSBhcmdfbWFwLT5zaXplIGRlZmluZXMg
dGhlIHNpemUgb2YgbWVtb3J5IGFsbG9jYXRpb24uIElmIHlvdSByZW1vdmUgdGhlDQphc3NpZ25t
ZW50IGhlcmUsIHRoZW4gd2hpY2ggc2l6ZSBrY2FsbG9jKCkgd2lsbCBhbGxvY2F0ZS4gSSBhc3N1
bWUgd2UgY291bGQgaGF2ZQ0KdHdvIHBvc3NpYmxlIHNjZW5hcmlvcyBoZXJlOiAoMSkgYXJnX21h
cC0+c2l6ZSBpcyBlcXVhbCB0byB6ZXJvIC0+IG5vIGFsbG9jYXRpb24NCmhhcHBlbnMsICgyKSBh
cmdfbWFwLT5zaXplIGNvbnRhaW5zIGdhcmJhZ2UgdmFsdWUgLT4gYW55IGZhaWx1cmUgY291bGQg
aGFwcGVuLg0KDQpIYXZlIHlvdSByZXByb2R1Y2VkIHRoZSBkZWNsYXJlZCBpc3N1ZSB0aGF0IHlv
dSBhcmUgdHJ5aW5nIHRvIGZpeD8gQXJlIHlvdSBzdXJlDQp0aGF0IHlvdXIgcGF0Y2ggY2FuIGZp
eCB0aGUgaXNzdWU/IEhhdmUgeW91IHRlc3RlZCB5b3VyIHBhdGNoIGF0IGFsbD8NCg0KVGhhbmtz
LA0KU2xhdmEuDQoNCj4gIAkJYXJnX21hcC0+YXJncyA9IGtjYWxsb2MoYXJnX21hcC0+c2l6ZSwg
c2l6ZW9mKCphcmdfbWFwLT5hcmdzKSwNCj4gIAkJCQkJR0ZQX05PSU8pOw0KPiAgCQlpZiAoIWFy
Z19tYXAtPmFyZ3MpIHsNCj4gIAkJCXJldCA9IC1FTk9NRU07DQo+ICAJCQlnb3RvIGZhaWw7DQo+
ICAJCX0NCj4gKwkJYXJnX21hcC0+c2l6ZSA9IGMtPm1heF9idWNrZXRzOw0KPiAgDQo+ICAJCWNl
cGhfZGVjb2RlXzMyX3NhZmUocCwgZW5kLCBudW1fYnVja2V0cywgZV9pbnZhbCk7DQo+ICAJCXdo
aWxlIChudW1fYnVja2V0cy0tKSB7DQo=

