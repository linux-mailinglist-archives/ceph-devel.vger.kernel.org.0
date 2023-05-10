Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3676FDD10
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 13:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbjEJLrF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 07:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjEJLrD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 07:47:03 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2057.outbound.protection.outlook.com [40.92.98.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F024219A3
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 04:46:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kkwew4GOLsEgJ+Q1Sgij08CyZraUPt5MG5Y2Ejw+iyu7w6GlLHIy8Uzvz2I+FYHHsWTt2iclFyjEr4l4I/C5V2MUMnV5HEHgTe2xkfsJtxkhGclIbqkyleC65i94R7CXRPvWJgA9eG93RcilrEo1y0W0/IbueAk5hWyS6s/E/eelW+Mh4zvwDasMZ8x548SsT7uuOVGQrCK2WluWYISSbniC99UuG93G2WXosADZQsJyvwyWsWAutwVh8UZ8P0ln44kb88O47i+MxlmW/AZc9GY7A9E2ks7nP6J+YzUsJ+F/Q5IdLRIl4tRoVkapnon5/NXtCiHOmM8dUOQOIUQFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Y/VKu9huOBOnKKP2S6JSlOjqH3Uumh2KaYABWKrx5w=;
 b=hLYVkYJ6338HlsauafV2Dge0CfvpKoObeC32QCB3RutcIrHPpxPtQJSyFhB2O0uDHDSrWCQPzfmqlRqNYd9MiYZiDQIwJYSm99FJX4ZrLR15mo4msSpG1VSrhLUpoHD06NqMegOEpAorR8ILsCVtiDf53o0h1wrE5hB5SXMOvwvgdwqcti2vPiK0KvmAmU5hA/KC3dS4GF/b8efp/O+3TqMwtqym952ezSkroK/bdkltnxWK2KpmQbPPzLFq9KENmgpUTJWWIFgMoaCcrhpO7xXbwxPTasbgJJwtCNOhiuSKV7cGH5RQV+vzifLNU+7VSexkuN9lvOnslxgxodt8hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y/VKu9huOBOnKKP2S6JSlOjqH3Uumh2KaYABWKrx5w=;
 b=sUzIF09YhBR/9w3Bkp8YZiQO8VuitxWVgK4L4vSncoDSYAK173WTZM3rdiTqUONuPIrleGo0KZM5YS15bpMzAJ0g9Iq/SFUKaDzIAy8lzEDWo2kdBMEIjCxYAlnxeKhmpDW2X0g7kxRjVN0VKWtIG0AhUtebjdR/SBo/cryL7GOQcHf+zpy8hGvE2hTo8X0/M7COF4tpUXb5FZGP/GCETAm1J+VxmE+7GmzLlsBbdpF+u2XVZcBEF6T2p/ODJ0+R3iXtM3qpEUbExwAVeQx1UPeRN/uwYEf1yUaRqhA4zf70b5GB96oSJDSvhuLpQlGwsF0BIq8RWyy1mcKG8vL6VA==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OSZP286MB1488.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:1b4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 11:46:55 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 11:46:55 +0000
Date:   Wed, 10 May 2023 19:46:45 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH 3/3] libceph: reject mismatching name and fsid
Message-ID: <TYCP286MB206605B08A1A58F1EA6E6D10C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <00479efd-529e-0b98-7f45-3d6c97f0e281@redhat.com>
 <TYCP286MB2066015566DE132BA5B3CF06C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <e235d9ce-2436-f82f-5392-3a380d38eb35@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e235d9ce-2436-f82f-5392-3a380d38eb35@redhat.com>
