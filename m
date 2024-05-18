Return-Path: <ceph-devel+bounces-1145-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57698C9295
	for <lists+ceph-devel@lfdr.de>; Sat, 18 May 2024 23:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AC0C281BD4
	for <lists+ceph-devel@lfdr.de>; Sat, 18 May 2024 21:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041746CDA3;
	Sat, 18 May 2024 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=datacrunch.io header.i=@datacrunch.io header.b="aoFMi9TH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2109.outbound.protection.outlook.com [40.107.241.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602A74501B;
	Sat, 18 May 2024 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716068462; cv=fail; b=CrDWKZzGaF6HAeScOfdmYeU+YK4/yh8E20lbvZ7ERqdxe7iIzRYSSVQW+AONY5mgyhiF7JCVqcbA2fnYStBPIFk3pRIgJx3AHOWSAxsyoOcsxMG6b9YZ8tVks6uz/WvXeYSUcLVacJ9PvNSs/1oEvge941ma6oIwRh1lAmy0Y78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716068462; c=relaxed/simple;
	bh=QHE1hJDCKgbWrC6uPWsuLr7chLroSn+n+jYZ+4U/350=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=o0tJ/gxPnDbYfFzQJpiJt+fDACuZMhC9vqcXnl4HO4c3l5in/i+G4VWT/glhfvw4L9xwvqHYGQA0BHmW6OMUj91iItwZrGeoqmeESPNYlZKEXT0MleLJBkQsP1LWrY9rJdGQDZ2GacEec3C1i53DacEO1qBC1EyqcBcNT5krwbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=datacrunch.io; spf=pass smtp.mailfrom=datacrunch.io; dkim=pass (2048-bit key) header.d=datacrunch.io header.i=@datacrunch.io header.b=aoFMi9TH; arc=fail smtp.client-ip=40.107.241.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=datacrunch.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=datacrunch.io
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4pawzQ+klmj87rx2aRnyaAf0mM5rqGuquXQawzV2AL1kM3aY1FRRf6UWSiE37rWYnbxQ6HtuYp3ANRjBKVilQgHSpKD5AQ3A3xhbW9Ze7KMh47Sz4MgyVN9UBvJYC6rbnimPjT7dUk9dSQQhtnhOrqowRYtdUOxNfIEJhuvEYW26b3nwPCF4V2RcnPOpNIOhsJO9UCdD20zgSfqnVbfNSvxcXuMJvKXboVXZjRGK4YjSQR9UQE+/Co+oMwzhcaz9mgdbbZUb2vV2J9j/rvukL7TVFC5KjmZsIqRyH1f+hygB28oWtd1ZE0rc7VA+0LT7Z+yptKJoFNPHYzOioHv2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GphDNIl1IP8S4OrpO60umbWx54FAamJ5fNtqF3aoAIA=;
 b=YhJfn/G6X747wZxDDPzPp2bosXZUIKu4T2Fvqi7jbwj2/kDF2DGRmMXlYtaQhRfez3sda2aH+IIRRoFqSztDhTFkYa/DCFekdQhLNtmj/eT00lEI4gVxeVm6UVpEU38YOijI4lMNYyppVj9yx+DJQfM66PdfY3CFy3ogrQBT+fRqlpHOb5gz0hmAWtCtIH47aho8lDswJPMOzeMGxjJslskbYZMKnZ4Cqrn9pdHfHPb/W9xg18EeMH571DZ1JtBYzUV1io1XtKlfdI3WtGH9Ni+/Yb+muOPP8HoSPN+ySIGjRz56Vr49iOzqyQRS27pqh7OPKkzewtyeY8zhDnfdIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=datacrunch.io; dmarc=pass action=none
 header.from=datacrunch.io; dkim=pass header.d=datacrunch.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datacrunch.io;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GphDNIl1IP8S4OrpO60umbWx54FAamJ5fNtqF3aoAIA=;
 b=aoFMi9THgdpWJU5X2ZNJiAA1p6iM9cdZodcv0u1JDjkpkEunuHQoEONFXY8J3ujQNLUfOj6BymDRZRIdrtkINOtXhhiuiqznbsHPKP4lj7YzJSwzZSxLLmW2c/XNfFH2Nst2gCUx0st+okgDF/ixrb+0DEv9FodEGEuOzWTmEIDuOSv3XzMV/0E5Xtn7pYnOqqNPY56M2z4nXQFnzRa40GnWrnLB3O/qMi+yckYd7KE7oLaTw8uUA1vN3CiyA79zl2YGccKT9CTlgss85UyXaoKxSPIXL4cXHnr7zH2N6VXPYCt6mLNu+O3WRRo/xqWcpeM3MdWsEenkRb7Y4PEwzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=datacrunch.io;
