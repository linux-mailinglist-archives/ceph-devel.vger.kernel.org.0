Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1F96FD3A2
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbjEJBuT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 21:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjEJBuS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 21:50:18 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2072.outbound.protection.outlook.com [40.92.98.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0605A3A8B
        for <ceph-devel@vger.kernel.org>; Tue,  9 May 2023 18:50:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkK8r3V7Po6lY/5tIR6Dz33DpOELeI7j57OwhaktkfS04UEQDvnGIjaSwo98zHGdudU+Lssgw/GqB/94x+sOi2UTNxsXZX8FgmZ9tyidbImlHNLPz0NKFvrBihJcgxQSUw3pOkcq083dN+TS4rRMpC7KFoOqNEMTxqjVQ8BIqaIEzwcZt2uyQfjj9rSWMC7AiJSxYu3RlEqiQD73603Tg1E7j+EdA4uMhosQyrQLM34gjHZtwQ0Ekttke4SX3irYxR2afOdK3S7GNHiPlJsPA4bVTvnNtp07NZ1XohlVdNSBsp2aFJiG2Hd2KxHdyQvtcrLmtQfP+vRjhFv6UzfWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOhG/94NRobKT9OHjltVNSREAqp2BAWCompsbYlf8Lo=;
 b=IpiwZX7yZrI3YZPAtXF4ZPlU/RODKGvEOBu72+Q23pWlDk61//b6eWVtxQSNdcohwXKtq3+LDAyfF+zETIViUylZolXYROWOBxAV3QmWOhXLkMA6YQ1zRZWLk0Bp94ckXRBRGQzyyXMIlIHVqJaSOKjdhebBKecr+BT43yExj+xi5yPlc9r37lC6k9YShLdaMlX2UajUeP9K2wis5OfD3UIcidsU0uU51eiCZpHnCCk4FT4C65cDAQxbQEIohTSnHeA6Vgo74pjY4otBZEBkqSyrYSbhfYdS6biFi6XxomP4HL2IFBgXD7Yopc943Vv5m/g+qWXLzbAF12Sx+qgq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOhG/94NRobKT9OHjltVNSREAqp2BAWCompsbYlf8Lo=;
 b=ZIM2wgfH9Ef3T0hyo55DwlpLq2fEzN4BTIYvECgLzLOEHv88IYTo0AMk4Gad6XKHoS6XwHDqKFHsW+SigEVI2l47MRMtwzqPm8fPJcGGI9KFw9Iy3Ll19SIK29/xUIjb5rKC0fTnxjMUEIOxIMbZhSMkiRmoIxiYxAKMixxW18lTWLUVgrJn1z66MjhL95QQ1ERXdL9/KHB1ONmsMo2QLJreEN133FFzhPQWmEVlqIVrpENBSCl2npJhNBlkJKquQs1HMad/KXl/vmYJ7EI/7/VHESl1la2WcscpLmK1uCVILo5UVpy3b6RX6xuy6SKmfIskpkn/P7eHT8ug2INN+g==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by TYWP286MB3622.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:395::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 01:50:12 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 01:50:12 +0000
Date:   Wed, 10 May 2023 09:50:03 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH 2/3] ceph: save name and fsid in mount source
Message-ID: <TYCP286MB20662D0554A81C89C2C2CC56C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB206604655F7CAB7C50C6218FC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <1c6da9b7-f424-1713-23a6-15999d954f28@redhat.com>
 <TYCP286MB20667D17632479D0BFCD48B5C0769@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <fda4ef57-0b5b-3a24-bacc-1d5b0cc302bb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fda4ef57-0b5b-3a24-bacc-1d5b0cc302bb@redhat.com>