X-TMN:  [EUuEIYWg3x6EC69sPnd+4OEkwjHBtzqp]
X-ClientProxiedBy: SJ0PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::25) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZFuEJUFNHNd149Cy@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OSZP286MB1488:EE_
X-MS-Office365-Filtering-Correlation-Id: ac1f0b8f-a1ec-48ee-85fc-08db514c4121
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwKg/rlrBUdmRT25QLZ4sqWAJ+XwoQ7zhJG2DPLA1Db8kbyQnktIWEDAl2wX1iC3edS3YY1N0V6i2F7nj0LdRcQ2ghcYHVjgX7CdCF0//eoHz0n+0d7sP+TnV4cnxJEhxVacAB0tHXbJckIxaYb/WAZOHXpKHYWBV/mGWioZneeMrL5iL3wAU3WsNLZP6IhMix8xNK3RXzjWRTVOKcyV8cquM9fRTPhAnN5aeuo+Zc0RWG9esFOtBKqw8bATtscqWUg3BKv7ffH6/chxV6P5TYrzW+cXyTfowlN9CqOm2kMpelHJetyjHdPU4qmsGf8lDf2e4O0Yq5l2QrGx+jA67OZU/6rDCKzzluq3HDFDDzQf57Mr8SaqEf25e5DESNdhJhefAcA2jjJ3JvckFgna9OCvk5dUKJo76NgSREjccS4ZTfnY1aTDDKFkRh6TaxhbedgIxbtRzuxz67d8jzJRcWGZ8NiaB+AkM85n4Ob/xAtMkW09tOIOF2UUytvrVGsXcDcfe29terT/yWxdh4eG4fRXWqA2wuDpINNpuf22p1bWb1GiHcFtm49jw2KbQlYLX3zELRjCcsJKc81JaFqBvbwCsk48aeQp5pg0Uj7/ADo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmdNOHMxVEw5K2xiRExHdW56bVhWcExwVldPTFpMWlU3L0N0RlRHNFJ0SUta?=
 =?utf-8?B?Q251bUhYb0RHWjZaNjkrSnkwZlBqekI1ZHhxQmtRMk9QeGFYNXRUdkdxdUhT?=
 =?utf-8?B?ZFdBYTFmQlNYMHYra0g1NG9NK3F2WXJlRGtYVVQ2bFUxU2NRd2NtMWNkc2Ez?=
 =?utf-8?B?VXo1bFVySTQrZWErMGhKOTI2UysvMDVCU2dsTmhOcGMrem5KREgydEIvMXJZ?=
 =?utf-8?B?SEtGZ09vMENqRDFrYjFJaFZJWDF3bERCdFlVcXpRN3I5Mi8yMUVvblZ3ZU1y?=
 =?utf-8?B?bEI5T0dsRkRRVlBUQXg0K3NzVWdXUXh5TG0wS3YvV214cXN5SS80VXpJZGF6?=
 =?utf-8?B?UkZvejV3S1A0SEIvWmFiVnVFaDNrdFlhV2JGRU9sM2FhdkhLYUNFcHZ4SHc4?=
 =?utf-8?B?UU1CNUtyRGZXdW41UWtxQW54eXBoMTJLWnV3RnpFUDE3OGVSWG45TWVLbjlW?=
 =?utf-8?B?RGNkM25qK2U4anRHOUZKK3Npa1poS3QzVlprcG9aSy8vTnBsYXBjVE9ubUp1?=
 =?utf-8?B?UVJzemlneHY4SU1pZGVOUS9Kd21YVUpJYUhld01sc25IZjFOc09nTytpTEM5?=
 =?utf-8?B?aDY1U1E3MXhJUkswSkowR1pxam5FK2JSak1pNzJPZFBpeW1yRTZ1SU50cG9i?=
 =?utf-8?B?N3dmS0JqeCt4MEtzK2l2YzgraThUNUdteW14YmdMRDI0UGQ2MFNRSHBWR2lk?=
 =?utf-8?B?NkVsYTFxakVEaytHSzNSN2hVUEFEOFlDZUtiTzNkSmU0L0cxUzdTNk9Xc0J1?=
 =?utf-8?B?dURYS1licHV4YWFsOGZ1bmZCc3lNMWNPSkMxbjVZczdFOXU5dzRNN3BPYyt3?=
 =?utf-8?B?UnBFMHc5SkcxUmI2TGxiMmh5aFNnaldlQnRwTDhuWmZicUF0dG1Td3NNK0s2?=
 =?utf-8?B?cUkyT1hMdzloaGY2TTN4Ry9jcGFrWmVYdEgva2IvVXRxaHhwVWlYY3EzWnp4?=
 =?utf-8?B?NW1WNFVJcXpwSURzdE5qekowN010am1YWHBLbDNvcU5UcGFWS0hGU2twakRC?=
 =?utf-8?B?Tnk5SEVyTVNnVlYxSm1NSUtNR1lYT00rY3ViWkxHM2lJWUlhWjlzanF1LzFX?=
 =?utf-8?B?Sk10NkZrWU40YVBDYlJVbERoTlNvOU9BY3ZLaGdvQjBDeEtmWC8wZFp5UUxM?=
 =?utf-8?B?cExwbEZkeCtiVkpVOWpOZFhSQXVFd2UxTktoTGVyclNaRkdHbkdVbXVnRGI5?=
 =?utf-8?B?dkpPdmJQUmZZb0xqVjMzRFRJbFArWHo4T2YvOG53eEpUUnppbU5HTjVmOXJk?=
 =?utf-8?B?SS95Nis3VUlEZWl6bVdEbVg5QkcvcW5mb2cxTmJ5K0R5bVdLMlhOWmswNk1J?=
 =?utf-8?B?K2Ywek9UaVRxZHRGbERHWXZKOStRWitIdEFCZVNndlM2THIxWE1XTWlLNHdQ?=
 =?utf-8?B?bVYyYi9vYTNDZkd3R3BsV2x1OGUwdlJYVk9yM09WTEVMTWtQaHRGME9aYmcx?=
 =?utf-8?B?VkF3ajlxS2Zad3A0OGdjNTdBN0M2TmppMHlzekJkMUcvOHJDcHNpTms3SWRl?=
 =?utf-8?B?aXgyVWdkWmpDS3l4RlhFc1Y0VkJ1NXFjeW40SG8vU3RPZnd3QkNaMEtBSnhJ?=
 =?utf-8?B?bUpMQ2VsQjVWc1JFUG1JY3hnblZkbjdBUFNUMGM0aUxzS1JGUzJ3L3ZxRW05?=
 =?utf-8?B?Q1JEKzFLRE1UNWFNQkZnN3RrVUJzRWc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1f0b8f-a1ec-48ee-85fc-08db514c4121
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 11:46:55.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB1488
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 10, 2023 at 06:44:22PM +0800, Xiubo Li wrote:
> 
> On 5/10/23 16:44, 胡玮文 wrote:
> > On Wed, May 10, 2023 at 03:02:09PM +0800, Xiubo Li wrote:
> > > On 5/8/23 01:55, Hu Weiwen wrote:
> > > > From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > > > 
> > > > These are present in the device spec of cephfs. So they should be
> > > > treated as immutable.  Also reject `mount()' calls where options and
> > > > device spec are inconsistent.
> > > > 
> > > > Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > > > ---
> > > >    net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
> > > >    1 file changed, 21 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > > index 4c6441536d55..c59c5ccc23a8 100644
> > > > --- a/net/ceph/ceph_common.c
> > > > +++ b/net/ceph/ceph_common.c
> > > > @@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
> > > >    		break;
> > > >    	case Opt_fsid:
> > > > -		err = ceph_parse_fsid(param->string, &opt->fsid);
> > > > +	{
> > > BTW, do we need the '{}' here ?
> > I want to declare 'fsid' variable closer to its usage.  But a declaration
> > cannot follow a case label:
> >    error: a label can only be part of a statement and a declaration is not a statement
> > 
> > searching for 'case \w+:\n\s+\{' in the source tree reveals about 1400
> > such usage.  Should be pretty common.
> 
> Did you see this when compiling ? So odd I jsut remove them and it worked
> for me.

Yes, my compiler is gcc version 9.4.0 from ubuntu 20.04. clangd 16.0.2
also gives error.

Console output:

  CC      net/ceph/ceph_common.o
net/ceph/ceph_common.c: In function ‘ceph_parse_param’:
net/ceph/ceph_common.c:443:3: error: a label can only be part of a statement and a declaration is not a statement
  443 |   struct ceph_fsid fsid;
      |   ^~~~~~

> > > > +		struct ceph_fsid fsid;
> > > > +
> > > > +		err = ceph_parse_fsid(param->string, &fsid);
> > > >    		if (err) {
> > > >    			error_plog(&log, "Failed to parse fsid: %d", err);
> > > >    			return err;
> > > >    		}
> > > > -		opt->flags |= CEPH_OPT_FSID;
> > > > +
> > > > +		if (!(opt->flags & CEPH_OPT_FSID)) {
> > > > +			opt->fsid = fsid;
> > > > +			opt->flags |= CEPH_OPT_FSID;
> > > > +		} else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
> > > > +			error_plog(&log, "fsid already set to %pU",
> > > > +				   &opt->fsid);
> > > > +			return -EINVAL;
> > > > +		}
> > > >    		break;
> > > > +	}
> > > >    	case Opt_name:
> > > > -		kfree(opt->name);
> > > > -		opt->name = param->string;
> > > > -		param->string = NULL;
> > > > +		if (!opt->name) {
> > > > +			opt->name = param->string;
> > > > +			param->string = NULL;
> > > > +		} else if (strcmp(opt->name, param->string)) {
> > > > +			error_plog(&log, "name already set to %s", opt->name);
> > > > +			return -EINVAL;
> > > > +		}
> > > >    		break;
> > > >    	case Opt_secret:
> > > >    		ceph_crypto_key_destroy(opt->key);
> 