Received: from AS4P192MB1838.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:51a::18)
 by PR3P192MB0825.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.34; Sat, 18 May
 2024 21:40:57 +0000
Received: from AS4P192MB1838.EURP192.PROD.OUTLOOK.COM
 ([fe80::543:a45e:d527:3bf9]) by AS4P192MB1838.EURP192.PROD.OUTLOOK.COM
 ([fe80::543:a45e:d527:3bf9%4]) with mapi id 15.20.7587.030; Sat, 18 May 2024
 21:40:56 +0000
Date: Sun, 19 May 2024 00:40:54 +0300
From: Artem Ikonnikov <artem@datacrunch.io>
To: linux-doc@vger.kernel.org
Cc: Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, ceph-devel@vger.kernel.org
Subject: [PATCH] doc: ceph: update userspace command to get CephFS metadata
Message-ID: <ZkkgZlRk+PbFBUOJ@kurwa>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: FR4P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::10) To AS4P192MB1838.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:51a::18)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4P192MB1838:EE_|PR3P192MB0825:EE_
X-MS-Office365-Filtering-Correlation-Id: 307af5fe-f640-41e0-2a5b-08dc77833350
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmdFbGt6Z2JkWUhIK05yRkhxRk9GdGtCNFVJRGttRHJPS2hmSW40dFdCdUQw?=
 =?utf-8?B?ZStONmFqb2hET09vT1VkaEI0S1EwellhY2ZTR2Y1QVcxeUFIT00yWElpcHZZ?=
 =?utf-8?B?bmRzNDUxakVlQ1VrQzc4aVhVVTdtR09RVmJ1Z0l4a0g1ZXIzYXk4TE5KaGEz?=
 =?utf-8?B?dmhlb0VGL21XbW5EN1F0SjJLdnJ6dktSdjJDME5IdWJrMVJhMm82ZzJKWkE3?=
 =?utf-8?B?RXdubzFsVy9ZZ3NwSHJveGZMZjRSZ3FYZUJxZHZSNTdQZnNHYTRlUjI2b1Zm?=
 =?utf-8?B?VkxsNVVkbWgyaXY4R0U3dVFCYnZLQnZ4MXlnUndoMm1MM2JJZ2JrNk9Tdkdq?=
 =?utf-8?B?ZHdmTVQrNHIzMENIMlJSWTkzdkJPSFlnZkEvbkNiTWlQcnlXUVFyMVNrL1pR?=
 =?utf-8?B?bVdNYzU4VWYvSTBZNUdpais5SUdpVWNNQXBRQkMyV0MrQnMxazljTVNGY0ll?=
 =?utf-8?B?Z1VDRiswdGR4SktWRE5BYklXc2ZWWDhMQlZrMXlyc0kzNDJqRXpHODVheFpl?=
 =?utf-8?B?RklNNzlLMGxLSWk2czhvR0doYnlZTHNhWGl0eTUxVXB4b2h0VXovVGQ1T2xo?=
 =?utf-8?B?VEdvY3JVNEJiRk4rU1dIeFRXTzkvU3ZQbkhJYWdtMTNTNUJxbnR5aEdhYWQ2?=
 =?utf-8?B?eUZycmNsRHZXdSs3cWJLSUovenljQlhya3J4RVFxMTN3UmU5cm5RQTc4cklR?=
 =?utf-8?B?QmxnSGlKQWhJR2VVOVVZZHcxL3RRYmY5R3N6WFNZT1lFalppWm5wOHNRakY1?=
 =?utf-8?B?eXlscXdDcEs2ZnNPZGVTWjlrNGJ2Q3hJZTNxZHVuY2hNbEYvdG9UazduMGRR?=
 =?utf-8?B?SFJDendqVVJFVEpEeUNDeGs5ZWF5MEhMdVlTS2pNZHFLMHBISEZkbjlOc2VR?=
 =?utf-8?B?NEc1VWVIQUVZRXpHTTREc0l2YXJIVUhGUk12NTYwSVV4OG1tMy9NTVZqbWZp?=
 =?utf-8?B?TWtONnVNazB1aS9ZSDR6a2Uwak02YTlQODBxdTdCYkZSZHlERjR2Q3lGVVoy?=
 =?utf-8?B?cm9GcWU2dlQrSWppVEkzMXRPZzVBRnVJeDVFWFovaDdpZm5iMjdhUXQvb2h2?=
 =?utf-8?B?NVZtallOL3dOL2ZNYnFscE45ZFJCZVJyck1SeGFRUEpyQlBzWDgzQ3FRd3J3?=
 =?utf-8?B?azhLT0VMTURZb3BhNnBPTmo0YVZnUkZxZEhRejBRN3A5UTJJVXJFOWRWdnV0?=
 =?utf-8?B?U0NZdzEvRFpoVnk5Y0FSdzZHSWQ3aStXS2ZvZkowQ1hBMlk4MUhiRW9nRno0?=
 =?utf-8?B?RExDRFdsWFF5d3FpeFB5ZzVCVUh2R1grRXBKUTExbEpwT2JQdlgzVktDSUQ2?=
 =?utf-8?B?NVNRQ2V5N01Kckw0QmU2TG1LVmJxUTh2U1p5QkFxbmNpSEcreGVqeFpScXlY?=
 =?utf-8?B?VW5IcGRSQ0NXNElwcjdzdDR0R3Ixam1xQlVhREo0QUJyaXk5TVNiQU1CZTFi?=
 =?utf-8?B?ckY3MFVUbWE3bWIxdUtDODdsOE53T1ZsVmNrTXRlZVBIRElsMUY2Q0o2U2Ji?=
 =?utf-8?B?eFhMSHZUeHJtZW5MMXRocWRpYkdudFh0QXJaT3RSWUNLVDNCbUlVc3piOFNJ?=
 =?utf-8?B?ajVVWWY5L3pSOFh5eUx6SzRNUllvQlpkQ2JpdDJzd3RnbTZ6TzZYdXZrT0ND?=
 =?utf-8?Q?FP9lWoTctqOaEy3xtRAI1SBxt1FuC3TcK2a2/89ZSX+Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4P192MB1838.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d256a3UrZjU1Tzd2a1VmeVBCaFcyUC9GVGZMSzZqdkVzSWdVdHo2VE1UYTZv?=
 =?utf-8?B?RGk3UmlMcEhKTWhCTWxrejFJeW1rMWlPU1d3QnB6MkJONnZaQ3VyWGNUWU1Y?=
 =?utf-8?B?R0NmMEVCbDlSK1pxaVcvajVQYTFhdVFsTTk3UlNaR0xHb0ZiMDM0YWF3TlRa?=
 =?utf-8?B?ekRkK3RhMkd3NGRMNTR4UWg0VzdsNnNmbTRMbW9DZXdoMFB3ZUEycW9IUHVE?=
 =?utf-8?B?elEyUkJ5OE1yR241UnhuYi9HZjh3elFDREFGYlp3WFFvV21yODkwRk9GNG0x?=
 =?utf-8?B?ZldJMDdvZ090MUg3czQ3ZmpZRkxiSHpKYTI3Y1VqZjROTTMvQUxMaWxaK2dK?=
 =?utf-8?B?aVlUMHZOT1g3R2lmSTVBNHRsNklyL3J3WU5VWStQcGNWb2lpczd6aUFKTHRa?=
 =?utf-8?B?blgrZEduY2x3TU9pQVEwYlpPY1NyNURlck5iNDN3UWQrakhOZFJ1RFRyd25j?=
 =?utf-8?B?Z0pXcy80MUp1QVJyZk5YU3MyREdCWDArTEU4TURKdDhpaTNhdUNNWEhXRkZt?=
 =?utf-8?B?ZVM3bTVOVEVpZlBoNDNYNFUvYjRuSTFuMGE3N3ViM25TNW03QTlBbWd5c3J5?=
 =?utf-8?B?M0xzQjJOWW9aV0Irb2xNb3hQbkIrbHQ2TENPR0FDaUFDcWErQTlXbGhVWjVq?=
 =?utf-8?B?MWRYWlNxeGJyRlUzQzBWcGh2dnZ6RVkrN0tWUXRtd3JnazMxOE1ML2x5VVJp?=
 =?utf-8?B?ODJVekgzNG4yU1BTZ0VvWFhMQjFDZ1c5ZGdCRUROK1c2WSsvUzdaNWU5RVVT?=
 =?utf-8?B?M2ZTT1RVTEJ6bzkzZDRLUEVZcVZOTUVkTXJDSmJnSlpueGFxQTA5L0d2bDRI?=
 =?utf-8?B?V1ZRZ3J4UWp1bUc0NnhmS1RnbG1tMWU0K0RTem5kZmp6ODJqbm9nWHB3T09t?=
 =?utf-8?B?YmRFVENZWE9LRkUwQnZKVDFod09HVmg4ZDJySEdYNGZsdWtHaEcrTzBBS0Mv?=
 =?utf-8?B?bU9qSVhTbXRBSittYlhGaHc4endIcHNJZDFFQ3R0bkM4bThKU0lGaDh3MEZQ?=
 =?utf-8?B?YlFTSSszMTZLTjNWbHNLMTNjQjErRXJHYVN2OFhZNEtkdXZWQTNiV1RHQ3NI?=
 =?utf-8?B?OFhKUEpIR2k2ZXJ0VzBVNzRCTXM2NlBERnppajBTanBOZk9XRTNTZStsYUR2?=
 =?utf-8?B?OHR5eUJOMnBydk9jS3VjY1JObHVlZndmQURoaU1QaTVUVFNDcEhQUkJJMkt1?=
 =?utf-8?B?L0RHdWFMSmlHdWxmQ25mSWhabU9mUGtJWk5lMmpzdVM1TFlmVStOQmRvTnpO?=
 =?utf-8?B?NG91L0gzY0p2WG5mZVM5cGwxSmRLWGRET2trcUNTUDU3eTI5UmFoSG1HTElG?=
 =?utf-8?B?a3dWMEg2RFpBTGxvK0VQVXBocER6Q0FnMW9Pakx4T0daOVRET00xN3BXR1Ns?=
 =?utf-8?B?OEhweXp6b3VDQ2RDV2phMmNqNGZWMzdhQ1AzMENJckZ0MTJ2cFdDcUNNWWpP?=
 =?utf-8?B?Mm9FbVI4Q2U5c3JZVjJXNVNtZ1JPNkk1U2lQeVN5ZnU0dnRWU0NLc1Zhc1Iw?=
 =?utf-8?B?RU5kUGltNW9tblp6Uys0SDFJbWZISVhpTmp1L0RzM1ROeDcwSHNNSFBLc3Iy?=
 =?utf-8?B?R3c3dEhtdmp2YWtpdmF6bFBSTVdmc1FMcGozUkJ5c1BaT2F4OXRWd081ZTly?=
 =?utf-8?B?OU5aV1psdzdVOGNGZk04YzhHYkc0STJjdFgvcVFOWjFVQlorbUdjYTRrSUlM?=
 =?utf-8?B?K1IveFdXSnBKTXBiMjRmdzdnd2t6SWh2RC9ncmQyWG1FOW9RbnA0QnR6VlVq?=
 =?utf-8?B?QU9ZVWFEVlhXcEVEL05vVzVVc1JPNm44TU5zbWRFRUVSOEdTTEVYZW9FWDNm?=
 =?utf-8?B?VFJnblF6N3RWcGthRDFqekk2cHlvaDluUTlaRnVZL0RFK1dQN3FmbVh3Z0da?=
 =?utf-8?B?dWlmekNYd2Q2bUZxeTZKOHFsUDdQZUNka2w0ZW1NcnhjY29WMUdhVEtiRjFt?=
 =?utf-8?B?V0dJWkI0UkRSWGVaQ01qdTBJYUMrMGlUUnVjMGRjZDhlakRiUEVmSVhIL3pv?=
 =?utf-8?B?R0ZUWGVVRk5wTWRldTZyV1NYU1dkMHppQVZBSjI2R1NiNmM2TWV3cStuTDhx?=
 =?utf-8?B?WmIxMzltUXdtYzVNN29aSWR0UENVWmNzWUFMUVo1VkVVc2VDUmpwQ0tZWXRx?=
 =?utf-8?Q?7DEHalo1b7A6ZP2SbWtNeuXBh?=