X-TMN:  [dx+H7ii06w5wJDmnxJMhC/Nejh1l4KHm]
X-ClientProxiedBy: BYAPR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:40::43) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZFr4S3rXR5UnK0r1@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|TYWP286MB3622:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f2e9f76-c9df-4fb6-09df-08db50f8e480
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1Ia+p5RfZMdyNcHWWtFbv9beG/y3YzYFp4PDCGqjMcLx6oySU9XmJ/MZ45lOnCJkLiYCm3qk7BMOSr8tqQztUmuWUQ7eAerD9LGLf39X7X1e33gTRxsNIVrSYlGO1naFXJo2541ktnWZ6PwRItf436O9Xwu0zTIb5SdNWsEXUUROMBeT8Z7uBTKP0DROSqMe3uSgNKMcqI3z2zdjPPMRgxgruukcKY2U75/tvorDMuDtDsOztxOMPimYFsINqLlQJdZPWItoqaoBpmPpJZBPJYeHkkVezJxHtp03h6VZCy776r6UD8phipUU+GQ2Li2InmmpJvqYWSaOgWCZqKCpc6DI8LIUCwIkszLtvGpcf+hYtnCRwrXb69peogTa/8jlsBehOpEL6sltXp2iQi25ujZHtpKDF2oXVy2/UqLQg4LskBXRhgVfScuKXoWu8VM2fWoqstGh9uwwACGs0+zhpWrbTc4woye7/yqpgGY3BOkq6Iyah5vYsOGDz/pc0pYo8o/YmMgLjkcKdNnHOZqgGf5HcFuL6XoGMWwn4Anl+mgYV3d44D06d3RwG1FAG7VXkSMTdWzU1bDzplylxGwBFd6yUqksQ2Bw6yC8y9XYurTTZtZ8HYp09x/qdU9+gAW
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UThJaDhwUVpxeXFpLzNxTFFtTVZRdXAvZnVLMVRqL0ZvN3VRcnR5cGYwcEIz?=
 =?utf-8?B?cWJsQjZOaGl0K1RmNUJ6T3NRT0h3T1RSRGxtNXFWVE8vaGJ1YlZEeVpndVRE?=
 =?utf-8?B?ak45VWJuNzVEcnBxMWV5aGx2NDliZFpPSnNRR3M2dktnYmtTRkd4OFlPNXhQ?=
 =?utf-8?B?d2xMMk9OWHI2L25CNEdpV0xLdEZPVC90UFJ6eWZ6ZWVTTjZMK294ekRTWnNW?=
 =?utf-8?B?ZGR4RStsOVIvbXVCR3BkYUZGS0RoQ04wOWduYXg1RTN0Z1E2RmFqa1R0czh4?=
 =?utf-8?B?VThqbEdUMmI3d0FpaFhZbzZGcHVNQWpHZnpsdUJhSDBJRndYQWVNV2s2VW9l?=
 =?utf-8?B?TUhnMENmSTEvOFdwT0lGWFVPTU00MyttdXFDN0F0dGJFL056TGk1UThIS0xa?=
 =?utf-8?B?S2RyR0F1d0dPdWtIWnNnb0M3cy9xdkcxSjQ3UElwdkVjVGE0Y3NkbVNDa3h1?=
 =?utf-8?B?K0IwS2xZQ0xqUEVTNG9iSnh0VnpnbkNkeWxZR0IybTBiQkYrdzhlZHQ5aGZE?=
 =?utf-8?B?WGFvSlZZS0ZCaXpvMStnMUl2N3FVdUxPcU05TlkyZXhpK01vUTg2YUFteEg2?=
 =?utf-8?B?WWxxZzEzNmZWQ0hIVnBTUVY5L1QzL2dvdHNLeXZaelFlZ0FVelF0eDlkRHhl?=
 =?utf-8?B?OFl6OURjUHl4bXpPVWJTOCtrMVdqUHk1SkRmUDg3UDhSU1RJb0JmMHpQV2F2?=
 =?utf-8?B?VzIxWS81NmprMElMZUtsRXJ0NlFRSHdwNHZsNXpyT1lSSGk0bUlJMlM3bFNy?=
 =?utf-8?B?dWJVaVFJc1hubENQTlRpS09ldHU4L1dpUXVSQTlrREx1bWVjUmRRbTBNTk83?=
 =?utf-8?B?WGNZR0RSOE9iaW1pZnhWRFNvQ2JSVTBrcU1DeUJ6eWVWYTJIQTdIUURFanN5?=
 =?utf-8?B?eVJzREVURHg0ZXg3YXh0U0w3dk5zYlBpVFk0L0FSYmFqQXI0bGtvbVNKeDdQ?=
 =?utf-8?B?dlIrNEVnUGR0RjR5SVp1RFN1dEdyY1packlpbFlWaWtuNWdEbnNMVTZXSkNh?=
 =?utf-8?B?SEkwYjBlVVgweGhKTld3V1ZHWDRnVnpyVWxPUHpuZFVuZFFnby94YnhudWpn?=
 =?utf-8?B?eGJTcSswTHRnbHVOdmlVY1UzWGhiNElkS0tjOEpkRlBQdXVWZnU2c0h6dE1Z?=
 =?utf-8?B?SzE5WXJITjh6OTN2aVRxQ0ZBOWFLZHQ4VEgycDVhNUN3WUxZWFlrVHAzOHFK?=
 =?utf-8?B?Z2pGS2h4eFMwNitKSFRHRk9rWVJZN0VuRnF4NWIvMkduQkl3VVp2YWhFY09t?=
 =?utf-8?B?N0piNTd0VVlSY1BrZ3lLd2Nqa215SU03L2U4MjhZWko5Vkx4U214TmxXS3oy?=
 =?utf-8?B?U3g5MjcveXJzOUVMVTZRblYvbmsvSnJCTTExTnBGWTVQb0sreHg3L0RKRDlE?=
 =?utf-8?B?bnhJdzcxVkVDWjJndHgxOFM3NkhoaXBvQStmMDJudjVtV0luMXBnZ2RZK3pm?=
 =?utf-8?B?aURYeDl4aStpdjhvZElzSWdZTXRDQTdyNVNkUnJuUUt2N09hWjBSRG1hNW51?=
 =?utf-8?B?V2dQV2lhd0Y3a1MvcTV2bkdOZ3ozenB2NVBDbzJZWmN2U0VUU0ZmTm1Mb3dx?=
 =?utf-8?B?SVowUTlqV0Y0WE51bVRWdW9wbmdaM25rSW1wMEs1Wm85TkdEU1Y2Q0Rka2lt?=
 =?utf-8?B?T0ZERjlZWmRaanQ4MW1aZUhNSGpEWWc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2e9f76-c9df-4fb6-09df-08db50f8e480
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 01:50:12.7041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB3622
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 10, 2023 at 08:42:10AM +0800, Xiubo Li wrote:
> 
> On 5/9/23 21:55, 胡玮文 wrote:
> > On Tue, May 09, 2023 at 09:36:16AM +0800, Xiubo Li wrote:
> > > On 5/8/23 01:55, Hu Weiwen wrote:
> > > > From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > > > 
> > > > We have name and fsid in the new device syntax.  It is confusing that
> > > > the kernel accept these info but do not take them into account when
> > > > connecting to the cluster.
> > > > 
> > > > Although the mount.ceph helper program will extract the name from device
> > > > spec and pass it as name options, these changes are still useful if we
> > > > don't have that program installed, or if we want to call `mount()'
> > > > directly.
> > > > 
> > > > Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > > > ---
> > > >    fs/ceph/super.c | 17 +++++++++++++++++
> > > >    1 file changed, 17 insertions(+)
> > > > 
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index 4e1f4031e888..74636b9383b8 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -267,6 +267,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > >    	struct ceph_fsid fsid;
> > > >    	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > >    	struct ceph_mount_options *fsopt = pctx->opts;
> > > > +	struct ceph_options *copts = pctx->copts;
> > > >    	char *fsid_start, *fs_name_start;
> > > >    	if (*dev_name_end != '=') {
> > > > @@ -285,6 +286,12 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > >    	if (ceph_parse_fsid(fsid_start, &fsid))
> > > >    		return invalfc(fc, "Invalid FSID");
> > > > +	if (!(copts->flags & CEPH_OPT_FSID)) {
> > > > +		copts->fsid = fsid;
> > > > +		copts->flags |= CEPH_OPT_FSID;
> > > > +	} else if (ceph_fsid_compare(&fsid, &copts->fsid)) {
> > > > +		return invalfc(fc, "Mismatching cluster FSID");
> > > > +	}
> > > >    	++fs_name_start; /* start of file system name */
> > > >    	len = dev_name_end - fs_name_start;
> > > > @@ -298,6 +305,16 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > >    	}
> > > >    	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> > > > +	len = fsid_start - dev_name - 1;
> > > > +	if (!copts->name) {
> > > > +		copts->name = kstrndup(dev_name, len, GFP_KERNEL);
> > > > +		if (!copts->name)
> > > > +			return -ENOMEM;
> > > Shouldn't we kfree the 'copts->mds_namespace' here ?
> > Seems not necessary.  ceph_free_fc() will take care of releasing the
> > whole 'struct ceph_parse_opts_ctx', including 'copts->mds_namespace'.
> > Besides, the mds_namespace may already be set before we parse the source
> > here.
> > 
> > ceph_free_fc() is called from:
> > put_fs_context
> 
> 457 void put_fs_context(struct fs_context *fc)
> 458 {
> 459         struct super_block *sb;
> 460
> 461         if (fc->root) {
> 462                 sb = fc->root->d_sb;
> 463                 dput(fc->root);
> 464                 fc->root = NULL;
> 465                 deactivate_super(sb);
> 466         }
> 467
> 468         if (fc->need_free && fc->ops && fc->ops->free)
> 469                 fc->ops->free(fc);
> 
> But are u sure the 'fc->need_free' is correctly set ?
> 
> It seems not from my reading if I didn't miss something.

'fc->need_free' is initialized to true just after init_fs_context() is
called, see 'alloc_fs_context()'.  And it is only reset to false after
calling free().

I've verified with gdb that ceph_free_fc() got called if
ceph_parse_new_source() returns an error.

Anyway, if ceph_free_fc() is not invoked, then we are leaking a lot of
things, not just mds_namespace.  The whole fs_context need to be freed
unconditionally after the mount is finished.

> Thanks
> 
> - Xiubo
> 
> > do_new_mount
> > do_mount
> > 
> > > > +	} else if (!strstrn_equals(copts->name, dev_name, len)) {
> > > > +		return invalfc(fc, "Mismatching cephx name");
> > > > +	}
> > > > +	dout("cephx name '%s'\n", copts->name);
> > > > +
> > > >    	fsopt->new_dev_syntax = true;
> > > >    	return 0;
> > > >    }
> 