X-OriginatorOrg: datacrunch.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 307af5fe-f640-41e0-2a5b-08dc77833350
X-MS-Exchange-CrossTenant-AuthSource: AS4P192MB1838.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2024 21:40:56.6652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46cbde63-6d87-4d48-ba2e-486da29923d2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0byHB9zo3YCtOwu0leqpa3SyIKKlXDR3FnTuwEEnIzZO/EdmyZlXTYI2nriNeO7utgpxMd41cfrG4uXy7UScw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P192MB0825

According to ceph documentation "getfattr -d /some/dir" no longer displays
the list of all extended attributes. Both CephFS kernel and FUSE clients
hide this information.

To retrieve the information you have to specify the particular attribute
name e.g. "getfattr -n ceph.dir.rbytes /some/dir"

Link: https://docs.ceph.com/en/latest/cephfs/quota/
Signed-off-by: Artem Ikonnikov <artem@datacrunch.io>
---
 Documentation/filesystems/ceph.rst | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 085f309ece60..6d2276a87a5a 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -67,12 +67,15 @@ Snapshot names have two limitations:
   more than 255 characters, and `<node-id>` takes 13 characters, the long
   snapshot names can take as much as 255 - 1 - 1 - 13 = 240.
 
-Ceph also provides some recursive accounting on directories for nested
-files and bytes.  That is, a 'getfattr -d foo' on any directory in the
-system will reveal the total number of nested regular files and
-subdirectories, and a summation of all nested file sizes.  This makes
-the identification of large disk space consumers relatively quick, as
-no 'du' or similar recursive scan of the file system is required.
+Ceph also provides some recursive accounting on directories for nested files
+and bytes.  You can run the commands::
+
+ getfattr -n ceph.dir.rfiles /some/dir
+ getfattr -n ceph.dir.rbytes /some/dir
+
+to get the total number of nested files and their combined size, respectively.
+This makes the identification of large disk space consumers relatively quick,
+as no 'du' or similar recursive scan of the file system is required.
 
 Finally, Ceph also allows quotas to be set on any directory in the system.
 The quota can restrict the number of bytes or the number of files stored
-- 
2.34.1

